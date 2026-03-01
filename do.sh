EMBIN=$(dirname $(which emcc))
export SHIM_INCLUDES=$(pwd)"/include/";
export EMTOOLCHAIN=$(dirname $(which emcc))/../share/emscripten
# make sure youve built libffi
export LIBFFI_BUILD=$(pwd)/libffi/wasm_build
export CXX=$EMTOOLCHAIN"/em++"
export CC=$EMTOOLCHAIN"/emcc"
export LD=$CC
export AR=$EMTOOLCHAIN"/emar"
export STRIP=$EMTOOLCHAIN"/emstrip"
export NM=$EMTOOLCHAIN"/emnm"
export INCL="-I"$SHIM_INCLUDES" -I"$LIBFFI_BUILD"/include";
export CFLAGS="-Wno-undef -Wno-format -Wno-format-security -Wno-unused -Wno-unused-private-field -Wno-missing-braces -Wno-unused-function -Wno-bitwise-instead-of-logical -Wno-deprecated-declarations "$INCL
export CXXFLAGS=$CFLAGS
export LDFLAGS=$INCL" -L"$LIBFFI_BUILD"/lib -llibffi -sSIDE_MODULE=1"
export EXEEXT="yes"
export PRECOMPILED_HEADERS_AVAILABLE=false
export BUILD_JDK=$(readlink -f $(dirname $(which java))"/../../..")
cd jdk

if [ "$1" = "config" ]; then
  rm -rf build/*

  emconfigure bash configure \
    --with-toolchain-path=$EMTOOLCHAIN \
    --with-conf-name=emscripten \
    --with-tools-dir=$EMTOOLCHAIN \
    --openjdk-target=x86_64-unknown-linux-gnu \
    --with-jvm-variants=zero \
    --with-libffi-include="$LIBFFI_BUILD"/include \
    --with-libffi-lib="$LIBFFI_BUILD"/lib \
    --without-cups --with-freetype=bundled --without-fontconfig \
    --with-alsa=bundled --with-libpng=bundled \
    --enable-precompiled-headers=no --disable-warnings-as-errors \
    --with-extra-cflags="$CFLAGS" --with-extra-cxxflags="$CFLAGS" --with-extra-ldflags="$LDFLAGS" \
    --with-build-jdk="$BUILD_JDK" --with-boot-jdk="$BUILD_JDK" \
    AR=$AR STRIP=$STRIP CXX=$CXX CC=$CC NM=$NM ar=$AR strip=$STRIP cxx=$CXX cc=$CC nm=$NM LD=$CC
else
  find build/emscripten/support -type f -exec touch -t 202601010000.05 {} + #fix zip throwing timestamp errors
  emmake make images emscripten
fi