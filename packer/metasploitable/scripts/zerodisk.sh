#!/bin/bash

# Zero out the free space to save space in the final image:
echo "[*] Zeroing free space"

dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
