

vm_id=9000

qm config ${vm_id}

zfs list rpool/data/vm-${vm_id}-disk-0

pvesm path local-zfs:vm-${vm_id}-disk-0

fdisk -l /dev/zvol/rpool/data/vm-${vm_id}-disk-0

mount -o rw /dev/rpool/data/vm-${vm_id}-disk-0-part1 /mnt/chroot


MCHRDIR=/mnt/chroot
mkdir ${MCHRDIR}

# Enable NBD on the Host
modprobe nbd max_part=8

# Connect the QCOW2 as network block device
qemu-nbd --connect=/dev/nbd0 kali-linux-2021.3-amd64.qcow2

# Find The Virtual Machine Partitions
fdisk /dev/nbd0 -l

# Mount the partition from the VM
mount /dev/nbd0p1 ${MCHRDIR}


####


## mount stuff, you will need more often
mount --bind /dev ${MCHRDIR}/dev
mount --bind /dev/pts ${MCHRDIR}/dev/pts
mount --bind /proc  ${MCHRDIR}/proc
mount --bind /sys ${MCHRDIR}/sys

## chroot
chroot ${MCHRDIR}


chroot ${MCHRDIR} /bin/bash << EOF
echo "nameserver 1.1.1.1" > /etc/resolv.conf
apt update
apt install -y cloud-init
systemctl enable cloud-init
systemctl enable ssh.service
EOF

# After you done, unmount and disconnect
umount ${MCHRDIR}/proc
umount ${MCHRDIR}/dev/pts
umount ${MCHRDIR}/dev
umount ${MCHRDIR}/sys

umount ${MCHRDIR}
qemu-nbd --disconnect /dev/nbd0
rmmod nbd


# SCript
```ci-via-chroot.sh
 
#!/bin/bash

MCHRDIR="/mnt/chroot"

mount --bind /dev ${MCHRDIR}/dev
mount --bind /dev/pts ${MCHRDIR}/dev/pts
mount --bind /proc  ${MCHRDIR}/proc
mount --bind /sys ${MCHRDIR}/sys

chroot ${MCHRDIR} /bin/bash << EOF
cat /etc/os-release
uname -a
echo "nameserver 1.1.1.1" > /etc/resolv.conf
echo "deb https://mirrors.ocf.berkeley.edu/kali kali-rolling main contrib non-free" | tee /etc/apt/sources.list
apt update
apt install -y cloud-init cloud-initramfs-growroot
sed -i -e '/    lock_passwd:\ /s/^.*$/    lock_passwd: false/' /etc/cloud/cloud.cfg.d/20_kali.cfg
sed -i -e "/GRUB_CMDLINE_LINUX=/s/^.*$/GRUB_CMDLINE_LINUX=\"quiet console=tty0 console=ttyS0,115200\"/" /etc/default/grub
systemctl enable cloud-init
systemctl enable ssh.service
EOF

```



sed -i -e "/GRUB_CMDLINE_LINUX=/s/^.*$/GRUB_CMDLINE_LINUX=\"quiet console=tty0 console=ttyS0,115200\"/" /etc/default/grub

GRUB_CMDLINE_LINUX="quiet console=tty0 console=ttyS0,115200" 