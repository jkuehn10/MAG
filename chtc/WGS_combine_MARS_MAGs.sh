#!/bin/bash
set -euo pipefail

echo "Starting MAG combination job on $(hostname)"

# Create working directories
mkdir -p MARS_MAG_ALL

# Copy all per-sample MAG tarballs from staging
cp /staging/kuehn4/MARS_WGS/MARS_MAG_*.tar.gz .

# Extract each tarball into the combined directory
for t in MARS_MAG_*.tar.gz; do
    echo "Extracting $t"
    tar -xzf "$t" -C MARS_MAG_ALL
done

# Create final combined archive
tar -czf MARS_MAG.tar.gz MARS_MAG_ALL

# Move final archive back to staging
mv MARS_MAG.tar.gz /staging/kuehn4/MARS_WGS/

echo "MAG combination complete"
