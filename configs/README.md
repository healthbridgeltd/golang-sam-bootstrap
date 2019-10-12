# `/configs`

Configuration file templates or default configs.

Examples:
* [.env.example](./.env.example) 

    Main configuration for project setup, you need to copy it to .env in the same directory and change the variables inside

* [lambdas-env.json](./lambdas-env.json)

    Override parameters for Lambda's environment variables
    To include SSM Parameters in a sam template do the following
```
      Environment:
        Variables:
          VariableName: '{{resolve:ssm:VariableName:1}}' 
```
    To include a static variable in a template do the following
```
      Environment:
        Variables:
          VariableName: VariableValue
```