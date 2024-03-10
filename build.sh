#!/bin/bash

export USE_CCACHE=1
export CCACHE_COMPRESS=1
export CCACHE_MAXSIZE=50G
source build/envsetup.sh
ccache -M 50G -F 0
clear

echo "***** TREBLE EVOLUTION BUILD *****"
lunch treble_arm64_bgN-userdebug 
make systemimage -j$(nproc --all)

cd out/target/product/tdgsi_arm64_ab
xz -9 -T0 -v -z system.img 

echo "***** UPLOADING... *****"
for file in `ls ~/ | grep xz` ; do
  gh release upload --clobber $1 ~/$file
done
echo "***** UPLOADING COMPLETED *****"
