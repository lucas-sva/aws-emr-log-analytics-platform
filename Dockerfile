FROM amazon/aws-cli:latest
LABEL authors="lucas-galdino"

RUN yum update -y && \
    yum install -y yum-utils unzip git tar jq

RUN yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo && \
    yum install -y terraform-1.14.3

WORKDIR /infra

ENTRYPOINT ["/bin/bash"]