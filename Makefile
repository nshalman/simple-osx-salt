INSTALLER=osx-salt-virtualenv-installer

$(INSTALLER): setup-minion.sh salt.zip
	cat $^ > $@
	chmod +x $@

salt.zip: build-salt.sh com.saltstack.salt.minion.plist
	sudo -H ./build-salt.sh

.PHONY:	clean test

clean:
	rm -f $(INSTALLER) salt.zip

test: $(INSTALLER)
	sudo rm -rf /usr/local/salt
	sudo ./osx-salt-virtualenv-installer $(MASTER)
