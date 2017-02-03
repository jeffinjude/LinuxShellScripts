#!/bin/bash
# Shell script to upload files to aws s3 bucket

# Fetch the  aws access keys from the user
read -p "Please provide your aws access key : " s3Key
read -p "Please provide your aws secret access key : " s3Secret

# Directory where the files to upload are present
file_path="/home/ubuntu/shell-scripts/upload-restapi/files-to-upload"

# Function to upload the files to s3 bucket using rest api
function uploadToS3
{
	objectName=$1
	bucket=jeffin-files
	resource="/${bucket}/${objectName}"
	contentType="text/plain"
	dateValue=`date -R`
	stringToSign="PUT\n\n${contentType}\n${dateValue}\n${resource}"

	# Prepare the authorization header string
	signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${s3Secret} -binary | base64`

	# S3 bucket Rest api to upload file
	curl -v -i -X PUT -T "${file_path}/${objectName}" \
          -H "Host: ${bucket}.s3.amazonaws.com" \
          -H "Date: ${dateValue}" \
          -H "Content-Type: ${contentType}" \
          -H "Authorization: AWS ${s3Key}:${signature}" \
          https://${bucket}.s3.amazonaws.com/${objectName}
}

for file in "$file_path"/*; do
	uploadToS3 "${file##*/}"
done
