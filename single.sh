#!/bin/bash
set -e

url=$1
bucket=$2
key=$3

date=`date +%Y%m%d`
date_fmt=`date -R`
rel_path="/${bucket}/${key}"
content_type="application/octet-stream"
string_to_sign="PUT\n\n${content_type}\n$date_fmt\n$rel_path"
signature=`echo -en $string_to_sign | openssl sha1 -hmac $AWS_SECRET_ACCESS_KEY -binary | base64`

curl -sf $url | curl -sf -X PUT --data-binary @- \
-H "Host: $bucket.s3.amazonaws.com" \
-H "Date: $date_fmt" \
-H "Content-Type: $content_type" \
-H "Authorization: AWS $AWS_ACCESS_KEY_ID:$signature" \
http://$bucket.s3.amazonaws.com/$key