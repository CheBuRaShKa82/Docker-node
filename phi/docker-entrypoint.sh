#!/bin/bash
set -euo pipefail

export PATH="/usr/local/bin:$PATH"

if [[ -z "${PHICOIN_RPC_PASSWORD}" ]]; then
    echo "Error: PHICOIN_RPC_PASSWORD environment variable is not set!"
    exit 1
fi

if [[ -z "${PHICOIN_RPC_USER}" ]]; then
    echo "Error: PHICOIN_RPC_USER environment variable is not set!"
    exit 1
fi

if [[ "$1" == "phicoin-cli" || "$1" == "phicoind" ]]; then
    mkdir -p "$PHICOIN_DATA"

    if [[ ! -s "$PHICOIN_DATA/phicoin.conf" ]]; then
        cat <<-EOF > "$PHICOIN_DATA/phicoin.conf"
            printtoconsole=1
            rpcallowip=::/0
            rpcpassword=${PHICOIN_RPC_PASSWORD}
            rpcuser=${PHICOIN_RPC_USER}
EOF
        chown phicoin:phicoin "$PHICOIN_DATA/phicoin.conf"
    fi

    # ensure correct ownership and linking of data directory
    # we do not update group ownership here, in case users want to mount
    # a host directory and still retain access to it
    chown -R phicoin "$PHICOIN_DATA"
    ln -sfn "$PHICOIN_DATA" /home/phicoin/.phicoin
    chown -h phicoin:phicoin /home/phicoin/.phicoin

    exec gosu phicoin "$@"
else
    echo "Error: Unknown command '$1'. Expected one of: phicoin-cli, phicoind." >&2
    exit 1
fi