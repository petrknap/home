#!/usr/bin/env bash
set -e -x

if [ -e ~/backup.tmp ]
then
    rm ~/backup.tmp
fi

sudo tree \
  ~/.apps \
  ~/Downloads \
  ~/Videos \
  ~/github.com \
  ~/snap \
> ~/excluded.tree

find ~ -maxdepth 1 \
    -not -path ~/backup.tmp -not -path ~/backup.tar -not -path ~/backup.tar.xz -not -path ~/backup.tar.xz.gpg \
    -not -path ~ \
    -not -path ~/.ansible \
    -not -path ~/.apps \
    -not -path ~/.cache \
    -not -path ~/.docker \
    -not -path ~/.java \
    -not -path ~/.local \
    -not -path ~/Downloads \
    -not -path ~/Videos \
    -not -path ~/github.com \
    -not -path ~/snap \
    | sed 's/.*/"&"/' \
    | xargs -t sudo tar --checkpoint=250 --create --xz \
        /etc \
        ~/.apps/KeePass \
    | gpg --verbose --symmetric --passphrase-file ~/backup.key --batch --output ~/backup.tmp \
&& rm ~/excluded.tree

if [ -e ~/backup.tar.xz.gpg ]
then
    rm ~/backup.tar.xz.gpg
fi
mv ~/backup.tmp ~/backup.tar.xz.gpg
