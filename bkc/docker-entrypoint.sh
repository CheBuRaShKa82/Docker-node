#!/bin/bash
set -e

# Получаем текущий шаблон для дампа ядра
core_pattern=$(cat /proc/sys/kernel/core_pattern)
pattern_start="$(echo $core_pattern | head -c 1)"

# Если шаблон не начинается с pipe, то проверим и создадим директорию для дампов
if [[ $pattern_start != "|" ]]; then
    directory=$(dirname "$core_pattern")
    mkdir -p "$directory"
    chmod 700 "$directory"  # Лучше установить более ограниченные права доступа
fi

# Для запуска команд briskcoin-cli, briskcoin-tx, briskcoind
if [[ "$1" == "briskcoin-cli" || "$1" == "briskcoin-tx" || "$1" == "briskcoind" ]]; then
    mkdir -p "$BITCOIN_DATA"

    
    # Обеспечиваем правильные права на директорию данных
    chown -R briskcoin "$BITCOIN_DATA"
    ln -sfn "$BITCOIN_DATA" /home/briskcoin/.briskcoin
    chown -h briskcoin:briskcoin /home/briskcoin/.briskcoin

    # Запуск команды от имени пользователя briskcoin
    exec gosu briskcoin "$@"
fi

# Если не briskcoin-cli, briskcoin-tx или briskcoind, просто выполняем команду
exec "$@"

