# API Gateway

This is a work in progress. The API gateway provides a Lua package that can be integrated
into a “host” such as nginx to marshal authentication tokens embedded in HTTP cookies into
a user id header suitable for user identification by services running behind the gateway.

## Testing

This package is tested using [busted](http://olivinelabs.com/busted/). To run the tests do
the following:

```
busted spec
```

## Resources

 * `/healthcheck`: Returns 200 status code on success. Checks to see that the
	 helios heartbeat responds as expected.

## Developing with Nginx Locally

The `scripts/` director contains helpers for stopping and starting nginx. The
nginx config file in `nginx/conf/nginx.conf` should be enough to test.

To start:

```
./scripts/nginx-start
```

You can test the basic functionality with:

```
curl -H “Cookie: session_token=<token>” http://127.0.0.1:8089/luatest
```

```
./scripts/nginx-reload
```

## Dependencies

 * [busted](http://olivinelabs.com/busted/)
 * [lua-httpclient](https://github.com/lusis/lua-httpclient). Can be installed with `luarocks`

## Environement variables

 * `NGINX_BIN`: Set to the location of your nginx binary.
 * `HELIOS_URL`: The URL to Helios (e.g. http://helios.site.com)
