FROM gcr.io/kaniko-project/executor:debug AS kaniko
FROM jenkins/inbound-agent:latest-alpine-jdk21

USER root

ENV TRRAFORM_VERSION=1.11.4

# Install required tools
RUN apk update && \
    apk add --no-cache \
    bash \
    sudo \
    curl \
    git \
    jq \
    unzip \
    npm \
    python3 \
    py3-pip \
    aws-cli \
    ansible && \
    rm -rf /tmp/* /var/cache/apk/*

# Install Terraform
RUN wget https://releases.hashicorp.com/terraform/${TRRAFORM_VERSION}/terraform_${TRRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TRRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/bin/terraform && \
    rm terraform_${TRRAFORM_VERSION}_linux_amd64.zip

#
# Add kaniko to this image by re-using binaries and steps from official image
#
COPY --from=kaniko /kaniko/ /kaniko/
ENV SSL_CERT_DIR /kaniko/ssl/certs
ENV PATH $PATH:/usr/local/bin:/kaniko
ENV DOCKER_CONFIG /kaniko/.docker/
ENV DOCKER_CREDENTIAL_GCR_CONFIG /kaniko/.config/gcloud/docker_credential_gcr_config.json


RUN chmod 777 /kaniko
RUN echo "jenkins ALL=(ALL) NOPASSWD:SETENV: /kaniko/executor" >> /etc/sudoers

RUN mkdir -p /workspace

USER jenkins

