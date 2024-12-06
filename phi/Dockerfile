FROM ubuntu:22.04

# Создаем пользователя phicoin
RUN groupadd -r phicoin && useradd -r -m -g phicoin phicoin

# Устанавливаем зависимости
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates dirmngr gosu libboost-all-dev libdb++-dev libminiupnpc-dev libzmq5 gpg wget \
    && rm -rf /var/lib/apt/lists/*

# Устанавливаем переменные
ARG PHICOIN_VERSION=1.1.1.1
ENV PHICOIN_VERSION=$PHICOIN_VERSION
ENV PHICOIN_URL=https://github.com/PhicoinProject/PhicoinProject/releases/download/${PHICOIN_VERSION}/linux.tar
ENV PHICOIN_SHA256=e4814f50a0d242128a9ef39351853f108b9ad50fad88a7c8969ad333575cec7c

# Скачиваем и устанавливаем бинарники Phicoin
RUN set -ex; \
    cd /tmp; \
    wget -qO phicoin.tar "$PHICOIN_URL"; \
    echo "$PHICOIN_SHA256 phicoin.tar" | sha256sum -c - || (echo "SHA256 checksum mismatch!" && exit 1); \
    tar -xvf phicoin.tar -C /usr/local/bin --strip-components=1 --exclude=*-qt; \
    rm -rf /tmp/*; \
    chmod +x /usr/local/bin/phicoind

# Настраиваем директорию для данных
ENV PHICOIN_DATA=/data
RUN mkdir -p "$PHICOIN_DATA" \
    && chown -R phicoin:phicoin "$PHICOIN_DATA" \
    && ln -sfn "$PHICOIN_DATA" /home/phicoin/.phicoin \
    && chown -h phicoin:phicoin /home/phicoin/.phicoin
VOLUME /data

# Добавляем скрипт входа
COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# Указываем открытые порты
EXPOSE 18965 18964

# Команда по умолчанию
CMD ["phicoind"]