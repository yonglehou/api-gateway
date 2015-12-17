#!/bin/bash
export PATH=$PATH:$HOME/.luarocks/bin:$HOME/local/nginx/sbin
NGINX_BIN=$(which openresty)
if [ -z $NGINX_BIN ]; then
    NGINX_BIN=$(which nginx)
fi
echo "*** Found nginx under '${NGINX_BIN}' *** "
$NGINX_BIN -v
export TEST_NGINX_BINARY=$NGINX_BIN
busted spec && prove -r t
