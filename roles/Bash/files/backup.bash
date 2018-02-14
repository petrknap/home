#!/bin/bash
set -e -x

if [ -e ~/backup.tmp ]
then
    rm ~/backup.tmp
fi

ls -aR ~/Downloads > ~/Downloads.ls || true
ls -aR ~/Videos > ~/Videos.ls || true
ls -aR ~/VirtualBox\ VMs > ~/VirtualBox\ VMs.ls || true
find ~ -maxdepth 1 \
    -not -path ~ \
    -not -path ~/backup.key -not -path ~/backup.tmp -not -path ~/backup.tar -not -path ~/backup.tar.gz -not -path ~/backup.tar.gz.gpg \
    -not -path ~/Downloads \
    -not -path ~/Videos \
    -not -path ~/VirtualBox\ VMs \
    -not -path ~/.wine \
    -not -path ~/.PlayOnLinux -not -path ~/PlayOnLinux\'s\ virtual\ drives \
    -not -path ~/.vagrant.d \
    | sed 's/.*/"&"/' \
    | xargs sudo tar -cz \
        /etc \
        /var/lib/emby \
    | gpg --symmetric --passphrase-file ~/backup.key --batch --output ~/backup.tmp \
&& rm ~/*.ls

if [ -e ~/backup.tar.gz.gpg ]
then
    rm ~/backup.tar.gz.gpg
fi
mv ~/backup.tmp ~/backup.tar.gz.gpg
