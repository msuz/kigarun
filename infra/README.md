# kigarun infra

## usage

```
% cd kigarun/infra
% terraform init
% terraform plan
% terraform apply
  Enter a value: yes
```

<details><summary>optional</summary><div>

```
% aws dynamodb list-tables
{
    "TableNames": [
        "GameScores"
    ]
}
```

```
% api_id=$(aws apigateway get-rest-apis | jq -r '.items[] | select(.name=="KigarunAPI") | .id') && \
region=$(aws configure get region) && \
stage_name=$(aws apigateway get-stages --rest-api-id $api_id | jq -r '.item[0].stageName') && \
KIGARUN_API="https://${api_id}.execute-api.${region}.amazonaws.com/${stage_name}" && \
echo ${KIGARUN_API}

% curl -s -X GET "${KIGARUN_API}/message" | jq .
{
  "status": "ok",
  "message": "hello world"
}

```
% terraform destroy
  Enter a value: yes
```

```
% aws dynamodb list-tables
{
    "TableNames": []
}
```
</div></details>

## setup

* date: 2024/03/08 
* env: MacBook Apple M1 Sonoma 14.3.1

### create aws iam user

* IAM > User > [kigarun_infra](https://us-east-1.console.aws.amazon.com/iamv2/home?region=us-east-1#/users/details/kigarun_infra)
* Role: AdministratorAccess
* Security credentials > Access keys > Create access key
  * Command Line Interface (CLI)
  * Access key created. This is the only time that the secret access key can be viewed or downloaded.
  * Download .csv file.

### install and configure awscli

<details><summary>old version</summary><div>

```
% sudo pip install awscli

% aws --version
aws-cli/1.32.58 Python/3.9.6 Darwin/23.3.0 botocore/1.34.58

% aws configure --profile xxx
Note: AWS CLI version 2, the latest major version of the AWS CLI, is now stable and recommended for general use. For more information, see the AWS CLI version 2 installation instructions at: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html

% sudo pip uninstall awscli
```
</div></details>

https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

```
% cd ~/Downloads

% curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"

% sudo installer -pkg ./AWSCLIV2.pkg -target /

% which aws
/usr/local/bin/aws

% aws --version
aws-cli/2.15.26 Python/3.11.8 Darwin/23.3.0 exe/x86_64 prompt/off
```

configure

```
% aws configure --profile kigarun_infra
AWS Access Key ID [None]: (copied from the .csv file)
AWS Secret Access Key [None]: (copied from the .csv file)
Default region name [None]: ap-northeast-1
Default output format [None]: json

% export AWS_PROFILE=kigarun_infra

% echo 'export AWS_PROFILE=kigarun_infra' >> ~/.zshrc # option

% aws iam list-attached-user-policies --user-name kigarun_infra
{
    "AttachedPolicies": [
        {
            "PolicyName": "AdministratorAccess",
            "PolicyArn": "arn:aws:iam::aws:policy/AdministratorAccess"
        }
    ]
}
```

### install terraform

<details><summary>old version</summary><div>

```
% brew install terraform

% which terraform
/opt/homebrew/bin/terraform

% terraform version
Terraform v1.5.7
on darwin_arm64

Your version of Terraform is out of date! The latest version
is 1.7.4. You can update by downloading from https://www.terraform.io/downloads.html
```

https://www.terraform.io/downloads.html
redirected to https://developer.hashicorp.com/terraform/install　
</div></details>


```
% brew tap hashicorp/tap
% brew install hashicorp/tap/terraform
% terraform version             
Terraform v1.7.4
on darwin_arm64
```

### init terraform file

```
% cd ~/git/kigarun/infra

% ls *.tf
dynamodb.tf

% terraform init
```