#!/bin/bash
# https://askubuntu.com/a/1371525
# https://developer.arm.com/downloads/-/gnu-rm

VER=${VER:-'10.3-2021.10'}

URL=https://developer.arm.com/-/media/Files/downloads/gnu-rm/${VER}/gcc-arm-none-eabi-${VER}-x86_64-linux.tar.bz2

mkdir .build-gcc-arm
cd .build-gcc-arm
echo "Creating gcc-arm-none-eabi x86_64 debian package"
echo "version: $VER"
echo "url: $URL"
if [ -f "gcc-arm-none-eabi.tar" ]; then
    read -p "gcc-arm-none-eabi.tar already exists. Do you want to overwrite it? (y/n) " choice
    if [[ $choice != "y" ]]; then
        echo "Skipping download."
    fi
else
    echo "Downloading..."
    curl -C - -fSL -A "Mozilla/4.0" -o gcc-arm-none-eabi.tar "$URL"
fi

origin_name="gcc-arm-none-eabi"
destination="/opt"

echo "Extracting..."
mkdir tmp
pushd tmp
tar -xf ../gcc-arm-none-eabi.tar
mv gcc-arm-none-eabi-* "$origin_name"
sudo mv "$origin_name" "$destination"
popd

echo "export PATH=\"/opt/$origin_name/bin:\$PATH\"" >>~/.bashrc
source ~/.bashrc
# exec bash
echo "gcc-arm-none-eabi moved to /opt and path added to system's PATH."
arm-none-eabi-gcc --version
echo "Done."
