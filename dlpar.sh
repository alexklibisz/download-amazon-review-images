#!/bin/bash

N=${N:-1000}
S3PREFIX=${S3PREFIX:-s3://elastiknn-benchmarks/data/amazon-reviews/images}

./catamz.py metadata.json.gz $N \
	| jq -r 'select(has("imUrl")) | select(.imUrl|endswith("jpg")) | "\(.imUrl) \(.asin)"' \
	| parallel --bar --halt now,fail=10% --colsep ' ' "curl -sf {1} | aws s3 cp - $S3PREFIX/{2}.jpg"

