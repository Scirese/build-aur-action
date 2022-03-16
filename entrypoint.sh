#!/bin/bash

pkgname=$1

yay -Syu

useradd builder -m
echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo 'PACKAGER="Clansty <i@gao4.pw>"
COMPRESSZST=(zstd -19 -c -z -q --threads=0 -)' > /home/builder/.makepkg.conf

if [[ $pkgname != ./* ]];then
  git clone https://aur.archlinux.org/$pkgname.git
fi # 否则为本地包
cd $pkgname
source PKGBUILD

chmod -R a+rw .

sudo --set-home -u builder yay -S --noconfirm --useask --needed --asdeps --overwrite='*' "${makedepends[@]}" "${depends[@]}"
sudo --set-home -u builder CARCH=$ARCH makepkg -sfA --skipinteg --nodeps

echo ::set-output name=filelist::$(sudo --set-home -u builder CARCH=$ARCH makepkg --packagelist | xargs)
