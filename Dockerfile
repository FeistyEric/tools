# docker build -t doctl_local --build-arg DOCTL_VERSION=1.23.1 .
#
# This Dockerfile exists so casual uses of `docker build` and `docker run` do something sane.
# We don't recommend using it: If you want to develop in docker, please use `make docker_build`
# instead.

FROM debian:buster

ENV PATH=${PATH}:/root/.krew/bin:/root/.arkade/bin:/root/.linkerd2/bin

RUN apt-get update && apt-get install -y \
  apt-utils \
  curl \
  git \
  openssl \
  zsh \
  tree \
  vim \
  jq \
  wget \
  gdebi-core \ 
  net-tools \
  procps \
  python \
  python-pip \
  awscli \
  uuid-runtime
  
#   && rm -rf /var/lib/apt/lists/*

RUN bash

WORKDIR /root


RUN curl -sLS https://dl.get-arkade.dev | sh
RUN arkade --help
RUN ark --help  # a handy alias

RUN ark get helm

RUN helm plugin install --version master https://github.com/sonatype-nexus-community/helm-nexus-push.git
RUN helm nexus-push --help

RUN ark get kubectl
RUN ark get kubectx
RUN ark get doctl
RUN ark get k9s
RUN ark get popeye
RUN arg get krew
RUN ark get likerd2

RUN kubectl krew install ns
RUN kubectl krew install ctx
RUN kubectl krew install cert-manager
RUN kubectl krew install popeye

RUN git clone https://github.com/andrey-pohilko/registry-cli.git
RUN pip install -r registry-cli/requirements-build.txt

RUN /root/registry-cli/registry.py || :
 
 
RUN curl -L https://github.com/gimlet-io/gimlet-cli/releases/download/v0.3.0/gimlet-$(uname)-$(uname -m) -o gimlet
RUN chmod +x gimlet
RUN mv ./gimlet /usr/local/bin/gimlet
RUN gimlet --version
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /tmp/*
CMD ["sleep", "infinity"]

