# Golang + AWS SAM bootstrap

## How to use this repo

Click on the green button that says "Use this template", then chose a name for your new repository.
This will create a new repository using this one.

![](how-to-use.gif)


## Contributing to this project

[Check contributing guidelines](./contributing.md)

## Setup Instructions

### Prerequisites

* [Golang version 1.11 or later](https://golang.org/doc/install) (_If you don't plan to use docker for local development_)
* [Docker](https://docs.docker.com/install)
* [AWS Command Line Interface](https://docs.aws.amazon.com/cli/latest/userguide/installing.html)
* [SAM CLI](https://aws.amazon.com/serverless/sam/)
* [Golint](https://github.com/golang/lint)
* [jq](https://stedolan.github.io/jq/)


### Project Configuration

- Copy the `configs/.env.example` variable file to `configs/.env` and change the project name, username, aws profile.
```
cp configs/.env.example configs/.env
```

### Project Setup
- Go to AWS console -> IAM -> Users -> Create, and create new user with programmatic access.

- Run the following commands, and use the IAM key / secret you generated.
```
make setup
```

### Docker container build
```
make docker_build
```

### Build Go artifacts
Golang is a statically compiled language, that means in order to run it, you need to build the executable targets
```
make build
```

### Local Development
To invoke the function locally through API Gateway
```
make run
```
When this command runs successfully, you will see the endpoints you can invoke


### AWS Deployment
To deploy the application to your aws account, invoke the following command
```
make deploy
```

- The default profile for deploy command is the aws profile in your .env, You can override it as follow:
```
make deploy STAGE=staging
```

## Make targets
```
help            Prints this help screen
setup           Create the s3 bucket that will host the artifcats in sandbox
docker_build    Build the docker image to execute make commands locally
build           Build Go artifcats
buildf          Build Go artifact for single function (ex: make buildf function={function handler})
lint            Run linter
tests           Run benchmark tests
format          Format code
vet             Find errors not caught by the compilers
deploy          Deploy application code (template.yml) to sandbox
race            Find race condition errors
benchmark       Run benchmark tests
coverage        Generate coverage report (Doesn't work with docker)
run             Run the lambda functions locally
logs            Display logs of certain function (ex: make logs function=FUNCTION-NAME)
destroy         Destroy the stacks (resources & application)
clean           Delete binaries, coverage reports.
```
