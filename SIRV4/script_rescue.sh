#!/bin/bash
#SBATCH --job-name=sqanti3
#SBATCH --output=log_sqanti3_%A_%a.out 
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=20gb
#SBATCH --qos=short
#SBATCH --time=4:00:00
#SBATCH --mail-type=BEGIN,END,FAIL #Send e-mails
#SBATCH --mail-user=carolina.monzo@csic.es

module load samtools
module load anaconda
conda activate sqanti3
module swap gnu9 gnu14/14.2.0

python ../../software/SQANTI3/sqanti3_qc.py --isoforms /storage/gge/genomes/mouse_ref_NIH/reference_genome/mm39.ncbiRefSeq_SIRV.gtf --refGTF /storage/gge/genomes/mouse_ref_NIH/reference_genome/mm39.ncbiRefSeq_SIRV.gtf --refFasta /storage/gge/genomes/mouse_ref_NIH/reference_genome/mm39_SIRV.fa --CAGE_peak /storage/gge/genomes/mouse_ref_NIH/reference_genome/lft_mm39_CAGE.bed --polyA_motif_list mouse_and_human.polyA_motif.txt --polyA_peak mouse_polyA_site.bed -c /storage/gge/nih/Illumina_short_reads/short_reads/NOVOGENE_stranded/mapped/B31/B31_EKRN230014690-1A_HFHGVDSX7_L4SJ.out.tab --SR_bam /storage/gge/nih/Illumina_short_reads/short_reads/NOVOGENE_stranded/mapped/B31/B31_EKRN230014690-1A_HFHGVDSX7_L4Aligned.sortedByCoord.out.bam -o reference_QC -d reference_QC --skipORF

python ../../software/SQANTI3/sqanti3_rescue.py ml --filter_class collapse_filter/B31_MLresult_classification.txt --refGTF /storage/gge/genomes/mouse_ref_NIH/reference_genome/mm39.ncbiRefSeq_SIRV.gtf --refFasta /storage/gge/genomes/mouse_ref_NIH/reference_genome/mm39_SIRV.fa --rescue_gtf collapse_filter/B31_filtered.gtf --rescue_isoforms collapse_QC/B31.fasta --refClassif reference_QC/reference_QC_classification.txt --mode full --random_forest collapse_filter/randomforest.RData -o collapse_rescue -d collapse_rescue

python ../../software/SQANTI3/sqanti3_qc.py --isoforms collapse_rescue/B31_rescued.gtf --refGTF /storage/gge/genomes/mouse_ref_NIH/reference_genome/mm39.ncbiRefSeq_SIRV.gtf --refFasta /storage/gge/genomes/mouse_ref_NIH/reference_genome/mm39_SIRV.fa --CAGE_peak /storage/gge/genomes/mouse_ref_NIH/reference_genome/lft_mm39_CAGE.bed --polyA_motif_list mouse_and_human.polyA_motif.txt --polyA_peak mouse_polyA_site.bed -c /storage/gge/nih/Illumina_short_reads/short_reads/NOVOGENE_stranded/mapped/B31/B31_EKRN230014690-1A_HFHGVDSX7_L4SJ.out.tab --SR_bam /storage/gge/nih/Illumina_short_reads/short_reads/NOVOGENE_stranded/mapped/B31/B31_EKRN230014690-1A_HFHGVDSX7_L4Aligned.sortedByCoord.out.bam -o isoseq_rescue -d collapse_rescue/QC --skipORF
