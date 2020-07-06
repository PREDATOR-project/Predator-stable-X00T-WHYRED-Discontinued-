#!/usr/bin/env bash
# Copyright (C) 2020 Fiqri Ardyansyah (fiqri19102002)
# Copyright (C) 2020 Mohammad Iqbal (predator112)
# Configured for Redmi Note 6 Pro / tulip custom kernel source
# Simple Local Kernel Build Script

# Clone AnyKernel
if ! [ -d "$PWD/AnyKernel" ]; then
    git clone https://github.com/PREDATOR-project/AnyKernel3.git -b Extended-Kernel --depth=1 AnyKernel3
else
    echo "AnyKernel3 folder is exist, not cloning"
fi

# Main Environment
KERNEL_DIR=/home/loli/kernel
KERN_IMG=$KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb
ZIP_DIR=/home/loli/kernel/AnyKernel3
CLANG_DIR=/home/loli/install
CONFIG_DIR=$KERNEL_DIR/arch/arm64/configs
CORES=$(grep -c ^processor /proc/cpuinfo)
THREAD="-j$CORES"

# export
export KBUILD_BUILD_USER=builder
export KBUILD_BUILD_HOST=MohammadIqbal
export ARCH=arm64
export LD_LIBRARY_PATH="/home/loli/install/bin/../lib:$PATH"

# compile plox
make -C $(pwd) -j$(nproc) O=out predator_defconfig
PATH="/home/loli/install/bin:${PATH}"
make -j$(nproc) O=out ARCH=arm64 \
       CC=clang \
       CLANG_TRIPLE=aarch64-linux-gnu- \
       CROSS_COMPILE=aarch64-linux-gnu- \
       CROSS_COMPILE_ARM32=arm-linux-gnueabi-
O=out \
            -j60 \
            -l50 2>&1| tee build.log
            if ! [ -a "$IMAGE" ]; then
                finerr
                exit 1
            fi
    cp out/arch/arm64/boot/Image.gz-dtb AnyKernel3
}
# Compress to zip file
cd $ZIP_DIR
make clean &>/dev/null
make normal &>/dev/null
cd ..
echo -e "The build is complete, and is in the directory $ZIP_DIR"
