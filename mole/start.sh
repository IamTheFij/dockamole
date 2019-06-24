#! /bin/bash

# Executes mole using local and remotes from env variables

local_remote=""
for i in `seq ${MAX_TUNNELS:-10}`; do
    local_name=MOLE_LOCAL_$i
    remote_name=MOLE_REMOTE_$i
    if [ ! -z "${!local_name}" ] && [ ! -z "${!remote_name}" ]; then
        local_remote="$local_remote -local ${!local_name} -remote ${!remote_name}"
    fi
done

if [ -z "$local_remote" ]; then
    echo "Must provide at least one local and remote via MOLE_LOCAL_1 and MOLE_REMOTE_1"
    exit 1
fi

mole -v \
    $local_remote \
    -server ${MOLE_SERVER} \
    -key ${SSH_KEY:-~/.ssh/id_rsa} \
    -insecure
