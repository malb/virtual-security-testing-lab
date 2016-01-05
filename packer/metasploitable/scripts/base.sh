#!/bin/bash

set -o nounset
set -o errexit

sed -i.orig s/security.ubuntu.com/old-releases.ubuntu.com/   /etc/apt/sources.list
sed -i.orig s/us.archive.ubuntu.com/old-releases.ubuntu.com/ /etc/apt/sources.list

apt-get -y update

