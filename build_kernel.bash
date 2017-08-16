cd
export CONCURRENCY_LEVEL=5
export CHOST="x86_64-pc-Linux-gnu"
export CFLAGS="-march=native -O2 -pipe"
export CXXFLAGS="$CFLAGS" 
export KV="4.10.1"
export KN="-777"
mkdir -p kernel-build
cd kernel-build
[ -e linux-${KV}.tar.xz ] || wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-${KV}.tar.xz
[ -d linux-${KV} ] || tar Jxf linux-${KV}.tar.xz
cd linux-${KV}
if [ ! -e .config ]
then
  echo "No .config in build directory!"
  echo "Press Ctrl-c to quit or Enter to continue..."
  read n
  make localmodconfig
  make oldconfig
  make menuconfig
fi
make clean
fakeroot make -j${CONCURRENCY_LEVEL} deb-pkg KDEB_PKGVERSION=${KN} kernel_image kernel_headers
#fakeroot make-kpkg -j${CONCURRENCY_LEVEL} --initrd --append-to-version=${KN} kernel_image kernel_headers
