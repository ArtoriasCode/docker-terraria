FROM debian:bullseye

ARG TML_VERSION

RUN apt-get update && \
    apt-get install -y wget unzip lib32gcc-s1 screen ca-certificates libicu-dev && \
    mkdir -p /opt/steamcmd && \
    cd /opt/steamcmd && \
    wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz && \
    tar -xzf steamcmd_linux.tar.gz && \
    rm steamcmd_linux.tar.gz && \
    ln -s /opt/steamcmd/steamcmd.sh /usr/local/bin/steamcmd && \
    mkdir -p /opt/terraria && \
    cd /opt/terraria && \
    wget https://github.com/tModLoader/tModLoader/releases/download/v${TML_VERSION}/tModLoader.zip -O tml.zip && \
    unzip tml.zip && \
    chmod +x /opt/terraria/start-tModLoaderServer.sh && \
    rm -rf tml.zip

WORKDIR /opt/terraria

COPY scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
