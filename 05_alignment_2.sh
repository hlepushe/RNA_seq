#!/usr/bin/env bash
#SBATCH --nodes=1
#SBATCH --nodelist=aglab0
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --partition=long
#SBATCH --time=08:00:00
#SBATCH --array=1-36
#SBATCH --output=/mnt/projects/esafronicheva/rna_seq/slurm_logs/star_%A_%a.out
#SBATCH --error=/mnt/projects/esafronicheva/rna_seq/slurm_logs/star_%A_%a.err

source /mnt/projects/esafronicheva/mnt/projects/esafronicheva/anaconda_new/etc/profile.d/conda.sh
conda activate star


# Label directories
workdir="/mnt/projects/esafronicheva/rna_seq"
indir="${workdir}/umi_collapse"
outdir="${workdir}/alignment_umi"
indexies="/mnt/projects/esafronicheva/rna_seq/ref/star2/star_indexes"
logfile="${outdir}/processing_log.txt"
failed_log_dir="${outdir}/failed_logs"
mkdir -p "$failed_log_dir"
mkdir -p "$outdir"

# Collect all R1 files
ALL_FILES=(${indir}/*.dedup.woumi.fastq)

# Calculate the total number of files
TOTAL_FILES=${#ALL_FILES[@]}
if [ $TOTAL_FILES -eq 0 ]; then
    echo "No .dedup.woumi.fastq" >&2
    exit 1
fi

# Check if the current task ID is within the range of available files
i=$SLURM_ARRAY_TASK_ID
if [ $i -gt $TOTAL_FILES ]; then
    echo "Task ID $i exceeds the number of available files ($TOTAL_FILES). Exiting." >&2
    exit 0
fi

# Get the file to process for this task
FS=${ALL_FILES[$((i-1))]}
FQBase=$(basename -s .dedup.woumi.fastq "$FS")

# Define the paired files
R1_FILE="$FS"

echo "Processing: $FQBase"
echo "R1: $R1_FILE"

STAR --runMode alignReads \
     --twopassMode Basic \
     --runThreadN 1 \
     --outFilterMismatchNoverLmax 0.04 \
     --outFilterMultimapNmax 10 \
     --outFilterIntronMotifs RemoveNoncanonical \
     --outSAMattributes NH HI AS nM NM MD jM jI XS \
     --outSAMtype BAM Unsorted \
     --bamRemoveDuplicatesType UniqueIdenticalNotMulti \
     --outSAMprimaryFlag AllBestScore \
     --genomeDir $indexies \
     --readFilesIn $R1_FILE \
     --outReadsUnmapped Fastx \
     --outFilterScoreMinOverLread 0.2 \
     --outFilterMatchNminOverLread 0.2 \
     --outFileNamePrefix ${outdir}/${FQBase}_

echo "Выравнивание завершено"
