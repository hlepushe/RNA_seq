#!/usr/bin/env bash
#SBATCH --nodes=1
#SBATCH --nodelist=aglab0
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --partition=long
#SBATCH --time=8:00:00
#SBATCH --array=1-18
#SBATCH --output=/mnt/projects/esafronicheva/rna_seq/slurm_logs/pikard1_%A_%a.out
#SBATCH --error=/mnt/projects/esafronicheva/rna_seq/slurm_logs/pikard1_%A_%a.err

source /mnt/projects/esafronicheva/mnt/projects/esafronicheva/anaconda_new/etc/profile.d/conda.sh
conda activate Pikard

# Set variables for input and output directories
INPUT_DIR=/mnt/projects/esafronicheva/rna_seq/pendula_alignment
OUTPUT_DIR=/mnt/projects/esafronicheva/rna_seq/pendula_sorted_bam
mkdir -p "$outdir"

# Loop through each BAM file in the input directory
for BAM_FILE in $INPUT_DIR/*.bam
do
  # Get the filename without the path or extension
  FILENAME=$(basename "$BAM_FILE" .bam)
  
# Set variables for read group parameters based on the filename
#  REF=/mnt/projects/esafronicheva/diploma/betula_new/01_data/fastq/ref/Betula_pendula_subsp_pendula.fasta
#  RGID="$FILENAME".0
#  RGLB="$FILENAME"
#  RGPU="$FILENAME"."$REF"
#  RGSM="$FILENAME"
#  RGPL="$REF"
  
  # Run the Picard tool to add or replace read groups
    picard AddOrReplaceReadGroups \
    I="$BAM_FILE" \
    O="$OUTPUT_DIR/$FILENAME"_rg.bam \
    RGLB=lib1 \
    RGPL=illumina \
    RGPU=unit1 \
    RGSM=$FILENAME

done
