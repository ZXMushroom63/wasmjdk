cd libffi
emconfigure ./configure \
    --host=wasm32-unknown-emscripten \
    --prefix=$(pwd)/wasm_build \
    --enable-static \
    --disable-shared \
    --disable-multi-os-directory \
    CFLAGS="-O3"

emmake make
emmake make install