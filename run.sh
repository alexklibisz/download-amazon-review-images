#!/bin/bash
set -e

BUCKET=${BUCKET:-elastiknn-benchmarks}
PREFIX=${PREFIX:-data/amazon-reviews/images}
N=${N:-10000}
SKIP=${SKIP:-$(aws s3api list-objects --bucket $BUCKET --prefix $PREFIX --output json --query "length(Contents[])" || echo 0)}
JOBS=${JOBS:-$(grep -c processor /proc/cpuinfo)}

echo "Skipping first $SKIP images. Reading next $N images with parallelism $JOBS"

python3 -u catamz.py $1 $SKIP $N \
  | parallel --jobs $JOBS --bar --retries 3 --halt now,fail=10 --colsep ' ' \
  "curl -sf {1} | aws s3 cp - s3://$BUCKET/$PREFIX/{2}.jpg"
