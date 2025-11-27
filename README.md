27.11.25
1. распаковать все .gz с сырыми ридами в ту же папку (/mnt/projects/esafronicheva/rna_seq/01_fastq)
   ```
   gzip -dk *.fastq.gz
   ```
2. в файлах collaps_umi* заменить
   # Label directories
workdir="/esafronicheva/rna_seq"
indir="${workdir}/01_fastq"
outdir="${workdir}/umi_collapse"
logfile="${outdir}/processing_log.txt"
failed_log_dir="${outdir}/failed_logs"
mkdir -p "$failed_log_dir"
mkdir -p "$outdir" 
