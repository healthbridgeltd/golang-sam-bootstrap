#!make
include ./configs/.env
export $(shell sed 's/=.*//' ./configs/.env)

AWS_PROFILE ?= default
APP_TEMPLATE = "template"
S3_BUCKET = $(APP_NAME)-$(AWS_PROFILE)-$(USERNAME)

# Set this variable in .env if you don't want to use docker locally  
ifneq ($(ENVIRONMENT),local)
	PROJECT_DIR ?=  $(shell pwd)
	DOCKER = docker run -t -v ${PROJECT_DIR}:/app --mount source=go-build-cache,target=/root/.cache --mount source=go-cache,target=/go $(APP_NAME):latest 
endif

setup:
	aws s3 mb s3://$(S3_BUCKET) --profile $(AWS_PROFILE)
	sed 's/golang-sam-bootstrap/$(APP_NAME)/g' go.mod 
	sed 's/golang-sam-bootstrap/$(APP_NAME)/g' template.yaml

build: tests
	${DOCKER} scripts/build.sh 

buildf: tests
${DOCKER} scripts/build-function.sh

lint:
	${DOCKER} golint -set_exit_status ./src/... 

tests: 
	${DOCKER} go test -covermode=count -coverprofile=build/coverage/count.out ./src/...

format:
	${DOCKER} go fmt ./src/...

vet:
	${DOCKER} go vet ./src/...

deploy:
	scripts/deploy.sh $(AWS_PROFILE) $(S3_BUCKET) $(APP_NAME) ${APP_TEMPLATE}

race:
	${DOCKER} go test -race -short ./src/...

benchmark:
	${DOCKER} go test -bench=. ./src/...
  
coverage: tests
	go tool cover -html=build/coverage/count.out

run:
	sam local start-api --env-vars configs/lambdas-env.json --profile $(AWS_PROFILE)

logs:
	sam logs -n $(function) --stack-name $(APP_NAME) --profile $(AWS_PROFILE)

destroy:
	aws cloudformation delete-stack --stack-name $(APP_NAME) --profile $(AWS_PROFILE)

clean: 
	rm -rf ./build/package/*
	rm -rf ./build/templates/*
	rm -rf ./build/coverage/*

docker_build:
	docker volume create go-cache 
	docker volume create go-build-cache
	docker build -f build/ci/Dockerfile . -t $(APP_NAME)