FROM debian:bullseye

ARG TERRARIA_VERSION

RUN apt-get update && \
    apt-get install -y wget unzip lib32gcc-s1 screen && \
    mkdir -p /opt/terraria && \
    cd /opt/terraria && \
    wget https://terraria.org/api/download/pc-dedicated-server/terraria-server-${TERRARIA_VERSION}.zip -O server.zip && \
    unzip server.zip && \
    cp -r $(find . -type d -name "Linux")/* . && \
    chmod +x /opt/terraria/TerrariaServer.bin.x86_64 && \
    rm -rf server.zip

WORKDIR /opt/terraria

COPY scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
