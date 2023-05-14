#!/bin/bash
# This script will install openocd from github xpack
#https://github.com/xpack-dev-tools/openocd-xpack/releases

echo "Installing OpenOCD from xpack tools..."

mkdir .build-openocd
cd .build-openocd
echo "Creating openocd "

FILE_NAME="openocd-linux-x64.tar.gz"

if [ -f "$FILE_NAME" ]; then
    read -p "$FILE_NAME already exists. Do you want to overwrite it? (y/n) " choice
    if [[ $choice != "y" ]]; then
        echo "Skipping download."
    fi
else
    echo "Downloading..."
    DOWNLOAD_URL=$(curl -s https://api.github.com/repos/xpack-dev-tools/openocd-xpack/releases/latest | grep "browser_download_url.*linux-x64.tar.gz" | grep -v ".sha" | cut -d : -f 2,3 | tr -d "[:space:]" | tr -d \" )
    echo "$FILE_NAME"
    echo "$DOWNLOAD_URL"
    curl -C - -fSL -A "Mozilla/4.0" -o "$FILE_NAME" "$DOWNLOAD_URL"
fi

origin_name="openocd"
destination="/opt"

echo "Extracting..."
mkdir tmp
pushd tmp
tar -xzf "../$FILE_NAME"
ls
mv "xpack-openocd"* "$origin_name"
sudo mv "$origin_name" "$destination"
popd

echo "export PATH=\"/opt/$origin_name/bin:\$PATH\"" >>~/.bashrc
source ~/.bashrc

echo "openocd moved to /opt and path added to system's PATH."
# exec bash
openocd --version
echo "Done."
