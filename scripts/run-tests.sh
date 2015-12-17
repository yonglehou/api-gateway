#!/bin/bash
export PATH=$PATH:$HOME/.luarocks/bin
export TEST_NGINX_BINARY=`which openresty`
/bin/ls -R $PERL5LIB/lib/perl5/
busted spec && prove -r t
