#!/bin/bash

set -o nounset
set -o errexit

# Clean up
echo "[*] Cleaning up apt"
apt-get -y autoremove
apt-get -y clean

# Removing leftover leases and persistent rules
echo "[*] Cleaning up dhcp leases"
rm -f /var/lib/dhcp3/*

# Make sure Udev doesn't block our network
echo "[*] Cleaning up udev"
rm -rf /dev/.udev/

echo "[*] Adding a 2 sec delay to the interface up, to make the dhclient happy"
echo "pre-up sleep 2" >> /etc/network/interfaces

# Cleanup logs
/root/reset_logs.sh

# Cleanup /tmp
echo "[*] Cleaning up /tmp"
rm -rf /tmp/* /tmp/.[^.]+

