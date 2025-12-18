#!/usr/bin/env bash
#SBATCH --nodes=1
#SBATCH --nodelist=aglab0
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --partition=long
#SBATCH --time=08:00:00
#SBATCH --array=1-36
#SBATCH --output=/mnt/projects/esafronicheva/rna_seq/slurm_logs/fastqc_%A_%a.out
#SBATCH --error=/mnt/projects/esafronicheva/rna_seq/slurm_logs/fastqc_%A_%a.err

#ml fastqc/0.11.8-java-1.8
source /mnt/projects/esafronicheva/mnt/projects/esafronicheva/anaconda_new/etc/profile.d/conda.sh
conda activate FastQC

DIR="/mnt/projects/esafronicheva/rna_seq/umi_collapse"

SAMPLE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" ${SAMPLES})

fastqc ${DIR}/RNA_S15470Nr*.dedup.woumi.fastq  -o /mnt/projects/esafronicheva/rna_seq/umi_collapse/fastqc
