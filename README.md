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

   upd: ЭТО НЕПРАВИЛЬНЫЕ ПУТИ 


04.12.25


сделала фaйл fastqc_before для оценки качества ридов до всего и проверки работы слёрма и путей. на картинке доступные окружения.
<img width="2100" height="662" alt="image" src="https://github.com/user-attachments/assets/13f02367-30d2-4b6c-a757-a9cb75bb3a6f" />

ничего не работало.

16.12.25

переделала файл 01_umi_collapse.sh, чтобы работал на процессорах и с моими путями, ДОБАВЛЕН В РЕПОЗИТОРИЮ запуск:
```
sbatch 01_umi_collapse.sh
```
в итоге есть файлы в папке umi_collapse 3 файла на каждый образец RNA_S15470Nr9.1.addedumi.fastq, RNA_S15470Nr9.1.dedup.fastq, RNA_S15470Nr9.1.dedup.woumi.fastq

все процессы заняли около 2х часов 

17.12.25

Запуск 02_umi_collapse2.sh и 03_fastqc.sh, фасткуси бежал оч долго, потом мультикуси в репозитории. Файлы приложены. 

27.01.26 

создано окружение star с одноименным тулом внутри. файл indexing для индексации геномов перед выравнивнанием. Нужен геном + аннотация. 
запуск файла 05_alignment_2.sh через sbatch. Это выравнивание ридов после юми на индексированный геном. 
