#!bin/bash

# Go to the working directory
mkdir ~/TWRP-9 && cd ~/TWRP-9
# Configure git
git config --global user.email "100Daisy@protonmail.com"
git config --global user.name "GitDaisy"
git config --global color.ui false
# Sync the source
repo init --depth=1 -u git://github.com/minimal-manifest-twrp/platform_manifest_twrp_omni.git -b twrp-9.0
repo sync  -f --force-sync --no-clone-bundle --no-tags -j$(nproc --all)
# Clone device tree and common tree
git clone --depth=1 https://github.com/100Daisy/android_device_xiaomi_lime -b android-9.0 device/xiaomi/line
# Build recovery image
export ALLOW_MISSING_DEPENDENCIES=true; . build/envsetup.sh; lunch omni_lime-eng; make -j$(nproc --all) recoveryimage
# Rename and copy the files
twrp_version=$(cat ~/TWRP-9/bootable/recovery/variables.h | grep "define TW_MAIN_VERSION_STR" | cut -d '"' -f2)
date_time=$(date +"%d%m%Y%H%M")
mkdir ~/final
cp recovery.img ~/final/twrp-$twrp_version-deen-"$date_time"-unofficial.img
# Upload to oshi.at
curl -T ~/final/*.img https://oshi.at 
