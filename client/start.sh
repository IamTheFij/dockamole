#! /bin/bash
set -e

# Tests if the command being passed in is for a shell
function is_shell() {
    case "$1" in
        bash|sh)
        return 0
        ;;
    esac
    return 1
}

# Determines if we should append to known_hosts
function should_append_hosts() {
    [ "${GEN_KNOWN_HOSTS:=1}" -eq 1 ]
}

# Appends server key to known_hosts if it's not already there
function maybe_append_host() {
    local host=$(echo $1 | sed -e 's/.*@//' -e 's/:.*//')
    local port=$(echo $1 | sed -n 's/.*:\([0-9]*\)/\1/p')
    local known_hosts=$HOME/.ssh/known_hosts
    touch $known_hosts
    echo "Ensuring $host is in $known_hosts..."
    echo "grep -q $1 $known_hosts || ssh-keyscan -p ${port:-22} $host >> $known_hosts"
    grep -q $host $known_hosts || ssh-keyscan -p ${port:-22} $host >> $known_hosts
}

# Executes mole using local and remotes from env variables
function get_local_remote_mapping() {
    local local_remote=""
    for i in `seq ${MAX_TUNNELS:-10}`; do
        local_name=MOLE_LOCAL_$i
        remote_name=MOLE_REMOTE_$i
        if [ ! -z "${!local_name}" ] && [ ! -z "${!remote_name}" ]; then
            local_remote="$local_remote -local ${!local_name} -remote ${!remote_name}"
        fi
    done
    echo $local_remote
}

function main() {
    if should_append_hosts ;then
        maybe_append_host $MOLE_SERVER
    fi
    local local_remote=$(get_local_remote_mapping)
    if [ -z "$local_remote" ]; then
        echo "Must provide at least one local and remote via MOLE_LOCAL_1 and MOLE_REMOTE_1"
        exit 1
    fi

    mole -v \
        $local_remote \
        $@ \
        -server ${MOLE_SERVER} \
        -key ${SSH_KEY:-~/.ssh/id_rsa}
}

# If first arg is bash or sh, we'll just execute directly
if is_shell $1 ; then
    echo "We think you're trying to just drop into a shell"
    exec "$@"
    exit 0
fi

main $@
