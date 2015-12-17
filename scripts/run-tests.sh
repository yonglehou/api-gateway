#!/bin/bash
export PATH=$PATH:$HOME/.luarocks/bin:$HOME/local/bin
export TEST_NGINX_BINARY=`which openresty`
busted spec && prove -r t
