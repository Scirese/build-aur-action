#!/bin/bash

pkgname=$1

yay -Syu

useradd builder -m
echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
chmod -R a+rw .

sudo --set-home -u builder yay -Sa --noconfirm --useask --builddir=./ "$pkgname"

cd $pkgname
echo ::set-output name=filelist::$(sudo --set-home -u builder makepkg --packagelist | xargs)
