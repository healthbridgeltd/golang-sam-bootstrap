# GO - SAM - Bootstrap


## How to use this repo

Click on the green button that says "Use this template", then chose a name for your new repository.
This will create a new repository using this one.

## Contributing to this project

[Check contributing guidelines](./contributing.md)


## Prerequisites

* [Golang version 1.11 or later](https://golang.org/doc/install)
* [Docker](https://docs.docker.com/install)
* [AWS Command Line Interface](https://docs.aws.amazon.com/cli/latest/userguide/installing.html)
* [SAM CLI](https://aws.amazon.com/serverless/sam/)
* [Golint](https://github.com/golang/lint)
* [jq](https://stedolan.github.io/jq/)

## Setup Instructions

### Configure AWS Credentials 
- Go to AWS console -> IAM -> Users -> Create, and create new user with programatic access.

- Update your credentials file
```
vim ~/.aws/credentials
```
Add the following section:
```
[sandbox]
aws_access_key_id = AccessKey
aws_secret_access_key = SecretAccessKey
region = eu-west-1
```
Where AccessKey and SecretAccessKey are the keys for the user you created in the console.

### Build docker container
```
make docker_build
```

### Configure project defaults

- Copy the `configs/.env.example` variable file to `configs/.env` and change the project name, username
```
cp configs/.env.example configs/.env
```

- The default stage for deploy command is sandbox, You can override it as follow:
```
make deploy STAGE=staging
```

## Make targets
```
make docker_build       Build the docker image to execute make commands locally
make setup              Create the s3 bucket that will host the artifcats in sandbox
make lint               Code linter
make format             Format Code
make vet                Find errors not caught by the compilers
make tests              Run unit tests
make benchmark          Run benchmark tests
make coverage           Generate coverage report (Doesn't work with docker)
make build              Build go artifcats
make deploy             Deploy application code (template.yml) to sandbox
make run                Run the lambda functions locally
make logs function=FUNCTION-NAME    Display logs of certain function
make destroy            Destroy the stacks (resources & application)
make clean              Delete binaries, coverage reports.
```
