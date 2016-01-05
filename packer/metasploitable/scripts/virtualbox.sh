#!/bin/bash

set -o nounset
#set -o errexit

apt="apt-get -qq -y"

if [ ! -e /home/msfadmin/.vbox_version ] ; then
    exit 0
fi

# VirtualBox Additions

# kernel source is needed for vbox additions
$apt install linux-headers-$(uname -r) build-essential dkms
if [ -f /etc/init.d/virtualbox-ose-guest-utils ] ; then
    # The netboot installs the VirtualBox support (old) so we have to
    # remove it
    /etc/init.d/virtualbox-ose-guest-utils stop
    rmmod vboxguest
    $apt purge virtualbox-ose-guest-x11 virtualbox-ose-guest-dkms \
        virtualbox-ose-guest-utils
elif [ -f /etc/init.d/virtualbox-guest-utils ] ; then
    /etc/init.d/virtualbox-guest-utils stop
    $apt purge virtualbox-guest-utils virtualbox-guest-dkms virtualbox-guest-x11
fi

# Installing the virtualbox guest additions
VBOX_VERSION=$(cat /home/msfadmin/.vbox_version)
VBOX_ISO=/home/msfadmin/VBoxGuestAdditions_${VBOX_VERSION}.iso

mount -o loop $VBOX_ISO /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt

rm $VBOX_ISO

$apt remove linux-headers-$(uname -r)
$apt autoremove

# Fix for https://github.com/mitchellh/vagrant/issues/3341
if [ "$VBOX_VERSION" == "4.3.10" ]
then
    ln -sf /opt/VBoxGuestAdditions-4.3.10/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions
fi

