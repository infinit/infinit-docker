#!/bin/sh
set -e

# Check for flags.
if [ "${1#-}" != "$1" ]; then
    exec infinit "$@"
fi

# Check for known modes.
#
# XXX: sh doesn't support array so...
test_mode() {
  mode=$1
  shift
  if [ "$mode" = "${1}" ]; then
      exec infinit "$@"
  fi
}

test_mode "acl" "$@"
test_mode "block" "$@"
test_mode "credentials" "$@"
test_mode "daemon" "$@"
test_mode "device" "$@"
test_mode "doctor" "$@"
test_mode "drive" "$@"
test_mode "journal" "$@"
test_mode "ldap" "$@"
test_mode "network" "$@"
test_mode "passport" "$@"
test_mode "silo" "$@"
test_mode "user" "$@"
test_mode "volume" "$@"

# If no arguments are provided, run infinit.
if [ "$#" = 0 ]; then
    exec infinit
fi

# Else default to run whatever the user wanted, like "sh".
exec "$@"
