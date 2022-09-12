#!/bin/bash
required_packages="zlib1g bzip2 gcc-12-base build-essential cmake clang icu-devtools libicu-dev libghc-bz2-dev libfuse-dev libfuse3-dev libattr1-dev"

apt-get update
apt-get install -y ${required_packages}
apt-get install -y cargo

## now we have cargo, release the cracken
# install this lib to complete cargo install of cracken
apt-get install -y librust-cargo+openssl-dev
cargo install cracken

## build instructions of apfs-fuse
cd /tmp/
git clone https://github.com/sgan81/apfs-fuse
cd apfs-fuse
git submodule init
git submodule update

mkdir -p build
cd build
cmake .
make
make install

## done.