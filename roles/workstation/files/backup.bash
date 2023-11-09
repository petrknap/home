#!/usr/bin/env bash
set -e -x

if [ -e ~/backup.tmp ]
then
    rm ~/backup.tmp
fi

ls -aR ~/.apps > ~/.apps.ls || true
ls -aR ~/Downloads > ~/Downloads.ls || true
ls -aR ~/Videos > ~/Videos.ls || true
ls -aR ~/github.com > ~/github.com.ls || true
ls -aR ~/snap > ~/snap.ls || true
find ~ -maxdepth 1 \
    -not -path ~ \
    -not -path ~/backup.key -not -path ~/backup.tmp -not -path ~/backup.tar -not -path ~/backup.tar.xz -not -path ~/backup.tar.xz.gpg \
    -not -path ~/.apps \
    -not -path ~/.cache \
    -not -path ~/Downloads \
    -not -path ~/Videos \
    -not -path ~/github.com \
    -not -path ~/snap \
    | sed 's/.*/"&"/' \
    | xargs -t sudo tar --checkpoint=250 --create --xz \
        /etc \
    | gpg --verbose --symmetric --passphrase-file ~/backup.key --batch --output ~/backup.tmp \
&& rm ~/*.ls

if [ -e ~/backup.tar.xz.gpg ]
then
    rm ~/backup.tar.xz.gpg
fi
mv ~/backup.tmp ~/backup.tar.xz.gpg
