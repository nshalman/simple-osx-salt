#!/bin/bash

SERIAL_NUMBER=$(python -c 'import plistlib,subprocess; print plistlib.readPlistFromString(subprocess.check_output("system_profiler SPHardwareDataType -xml",shell=True))[0]["_items"][0]["serial_number"]')
MINION_ID_STRING="id: mac-${SERIAL_NUMBER}"

# if minion id is correct, start salt
grep -q "^${MINION_ID_STRING}$" /etc/salt/minion && exec /usr/local/salt/bin/salt-minion

#otherwise, purge pki keys, fix minion config, then start salt
rm -rf /etc/salt/pki
mv /etc/salt/minion{,.bak}
sed -e '/^id/d' /etc/salt/minion.bak > /etc/salt/minion
echo "${MINION_ID_STRING}" >> /etc/salt/minion
exec /usr/local/salt/bin/salt-minion
