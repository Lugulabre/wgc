cd /shared/projects/uparis_m2_bi_2020/metagenomique_2

module add bowtie2

srun -c 12 bowtie2 -p 12 -x databases/all_genome.fasta -1 fastq/EchG_R1.fastq.gz -2 fastq/EchG_R2.fastq.gz -S mpretet/results_bowtie_echG.sam

module add samtools

srun -c 12 samtools view -@ 12 -bS mpretet/results_bowtie_echG.sam > mpretet/results_bowtie_echG.bam 

srun -c 12 samtools sort -@ 12 mpretet/results_bowtie_echG.bam  > mpretet/results_bowtie_echG_sort.bam

srun -c 12 samtools index -@ 12 mpretet/results_bowtie_echG_sort.bam

srun -c 12 samtools idxstats -@ 12 mpretet/results_bowtie_echG_sort.bam > mpretet/results_bowtie_echG_stat

grep ">" databases/all_genome.fasta|cut -f 2 -d ">" >mpretet/association.tsv

srun -c 12 --mem 8G megahit -1 fastq/EchG_R1.fastq.gz  -2 fastq/EchG_R2.fastq.gz  -t 12  -o mpretet/megahit_result --k-list 21

srun -c 12 prodigal -d mpretet/EchG_R1_prodigal.fasta -i mpretet/megahit_result/final.contigs.fa -o mpretet/prodigal_results.gbk

sed "s:>:*\n>:g" mpretet/EchG_R1_prodigal.fasta | sed -n "/partial=00/,/*/p"|grep -v "*" > mpretet/genes_full.fna

srun -c 12 blastn -perc_identity 80 -qcov_hsp_perc 80 -db databases/resfinder.fna -query mpretet/genes_full.fna -out mpretet/blastn.out -num_threads 12 -evalue 0.003

squeue -u mpretet

scp mpretet@core.cluster.france-bioinformatique.fr/shared/projects/uparis_m2_bi_2020/metagenomique_2/mpretet/association.tsv /Users/MAEL/Documents/M2_BI/Genomique/omique_floobits/ghozlane_achaz