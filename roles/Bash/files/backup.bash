#!/bin/bash
set -e -x

CURRENT_USER=$USER
if [ -e ~/backup.tmp ]
then
	rm ~/backup.tmp
fi

ls -aR ~/Downloads > ~/Downloads.ls || true
ls -aR ~/Videos > ~/Videos.ls || true
ls -aR ~/VirtualBox\ VMs > ~/VirtualBox\ VMs.ls || true
sudo tar -cz \
	$(realpath $0) \
	/etc \
	~/.apps \
	~/.config \
	~/.local/share/applications \
	~/.thunderbird \
	~/.PhpStorm* \
	~/.PyCharm* \
	$(find ~ -maxdepth 1 -type f) \
	$(find ~/* -maxdepth 0 -type d -not -path "*/Downloads" -not -path "*/Videos" -not -path "*/VirtualBox VMs") \
	| gpg --symmetric --passphrase-file ~/backup.key --batch --output ~/backup.tmp \
&& rm ~/*.ls;

if [ -e ~/backup.tar.gz.gpg ]
then
	rm ~/backup.tar.gz.gpg
fi
mv ~/backup.tmp ~/backup.tar.gz.gpg
