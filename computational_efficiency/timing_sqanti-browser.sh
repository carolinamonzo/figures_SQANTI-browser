#!/bin/bash
#SBATCH --job-name=sqanti_browserMem
#SBATCH --output=sqantibrowser_%A_%a.out 
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4gb
#SBATCH --qos=medium
#SBATCH --time 01:00:00
#SBATCH --array=0-4
#SBATCH --mail-type=BEGIN,END,FAIL #Send e-mails
#SBATCH --mail-user=carolina.monzo@csic.es

readarray myarray < list_gffs.fof

# Read the file corresponding to the task
file=${myarray[$SLURM_ARRAY_TASK_ID]}

echo $file
start=$SECONDS

filename=$(basename $file)
name="${filename%.gff}"

/usr/bin/time -v singularity exec --bind $(pwd):/data SQANTI-browser/sqanti-browser.sif python SQANTI-browser/sqanti_browser.py --gtf /data/analysis/"${name}"/"${name}"_corrected.gtf --classification /data/analysis/"${name}"/"${name}"_classification.txt --output /data/analysis/"${name}" --genome hg38 --tables --hub-name "${name}"

echo "Completed %A_%a for $file in $SECONDS seconds"
