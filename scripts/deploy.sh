#!/usr/bin/env bash

# Package binaries and upload them to S3 bucket
sam package --template-file $4.yaml --s3-bucket $2 --output-template-file build/templates/$1-$4-out.yaml  --profile $1

# Deploy binaries to lambda functions
sam deploy --template-file build/templates/$1-$4-out.yaml --stack-name $3 --capabilities CAPABILITY_IAM --profile $1 --no-fail-on-empty-changeset --parameter-overrides Stage=$1

# View the output after deploying the stack
aws cloudformation describe-stacks --stack-name $3 --profile $1 | jq -r '.Stacks[0].Outputs'