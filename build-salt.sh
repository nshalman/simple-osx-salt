#!/bin/bash

SALT_DIR=/usr/local/salt

alert () {
  osascript -e "display alert \"$*\""
}

re-exec () {
  CMD="sudo -H $0"
  alert About to re-execute this way: $CMD
  exec $CMD
}

have_xcode () {
  xcode-select -p 2>/dev/null
  return $?
}

install_xcode () {
  alert Please follow the prompts to install compilers
  xcode-select --install
  until have_xcode; do sleep 2; done;
  alert Compilers installed. Thank you
}

[[ $USER == root ]] || re-exec

have_xcode || install_xcode

[[ -x $(which virtualenv) ]] || easy_install pip virtualenv

rm -rf $SALT_DIR
virtualenv $SALT_DIR
$SALT_DIR/bin/pip install salt || rm -rf /usr/local/salt
cp com.saltstack.salt.minion.plist $SALT_DIR/lib/
cp start-salt-minion.sh $SALT_DIR/bin/
chmod 744 $SALT_DIR/bin/start-salt-minion.sh
zip -r salt.zip /usr/local/salt
chown $SUDO_USER salt.zip
