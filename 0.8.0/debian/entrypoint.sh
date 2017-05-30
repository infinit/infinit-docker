#!/bin/bash
set -e

# Check for flags.
if [ "${1#-}" != "$1" ]; then
    exec infinit "$@"
fi

# Check for known modes.
modes=("acl" "block" "credentials" "daemon" "device" "doctor" "drive" \
       "journal" "ldap" "network" "passport" "silo" "user" "volume")
if [[ " ${modes[@]} " =~ " ${1} " ]]; then
  exec infinit "$@"
fi

# If no arguments are provided, run infinit.
if [ "$#" = 0 ]; then
    exec infinit
fi

# Else default to run whatever the user wanted, like "bash"
exec "$@"
