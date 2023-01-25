echo "===================Setup Export========================="
export ARCH=arm64
#export CROSS_COMPILE=$GITHUB_WORKSPACE/kernel/tool/aarch/bin/aarch64-linux-android-
#export CROSS_COMPILE_ARM32=$GITHUB_WORKSPACE/kernel/tool/arm/bin/arm-linux-androideabi-


KERNEL_DEFCONFIG=vendor/alioth_defconfig







sudo apt-get install gcc-aarch64-linux-gnu gcc-arm-linux-gnueabi


BUILD_START=$(date +"%s")

blue='\033[1;34m'

yellow='\033[1;33m'

nocol='\033[0m'

# Always do clean build lol

echo -e "$yellow**** Cleaning ****$nocol"

mkdir -p out

make O=out clean

echo -e "$yellow**** Kernel defconfig is set to $KERNEL_DEFCONFIG ****$nocol"

echo -e "$blue***********************************************"

echo "          BUILDING KERNEL          "

echo -e "***********************************************$nocol"

make $KERNEL_DEFCONFIG O=out

make -j$(nproc --all) O=out \

                      ARCH=arm64 \

                      CC=clang \

                      CLANG_TRIPLE=aarch64-linux-gnu- \

                      CROSS_COMPILE=aarch64-linux-gnu- \

                      CROSS_COMPILE_ARM32=arm-linux-androideabi-

find out/arch/arm64/boot/dts/vendor/qcom/ -name '*.dtb' -exec cat {} + >out/arch/arm64/boot/dtb

BUILD_END=$(date +"%s")

DIFF=$(($BUILD_END - $BUILD_START))

echo -e "$yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"






