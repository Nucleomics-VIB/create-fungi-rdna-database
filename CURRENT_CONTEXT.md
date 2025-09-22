# CURRENT CONTEXT

## Project

A pipeline that collects fungal 18S-ITS-28S sequences from downloaded NCBI sequences and uses these to build a database for sequence classification and phylogenic determination.

## Testing
A `tests` folder has been added to verify the functionality of scripts. It contains:
- `test_barrnap_output.gff`: Example Barrnap GFF file for testing.
- `test_find_rDNA_region.sh`: Bash script to run `find_rDNA_region.py` on the test GFF and show output.

Use these files to confirm that `find_rDNA_region.py` works as expected.
