FROM golang:alpine
MAINTAINER Nigel Gibbs <nigel@gibbsoft.com>


ENV TERRAFORM_VERSION=0.8.8
ENV TERRAGRUNT_VERSION=0.11.1
ENV TERRAFORM_CREDSTASH_VERSION=v0.1.0
ENV TERRAGRUNT_TFPATH=/go/bin/terraform
ENV PATH=${PATH}:/go/bin

RUN apk add --update build-base openssh openssl-dev libffi-dev python2 python2-dev py2-pip py-virtualenv git bash curl

RUN mkdir -p ${GOROOT} ${GOROOT}/bin ${GOBIN}

RUN curl -sL https://github.com/gruntwork-io/terragrunt/releases/download/v$TERRAGRUNT_VERSION/terragrunt_linux_386 \
  -o /bin/terragrunt && chmod +x /bin/terragrunt

WORKDIR $GOPATH/src/github.com/hashicorp/terraform
RUN git clone https://github.com/hashicorp/terraform.git ./ && \
    git checkout v${TERRAFORM_VERSION} && \
    /bin/bash scripts/build.sh

WORKDIR $GOPATH
RUN go get -v -u github.com/sspinc/terraform-provider-credstash

WORKDIR $GOPATH
ENTRYPOINT ["/bin/bash"]
