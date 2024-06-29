#!/bin/bash

if-host () {
    # Example usage
    # if-host ywata echo "This is ywata machine"

    HOST_KEY_WORD=$1
    shift
    COMMAND='"$@"'

    if [[ `hostname` == *"$HOST_KEY_WORD"* ]]; then
        eval "$COMMAND"
    fi
}

if-os () {
    # Example usage
    # if-os ubuntu echo "This is Ubuntu"
    # if-os centos echo "This is CentOS"

    OS_KEY_WORD=$1
    shift
    COMMAND='"$@"'

    # Read the ID line directly from /etc/os-release to determine the OS type
    OS_TYPE=$(grep '^ID=' /etc/os-release | cut -d'=' -f2 | tr -d '"')

    # Check if the OS type matches the keyword, execute command if it does
    if [[ $OS_TYPE == *"$OS_KEY_WORD"* ]]; then
        eval "$COMMAND"
    fi
}

# EOF
