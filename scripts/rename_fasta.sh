#!/bin/bash

# Usage: ./rename_fasta.sh input.fasta taxonomy.csv output.fasta

FASTA="$1"
CSV="$2"
OUT="$3"

bioawk -c fastx -v csv="$CSV" '
    BEGIN {
        FS = ",";
        while ((getline < csv) > 0) {
            assemblyID = $1;
            contig = $2;
            tax = $3;
            gsub(/\r$/, "", tax);
            map[contig] = assemblyID "\t" tax;
        }
        close(csv);
    }
    {
        split($name, a, ":");
        contig_name = a[1];
        coords = (length(a) > 1) ? ":" a[2] : "";
        if (contig_name in map) {
            split(map[contig_name], fields, "\t");
            assemblyID = fields[1];
            tax = fields[2];
            print ">" assemblyID ":" contig_name coords " " tax;
        } else {
            # If no match, print original contig_name with coords and NA
            print ">" contig_name coords " NA";
        }
        print $seq;
    }
' "$FASTA" > "$OUT"

