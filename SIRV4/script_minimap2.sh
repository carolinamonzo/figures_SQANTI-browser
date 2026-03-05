#!/bin/bash
#SBATCH --job-name=mm2_isoseq
#SBATCH --output=mm2_isoseq.out 
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=20gb
#SBATCH --qos=short
#SBATCH --time=10:00:00
#SBATCH --mail-type=BEGIN,END,FAIL #Send e-mails
#SBATCH --mail-user=carolina.monzo@csic.es

module load samtools
module load anaconda
conda activate sqanti3
module swap gnu9 gnu14/14.2.0
#conda activate pychopper

#minimap2 -ax splice:hq -uf /storage/gge/genomes/mouse_ref_NIH/reference_genome/mm39_SIRV.fa PacBio_isoseq_clustered_B31.fastq > PacBio_isoseq_clustered_mm2_B31.sam

#samtools view -bS -F0x900 PacBio_isoseq_clustered_mm2_B31.sam | samtools sort -o PacBio_isoseq_clustered_mm2_B31_sorted.bam

#spliced_bam2gff -t 1000000 -M PacBio_isoseq_clustered_mm2_B31_sorted.bam > PacBio_isoseq_clustered_mm2_B31.gff

#python ../../software/SQANTI3/sqanti3_qc.py --isoforms B31.gtf --refGTF /storage/gge/genomes/mouse_ref_NIH/reference_genome/mm39.ncbiRefSeq_SIRV.gtf --refFasta /storage/gge/genomes/mouse_ref_NIH/reference_genome/mm39_SIRV.fa --CAGE_peak /storage/gge/genomes/mouse_ref_NIH/reference_genome/lft_mm39_CAGE.bed --polyA_motif_list mouse_and_human.polyA_motif.txt --polyA_peak mouse_polyA_site.bed -c /storage/gge/nih/Illumina_short_reads/short_reads/NOVOGENE_stranded/mapped/B31/B31_EKRN230014690-1A_HFHGVDSX7_L4SJ.out.tab -fl B31.flnc_count.tsv --SR_bam /storage/gge/nih/Illumina_short_reads/short_reads/NOVOGENE_stranded/mapped/B31/B31_EKRN230014690-1A_HFHGVDSX7_L4Aligned.sortedByCoord.out.bam -o collapse_QC -d collapse_QC

#python ../../software/SQANTI3/sqanti3_qc.py --isoforms /storage/gge/genomes/mouse_ref_NIH/reference_genome/mm39.ncbiRefSeq_SIRV.gtf --refGTF /storage/gge/genomes/mouse_ref_NIH/reference_genome/mm39.ncbiRefSeq_SIRV.gtf --refFasta /storage/gge/genomes/mouse_ref_NIH/reference_genome/mm39_SIRV.fa --CAGE_peak /storage/gge/genomes/mouse_ref_NIH/reference_genome/lft_mm39_CAGE.bed --polyA_motif_list mouse_and_human.polyA_motif.txt --polyA_peak mouse_polyA_site.bed -c /storage/gge/nih/Illumina_short_reads/short_reads/NOVOGENE_stranded/mapped/B31/B31_EKRN230014690-1A_HFHGVDSX7_L4SJ.out.tab -fl B31.flnc_count.tsv --SR_bam /storage/gge/nih/Illumina_short_reads/short_reads/NOVOGENE_stranded/mapped/B31/B31_EKRN230014690-1A_HFHGVDSX7_L4Aligned.sortedByCoord.out.bam -o reference_QC -d reference_QC

python ../../software/SQANTI3/sqanti3_rescue.py --filter_class ml --filter_class /home/cmonzo/workspace/SIRVS_sqantibrowser/B31_sq3_filter/B31_MLresult_classification.txt --refGTF /storage/gge/genomes/mouse_ref_NIH/reference_genome/mm39.ncbiRefSeq_SIRV.gtf --refFasta /storage/gge/genomes/mouse_ref_NIH/reference_genome/mm39_SIRV.fa --corrected_isoforms_fasta /home/cmonzo/workspace/SIRVS_sqantibrowser/collapse_QC/B31_corrected.fasta --filtered_isoforms_gtf /home/cmonzo/workspace/SIRVS_sqantibrowser/B31_sq3_filter/B31.filtered.gtf --refClassif /home/cmonzo/workspace/SIRVS_sqantibrowser/reference_QC/reference_QC_classification.txt --mode full --random_forest /home/cmonzo/workspace/SIRVS_sqantibrowser/B31_sq3_filter/randomforest.RData --dir ./collapse_rescue --output collapse_rescue


