#!/bin/bash

STAR --runMode genomeGenerate \
 --genomeDir star_indexes \
 --genomeFastaFiles genome_betula_pendula_var_carelica.fasta \
 --sjdbGTFtagExonParentTranscript annotation_betula_pendula_var_carelica.gff \
 --runThreadN 8 \
 --genomeSAindexNbases 11

echo "Индексирование завершено"
