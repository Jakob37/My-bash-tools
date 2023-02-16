#!/bin/bash

user=USERNAME

user=$(who | head -1 | cut -f1 -d" " | uniq)
if [ "${user}" == "${user}" ]; then
        poweroff
fi

