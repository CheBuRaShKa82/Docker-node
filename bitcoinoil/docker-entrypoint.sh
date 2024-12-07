#!/bin/sh
set -e

# Добавляем /usr/local/bin в PATH
PATH="/usr/local/bin:$PATH"

# Устанавливаем значение BITCOINOIL_DATA по умолчанию, если оно не задано
BITCOINOIL_DATA=${BITCOINOIL_DATA:-/data}

# Указываем путь к исполняемому файлу, если требуется
BITCOINOILD_BIN=${BITCOINOILD_BIN:-bitcoinoild}

# Проверяем, является ли первый аргумент опцией (начинается с '-')
if [ -n "$1" ] && [ "$(echo "$1" | cut -c1)" = "-" ]; then
    echo "$0: assuming arguments for $BITCOINOILD_BIN"
    set -- "$BITCOINOILD_BIN" "$@"
fi

# Настраиваем директорию данных, если это `bitcoinoild`, `bitcoinoil-cli` или `bitcoinoil-tx`
if [ "$1" = "$BITCOINOILD_BIN" ] || [ "$1" = "bitcoinoil-cli" ] || [ "$1" = "bitcoinoil-tx" ]; then
    mkdir -p "$BITCOINOIL_DATA"
    chmod 775 "$BITCOINOIL_DATA" || echo "$0: Could not chmod $BITCOINOIL_DATA (permissions issue)" >&2
    chown -R bitcoinoil "$BITCOINOIL_DATA" || echo "$0: Could not chown $BITCOINOIL_DATA (permissions issue)" >&2
    echo "$0: setting data directory to $BITCOINOIL_DATA"
    set -- "$@" -datadir="$BITCOINOIL_DATA"
fi

# Проверяем наличие gosu и существование пользователя 'bitcoinoil'
if [ "$(id -u)" = "0" ]; then
    if ! command -v gosu >/dev/null 2>&1; then
        echo "$0: gosu is not installed. Please install it." >&2
        exit 1
    fi
    if ! id -u bitcoinoil >/dev/null 2>&1; then
        echo "$0: user 'bitcoinoil' does not exist. Please create it first." >&2
        exit 1
    fi

    # Проверяем наличие исполняемого файла bitcoinoild
    if ! command -v "$BITCOINOILD_BIN" >/dev/null 2>&1; then
        echo "$0: $BITCOINOILD_BIN is not found in PATH. Please ensure it is installed and accessible." >&2
        exit 1
    fi

    echo "$0: switching to user 'bitcoinoil'"
    exec gosu bitcoinoil "$@"
fi

# Проверяем наличие исполняемого файла для обычного пользователя
if ! command -v "$1" >/dev/null 2>&1; then
    echo "$0: $1 is not found in PATH. Please ensure it is installed and accessible." >&2
    exit 1
fi

# Запускаем команду
echo "$0: executing command: $@"
exec "$@"
