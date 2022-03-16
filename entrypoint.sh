#!/bin/bash

pkgname=$1

yay -Syu

useradd builder -m
echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo 'PACKAGER="Clansty <i@gao4.pw>"
COMPRESSZST=(zstd -19 -c -z -q --threads=0 -)' > /home/builder/.makepkg.conf

if [[ $ARCH == "x86_64" ]]; then
  echo qwq
elif [[ $ARCH == "i686" ]]; then
  export CFLAGS+=" -m32"
  export CXXFLAGS+=" -m32"
  export LDFLAGS+=" -m32"
  export PKG_CONFIG_PATH='/usr/lib32/pkgconfig'
  rm /etc/pacman.conf
  mv /etc/pacman32.conf /etc/pacman.conf
  pacman -Syy
else
  if [[ $pkgname != ./* ]];then
    git clone https://aur.archlinux.org/$pkgname.git
  fi # 否则为本地包
  cd $pkgname
  source PKGBUILD
fi

chmod -R a+rw .

if [[ $ARCH == "x86_64" ]]; then
  sudo --set-home -u builder yay -Sa --noconfirm --useask --builddir=./ --overwrite='*' "$pkgname" --mflags --skipinteg
  cd $pkgname
elif [[ $ARCH == "i686" ]]; then
  sudo --set-home -u builder linux32 yay -Sa --noconfirm --useask --builddir=./ --overwrite='*' "$pkgname" --mflags --skipinteg
  cd $pkgname
else
  sudo --set-home -u builder yay -S --noconfirm --needed --asdeps --overwrite='*' "${makedepends[@]}" "${depends[@]}"
  sudo --set-home -u builder CARCH=$ARCH makepkg -sfA --skipinteg --nodeps
fi
echo ::set-output name=filelist::$(sudo --set-home -u builder CARCH=$ARCH makepkg --packagelist | xargs)
