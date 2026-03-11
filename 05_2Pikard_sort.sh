#!/usr/bin/env bash
#SBATCH --nodes=1
#SBATCH --nodelist=aglab0
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --partition=long
#SBATCH --time=8:00:00
#SBATCH --array=1-18
#SBATCH --output=/mnt/projects/esafronicheva/rna_seq/slurm_logs/pikard2_%A_%a.out
#SBATCH --error=/mnt/projects/esafronicheva/rna_seq/slurm_logs/pikard2_%A_%a.err

source /mnt/projects/esafronicheva/mnt/projects/esafronicheva/anaconda_new/etc/profile.d/conda.sh
conda activate Pikard

# Set variables for input and output directories
INPUT_DIR=/mnt/projects/esafronicheva/rna_seq/pendula_sorted_bam
OUTPUT_DIR=/mnt/projects/esafronicheva/rna_seq/pendula_sorted_bam


# Loop through all BAM files in the input directory
for BAM_FILE in "$INPUT_DIR"/*.bam; do
  # Set output file name
  OUTPUT_FILE="${BAM_FILE%.*}_sorted.bam"

  # Sort the input BAM file
  picard SortSam -I "$BAM_FILE" -O "$OUTPUT_FILE" -SO coordinate


done
