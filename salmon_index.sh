#!/bin/bash

grep "^>" Betula_pendula_subsp_pendula.fasta | cut -d " " -f 1 > decoys.txt
sed -i.bak -e 's/>//g' decoys.txt

cat Betula_pendula_subsp_pendula.cdna.faa Betula_pendula_subsp_pendula.fasta > gentrome.fa

mkdir -p ready_indexes

salmon index -t gentrome.fa -d decoys.txt -p 12 -i ready_indexes --gencode
