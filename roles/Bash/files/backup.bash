#!/bin/bash
set -e -x

CURRENT_USER=$USER
if [ -e ~/backup.tmp ]
then
	sudo rm ~/backup.tmp
fi

ls -aR ~/Downloads > ~/Downloads.ls || true
ls -aR ~/Videos > ~/Videos.ls || true
ls -aR ~/VirtualBox\ VMs > ~/VirtualBox\ VMs.ls || true
sudo tar -cvzf ~/backup.tmp \
	$(realpath $0) \
	/etc \
	~/.apps \
	~/.config \
	~/.local/share/applications \
	~/.thunderbird \
	~/.PhpStorm* \
	~/.PyCharm* \
	~/*.ls \
	$(find ~/* -maxdepth 0 -type d -not -path "*/Downloads" -not -path "*/Videos" -not -path "*/VirtualBox VMs") \
&& rm ~/*.ls;
sudo chown $CURRENT_USER ~/backup.tmp

if [ -e ~/backup.tar.gz ]
then
	rm ~/backup.tar.gz
fi
mv ~/backup.tmp ~/backup.tar.gz
