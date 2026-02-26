EMBIN=$(dirname $(which emcc))
EMTOOLCHAIN=$(dirname $(which emcc))/../share/emscripten
export CXX=$EMTOOLCHAIN"/em++"
export CC=$EMTOOLCHAIN"/emcc"
export AR=$EMTOOLCHAIN"/emar"
export CFLAGS=""
export CXXFLAGS=""
export EXEEXT="yes"
cd jdk
if [ $1 = "config" ]; then
  rm -rf build/*
  bash configure \
    --with-toolchain-path=$EMTOOLCHAIN \
    --with-conf-name=emscripten \
    --with-tools-dir=$EMTOOLCHAIN \
    --openjdk-target=arm-linux-gnueabihf \
    --without-cups --with-freetype=bundled --without-fontconfig
else
  make images emscripten
fi