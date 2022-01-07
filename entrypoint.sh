#!/bin/bash

pkgname=$1

yay -Syu

useradd builder -m
echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

if [[ $ARCH != "x86_64" ]]; then
  git clone https://aur.archlinux.org/$pkgname.git
  cd $pkgname
  source PKGBUILD
fi

chmod -R a+rw .

if [[ $ARCH == "x86_64" ]]; then
  sudo --set-home -u builder yay -Sa --noconfirm --useask --builddir=./ "$pkgname"
  cd $pkgname
else
  sudo --set-home -u builder yay -S --noconfirm --needed --asdeps "${makedepends[@]}" "${depends[@]}"
  sudo --set-home -u builder CARCH=$ARCH makepkg -sfA
fi
echo ::set-output name=filelist::$(sudo --set-home -u builder CARCH=$ARCH makepkg --packagelist | xargs)
