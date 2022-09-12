#!/bin/bash
required_packages="zlib1g bzip2 gcc-12-base build-essential cmake clang icu-devtools libicu-dev libghc-bz2-dev libfuse-dev libfuse3-dev libattr1-dev"

apt-get update
apt-get install -y ${required_packages}
apt-get install -y cargo
export PATH=${HOME}/.cargo/bin:${PATH}
## now we have cargo, release the cracken
# install this lib to complete cargo install of cracken
apt-get install -y librust-cargo+openssl-dev
cargo install cracken

## build instructions of apfs-fuse
cd /tmp/
rm -rfv /tmp/apfs-fuse
git clone https://github.com/sgan81/apfs-fuse
cd /tmp/apfs-fuse
git submodule init
git submodule update

cmake .
make
make install

cd ${HOME}
#git clone https://github.com/danielmiessler/SecLists.git

## done.