#!/bin/sh

set -e

echo "Installing binwalk"
git clone --depth=1 https://github.com/devttys0/binwalk.git
cd binwalk

# Change to python3 in deps.sh to allow installation on Ubuntu 20.04 (binwalk commit 2b78673)
sed -i '/REQUIRED_UTILS="wget tar python"/c\REQUIRED_UTILS="wget tar python3"' deps.sh
cd ..

# Apply patches
PATCHDIR=/patches

if [ ! -d "$PATCHDIR" ]; then
	PATCHDIR=./patches
fi

patch binwalk/deps.sh "$PATCHDIR"/binwalk/deps.sh.patch

echo "Installing firmadyne"
# tested with firmadyne commit bcd8bc0
git clone --recursive https://github.com/firmadyne/firmadyne.git
cd firmadyne
./download.sh
firmadyne_dir=$(realpath .)

# Set FIRMWARE_DIR in firmadyne.config
sed -i "/FIRMWARE_DIR=/c\FIRMWARE_DIR=$firmadyne_dir" firmadyne.config

# Comment out psql -d firmware ... in getArch.sh
sed -i 's/psql/#psql/' ./scripts/getArch.sh

# Change interpreter to python3
sed -i 's/env python/env python3/' ./sources/extractor/extractor.py ./scripts/makeNetwork.py
cd ..

echo "Setting up firmware analysis toolkit"
chmod +x fat.py
chmod +x reset.py

# Set firmadyne_path in fat.config
sed -i "/firmadyne_path=/c\firmadyne_path=$firmadyne_dir" fat.config

cd qemu-builds
wget -O qemu-system-static-2.5.0.zip "https://github.com/attify/firmware-analysis-toolkit/files/4244529/qemu-system-static-2.5.0.zip"
unzip -qq qemu-system-static-2.5.0.zip && rm qemu-system-static-2.5.0.zip
cd ..

echo "====================================================="
echo "Firmware Analysis Toolkit installed successfully!"
echo "Before running fat.py for the first time,"
echo "====================================================="
