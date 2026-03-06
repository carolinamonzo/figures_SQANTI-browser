#for file in $(cat gtfs.fof);
#do filename="${file%.*}";
#outname="${filename%_S*}";
#python ~/workspace/SQANTI-browser/sqanti_browser.py --gtf ${filename}/${filename}_corrected.gtf --classification ${filename}/${filename}_classification.txt --output ./${filename} --genome SIRV4 --tables --no-category-tracks --hub-name ${outname} --twobit ~/workspace/SQANTI-browser/example/SQANTI3_QC_custom_genome/SIRVS.2bit;
#done

python ~/workspace/SQANTI-browser/sqanti_browser.py --gtf collapse_QC/PacBio_isoforms_collapse_QC.gtf --classification collapse_QC/PacBio_isoforms_collapse_QC_classification.txt --output ./collapse_QC --genome SIRV4 --tables --no-category-tracks --hub-name PacBio_isoseq_collapse_QC --twobit ~/workspace/SQANTI-browser/example/SQANTI3_QC_custom_genome/SIRVS.2bit --no-highlight

python ~/workspace/SQANTI-browser/sqanti_browser.py --gtf collapse_filter/PacBio_isoseq_collapse_filter.gtf --classification collapse_filter/PacBio_isoseq_collapse_filter_classification.txt --output ./collapse_filter --genome SIRV4 --tables --no-category-tracks --hub-name PacBio_isoseq_collapse_filter --twobit ~/workspace/SQANTI-browser/example/SQANTI3_QC_custom_genome/SIRVS.2bit --no-highlight

python ~/workspace/SQANTI-browser/sqanti_browser.py --gtf collapse_rescue/PacBio_isoseq_collapse_rescue.gtf --classification collapse_rescue/PacBio_isoseq_collapse_rescue_classification.txt --output ./collapse_rescue --genome SIRV4 --tables --no-category-tracks --hub-name PacBio_isoseq_collapse_rescue --twobit ~/workspace/SQANTI-browser/example/SQANTI3_QC_custom_genome/SIRVS.2bit --no-highlight
