FROM jenkins/inbound-agent:latest-jdk21

USER root

# Install necessary packages (adjust versions as needed)
RUN apt update

RUN apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    net-tools \
    jq \
    gnupg-agent \
    software-properties-common \
    unzip

RUN mkdir -p /etc/docker/

# Create or edit the daemon.json file
RUN echo '{ \
  "iptables": false, \
  "dns": ["8.8.8.8", "8.8.4.4"], \
  "log-driver": "json-file", \
  "log-opts": { \
    "max-size": "10m", \
    "max-file": "3", \
    "tag": "myapp", \
    "path": "/var/log/syslog.log" \
  } \
}' > /etc/docker/daemon.json

RUN ln -sf /dev/stdout /var/log/syslog.log

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker.gpg

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | \
    tee /etc/apt/sources.list.d/docker.list

RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
    echo "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list

RUN apt update

RUN apt install -y docker-ce docker-ce-cli containerd.io
RUN apt install -y terraform

RUN apt clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install AWS CLI v2 (adjust version as needed)
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws awscliv2.zip

USER jenkins
