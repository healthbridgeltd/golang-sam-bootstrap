#!/bin/sh

# Build Binary for each function
CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-extldflags "-static"' -o build/package/"$function" ./src/cmd/lambdas/"$function"

# Copy assets to package dir so it is available for lambda in /var/task
cp -R ./src/assets build/package

echo  "\033[33;5mFunction ${function} build is complete.\033[0m"