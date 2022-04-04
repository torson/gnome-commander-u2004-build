#!/bin/bash

[ -d build ] || mkdir build
cd build

export DEBIAN_FRONTEND=noninteractive

echo "upgrade all packages"
apt-get update
apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade

echo "install gnome-commander dependencies and tools"
apt-get install -y build-essential itstool gawk libxml2-utils libglib2.0-dev libgtk2.0-dev flex wget checkinstall

echo "add 18.04 Bionic universe repository to fetch packages libgnomevfs2-dev (for build) and libgnomevfs2-0 and libgnomevfs2-common (for runtime)"
echo "deb http://archive.ubuntu.com/ubuntu bionic universe" >> /etc/apt/sources.list
apt-get update
apt-get install -y libgnomevfs2-dev

# version 1.14 doesn't build on 20.04 : Requested 'glib-2.0 >= 2.66.0' but version of GLib is 2.64.6
# GC_VERSION=1.14.2
# GC_VERSION_MINOR=1.14

GC_VERSION=1.12.3.1
GC_VERSION_MINOR=1.12

# version 1.10 has some issues with adding devices in the configuration - crashes with "widget not found: multiple_instance_check"
# GC_VERSION=1.10.3
# GC_VERSION_MINOR=1.10

# version 1.4 doesn't build due to configure error : checking if libgnome >= 2.0.0 exists... configure: error: no
# GC_VERSION=1.4.9
# GC_VERSION_MINOR=1.4

echo "build gnome-commander"
wget https://download.gnome.org/sources/gnome-commander/${GC_VERSION_MINOR}/gnome-commander-${GC_VERSION}.tar.xz
tar -xvf gnome-commander-${GC_VERSION}.tar.xz
cd gnome-commander-${GC_VERSION}
./configure
make

echo "build gnome-commander package"
checkinstall -y --install=no --pkgname=gnome-commander --pkgversion=${GC_VERSION} --pkggroup=Application/Accessories
echo "move .deb file one folder up"
mv gnome-commander_${GC_VERSION}-1_amd64.deb ../

cd ..
echo "download libgnomevfs .deb files, these need to be installed on the target host along with the gnome-commander"
apt-get download libgnomevfs2-0 libgnomevfs2-common

## install dependencies:
# dpkg -i libgnomevfs2-common_1%3a2.24.4-6.1ubuntu2_amd64.deb
# dpkg -i libgnomevfs2-0_1%3a2.24.4-6.1ubuntu2_amd64.deb
# apt-get -f install
## dependencies in ubuntu package in 18.04 , there are a few differences with 20.04
#  >> taken from DEBIAN/config : Depends: gnome-commander-data (>= 1.4.8-1.1), libc6 (>= 2.14), libexiv2-14 (>= 0.25), libgcc1 (>= 1:3.0), libgdk-pixbuf2.0-0 (>= 2.22.0), libglib2.0-0 (>= 2.37.3), libgnome-2-0, libgnomeui-0 (>= 2.22.0), libgnomevfs2-0 (>= 1:2.17.90), libgtk2.0-0 (>= 2.24.31), libpango-1.0-0 (>= 1.14.0), libpoppler-glib8 (>= 0.18.0), libpython2.7 (>= 2.7), libstdc++6 (>= 5.2), libtag1v5 (>= 1.9.1-2.2~), libunique-1.0-0 (>= 1.0.0)
#  - a few are missing : libgnome-2-0 libgnomeui-0
#  - one has higher version : libexiv2-27 instead of libexiv2-14
# apt-get -y install libc6 libexiv2-27 libgcc1 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk2.0-0 libpango-1.0-0 libpoppler-glib8 libpython2.7 libstdc++6 libtag1v5

# install gnome-commander
# apt-get install gnome-commander_1.10.3-1_amd64.deb
