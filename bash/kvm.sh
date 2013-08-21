#!/bin/bash

sudo su
egrep '(vmx|svm)' --color=always /proc/cpuinfo
if [$? eq 0]
then
  echo "CPU doesn't support VT"
fi

apt-get install ubuntu-virt-server python-vm-builder kvm-ipxe

#`id -un` is the current user
adduser `id -un` libvirtd
adduser `id -un` kvm

#you can use `virsh -c qemu:///system` to check if it success

cat > /etc/network/interfaces <<'EOF'
auto lo
iface lo inet loop

auto eth0
iface eth0 inet manual

auto br0
iface br0 inet static
  address 192.168.1.007
  netmask 255.255.255.0
  gateway 192.168.1.1
  network 192.168.1.0
  broadcast 192.168.1.255
  dns-servers 8.8.8.8 8.8.4.4
  bridge_ports eth0
  bridge_fd 9
  bridge_hello 2
  bridge_maxage 12
  bridge_stp off
EOF

if [$? eq 0]
then
  /etc/init.d/networking restart
fi

cd /var/lib/libvirt/images/
mkdir -p vm1
cd vm1
mkdir - p /var/libvirt/images/vm1/mytemplates/libvirt
cp /etc/vmbuilder/libvirt/* /var/libvirt/images/vm1/mytemplates/libvirt

cat > /var/lib/libvirt/images/vm1/vmbuilder.partition << 'EOF'
root 8000
swap 4000
---
/var 20000
EOF

cat > /var/lib/libvirt/images/vm1/boot.sh << 'EOF'
passwd -e suma
apt-get update
apt-get install -qqy --force-yes -openssh-server
EOF

cd /var/lib/libvirt/images/vm1

#vmbuilder kvm ubuntu --suite=precise --flavour=virtual --arch=amd64 --mirror=http://de.archive.ubuntu.com/ubuntu -o --
#libvirt=qemu:///system --ip=192.168.0.101 --gw=192.168.0.1 --part=vmbuilder.partition --templates=mytemplates --user=administrator --
#name=Administrator --pass=howtoforge --addpkg=vim-nox --addpkg=unattended-upgrades --addpkg=acpid --
#firstboot=/var/lib/libvirt/images/vm1/boot.sh --mem=256 --hostname=vm1 --bridge=br0

vmbuilder kvm ubuntu --suite=precise --flavour=virtual --arch=amd64 --mirror=http://http://mirrors.163.com/ubuntu -o \
  --libvirt=qemu:///system --ip=192.168.1.008 --gw=192.168.1.1 --templates=mytemplats --user=suma --name=ddllsuma    \
  --pass=qq --addpkg=vim-nox --addpkg=unattended-upgrades --addpkg=acpid --mem=1024 --hostname=vm1 --bridge=br0

vmbuilder kvm ubuntu --suite=precise --flavour=virtual --arch=amd64 --mirror=http://mirrors.163.com/ubuntu -o \
  --libvirt=qemu:///system --ip=192.168.1.8 --gw=192.168.1.1 --templates=mytemplats --user=suma --name=ddllsuma    \
  --pass=qq --addpkg=vim-nox --addpkg=unattended-upgrades --addpkg=acpid --hostname=vm3 --bridge=br0

vmbuilder kvm ubuntu --suite=precise --flavour=virtual --arch=amd64 --mirror=http://mirrors.163.com/ubuntu -o \
  --libvirt=qemu:///system --ip=192.168.1.7 --gw=192.168.1.1 --templates=mytemplats --user=suma --name=ddllsuma    \
  --pass=qq --addpkg=vim-nox --addpkg=unattended-upgrades --addpkg=acpid --hostname=vm4 --bridge=br0

vmbuilder kvm ubuntu --suite=precise --flavour=virtual --arch=amd64 --mirror=http://mirrors.163.com/ubuntu -o \
  --libvirt=qemu:///system --ip=192.168.1.5 --gw=192.168.1.1 --templates=mytemplats --user=suma --name=ddllsuma    \
  --pass=qq --addpkg=vim-nox --addpkg=unattended-upgrades --addpkg=acpid --hostname=vm5 --bridge=br0

vmbuilder kvm ubuntu --suite=precise --flavour=virtual --arch=amd64 --mirror=http://mirrors.163.com/ubuntu -o \
  --libvirt=qemu:///system --ip=192.168.1.6 --gw=192.168.1.1 --templates=mytemplats --user=suma --name=ddllsuma    \
  --pass=qq --addpkg=vim-nox --addpkg=unattended-upgrades --addpkg=acpid --hostname=vm6 --bridge=br0

vmbuilder kvm ubuntu --suite=precise --flavour=virtual --arch=amd64 --mirror=http://mirrors.163.com/ubuntu -o \
  --libvirt=qemu:///system --ip=192.168.1.3 --gw=192.168.1.1 --templates=mytemplats --user=suma --name=ddllsuma    \
  --pass=qq --addpkg=vim-nox --addpkg=unattended-upgrades --addpkg=acpid --hostname=vm7 --bridge=br0

vmbuilder kvm ubuntu --suite=precise --flavour=virtual --arch=amd64 --mirror=http://mirrors.163.com/ubuntu -o \
  --libvirt=qemu:///system --ip=192.168.1.4 --gw=192.168.1.1 --templates=mytemplats --user=suma --name=ddllsuma    \
  --pass=qq --addpkg=vim-nox --addpkg=unattended-upgrades --addpkg=acpid --hostname=vm8 --bridge=br0

vmbuilder kvm ubuntu --suite=precise --flavour=virtual --arch=amd64 --mirror=http://mirrors.163.com/ubuntu -o \
  --libvirt=qemu:///system --ip=192.168.1.9 --gw=192.168.1.1 --templates=mytemplats --user=suma --name=ddllsuma    \
  --pass=qq --addpkg=vim-nox --addpkg=unattended-upgrades --addpkg=acpid --hostname=vm9 --bridge=br0

vmbuilder kvm ubuntu --suite=precise --flavour=virtual --arch=amd64 --mirror=http://mirrors.163.com/ubuntu -o \
  --libvirt=qemu:///system --ip=192.168.1.10 --gw=192.168.1.1 --templates=mytemplats --user=suma --name=ddllsuma    \
  --pass=qq --addpkg=vim-nox --addpkg=unattended-upgrades --addpkg=acpid --hostname=vm10 --bridge=br0
