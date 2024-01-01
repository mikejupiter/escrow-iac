# Custom Jenkins agent image

# Overview
This image based on the latest LTS Java 21 and adds some important CLIs:

- `Docker` CLI
- `AWS CLI`
- `Terraform`

# Prepare AWS ECR

create public repo like `public.ecr.aws/q7a1j3e0/cli-java21-jenkins-agent`

# How to build

```
docker build -t cli-java21-jenkins-agent .
docker tag cli-java21-jenkins-agent:latest public.ecr.aws/q7a1j3e0/cli-java21-jenkins-agent:1.0.0


#create env vars

export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=

aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/q7a1j3e0

docker push public.ecr.aws/q7a1j3e0/cli-java21-jenkins-agent:1.0.0
```