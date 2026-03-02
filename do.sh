EMBIN=$(dirname $(which emcc))
export SHIM_INCLUDES=$(pwd)"/patch_include/";
export EMTOOLCHAIN=$(dirname $(which emcc))/../share/emscripten
# make sure youve built libffi

export EXPOSE="-sEXPORTED_FUNCTIONS=['_JNI_CreateJavaVM','_JNI_GetDefaultJavaVMInitArgs','_JNI_GetCreatedJavaVMs','_main'] \
               -sEXPORTED_RUNTIME_METHODS=['ccall','cwrap','FS','ERRNO_CODES'] -sEXIT_RUNTIME=0"

export LIBFFI_BUILD=$(pwd)/libffi/wasm_build
export CXX=$EMTOOLCHAIN"/em++"
export CC=$EMTOOLCHAIN"/emcc"
export LD=$CC
export AR=$EMTOOLCHAIN"/emar"
export STRIP=true
export NM=$EMTOOLCHAIN"/emnm"
export INCL="-I"$SHIM_INCLUDES" -I"$LIBFFI_BUILD"/include";
export CFLAGS="-fPIC -fvisibility=default -Wno-undef -Wno-format -Wno-format-security -Wno-unused -Wno-unused-private-field -Wno-missing-braces -Wno-unused-function -Wno-bitwise-instead-of-logical -Wno-deprecated-declarations -Wno-unused-command-line-argument -sMAIN_MODULE=1 -sRELOCATABLE=1 "$INCL
export CXXFLAGS=$CFLAGS
export LDFLAGS="-sRELOCATABLE=1 -Wno-unused-command-line-argument -sMAIN_MODULE=1 -fPIC -fvisibility=default -sERROR_ON_UNDEFINED_SYMBOLS=0 "$EXPOSE" --no-entry "
export PRECOMPILED_HEADERS_AVAILABLE=false
export BUILD_JDK=$(readlink -f $(dirname $(which java))"/../../..")
export EXTEXE="yes"
export OBJCOPY=true
# if still broken, remove libffi to configure, and bypass the error message
# and instead just manually link to it using LDFLAGS and CFLAGS
if [ "$1" = "config" ]; then
  cp libffi/wasm_build/lib/libffi.a libffi/wasm_build/lib/libffi.so.0
  cd jdk
  rm -rf build/*

  emconfigure bash configure \
    --with-toolchain-path=$EMTOOLCHAIN \
    --with-conf-name=emscripten \
    --with-tools-dir=$EMTOOLCHAIN \
    --openjdk-target=i686-unknown-linux-gnu \
    --with-jvm-variants=zero \
    --with-libffi-include="$LIBFFI_BUILD"/include \
    --with-libffi-lib="$LIBFFI_BUILD"/lib \
    --disable-libffi-bundling \
    --without-cups --with-freetype=bundled --without-fontconfig \
    --with-alsa=bundled --with-libpng=bundled \
    --with-native-debug-symbols=none \
    --enable-precompiled-headers=no --disable-warnings-as-errors \
    --with-extra-cflags="$CFLAGS" --with-extra-cxxflags="$CFLAGS" --with-extra-ldflags="$LDFLAGS" \
    --with-build-jdk="$BUILD_JDK" --with-boot-jdk="$BUILD_JDK" \
    AR=$AR STRIP=$STRIP CXX=$CXX CC=$CC NM=$NM ar=$AR strip=$STRIP cxx=$CXX cc=$CC nm=$NM LD=$CC
else
  cp libffi/wasm_build/lib/libffi.a libffi/wasm_build/lib/libffi.so.0
  cd jdk
  find build/emscripten/support -type f -exec touch -t 202601010000.05 {} + #fix zip throwing timestamp errors
  emmake make images emscripten DEBUG=info VERIFY_KERNELS=false CHECK_AND_PATCH_LIBRARIES=false && echo "JDK/JRE 25 cross-compiled to webassembly"
  
  echo ""
  echo "Ignore the error, it is caused by a validation step in the makefile that cannot handle wasm binaries"
  echo ""

  cp build/emscripten/jdk/lib/zero/libjvm.so ../wasmjdk_build/lib/libjvm.a
  rm -r ../wasmjdk_build/include/*
  cp -r build/emscripten/jdk/include/* ../wasmjdk_build/include/
fi
