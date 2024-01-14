FROM gcr.io/kaniko-project/executor:debug AS kaniko
FROM jenkins/inbound-agent:latest-alpine-jdk21

USER root

RUN apk --update add \
bash \
curl \
git \
jq \
unzip \
npm

RUN wget https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_linux_amd64.zip
RUN unzip terraform_1.6.6_linux_amd64.zip && rm terraform_1.6.6_linux_amd64.zip
RUN mv terraform /usr/bin/terraform
#
# Add kaniko to this image by re-using binaries and steps from official image
#
COPY --from=kaniko /kaniko/ /kaniko/
ENV SSL_CERT_DIR /kaniko/ssl/certs
ENV PATH $PATH:/usr/local/bin:/kaniko
ENV DOCKER_CONFIG /kaniko/.docker/
ENV DOCKER_CREDENTIAL_GCR_CONFIG /kaniko/.config/gcloud/docker_credential_gcr_config.json

# Install AWS CLI v2 (adjust version as needed)
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws awscliv2.zip

RUN chmod 777 /kaniko
RUN echo "jenkins ALL=(ALL) NOPASSWD: /kaniko/executor" >> /etc/sudoers

USER jenkins
