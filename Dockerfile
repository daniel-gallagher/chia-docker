FROM ubuntu:latest

EXPOSE 8555
EXPOSE 8444

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

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
    curl jq python3 ansible tar bash ca-certificates git openssl unzip wget python3-pip sudo acl build-essential python3.9 python3.9-dev python3.9-venv python3.9-distutils apt nfs-common python-is-python3 nano tzdata

RUN echo "cloning ${branch}"
RUN git clone https://github.com/Chia-Network/chia-blockchain.git -b ${branch} --recurse-submodules
RUN cd chia-blockchain && /usr/bin/sh ./install.sh

WORKDIR /chia-blockchain

COPY scripts/chia_update.sh /usr/local/bin/chia_update.sh
RUN chmod +x /usr/local/bin/chia_update.sh
RUN mkdir /plots
ADD ./entrypoint.sh entrypoint.sh

ENTRYPOINT ["bash", "./entrypoint.sh"]
