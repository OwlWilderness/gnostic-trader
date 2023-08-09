#!/bin/bash

set -e  # Exit script on first error

# Check dependencies
command -v git >/dev/null 2>&1 ||
{ echo >&2 "Git is not installed!";
  exit 1
}

command -v poetry >/dev/null 2>&1 ||
{ echo >&2 "Poetry is not installed!";
  exit 1
}

command -v docker >/dev/null 2>&1 ||
{ echo >&2 "Docker is not installed!";
  exit 1
}

docker rm -f abci0 node0 trader_abci_0 trader_tm_0 &> /dev/null

# Prompt for agent address, safe address, private key and RPC
[[ -z "${AGENT_ADDRESS}" ]] && read -p "Enter agent address: " AGENT_ADDRESS || AGENT_ADDRESS="${AGENT_ADDRESS}"
[[ -z "${SAFE_CONTRACT_ADDRESS}" ]] && read -p "Enter Safe address: " SAFE_CONTRACT_ADDRESS || SAFE_CONTRACT_ADDRESS="${SAFE_CONTRACT_ADDRESS}"
[[ -z "${private_key}" ]] && read -sp "Enter agent private key [hidden input]: " private_key || private_key="${private_key}"
echo
[[ -z "${RPC_0}" ]] && read -sp "Enter a Gnosis RPC that support eth_newFilter [hidden input]: " RPC_0 || RPC_0="${RPC_0}"
echo

# Set environment variables. Tweak these to modify your strategy
export RPC_0="$RPC_0"
export CHAIN_ID=100
export ALL_PARTICIPANTS='["'$AGENT_ADDRESS'"]'
export SAFE_CONTRACT_ADDRESS="$SAFE_CONTRACT_ADDRESS"
# This is the default market creator. Feel free to update with other market creators
export OMEN_CREATORS='["0x89c5cc945dd550BcFfb72Fe42BfF002429F46Fec"]'
export BET_AMOUNT_PER_THRESHOLD_000=0
export BET_AMOUNT_PER_THRESHOLD_010=0
export BET_AMOUNT_PER_THRESHOLD_020=0
export BET_AMOUNT_PER_THRESHOLD_030=0
export BET_AMOUNT_PER_THRESHOLD_040=0
export BET_AMOUNT_PER_THRESHOLD_050=0
export BET_AMOUNT_PER_THRESHOLD_060=30000000000000000
export BET_AMOUNT_PER_THRESHOLD_070=40000000000000000
export BET_AMOUNT_PER_THRESHOLD_080=60000000000000000
export BET_AMOUNT_PER_THRESHOLD_090=80000000000000000
export BET_AMOUNT_PER_THRESHOLD_100=100000000000000000
export BET_THRESHOLD=5000000000000000
export PROMPT_TEMPLATE='With the given question "@{question}" and the `yes` option represented by `@{yes}` and the `no` option represented by `@{no}`, what are the respective probabilities of `p_yes` and `p_no` occurring?'

# This is a tested version that works well. Feel free to replace this with a different version of the service.
service_version=0.1.0:bafybeihdl7u6a2khmvpz2iebjgmmxcyd3bpn7rv5dcdduj2wtac2eqrede

service_dir="trader_service"
build_dir="abci_build"
directory="trader/$service_dir/$build_dir"
if [ -d $directory ]
then
    echo "Detected an existing build. Using this one."
    cd "trader/$service_dir"
    echo "The script will use sudo permissions in order to delete part of the build artifacts."
    sudo rm -rf $build_dir
else
    if ! [ -d "trader" ]; then
        echo "Setting up the trader repo..."
        git clone https://github.com/valory-xyz/trader.git
    fi
    cd trader
    echo "Setting up the trader service..."
    poetry install

    if ! [ -d "$service_dir" ]; then
        # Fetch the service
        poetry run autonomy fetch --service valory/trader:$service_version --alias $service_dir
    fi

    cd $service_dir
    # Build the image
    poetry run autonomy build-image
    cat > keys.json << EOF
[
{
    "address": "$AGENT_ADDRESS",
    "private_key": "$private_key"
}
]
EOF
fi

# Build the deployment with a single agent
poetry run autonomy deploy build --n 1 -ltm
# Run the deployment
poetry run autonomy deploy run --build-dir $build_dir