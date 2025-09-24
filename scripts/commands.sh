myenv=rDNA_database
source /opt/miniconda3/etc/profile.d/conda.sh
conda activate ${myenv} || \
  ( echo "# the conda environment ${myenv} was not found on this machine" ;
    echo "# please read the top part of the script!" \
    && exit 1 )

# datasets download genome taxon 4751 --reference --include genome,seq-report --filename ncbi-dataset.zip
# datasets download taxonomy taxon 4751 --children --filename taxonomy.zip
# unzip both archives for data extraction below

outfolder=barrnap_results
mkdir -p ${outfolder}

# create empty classification file
cat /dev/null > classification.csv

for fasta in $(find ncbi-dataset -name "*.fna"); do
    base=$(basename $(dirname "$fasta"))

    # 1. Extract classification and append to classification.csv
    datasets summary genome accession "$base" | jq -r "\"$base,\" + .reports[0].organism.organism_name" >> classification.csv

    # 2. Predict rDNA genes with Barrnap
    barrnap --kingdom euk --threads 4 "$fasta" > "${outfolder}/${base}_barrnap_output.gff"

    # 3. Extract only contiguous SSU-LSU regions using Python script output
    python ./find_rDNA_region.py "${outfolder}/${base}_barrnap_output.gff" > "${outfolder}/${base}_contiguous_rDNA.bed"

    #Only extract fasta if BED file is not empty
    if [ -s "${outfolder}/${base}_contiguous_rDNA.bed" ]; then
        bedtools getfasta -fi "$fasta" -bed "${outfolder}/${base}_contiguous_rDNA.bed" -fo "${outfolder}/${base}_extracted_rDNA.fa"
    fi
done

# merge and reannotate
cat barrnap_results/*.fa > rDNA_18S_5.8S_28S.fa
barrnap --kingdom euk --threads 24 rDNA_18S_5.8S_28S.fa > rDNA_18S_5.8S_28S.gff

# create csv with asm and contig IDs from fna files
echo "assemblyID,contig_name" > ass2ctg.csv
find ncbi_dataset/data -type f -name "*.fna" | while read -r fasta;
do
  assemblyID=$(basename "$(dirname "$fasta")");
  awk -v id="$assemblyID" '/^>/ { split($1,a," "); sub(/^>/,"",a[1]); print id "," a[1] }' "$fasta";
done >> ass2ctg.csv

# merge ass2ctg.csv and classification into taxonomy.csv
awk -F, '
  BEGIN { OFS = "," }
  NR==FNR {
    # Loading classification.csv into memory hash
    classification[$1] = $2
    next
  }
  FNR==1 {
    # Print header with an added taxonomy column
    print $0, "taxonomy"
    next
  }
  {
    # Lookup taxonomy in hash, default to NA if missing
    tax = ($1 in classification) ? classification[$1] : "NA"
    print $0, tax
  }
' classification.csv ass2ctg.csv > taxonomy.csv


# rename barrnap extracted sequences with taxonomy.csv
./rename_fasta.sh rDNA_18S_5.8S_28S.fa taxonomy.csv rDNA_18S_5.8S_28S_tax.fa
