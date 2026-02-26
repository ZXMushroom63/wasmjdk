EMBIN=$(dirname $(which emcc))
EMTOOLCHAIN=$(dirname $(which emcc))/../share/emscripten
cd jdk
bash configure \
  --with-toolchain-path=$EMTOOLCHAIN \
  --with-conf-name=emscripten