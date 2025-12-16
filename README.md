27.11.25
1. распаковать все .gz с сырыми ридами в ту же папку (/mnt/projects/esafronicheva/rna_seq/01_fastq)
   ```
   gzip -dk *.fastq.gz
   ```
2. в файлах collaps_umi* заменить
Label directories  
workdir="/esafronicheva/rna_seq"  
indir="${workdir}/01_fastq"  
outdir="${workdir}/umi_collapse"  
logfile="${outdir}/processing_log.txt"  
failed_log_dir="${outdir}/failed_logs"  
mkdir -p "$failed_log_dir"  
mkdir -p "$outdir"  

3. создать папку вывода логов и ошибок
   /esafronicheva/rna_seq/slurm_logs  

   в файлах collaps_umi* заменить

   SBATCH --output=/esafronicheva/rna_seq/slurm_logs/umi_collapse_%A_%a.out  
   SBATCH --error=/esafronicheva/rna_seq/slurm_logs/umi_collapse_%A_%a.err
04.12.25RNA_S15470Nr9.1.addedumi.fastq
RNA_S15470Nr12.1.dedup.woumi.fastq  RNA_S15470Nr3.1.addedumi.fastq      RNA_S15470Nr9.1.dedup.fastq
RNA_S15470Nr13.1.addedumi.fastq     RNA_S15470Nr3.1.dedup.fastq         RNA_S15470Nr9.1.dedup.woumi.fastq
сделала фaйл fastqc_before для оценки качества ридов до всего и проверки работы слёрма и путей. на картинке доступные окружения.
<img width="2100" height="662" alt="image" src="https://github.com/user-attachments/assets/13f02367-30d2-4b6c-a757-a9cb75bb3a6f" />

ничего не работало.

16.12.25
переделала файл 01_umi_collapse.sh, чтобы работал на процессорах и с моими путями, ДОБАВЛЕН В РЕПОЗИТОРИЮ. 
в итоге есть файлы в папке umi_collapse 3 файла на каждыйобразец RNA_S15470Nr9.1.addedumi.fastq, RNA_S15470Nr9.1.dedup.fastq, RNA_S15470Nr9.1.dedup.woumi.fastq
