#!/bin/bash
VERSION=2.0.11
PACKAGE=luarocks-${VERSION}.tar.gz
LUAJIT_PATH=${LUAJIT_PATH-/usr/local/openresty/luajit}
TEMPDIR=$HOME/tmp
PREFIX=$HOME/local

mkdir -p $TEMPDIR
mkdir -p $PREFIX

cd $TEMPDIR
rm -rf luarocks-${VERSION}/

wget http://luarocks.org/releases/$PACKAGE
tar -xzvf $PACKAGE
cd luarocks-${VERSION}/
./configure --prefix=$LUAJIT_PATH \
    --with-lua=$LUAJIT_PATH \
    --lua-suffix=jit-2.1.0-alpha \
    --with-lua-include=$LUAJIT_PATH/include/luajit-2.1
make
make install
$LUAJIT_PATH/bin/luarocks install lua-resty-http
