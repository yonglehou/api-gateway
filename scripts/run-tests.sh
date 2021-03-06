#!/bin/bash
export PATH=$PATH:$HOME/.luarocks/bin:$HOME/local/nginx/sbin
if [ $(uname) == "Darwin" ]; then
    NGINX_BIN=$(which openresty)
    if [ -z $NGINX_BIN ]; then
        NGINX_BIN=$(which nginx)
    fi
    export TEST_NGINX_BINARY=$NGINX_BIN
fi

busted spec
prove -r t
if [ $? -ne 0 ]; then
    cat $PWD/t/servroot/logs/error.log
    exit 1
fi
