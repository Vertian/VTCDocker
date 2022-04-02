#!/bin/bash

cd /root/vertcoin
export WORKSPACE=`pwd`
rm -rf build

export HOST=riscv64-linux-gnu
make -j8 -C depends HOST=$HOST
mkdir -p $WORKSPACE/out/$HOST
./autogen.sh
mkdir build && cd build
../configure --disable-dependency-tracking --disable-tests --disable-bench --enable-glibc-back-compat --prefix=$WORKSPACE/depends/$HOST --enable-reduce-exports --bindir=$WORKSPACE/out/$HOST/bin --libdir=$WORKSPACE/out/$HOST/lib
make -j8 install
cd ../
rm -rf build
rm -rf /root/output/$HOST
mv $WORKSPACE/out/$HOST /root/output/$HOST

QT_BINS=("/root/output/$HOST/bin/vertcoin-qt")
DAEMON_BINS=("/root/output/$HOST/bin/vertcoind" "/root/output/$HOST/bin/vertcoin-tx" "/root/output/$HOST/bin/vertcoin-cli" "/root/output/$HOST/bin/vertcoin-wallet")

strip --strip-unneeded "${QT_BINS[@]}" "${DAEMON_BINS[@]}"
zip -j /root/output/vertcoind-riscv64.zip "${DAEMON_BINS[@]}"
zip -j /root/output/vertcoinqt-riscv64.zip "${QT_BINS[@]}"