#!/bin/bash

BUCKET=${BUCKET:-elastiknn-benchmarks}
PREFIX=${PREFIX:-data/amazon-reviews/images}
N=${N:-100000}
N_FINISHED=$(aws s3api list-objects --bucket $BUCKET --prefix $PREFIX --output json --query "length(Contents[])") 

echo "Found $N_FINISHED images already saved"

./catamz.py metadata.json.gz $N_FINISHED $N \
  | jq -r 'select(has("imUrl")) | select(.imUrl|endswith("jpg")) | "\(.imUrl) \(.asin)"' \
  | parallel --jobs 8 --retries 3 --bar --halt now,fail=10% --colsep ' ' "curl -sf {1} | aws s3 cp - s3://$BUCKET/$PREFIX/{2}.jpg"

