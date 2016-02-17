#!/bin/bash

[[ -z ${1} ]] && echo "Please provide name of salt master as an argument" && exit 1

THIS=$(cd $(dirname ${0}); pwd)/$(basename ${0})

[[ $USER == root ]] || exec sudo -H ${THIS} "$@"

mkdir -p /etc/salt
echo "master: ${1}" > /etc/salt/minion

cd /
unzip ${THIS} &>/dev/null
cp /usr/local/salt/lib/com.saltstack.salt.minion.plist /Library/LaunchDaemons/
launchctl load "/Library/LaunchDaemons/com.saltstack.salt.minion.plist"
exit $?
