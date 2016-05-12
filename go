#!/bin/bash

#starts up the qemu vm


#time qemu-system-x86_64 -enable-kvm -cpu host -net user -net nic,model=virtio -m 4G -drive file=my_guix.cow,discard=on -drive file="/home/zazdxscf/Downloads/guixsd-usb-install-0.10.0.x86_64-linux",media=disk,format=raw,discard=on -boot menu=on

sharedfolder="/tmp/qemushared/"
shf_tag="qsh"
cowhdd="my_guix.cow"
usbstickhdd="/home/zazdxscf/Downloads/"
#usbstickhdd+="guixsd-usb-install-0.10.0.x86_64-linux"
usbstickhdd+="37v7r5jvypqrklw8frir0q9df929s8nf-disk-image"
#XXX: add these args for usb stick boot(and F12, 2, during boot)
# -drive file="$usbstickhdd",media=disk,format=raw,discard=on

mkdir -p -- "$sharedfolder"
time qemu-system-x86_64 -enable-kvm -cpu host -net user -net nic,model=virtio -m 4G -drive file="$cowhdd",discard=on -boot menu=on -virtfs local,path="$sharedfolder",security_model=none,mount_tag="$shf_tag"
#src: https://gitlab.com/rain1/guix-wiki/wikis/qemu
#XXX: -vnc localhost:0  (that's 127.0.0.0:5900)  but still has no copy/paste !! tested with: VNC-Viewer-5.3.0-Linux-x64

#XXX: mount (inside guest vm) via:
#mount -t 9p -o trans=virtio "$shf_tag" mountpointhere -oversion=9p2000.L
#src: http://wiki.qemu.org/Documentation/9psetup#Mounting_the_shared_path

#TODO: -serial stdio -vga std

