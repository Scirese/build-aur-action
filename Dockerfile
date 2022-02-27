FROM archlinux:latest

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN date

WORKDIR /tmp
COPY pacman.conf /etc/pacman.conf

RUN pacman-key --init
RUN pacman -Syu --noconfirm
RUN pacman -S --noconfirm archlinuxcn-keyring
RUN pacman -S --noconfirm base-devel git yay nodejs-lts-gallium jdk11-openjdk



COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"] 
