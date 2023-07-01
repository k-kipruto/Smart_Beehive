#!/bin/bash
# https://github.com/xpack-dev-tools/riscv-none-elf-gcc-xpack/releases

mkdir .build-gcc-riscv
cd .build-gcc-riscv
echo "Creating gcc-riscv-none-elf x86_64 debian package"

FILE_NAME="riscv-none-elf-gcc-linux-x64.tar.gz"

if [-f "$FILE_NAME"]; then
  read -p "$FILE_NAME already exists. Do you want to overwrite it? (y/n) " choice
  if [[ $choice != "y" ]]; then
    echo "Skipping download."
  fi
else
  echo "Downloading..."
  DOWNLOAD_URL=$(curl -s https://api.github.com/repos/xpack-dev-tools/riscv-none-elf-gcc-xpack/releases/latest | grep "browser_download_url.*linux-x64.tar.gz" | cut -d : -f 2,3 | tr -d \")
  curl -C - -fSL -A "Mozilla/4.0" -o "$FILE_NAME" "$DOWNLOAD_URL"
fi

origin_name="riscv-none-elf-gcc"
destination="/opt"

echo "Extracting..."
mkdir tmp
pushd tmp
tar -xzf "../$FILE_NAME"
mv "xpack-riscv-none-elf-gcc"* "$origin_name"
sudo mv "$origin_name" "$destination"
popd

echo "export PATH=\"/opt/$origin_name/bin:\$PATH\"" >>~/.bashrc
source ~/.bashrc

echo "riscv-none-elf-gcc moved to /opt and path added to system's PATH."
# exec bash
riscv-none-elf-gcc --print-multi-lib
echo "Done."
