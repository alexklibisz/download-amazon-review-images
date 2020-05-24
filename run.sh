#!/bin/bash
set -e

bucket=${bucket:-elastiknn-benchmarks}
prefix=${prefix:-data/raw/amazon-reviews/images}
n=${n:-1000}
skip=${skip:-$(aws s3api list-objects --bucket $bucket --prefix $prefix --output json --query "length(Contents[])" || echo 0)}
jobs=${jobs:-$(grep -c processor /proc/cpuinfo)}

echo "Skipping first $skip images. Reading next $n images with parallelism $jobs"

python3 -u catamz.py $1 $skip $n \
  | parallel --jobs $jobs --joblog $1.log --resume --retries 5 --halt now,fail=1000 --colsep ' ' \
  "./single.sh {1} $bucket $prefix/{2}.jpg && echo {#} {}"
