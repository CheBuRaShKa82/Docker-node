#!/bin/bash
set -euo pipefail

export PATH="/usr/local/bin:$PATH"

if [[ -z "${BITCOINOIL_RPC_PASSWORD}" ]]; then
    echo "Error: BITCOINOIL_RPC_PASSWORD environment variable is not set!"
    exit 1
fi

if [[ -z "${BITCOINOIL_RPC_USER}" ]]; then
    echo "Error: BITCOINOIL_RPC_USER environment variable is not set!"
    exit 1
fi

if [[ "$1" == "bitcoinoil-cli" || "$1" == "bitcoinoild" ]]; then
    mkdir -p "$BITCOINOIL_DATA"

    if [[ ! -s "$BITCOINOIL_DATA/bitcoinoil.conf" ]]; then
        cat <<-EOF > "$BITCOINOIL_DATA/bitcoinoil.conf"
            printtoconsole=1
            rpcallowip=::/0
            rpcpassword=${BITCOINOIL_RPC_PASSWORD}
            rpcuser=${BITCOINOIL_RPC_USER}
EOF
        chown bitcoinoil:bitcoinoil "$BITCOINOIL_DATA/bitcoinoil.conf"
    fi

    # ensure correct ownership and linking of data directory
    # we do not update group ownership here, in case users want to mount
    # a host directory and still retain access to it
    chown -R bitcoinoil "$BITCOINOIL_DATA"
    ln -sfn "$BITCOINOIL_DATA" /home/bitcoinoil/.bitcoinoil
    chown -h bitcoinoil:bitcoinoil /home/bitcoinoil/.bitcoinoil

    exec gosu bitcoinoil "$@"
else
    echo "Error: Unknown command '$1'. Expected one of: bitcoinoil-cli, bitcoinoild." >&2
    exit 1
fi