#!/bin/bash
VERSION=1.7.10.2
PACKAGE=ngx_openresty-${VERSION}.tar.gz
DOWNLOAD_BASE=https://openresty.org/download
TEMPDIR=$HOME/tmp
PREFIX=$HOME/local

mkdir -p $TEMPDIR
mkdir -p $PREFIX


cd $TEMPDIR
wget $DOWNLOAD_BASE/$PACKAGE
tar zxvf $PACKAGE

cd ngx_openresty-${VERSION}
./configure --prefix=$HOME/local
make
make install

