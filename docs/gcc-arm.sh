#!/bin/bash
# https://askubuntu.com/a/1371525
# https://developer.arm.com/downloads/-/gnu-rm

VER=${VER:-'10.3-2021.10'}

    # https://developer.arm.com/-/media/Files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2
URL=https://developer.arm.com/-/media/Files/downloads/gnu-rm/${VER}/gcc-arm-none-eabi-${VER}-x86_64-linux.tar.bz2
# URL=https://developer.arm.com/-/media/Files/downloads/gnu/${VER}/binrel/gcc-arm-${VER}-x86_64-arm-none-eabi.tar.xz


echo "Creating gcc-arm-none-eabi x86_64 debian package" 
echo "version: $VER"

echo "Downloading..."
curl -fSL -A "Mozilla/4.0" -o gcc-arm-none-eabi.tar "$URL"

echo "Extracting..."
mkdir tmp
pushd tmp
tar -xf ../gcc-arm-none-eabi.tar
popd
rm gcc-arm-none-eabi.tar

echo "Generating debian package..."
mkdir gcc-arm-none-eabi
mkdir gcc-arm-none-eabi/DEBIAN
mkdir gcc-arm-none-eabi/usr
echo "Package: gcc-arm-none-eabi"          >  gcc-arm-none-eabi/DEBIAN/control
echo "Version: $VER"                       >> gcc-arm-none-eabi/DEBIAN/control
echo "Architecture: amd64"                 >> gcc-arm-none-eabi/DEBIAN/control
echo "Maintainer: maintainer"              >> gcc-arm-none-eabi/DEBIAN/control
echo "Description: Arm Embedded toolchain" >> gcc-arm-none-eabi/DEBIAN/control
mv tmp/gcc-arm-*/* gcc-arm-none-eabi/usr/
dpkg-deb --build --root-owner-group gcc-arm-none-eabi

# echo "Installing..."
# sudo apt install ./gcc-arm-none-eabi.deb -y --allow-downgrades

mv "gcc-arm-none-eabi.deb" "gcc-arm-none-eabi-${VER}-x86_64.deb"
ls -l *.deb

echo "Done."

