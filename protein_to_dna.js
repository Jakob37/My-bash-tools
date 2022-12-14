#!/usr/bin/env node

// Usage: node protein_to_dna.js KKLLQQWW

const args = process.argv.slice(2);
const protSeq = args[0];

if (protSeq == null) {
    console.log("Error: No protein sequence provided as argument");
    process.exit();
}

const aaToCodon = {
    F: 'TTT',
    L: 'TTA',
    I: 'ATT',
    M: 'ATG',
    V: 'GTT',
    S: 'TCT',
    P: 'CCT',
    T: 'ACT',
    A: 'GCT',
    Y: 'TAT',
    "*": 'TAA',
    H: 'CAT',
    Q: 'CAA',
    N: 'AAT',
    K: 'AAA',
    D: 'GAT',
    E: 'GAA',
    C: 'TGT',
    W: 'TGG',
    R: 'CGT',
    S: 'AGT',
    R: 'AGA',
    G: 'GGT',
}

const codons = [];
for (let i = 0; i < protSeq.length; i++) {
    const aa = protSeq[i];
    const codon = aaToCodon[aa];
    codons.push(codon);
}

console.log(codons.join(''))
