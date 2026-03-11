#!/usr/bin/env bash
#SBATCH --nodes=1
#SBATCH --nodelist=aglab0
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --partition=long
#SBATCH --time=08:00:00
#SBATCH --array=1-18
#SBATCH --output=/mnt/projects/esafronicheva/rna_seq/slurm_logs/salmon_%A_%a.out
#SBATCH --error=/mnt/projects/esafronicheva/rna_seq/slurm_logs/salmon_%A_%a.err

source /mnt/projects/esafronicheva/mnt/projects/esafronicheva/anaconda_new/etc/profile.d/conda.sh
conda activate salmon

# Label directories
workdir="/mnt/projects/esafronicheva/rna_seq"
indir="${workdir}/umi_collapse"
outdir="${workdir}/quantification_pendula2"
logfile="${outdir}/processing_log.txt"
failed_log_dir="${outdir}/failed_logs"
mkdir -p "$failed_log_dir"
mkdir -p "$outdir"

# Function to log failures
log_failure() {
    local step=$1
    local input_file=$2
    local error_log=$3
    echo "FAILED: ${step} failed for ${input_file}" >> "${logfile}.${SLURM_ARRAY_TASK_ID}"
    # Copy detailed error information to failed_logs directory
    cp "${error_log}" "${failed_log_dir}/${FQBase}_${step}_error.log"
}

# Collect all R1 files (assuming paired-end with .1.fastq.gz and .2.fastq.gz)
ALL_FILES=(${indir}/*.1.dedup.woumi.fastq)

# Calculate the total number of files
TOTAL_FILES=${#ALL_FILES[@]}
if [ $TOTAL_FILES -eq 0 ]; then
    echo "No .1.dedup.woumi.fastq files found." >&2
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
FQBase=$(basename -s .1.dedup.woumi.fastq "$FS")  # Fixed: removed [0-9] pattern

# Define the paired files
R1_FILE="$FS"
R2_FILE="${indir}/${FQBase}.2.dedup.woumi.fastq"

# Check if both files exist
if [[ ! -f "$R1_FILE" ]]; then
    echo "ERROR: R1 file [$R1_FILE] does not exist!" >&2
    exit 1
fi

if [[ ! -f "$R2_FILE" ]]; then
    echo "ERROR: R2 file [$R2_FILE] does not exist!" >&2
    exit 1
fi

# Define expected output files and directories
quant_dir="${outdir}/${FQBase}"
quant_sf="${quant_dir}/quant.sf"
cmd_info="${quant_dir}/cmd_info.json"
lib_format="${quant_dir}/lib_format_counts.json"
logs="${quant_dir}/logs/salmon_quant.log"

# Define error log file
salmon_error_log="${failed_log_dir}/${FQBase}_salmon_quant.log"

# Run Salmon quantification
salmon quant --libType A -i /mnt/projects/esafronicheva/rna_seq/ref/salmon_pendula_index/ready_indexes \
     --validateMappings \
    -1 "$R1_FILE" \
    -2 "$R2_FILE" \
    -p 5 \
    -o "${quant_dir}"  2> "$salmon_error_log"
