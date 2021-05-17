FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive
ENV DEBIAN_PRIORITY critical

ENV chia_service="farmer"
ENV chia_update_on_init="true"
ENV chia_dir="/chia-blockchain"
ENV keys="generate"
ENV harvester="false"
ENV farmer="false"
ENV plots_dir="/plots"
ENV farmer_address="localhost"
ENV farmer_port=8447
ENV full_node_port=8444
ENV testnet="false"
ENV PATH=/chia-blockchain/venv/bin/:$PATH
ENV branch="latest"

#Keeping this way for use in TrueNAS Helm chart
ARG branch_arg

RUN apt-get update ; \
    apt-get install -qy curl jq python3 ansible tar bash ca-certificates git openssl unzip wget python3-pip sudo acl build-essential python3.8-dev python3.8-venv python3.8-distutils apt nfs-common python-is-python3 nano bc apt-utils ; \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/Chia-Network/chia-blockchain.git -b latest --recurse-submodules

WORKDIR /chia-blockchain

COPY scripts/chia_update.sh /usr/local/bin/chia_update.sh

RUN /usr/bin/sh ./install.sh
RUN chmod +x /usr/local/bin/chia_update.sh
RUN mkdir /plots
ADD ./entrypoint.sh entrypoint.sh

EXPOSE 8555 8444 8447

ENTRYPOINT ["bash", "./entrypoint.sh"]
