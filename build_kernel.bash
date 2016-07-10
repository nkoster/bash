#!/bin/bash
cd
export CONCURRENCY_LEVEL=9
export CHOST="x86_64-pc-Linux-gnu"
export CFLAGS="-march=native -O2 -pipe"
export CXXFLAGS="$CFLAGS" 
export KV="4.6.3"
export KN="-para"
mkdir -p kernel-build
cd kernel-build
[ -e linux-${KV}.tar.xz ] || wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-${KV}.tar.xz
[ -d linux-${KV} ] || tar Jxf linux-${KV}.tar.xz
cd linux-${KV}
if [ ! -e .config ]
then
  make localmodconfig
  make oldconfig
  make menuconfig
  cp .config ../dot-config-$(openssl rand -hex 4)
fi
make clean
fakeroot make-kpkg -j${CONCURRENCY_LEVEL} --initrd --append-to-version=${KN} kernel_image kernel_headers
