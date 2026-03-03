cd runner
rm -rf build
mkdir -p build
mkdir -p emcache
export EMCACHE=$(pwd)"/emcache"
cd build
emcc ../main.cpp ../../wasmjdk_build/lib/libjvm.a -pthread -I../../wasmjdk_build/include/ -I../../wasmjdk_build/include/linux/ -o jvm.js $(cat ../../export_flags) \
-s MODULARIZE=1 -s EXPORT_NAME='JVM' \
-s ALLOW_MEMORY_GROWTH=1
rm -rf ../../docs/*
mv * ../../docs
cp ../template/* ../../docs