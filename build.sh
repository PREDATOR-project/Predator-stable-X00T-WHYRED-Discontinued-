#!/bin/bash
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER=iqbal
export KBUILD_BUILD_HOST=predator
export CROSS_COMPILE=/home/iqbal/gcc64/bin/aarch64-linux-gnu-
export CROSS_COMPILE_ARM32=/home/iqbal/gcc32/bin/arm-linux-gnueabi-
mkdir -p out
make O=out clean
make O=out mrproper
make O=out predator_defconfig
make O=out -j$(nproc --all)
