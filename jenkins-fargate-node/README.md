# Custom Jenkins agent image

# Overview
This image based on the latest LTS Java 21 and adds some important CLIs:

- `Docker` CLI
- `AWS CLI`
- `Terraform`

# How to build

```
docker build -t cli-java21-jenkins-agent .
docker tag cli-java21-jenkins-agent:latest public.ecr.aws/q7a1j3e0/pub/cli-java21-jenkins-agent:1.0.0
docker push public.ecr.aws/q7a1j3e0/pub/cli-java21-jenkins-agent:1.0.0
```