#!/usr/bin/env bash
#SBATCH --job-name=star_pe
#SBATCH --nodes=1
#SBATCH --nodelist=aglab0
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --partition=long
#SBATCH --time=24:00:00
#SBATCH --array=1-18
#SBATCH --output=/mnt/projects/esafronicheva/rna_seq/slurm_logs/star_%A_%a.out
#SBATCH --error=/mnt/projects/esafronicheva/rna_seq/slurm_logs/star_%A_%a.err

source /mnt/projects/esafronicheva/mnt/projects/esafronicheva/anaconda_new/etc/profile.d/conda.sh
conda activate star

# --- directories ---
workdir="/mnt/projects/esafronicheva/rna_seq"
indir="${workdir}/umi_collapse"
outdir="${workdir}/pendula_alignment"
indexies="/mnt/projects/esafronicheva/rna_seq/ref/star_index_pendula/star_indexes"

mkdir -p "$outdir"

# --- collect ONLY R1 files ---
R1_FILES=(${indir}/*.1.dedup.woumi.fastq)
TOTAL_FILES=${#R1_FILES[@]}

if [ "$TOTAL_FILES" -eq 0 ]; then
    echo "No R1 files (*.1.dedup.woumi.fastq) found in ${indir}" >&2
    exit 1
fi

# --- SLURM array logic ---
i=$SLURM_ARRAY_TASK_ID
if [ "$i" -gt "$TOTAL_FILES" ]; then
    echo "Task ID $i exceeds number of samples ($TOTAL_FILES). Exiting."
    exit 0
fi

# --- select sample ---
R1_FILE=${R1_FILES[$((i-1))]}
FQBase=$(basename -s .1.dedup.woumi.fastq "$R1_FILE")
R2_FILE="${indir}/${FQBase}.2.dedup.woumi.fastq"

# --- sanity check ---
if [[ ! -f "$R2_FILE" ]]; then
    echo "R2 file not found: $R2_FILE" >&2
    exit 1
fi

echo "Processing sample: $FQBase"
echo "R1: $R1_FILE"
echo "R2: $R2_FILE"

# --- STAR paired-end alignment ---
STAR --runMode alignReads \
     --twopassMode Basic \
     --runThreadN ${SLURM_CPUS_PER_TASK} \
     --outFilterMismatchNoverLmax 0.04 \
     --outFilterMultimapNmax 10 \
     --outFilterIntronMotifs RemoveNoncanonical \
     --outSAMattributes NH HI AS nM NM MD jM jI XS \
     --outSAMtype BAM Unsorted \
     --bamRemoveDuplicatesType UniqueIdenticalNotMulti \
     --outSAMprimaryFlag AllBestScore \
     --genomeDir "$indexies" \
     --readFilesIn "$R1_FILE" "$R2_FILE" \
     --outReadsUnmapped Fastx \
     --outFilterScoreMinOverLread 0.2 \
     --outFilterMatchNminOverLread 0.2 \
     --outFileNamePrefix "${outdir}/${FQBase}_"

echo "Alignment finished for ${FQBase}"
