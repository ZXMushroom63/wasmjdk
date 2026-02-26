EMBIN=$(dirname $(which emcc))
export EMTOOLCHAIN=$(dirname $(which emcc))/../share/emscripten
export CXX=$EMTOOLCHAIN"/em++"
export CC=$EMTOOLCHAIN"/emcc"
export AR=$EMTOOLCHAIN"/emar"
export STRIP=$EMTOOLCHAIN"/emstrip"
export CFLAGS="-Wno-unused -Wno-unused-private-field -Wno-missing-braces -Wno-unused-function"
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
    --enable-precompiled-headers=no
else
  make images emscripten
fi