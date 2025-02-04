FROM gcr.io/kaniko-project/executor:debug AS kaniko
FROM jenkins/inbound-agent:latest-alpine-jdk21

USER root

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
  rm -rf /tmp/* && \
  rm -rf /var/cache/apk/*


RUN wget https://releases.hashicorp.com/terraform/1.10.5/terraform_1.10.5_linux_amd64.zip
RUN unzip terraform_1.10.5_linux_amd64.zip && rm terraform_1.10.5_linux_amd64.zip
RUN mv terraform /usr/bin/terraform
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

USER jenkins
