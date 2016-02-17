#!/bin/bash

[[ -z ${1} ]] && echo "Please provide name of salt master as an argument" && exit 1

SERIAL_NUMBER=$(python -c 'import plistlib,subprocess; print plistlib.readPlistFromString(subprocess.check_output("system_profiler SPHardwareDataType -xml",shell=True))[0]["_items"][0]["serial_number"]')

mkdir -p /etc/salt
echo "master: ${1}" > /etc/salt/minion
echo "id: mac-${SERIAL_NUMBER}" >> /etc/salt/minion

HERE=$(cd $(dirname ${0}); pwd)
THIS=$(basename ${0})
cd /
unzip ${HERE}/${THIS}
cp /usr/local/salt/lib/com.saltstack.salt.minion.plist /Library/LaunchDaemons/
launchctl load "/Library/LaunchDaemons/com.saltstack.salt.minion.plist"
exit $?
