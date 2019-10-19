To get list of APIs in the account
- Get the Api ID
```
 aws apigateway get-rest-apis --profile sandbox
 ```
 - To get list of Stages
 ```
 aws apigateway get-stages --rest-api-id p8q76zja67 --profile sandbox
 ```
 - To export a swagger file
 ```
 aws apigateway get-export --parameters extensions='apigateway' --rest-api-id p8q88zja67 --profile sandbox --stage-name Prod  --export-type swagger latestswagger2.json
 ```
 - To export a postman file
 ```
 aws apigateway get-export --parameters extensions='postman' --rest-api-id p8q88zja67 --profile sandbox --stage-name Prod  --export-type swagger postman.json
 ```