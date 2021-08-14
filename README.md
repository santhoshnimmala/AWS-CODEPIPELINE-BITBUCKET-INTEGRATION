# CodePipeline Integration with Bitbucket Server
This blog post presents a solution to integrate the AWS CodePipeline with Bitbucket Server. If you want to integrate with Bitbucket Cloud, consult this [post](https://aws.amazon.com/blogs/devops/integrating-git-with-aws-codepipeline/). The Lambda Function provided can get the source code from a Bitbucket Server repository whenever the user sends a new code push and store it in a designed S3 bucket.

The Bitbucket Server integration is performed by using webhooks configured in the Bitbucket repository. Webhooks are ideal for this case, and it avoids the need for performing frequent pooling to check for changes in the repository.

Some security protection are available with this solution.
* The S3 bucket has encryption enabled using SSE-AES, and every objected created is encrypted by default.
* The Lambda Function accepts only events signed by the Bitbucket Server.
* All environment variables used by the Lambda Function are encrypted in rest using the AWS Key Management Service (KMS).

## Overview
The figure below shows how the integration works. During the creation of the CloudFormation stack, you can select using API Gateway or ELB to communicate with the Lambda Function.

![Solution Diagram](component_infra/assets/diagram.png)

1. The user pushes code to the Bitbucket repository. 
2. Based on that user action, the Bitbucket server generates a new webhook event and send it to  API Gateway.
3. The API Gateway  forwards the request to the Lambda Function, then the Lambda Function moves to the next step.
4. The Lambda Function calls the Bitbucket server API and requests it to generate a ZIP package with the content of the branch modified by the user in step 1. 
5. The Lambda Function sends the ZIP package to the S3 bucket.
6. The CodePipeline is triggered when it detected a new or updated file in the S3 bucket path.


## Requirements
* Before starting the solution setup, make sure you have an S3 bucket available to store the Terraform Statefiles.
* IAM Profile to Provision above Resources 
* Terraform >= 12.0

## Setup

### Create a personal token on the Bitbucket server
In this step, you create a personal token on the Bitbucket server that the Lambda Function uses to access the repository.

1. Log in into the Bitbucket server.
1. In the top right, click on your user avatar and select the option **Manage Account**. 
1. In the Account screen, select the option **Personal access tokens**.
1. Click in **Create a token**.
1. Fill out the form with the Token name, and in the *Permissions*  section leave as is with Read for Projects and Repositories. Click on the **Create** button to finish.

### Terraform apply 
In this step, create a zip file of your lambda function .

#### Clone the Git repository containing the solution source code
```bash
git clone https://github.com/aws-samples/aws-codepipeline-bitbucket-integration.git
```

#### Terraform Init , Plan, and Apply
```bash
cd component_infra
terraform init 
terraform plan 
terraform apply 

```


#### Edit/Add new parameters variable.tf and terraform.tfvars
Open the file located at infra/parameters.json in your favorite text editor and replace the parameters accordingly.

Parameter Name | Description
------------ | -------------
project_url | URL of your Bitbucket Server e.g. https://server:port
token | Bitbucket server Personal token used by the Lambda Function to access the Bitbucket API. 
bucketname | S3 bucket name that this stack creates to store the Bitbucket repository content.
Change backen.tf | Backend bucketname

### Create a webhook on the Bitbucket Server
Now you create the webhook on Bitbucket server to notify the Lambda Function of push events to the repository.

1. Log into the Bitbucket server and navigate to the repository page. 
1. In the left side, click on the **Repository settings** button.
1. In the **Repository settings** screen, click on the **Webhook** option.
1. Click on the **Create webhook** button.
1. Fill out the form with the name of the webhook, for example, CodePipeline.
1. Fill out the **URL** field with the API Gateway or Load Balancer URL. To obtain this URL, click on the Outputs tab of the CloudFormation stack.
1. Fill out the field **Secret** with the same value used in the CloudFormation stack.
1. In the Events section, keep the option **Push** selected.
1. Click on the button **Create** to finish.
1. Repeat these steps for each repository that you want to enable the integration.

### Configure your pipeline
Lastly, change your pipeline on AWS CodePipeline to use the S3 bucket created by the Terraform  as the source of your pipeline.

The Lambda Function uploads the files to the S3 bucket using the following path structure:
branchname.zip

Now every time someone pushes code to the Bitbucket repository, your pipeline starts automatically.

## Conclusion
In this post you learned how to integrate your Bitbucket Server with AWS CodePipeline.

## Credits

 last but not least i have taken some references from  aws-samples [post](https://github.com/aws-samples/aws-codepipeline-bitbucket-integration)