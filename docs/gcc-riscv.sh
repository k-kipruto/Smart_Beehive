#!/bin/bash
# https://askubuntu.com/a/1371525
# https://developer.arm.com/downloads/-/gnu-rm
VER=${VER:-'12.2.0-3'}

mkdir .build-gcc-riscv
cd .build-gcc-riscv
echo "Creating gcc-riscv-none-elf x86_64 debian package" 

echo "Downloading..."

curl -fSL -A "Mozilla/4.0" -o riscv-none-elf-gcc-linux-x64.tar.gz $(curl -s https://api.github.com/repos/xpack-dev-tools/riscv-none-elf-gcc-xpack/releases/latest | grep "browser_download_url.*linux-x64.tar.gz" | cut -d : -f 2,3 | tr -d \")


echo "Extracting..."
mkdir tmp
pushd tmp
tar -xzf ../riscv-none-elf-gcc-linux-x64.tar.gz
popd
rm riscv-none-elf-gcc-linux-x64.tar.gz

echo "Generating debian package..."
mkdir riscv-none-elf-gcc
mkdir riscv-none-elf-gcc/DEBIAN
mkdir riscv-none-elf-gcc/usr
echo "Package: riscv-none-elf-gcc"          >  riscv-none-elf-gcc/DEBIAN/control
echo "Version: $VER"                       >> riscv-none-elf-gcc/DEBIAN/control
echo "Architecture: amd64"                 >> riscv-none-elf-gcc/DEBIAN/control
echo "Maintainer: maintainer"              >> riscv-none-elf-gcc/DEBIAN/control
echo "Description: RISC-V Embedded toolchain" >> riscv-none-elf-gcc/DEBIAN/control
mv tmp/riscv-none-*/* riscv-none-elf-gcc/usr/
dpkg-deb --build --root-owner-group riscv-none-elf-gcc