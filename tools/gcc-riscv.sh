#!/bin/bash
# https://github.com/xpack-dev-tools/riscv-none-elf-gcc-xpack/releases
VER=${VER:-'12.2.0-3'}

mkdir .build-gcc-riscv
cd .build-gcc-riscv
echo "Creating gcc-riscv-none-elf x86_64 debian package" 

FILE_NAME="riscv-none-elf-gcc-linux-x64.tar.gz"

if [ -f "$FILE_NAME" ]; then
  echo "File already exists. Skipping download."
else
  echo "Downloading..."
  DOWNLOAD_URL=$(curl -s https://api.github.com/repos/xpack-dev-tools/riscv-none-elf-gcc-xpack/releases/latest | grep "browser_download_url.*linux-x64.tar.gz" | cut -d : -f 2,3 | tr -d \")
  curl -C - -fSL -A "Mozilla/4.0" -o "$FILE_NAME" "$DOWNLOAD_URL"
fi

echo "Extracting..."
mkdir tmp
pushd tmp
tar -xzf "../$FILE_NAME"
mv "xpack-riscv-none-elf-gcc-*" "riscv-none-elf-gcc"
popd
# rm riscv-none-elf-gcc-linux-x64.tar.gz

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