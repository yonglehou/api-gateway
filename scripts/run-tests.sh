#!/bin/bash
export PATH=$PATH:$HOME/.luarocks/bin:$HOME/local/nginx/sbin
export TEST_NGINX_BINARY=`which openresty`
busted spec && prove -r t
