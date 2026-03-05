#!/bin/bash
#SBATCH --job-name=sqanti_mem
#SBATCH --output=sqanti_%A_%a.out 
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=100gb
#SBATCH --qos=short
#SBATCH --time=24:00:00
#SBATCH --array=0-4
#SBATCH --mail-type=BEGIN,END,FAIL #Send e-mails
#SBATCH --mail-user=carolina.monzo@csic.es

module swap gnu9 gnu14/14.2.0
module load anaconda
conda activate sqanti3

# Create array of files
readarray myarray < list_gffs.fof

# Read the file corresponding to the task
file=${myarray[$SLURM_ARRAY_TASK_ID]}

echo $file

file_dir=$(dirname $file)
qc_dir="/home/cmonzo/workspace/comp-eff-SQANTI-browser/analysis/"
ori_name=$(basename $file)
filename="${ori_name%.gff}"

echo $filename

ref_annotation="/storage/gge/genomes/human/Homo_sapiens.GRCh38.99.gtf"
assembly="/storage/gge/genomes/human/Homo_sapiens.GRCh38.dna.primary_assembly.fa"


# SQ input
isoforms_gff="/home/cmonzo/workspace/comp-eff-SQANTI-browser/data/${filename}.gff"

python3 /home/cmonzo/software/SQANTI3/sqanti3_qc.py --min_ref_len 0 --skipORF --dir "${qc_dir}/${filename}" --output "${filename}" --isoforms ${isoforms_gff} --refGTF ${ref_annotation} --refFasta ${assembly}
