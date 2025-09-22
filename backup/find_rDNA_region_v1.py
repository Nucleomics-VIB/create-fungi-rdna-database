#!/usr/bin/env python3

# Usage:
#    python find_rDNA_region.py <barrnap_output.gff>
# Description:
#    This script parses a Barrnap GFF file and finds contiguous SSU-LSU rDNA regions on each scaffold.
#    Contiguity is required as the query sequences will be from amplicons spanning the two genes
#    The default maximum allowed gap between SSU and LSU is 2000 bp (adjustable via MAX_GAP).
#    Output: tab-separated lines: scaffold  start  end

import sys

# Set maximum gap between SSU and LSU to consider them contiguous (default 2000 bp)
MAX_GAP = 2000

def parse_gff(gff_file):
    """
    Parse the barrnap GFF file to extract rRNA features:
    Returns a dict: scaffold -> list of (feature_type, start, end)
    """
    features = {}
    with open(gff_file, 'r') as f:
        for line in f:
            if line.startswith('#'):
                continue
            fields = line.strip().split('\t')
            if len(fields) < 9:
                continue
            scaffold, source, feature_type, start, end, score, strand = fields[0], fields[1], fields[2], int(fields[3]), int(fields[4]), fields[5], fields[6]
            # We consider only rRNA features: SSU_rRNA, LSU_rRNA, 18S_rRNA, 28S_rRNA
            # Adjust feature_type checks based on barrnap output annotation style
            if 'rRNA' in feature_type:
                # Normalize feature type: SSU, LSU, or other
                feat = None
                # Accept both classic and numeric names
                if ('SSU' in feature_type or 'small subunit' in feature_type.lower() or '18S' in feature_type or '18S' in fields[8]):
                    feat = 'SSU'
                elif ('LSU' in feature_type or 'large subunit' in feature_type.lower() or '28S' in feature_type or '28S' in fields[8]):
                    feat = 'LSU'
                else:
                    continue
                features.setdefault(scaffold, []).append((feat, start, end, strand))
    return features


def find_contiguous(features, max_gap=MAX_GAP):
    """
    Find SSU-LSU pairs on the same scaffold that are contiguous or separated by <= max_gap
    Returns a list of tuples: (scaffold, start, end, strand)
    """
    contiguous_regions = []
    for scaffold, feats in features.items():
        # Sort by start coordinate
        feats.sort(key=lambda x: x[1])
        for i in range(len(feats) - 1):
            feat1, start1, end1, strand1 = feats[i]
            feat2, start2, end2, strand2 = feats[i + 1]
            # Plus strand: SSU (18S) then LSU (28S)
            if strand1 == '+' and strand2 == '+':
                if feat1 == 'SSU' and feat2 == 'LSU':
                    gap = start2 - end1
                    if 0 <= gap <= max_gap:
                        contiguous_regions.append((scaffold, start1, end2, '+'))
            # Minus strand: LSU (28S) then SSU (18S)
            elif strand1 == '-' and strand2 == '-':
                if feat1 == 'LSU' and feat2 == 'SSU':
                    gap = start2 - end1
                    if 0 <= gap <= max_gap:
                        contiguous_regions.append((scaffold, start1, end2, '-'))
    return contiguous_regions
    return contiguous_regions


def main():
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} barrnap_output.gff", file=sys.stderr)
        sys.exit(1)
    gff_file = sys.argv[1]
    features = parse_gff(gff_file)
    contiguous = find_contiguous(features)
    # Output BED format: chrom, start-1, end, name, score, strand
    for scaffold, start, end, strand in contiguous:
        print(f"{scaffold}\t{start-1}\t{end}\trDNA_region\t0\t{strand}")


if __name__ == "__main__":
    main()