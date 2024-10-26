# syntax=docker/dockerfile:labs
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

USER root

RUN apt-get update && apt-get install -y curl sudo bash openssl fuse3 fuse-overlayfs lsof && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu noble stable" > /etc/apt/sources.list.d/docker.list

RUN apt-get update && apt-get upgrade -y && apt-get install -y ca-certificates iproute2 \
    docker-ce docker-ce-cli containerd.io docker-compose-plugin && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV INSTALL_DOCKER=false
ENV INSTALL_COMPOSE=false
ENV SKIP_DOCKER_RESTART_FLAG_FILE=true
#ENV SKIP_EGRESS=false
#ENV SKIP_V4L2LOOPBACK=true
#ENV SKIP_CUSTOM_RCLONE=true
#ENV FORCE_DEPS_INSTALL=true

RUN mkdir -p /install && mkdir -p /runtime && cd /install && \
    curl -O https://kasm-static-content.s3.amazonaws.com/kasm_release_1.16.0.a1d5b7.tar.gz && \
    tar -xf kasm_release_1.16.0.a1d5b7.tar.gz && \
    sed -i 's/^\s*ulimit -Hn 524288/#&/' /etc/init.d/docker && \
    sed -i '/sudo service docker restart/s/^/#/' /install/kasm_release/install.sh

COPY build/setup.sh /install/setup.sh
COPY runtime/startup.sh /runtime/startup.sh
COPY runtime/docker.sh /runtime/docker.sh

ARG HOSTNAME=kasm-agent-container
ARG MANAGER_HOSTNAME=kasm-proxy

ENV HOSTNAME=${HOSTNAME}
ENV MANAGER_HOSTNAME=${MANAGER_HOSTNAME}

RUN --security=insecure /install/setup.sh && \
    kill $(cat /var/run/docker.pid) && rm -rf /install && \
    rm /var/run/docker.pid && \
    docker logout

EXPOSE 443

CMD ["/bin/bash", "/runtime/startup.sh"]
