EMBIN=$(dirname $(which emcc))
export SHIM_INCLUDES=$(pwd)"/include/";
export EMTOOLCHAIN=$(dirname $(which emcc))/../share/emscripten
export CXX=$EMTOOLCHAIN"/em++"
export CC=$EMTOOLCHAIN"/emcc"
export AR=$EMTOOLCHAIN"/emar"
export STRIP=$EMTOOLCHAIN"/emstrip"
export NM=$EMTOOLCHAIN"/emnm"
export CFLAGS="-Wno-unused -Wno-unused-private-field -Wno-missing-braces -Wno-unused-function -Wno-bitwise-instead-of-logical -I"$SHIM_INCLUDES
export CXXFLAGS=$CFLAGS
export EXEEXT="yes"
export PRECOMPILED_HEADERS_AVAILABLE=false
cd jdk
if [ $1 = "config" ]; then
  rm -rf build/*
  bash configure \
    --with-toolchain-path=$EMTOOLCHAIN \
    --with-conf-name=emscripten \
    --with-tools-dir=$EMTOOLCHAIN \
    --openjdk-target=arm-linux-gnueabihf \
    --without-cups --with-freetype=bundled --without-fontconfig \
    --with-alsa=bundled --with-libpng=bundled \
    --enable-precompiled-headers=no \
    --with-extra-cflags="$CFLAGS" --with-extra-cxxflags="$CFLAGS" \
    AR=$AR STRIP=$STRIP CXX=$CXX CC=$CC NM=$NM ar=$AR strip=$STRIP cxx=$CXX cc=$CC nm=$NM
else
  make images emscripten
fi