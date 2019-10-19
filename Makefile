#!make
include ./configs/.env
export $(shell sed 's/=.*//' ./configs/.env)

AWS_PROFILE ?= sandbox
APP_TEMPLATE = "template"
S3_BUCKET = $(APP_NAME)-$(AWS_PROFILE)-$(USERNAME)

# Set this variable in .env if you don't want to use docker locally  
ifneq ($(USE_DOCKER),no)
	PROJECT_DIR ?=  $(shell pwd)
	DOCKER = docker run -t -v ${PROJECT_DIR}:/app --mount source=go-build-cache,target=/root/.cache --mount source=go-cache,target=/go $(APP_NAME):latest 
endif

.SILENT:
.PHONY: help

## Prints this help screen
help:
	printf "Available targets\n\n"
	awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "%-15s %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

## Create the s3 bucket that will host the artifcats in aws environment
setup:
	aws configure --profile $(AWS_PROFILE)
	aws s3 mb s3://$(S3_BUCKET) --profile $(AWS_PROFILE)

## Build the docker image to execute make commands locally
docker_build:	
	docker volume create go-cache 
	docker volume create go-build-cache
	docker build -f build/ci/Dockerfile . -t $(APP_NAME)

## Build Go artifcats
build: tests
	${DOCKER} scripts/build.sh 

## Build Go artifact for single function (ex: make buildf function={function handler})
buildf: 
	tests
	${DOCKER} scripts/build-function.sh

## Run linter
lint:
	${DOCKER} golint -set_exit_status ./src/... 

## Run benchmark tests
tests: 
	${DOCKER} go test -covermode=count -coverprofile=build/coverage/count.out ./src/...

## Format code
format:
	${DOCKER} go fmt ./src/...

## Find errors not caught by the compilers
vet:
	${DOCKER} go vet ./src/...

## Deploy application code (template.yml) to aws environment
deploy:			
	scripts/deploy.sh $(AWS_PROFILE) $(S3_BUCKET) $(APP_NAME) ${APP_TEMPLATE}

## Find race condition errors
race:
	${DOCKER} go test -race -short ./src/...

## Run benchmark tests
benchmark:
	${DOCKER} go test -bench=. ./src/...
	
## Generate coverage report (Doesn't work with docker)
coverage: tests
	go tool cover -html=build/coverage/count.out

## Run the lambda functions locally
run:			
	sam local start-api --env-vars configs/lambdas-env.json --profile $(AWS_PROFILE)

## Display logs of certain function (ex: make logs function=FUNCTION-NAME)
logs:			
	sam logs -n $(function) --stack-name $(APP_NAME) --profile $(AWS_PROFILE)

## Destroy the stacks (resources & application)
destroy:		
	aws cloudformation delete-stack --stack-name $(APP_NAME) --profile $(AWS_PROFILE)

## Delete binaries, coverage reports.
clean: 			
	rm -rf ./build/package/*
	rm -rf ./build/templates/*
	rm -rf ./build/coverage/*


