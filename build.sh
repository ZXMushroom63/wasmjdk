rm -rf jdk/
git clone --depth=1 https://github.com/openjdk/jdk.git -b jdk25
cd jdk
bash configure
make images