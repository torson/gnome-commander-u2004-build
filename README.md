Build Gnome-commander for Ubuntu 20.04 Focal using Docker.
You need to have Docker installed, that's the only requirement.
You can run this on any Linux distribution.

It's based on instructions from the Gnome-commander page:
https://gcmd.github.io/2021/01/28/Build-on-Ubuntu-2004.html

It builds Gnome-commander v1.12.3.1 .

# Steps

1. Start and get into the Ubuntu 20.04 Focal container.
This will mount the current path where the deb packages will be available at the end:

```
docker run --rm -it -v $(pwd):/mount -w /mount ubuntu:focal
```

2. Inside the container run:

```
./build.sh
```

3 .deb file files should now be in the current path:
- libgnomevfs2-common_1%3a2.24.4-6.1ubuntu2_amd64.deb
- libgnomevfs2-0_1%3a2.24.4-6.1ubuntu2_amd64.deb
- gnome-commander_1.12.3.1-1_amd64.deb


3. Copy the 3 files over to the target host (Ubuntu 20.04) and install them:

```
# first install the libgnomevfs packages
dpkg -i libgnomevfs2-common_1%3a2.24.4-6.1ubuntu2_amd64.deb
dpkg -i libgnomevfs2-0_1%3a2.24.4-6.1ubuntu2_amd64.deb
apt-get -f install

# install other gnome-commander dependencies
apt-get -y install libc6 libexiv2-27 libgcc1 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk2.0-0 libpango-1.0-0 libpoppler-glib8 libpython2.7 libstdc++6 libtag1v5

# install gnome-commander
apt-get install gnome-commander_1.12.3.1-1_amd64.deb
```

