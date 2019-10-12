#!/bin/sh

# Extract functions names from SAM template
FUNCTIONS_NAMES=`cat template.yaml | grep 'Handler' | awk -f scripts/utils/script.awk | cut -c 2-`

for FUNCTION in $(echo $FUNCTIONS_NAMES | sed "s/,/ /g")
do
	# Build Binary for each function
CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-extldflags "-static"' -o build/package/"$FUNCTION" ./src/cmd/lambdas/"$FUNCTION"
done

# Copy assets to package dir so it is available for lambda in /var/task
cp -R ./src/assets build/package

echo  "\033[33;5mAll functions build is complete.\033[0m"