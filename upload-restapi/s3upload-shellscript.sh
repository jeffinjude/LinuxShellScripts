#!/bin/bash
# Shell script to upload file to aws s3 bucket

current_time=$(date "+%Y.%m.%d-%H.%M.%S")
objectName=sample-text_$current_time.txt
file=sample-text.txt
bucket=jeffin-files
resource="/${bucket}/${objectName}"
contentType="text/plain"
dateValue=`date -R`
stringToSign="PUT\n\n${contentType}\n${dateValue}\n${resource}"

# Fetch the  aws access keys from the user
read -p "Please provide your aws access key : " s3Key
read -p "Please provide your aws secret access key : " s3Secret

# Prepare the authorization header string
signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${s3Secret} -binary | base64`

# S3 bucket Rest api to upload file
curl -v -i -X PUT -T "${file}" \
          -H "Host: ${bucket}.s3.amazonaws.com" \
          -H "Date: ${dateValue}" \
          -H "Content-Type: ${contentType}" \
          -H "Authorization: AWS ${s3Key}:${signature}" \
          https://${bucket}.s3.amazonaws.com/${objectName}
