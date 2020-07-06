#!/usr/bin/env bash
# Copyright (C) 2020 Fiqri Ardyansyah (fiqri19102002)
# Copyright (C) 2020 Mohammad Iqbal (predator112)
# Configured for Redmi Note 6 Pro / tulip custom kernel source
# Simple Local Kernel Build Script

# Clone toolchain ARM64
if ! [ -d "$PWD/toolchain64" ]; then
    git clone https://github.com/najahiiii/aarch64-linux-gnu.git -b linaro8-20190402 --depth=1 toolchain64
else
    echo "Toolchain ARM64 folder is exist, not cloning"
fi

# Clone toolchain ARM32
if ! [ -d "$PWD/toolchain32" ]; then
    git clone https://github.com/innfinite4evr/android-prebuilts-gcc-linux-x86-arm-arm-eabi-7.2.git -b master --depth=1 toolchain32
else
    echo "Toolchain ARM32 folder is exist, not cloning"
fi

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
CONFIG=predator_defconfig
CORES=$(grep -c ^processor /proc/cpuinfo)
THREAD="-j$CORES"

# Export
export ARCH=arm64
export SUBARCH=arm64
export CROSS_COMPILE
export CROSS_COMPILE="$KERNEL_DIR/toolchain64/bin/aarch64-linux-gnu-"
export CROSS_COMPILE_ARM32="$KERNEL_DIR/toolchain32/bin/arm-eabi-"
export CC=$CLANG_DIR/bin/clang-11
export KBUILD_COMPILER_STRING=$($CC --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g' -e 's/[[:space:]]*$//')
export CLANG_TREPLE=aarch64-linux-gnu-
export KBUILD_BUILD_USER="builder"
export KBUILD_BUILD_HOST="MohammadIqbal"

# Mkdir
if ! [ -d "$KERNEL_DIR/out" ]; then
    mkdir -p $KERNEL_DIR/out
else
    echo "Out folder is exist, not Make"
fi

# Start building the kernel
make  O=out $CONFIG $THREAD &>/dev/null
make  O=out $THREAD & pid=$!
spin[0]="-"
spin[1]="\\"
spin[2]="|"
spin[3]="/"
while kill -0 $pid &>/dev/null
do
	for i in "${spin[@]}"
	do
		echo -ne "\b$i"
		sleep 0.1
	done
done

if ! [ -a $KERN_IMG ]; then
	echo -e "\n(!)Build error, please fix the issue"
	exit 1
fi

[[ -z ${ZIP_DIR} ]] && { exit; }

# Compress to zip file
cd $ZIP_DIR
make clean &>/dev/null
make normal &>/dev/null
cd ..
echo -e "The build is complete, and is in the directory $ZIP_DIR"
