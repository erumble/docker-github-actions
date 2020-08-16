FROM ubuntu:18.04

ARG GH_RUNNER_VERSION
ARG DOCKER_COMPOSE_VERSION

ENV DEBIAN_FRONTEND noninteractive
ENV RUNNER_ALLOW_RUNASROOT true

WORKDIR /opt/runner

RUN apt-get update \
  && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    supervisor \
    jq \    
    software-properties-common
    # sudo \
    # iputils-ping \
    # build-essential \
    # zlib1g-dev \
    # gettext \
    # liblttng-ust0 \
    # libcurl4-openssl-dev

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN chmod 644 /etc/supervisor/conf.d/supervisord.conf

# Install Git
RUN add-apt-repository ppa:git-core/ppa -y \
  && DEBIAN_FRONTEND=noninteractive apt-get update \
  && apt-get install -y \
    git

# Install Docker CLI
RUN curl -fsSL https://get.docker.com -o get-docker.sh \
  && sh get-docker.sh \
  && rm -f get-docker.sh

# Install Docker-Compose
RUN export DOCKER_COMPOSE_VERSION=${DOCKER_COMPOSE_VERSION:-$(curl -s "https://api.github.com/repos/docker/compose/releases/latest" | jq -r '.tag_name')} \
  && echo "Docker Compose Version - $DOCKER_COMPOSE_VERSION" \
  && eval $(curl -s "https://api.github.com/repos/docker/compose/releases/tags/${DOCKER_COMPOSE_VERSION}" \
    | jq -r '.assets[] | select(.name | contains("Linux-x86_64")) | select(.name | contains("sha") | not) | {download_url: .browser_download_url} | to_entries[] | "\(.key)=\(.value | @sh)"') \
  && curl -L $download_url -o /usr/local/bin/docker-compose \
  && chmod +x /usr/local/bin/docker-compose

# Install Github-Actions-Runner
RUN export GH_RUNNER_VERSION=${GH_RUNNER_VERSION:-$(curl -s "https://api.github.com/repos/actions/runner/releases/latest" | jq -r '.tag_name')} \
  && eval $(curl -s "https://api.github.com/repos/actions/runner/releases/tags/${GH_RUNNER_VERSION}" \
    | jq -r '.assets[] | select(.name | contains("linux-x64")) | {file_name: .name,download_url: .browser_download_url} | to_entries[] | "\(.key)=\(.value | @sh)"') \
  && curl -L -O $download_url \
  && tar -zxf $file_name --no-same-owner \
  && rm -f $file_name \
  && ./bin/installdependencies.sh

RUN rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/* \
  && apt-get clean

COPY entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
