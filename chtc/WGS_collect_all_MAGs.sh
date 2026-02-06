#!/bin/bash
set -euo pipefail

echo "Processing sample: $1"

# Create directories (safe if already exist)
mkdir -p MARS_MAG
mkdir -p _tmp_extract

# Copy tarball from staging
cp /staging/kuehn4/MARS_WGS/metabat2_out_$1.tar.gz .

# Extract into temp directory
tar -xzf metabat2_out_$1.tar.gz -C _tmp_extract

# Copy and rename MAGs to avoid overwriting
for f in _tmp_extract/metabat2_out_$1/bin*.fa; do
    cp "$f" "MARS_MAG/$1_$(basename "$f")"
done

# Clean temp directory
rm -rf _tmp_extract/metabat2_out_$1

# Package results for this job
tar -czf MARS_MAG_$1.tar.gz MARS_MAG

# Move output back to staging
mv MARS_MAG_$1.tar.gz /staging/kuehn4/MARS_WGS

