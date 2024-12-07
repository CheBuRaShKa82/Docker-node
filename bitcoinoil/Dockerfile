FROM ubuntu:latest

# Создаем пользователя и группу для безопасного запуска процессов
RUN groupadd -r bitcoinoil && useradd -r -m -g bitcoinoil bitcoinoil

# Устанавливаем необходимые зависимости
RUN set -ex \
    && apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        dirmngr \
        gosu \
        gpg \
        wget \
		gcc \
    && rm -rf /var/lib/apt/lists/*

# Устанавливаем переменные окружения для удобства
ENV BITCOINOIL_VERSION=25.1.1
ENV BITCOINOIL_URL=https://github.com/escapeneo/bitcoinoil/releases/download/v${BITCOINOIL_VERSION}/BitcoinOil-linux.tar.gz
ENV BITCOINOIL_SHA256=2f4d1950377d86407687542165a6f8b78a7ffd1922cf8394423c50f38b43dbf8

# Скачиваем и устанавливаем бинарные файлы BitcoinOil
RUN set -ex \
    && cd /tmp \
    && wget -qO bitcoinoil.tar.gz "$BITCOINOIL_URL" \
    && echo "$BITCOINOIL_SHA256 bitcoinoil.tar.gz" | sha256sum -c - \
    && tar -xzvf bitcoinoil.tar.gz -C /usr/local/bin --exclude=*-qt; \
	rm -rf /tmp/*; \
    chmod +x /usr/local/bin/bitcoinoild

# Настраиваем директорию для данных
ENV BITCOINOIL_DATA=/data
RUN mkdir -p "$BITCOINOIL_DATA" \
    && chown -R bitcoinoil:bitcoinoil "$BITCOINOIL_DATA" \
    && ln -sfn "$BITCOINOIL_DATA" /home/bitcoinoil/.bitcoinoil \
    && chown -h bitcoinoil:bitcoinoil /home/bitcoinoil/.bitcoinoil
VOLUME /data

# Добавляем скрипт входа
COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# Открываем необходимые порты
EXPOSE 19712 19711

# Команда запуска по умолчанию
CMD ["bitcoinoild"]