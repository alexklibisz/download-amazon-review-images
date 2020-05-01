#!/bin/bash
set -e

BUCKET=${BUCKET:-elastiknn-benchmarks}
PREFIX=${PREFIX:-data/amazon-reviews/images}
N=${N:-10000}
N_FINISHED=$(aws s3api list-objects --bucket $BUCKET --prefix $PREFIX --output json --query "length(Contents[])" || echo 0)
JOBS=${JOBS:-$(grep -c processor /proc/cpuinfo)}

echo "Found $N_FINISHED images already saved. Reading $N more images with parallelism $JOBS"

python3 -u catamz.py metadata.json.gz $N_FINISHED $N \
  | parallel --jobs $JOBS --bar --retries 3 --halt now,fail=10 --colsep ' ' \
  "echo {1} > /dev/null"

exit 0

#tail -n +$N_FINISHED url_asin.txt | head -n $N \
#  | parallel --jobs $JOBS --bar --retries 3 --halt now,fail=1 --colsep ' ' \
#  "curl -sf {2} | aws s3 cp - s3://$BUCKET/$PREFIX/{2}.jpg" 

#tail -n +$N_FINISHED url_asin.txt | head -n $N \
#  | parallel --jobs $JOBS --bar --retries 3 --halt now,fail=10% --colsep ' ' \
#  "curl -sf {1} | aws s3 cp - s3://$BUCKET/$PREFIX/{2}.jpg" 

