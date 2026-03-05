#!/bin/bash
#SBATCH --job-name=sqanti3
#SBATCH --output=log_sqanti3_%A_%a.out 
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=20gb
#SBATCH --qos=short
#SBATCH --time=2:00:00
#SBATCH --array=0-6
#SBATCH --mail-type=BEGIN,END,FAIL #Send e-mails
#SBATCH --mail-user=carolina.monzo@csic.es

module load samtools
module load anaconda
conda activate sqanti3
module swap gnu9 gnu14/14.2.0

# Create array of files
readarray myarray < gtfs.fof

# Read the file corresponding to the task
file=${myarray[$SLURM_ARRAY_TASK_ID]}

ori_name="$file"
filename="${ori_name%.*}"

echo $filename

python ../../software/SQANTI3/sqanti3_qc.py --isoforms $ori_name --refGTF /storage/gge/genomes/mouse_ref_NIH/reference_genome/mm39.ncbiRefSeq_SIRV.gtf --refFasta /storage/gge/genomes/mouse_ref_NIH/reference_genome/mm39_SIRV.fa --CAGE_peak /storage/gge/genomes/mouse_ref_NIH/reference_genome/lft_mm39_CAGE.bed --polyA_motif_list mouse_and_human.polyA_motif.txt --polyA_peak mouse_polyA_site.bed -c /storage/gge/nih/Illumina_short_reads/short_reads/NOVOGENE_stranded/mapped/B31/B31_EKRN230014690-1A_HFHGVDSX7_L4SJ.out.tab --SR_bam /storage/gge/nih/Illumina_short_reads/short_reads/NOVOGENE_stranded/mapped/B31/B31_EKRN230014690-1A_HFHGVDSX7_L4Aligned.sortedByCoord.out.bam -o $filename -d $filename


