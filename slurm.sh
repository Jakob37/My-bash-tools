# Source this file in Bash to load the Slurm helpers.
# The recent-job shortcuts use GNU date.
#
# slurm_recent [LOOKBACK] [--table]
#     List CP_ driver jobs for a lookback such as 30minutes or 12hours.
#     Pass --table to any slurm_recent shortcut to page an aligned table.
# slurm_cp_jobs START [END]  List CP_ driver jobs in a Slurm time window.
# slurm_follow_latest [DIR [GLOB]]
#                            Follow the newest matching log as new logs appear.

slurm_cp_jobs() (
    if (( $# < 1 || $# > 2 )); then
        printf 'Usage: slurm_cp_jobs START [END]\n' >&2
        return 2
    fi

    local end_args=()
    if [[ -n "${2:-}" ]]; then
        end_args=(--endtime="$2")
    fi

    set -o pipefail
    sacct -a -X -P --starttime="$1" "${end_args[@]}" \
        --format=JobID,JobName%80,Partition,NodeList,Start,End,State,ExitCode \
        | awk -F'|' 'NR == 1 || $2 ~ /^CP_/'
)

slurm_recent() {
    local lookback=1hour
    if (( $# )) && [[ "$1" != --table ]]; then
        lookback="${1:-1hour}"
        shift
    fi
    if [[ $# -gt 1 || ( $# -eq 1 && "$1" != --table ) ]]; then
        printf 'Usage: slurm_recent [LOOKBACK] [--table]\n' >&2
        return 2
    fi

    local start_time
    start_time="$(date -d "$lookback ago" '+%Y-%m-%dT%H:%M:%S')" || return
    if [[ "${1:-}" != --table ]]; then
        slurm_cp_jobs "$start_time"
        return
    fi

    local rows
    rows="$(slurm_cp_jobs "$start_time")" || return
    if declare -F tablel >/dev/null; then
        printf '%s\n' "$rows" | tr '|' '\t' | tablel /dev/stdin
    else
        printf '%s\n' "$rows" | column -s '|' -t | less -S
    fi
}

slurm_recent_1h() {
    slurm_recent 1hour "$@"
}

slurm_recent_6h() {
    slurm_recent 6hours "$@"
}

slurm_recent_12h() {
    slurm_recent 12hours "$@"
}

slurm_recent_24h() {
    slurm_recent 24hours "$@"
}

slurm_follow_latest() (
    dir="${1:-.}"
    pattern="${2:-slurm-*.out}"
    current=""
    tail_pid=""

    if ! command -v inotifywait >/dev/null; then
        printf 'slurm_follow_latest requires inotifywait (inotify-tools).\n' >&2
        return 127
    fi

    slurm_follow_latest_switch() {
        local newest
        newest="$(find "$dir" -maxdepth 1 -type f -name "$pattern" \
            -printf '%T@\t%p\n' | sort -nr | head -n 1 | cut -f 2-)"
        [[ -n "$newest" && "$newest" != "$current" ]] || return 0

        if [[ -n "$tail_pid" ]]; then
            kill "$tail_pid" 2>/dev/null || :
            wait "$tail_pid" 2>/dev/null || :
        fi

        current="$newest"
        printf '\n==> Following %s <==\n' "$current"
        tail -n 20 -F -- "$current" &
        tail_pid=$!
    }

    slurm_follow_latest_cleanup() {
        if [[ -n "$tail_pid" ]]; then
            kill "$tail_pid" 2>/dev/null || :
            wait "$tail_pid" 2>/dev/null || :
        fi
        kill "$watch_pid" 2>/dev/null || :
        wait "$watch_pid" 2>/dev/null || :
    }

    # Start the watcher before looking for the first log.
    exec 3< <(
        exec inotifywait -m -q -e create -e moved_to --format '%w%f' -- "$dir"
    )
    watch_pid=$!
    trap slurm_follow_latest_cleanup EXIT
    trap 'exit 130' INT
    trap 'exit 143' TERM
    trap 'exit 129' HUP

    slurm_follow_latest_switch

    while IFS= read -r changed <&3; do
        [[ "${changed##*/}" == $pattern ]] || continue
        slurm_follow_latest_switch
    done
    wait "$watch_pid"
)
