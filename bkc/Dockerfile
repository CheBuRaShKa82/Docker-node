FROM ubuntu:latest

RUN groupadd -r briskcoin && useradd -r -m -g briskcoin briskcoin

RUN set -ex \
	&& apt-get update \
	&& apt-get install -qq --no-install-recommends ca-certificates dirmngr gosu gpg unzip wget libatomic1 \
	&& rm -rf /var/lib/apt/lists/*

# Установка переменных окружения
ENV BITCOIN_VERSION=1.0.0
ENV BITCOIN_URL=https://github.com/briskcoin-project/wallet/raw/refs/heads/main/Briskcoin-wallet-Linux-v1.0.0.zip
ENV BITCOIN_SHA256=f1af8fb01cb5963130de2056dfb3a181497f7390d4933fa619df5f74574ea1df

# Установка бинарников briskcoin
RUN set -ex \
    && cd /tmp \
    && wget -O briskcoin.zip "$BITCOIN_URL" \
    && echo "$BITCOIN_SHA256 briskcoin.zip" | sha256sum -c - \
    && unzip briskcoin.zip \
    && mv Briskcoin-wallet-Linux-v1.0.0/* /usr/local/bin/ \
    && rm -rf /tmp/*

# Создание директории данных
ENV BITCOIN_DATA=/data
RUN mkdir -p "$BITCOIN_DATA" \
    && chown -R briskcoin:briskcoin "$BITCOIN_DATA" \
    && ln -sfn "$BITCOIN_DATA" /home/briskcoin/.briskcoin \
    && chown briskcoin:briskcoin /home/briskcoin/.briskcoin

VOLUME /data

# Копирование entrypoint скрипта
COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# Открытие необходимых портов
EXPOSE 8553 8552

# Запуск основного процесса
CMD ["briskcoind"]

