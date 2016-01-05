#!/bin/bash -eux

# Import Kali PGP Key

gpg --keyserver pgpkeys.mit.edu --recv-key  ED444FF07D8D0BF6
gpg -a --export ED444FF07D8D0BF6 | sudo apt-key add -

# switch to kali
cat <<EOF > /etc/apt/sources.list
deb http://kali.muzzy.org.uk/kali/ sana main non-free contrib
deb http://security.kali.org/kali-security sana/updates main contrib non-free
EOF

apt-get -y update
aptitude -yR full-upgrade

export DEBIAN_FRONTEND=noninteractive

echo kismet kismet/install-setuid boolean false | debconf-set-selections
echo kismet kismet/install-users string         | debconf-set-selections

echo sslh sslh/inetd_or_standalone select standalone | debconf-set-selections
echo mysql-server-5.5 mysql-server/root_password_again password              | debconf-set-selections
echo mysql-server-5.5 mysql-server/root_password password                    | debconf-set-selections
echo mysql-server-5.5 mysql-server-5.5/postrm_remove_databases boolean false | debconf-set-selections
echo mysql-server-5.5 mysql-server-5.5/start_on_boot boolean true            | debconf-set-selections
echo mysql-server-5.5 mysql-server-5.5/nis_warning note                      | debconf-set-selections
echo mysql-server-5.5 mysql-server-5.5/really_downgrade boolean false        | debconf-set-selections

# We install kali-linux-full

aptitude keep-all
aptitude -yR --schedule-only install kali-linux-full ettercap-text-only

# and remove a lot of X11 stuff we don't need

aptitude -yR --schedule-only remove x11-common \
         texlive-base \
         glib-networking-common \
         x11proto-core-dev \
         gir1.2-glib-2.0 \
         hydra-gtk \
         libgtkmm-2.4-1c2a \
         tex-common \
         libgl1-mesa-glx \
         dconf-cli \
         dconf-gsettings-backend \
         dconf-service \
         desktop-base \
         libasound2 \
         libasound2-data \
         libcairo-gobject2 \
         libcairo-perl \
         libcairo-script-interpreter2 \
         libcairomm-1.0-1 \
         libdrm-nouveau2 \
         libdrm-radeon1 \
         libdrm2 \
         libegl1-mesa \
         libfontconfig1-dev \
         libfreetype6-dev \
         libglapi-mesa \
         libglib-perl \
         libglib2.0-bin \
         libglib2.0-dev \
         libgstreamer0.10-0 \
         libgstreamer1.0-0 \
         libgtksourceview2.0-common \
         libpango1.0-0 \
         libqt5core5a \
         libqtcore4 \
         libwine-gecko-2.21 \
         python-pyx \
         x11proto-kb-dev \
         x11proto-randr-dev \
         x11proto-xinerama-dev \
         xbitmaps \
         xdg-utils \
         xorg-sgml-doctools \
         xprobe \
         xsltproc \
         xspy \
         xsser \
         xtrans-dev 

# finally, we clean up broken packages

while true; do
    BROKEN=`aptitude -F "%p" search ~b | xargs echo -n`
    if [ -z "$BROKEN" ]; then
        break;
    fi;
    echo $BROKEN
    aptitude --schedule-only remove $BROKEN
done    

aptitude -yR install



