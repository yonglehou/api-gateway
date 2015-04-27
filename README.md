[![Build Status](https://travis-ci.org/Wikia/api-gateway.svg?branch=master)](https://travis-ci.org/Wikia/api-gateway)

# API Gateway

The API gateway provides a Lua package that can be integrated into a “host”
such as nginx to marshal authentication tokens embedded in HTTP cookies into a
user id header suitable for user identification by services running behind the
gateway.

## Testing

This package is tested using [busted](http://olivinelabs.com/busted/). To run the tests do
the following:

```
busted spec
```

## Resources

 * `/healthcheck`: Returns 200 status code on success. Checks to see that the
	 helios heartbeat responds as expected.
 * `/service/(.*)`: Proxies requests to the service load balancers. See below
	 for more details regarding the session token handling.


If the `session_token` cookie exists and is not empty then an attempt will be
made to authenticate the token against helios and retrieve the user id of the
user to whom the token belongs. If a user id is returned from helios then that
user id will be provided in the `X-Wikia-UserId` header sent to the service.

If the `session_token` cookie is absent, expired, or invalid then no
`X-Wikia-UserId` will be sent to the service.

## Developing with Nginx Locally

The `scripts/` director contains helpers for stopping and starting nginx. The
nginx config file in `nginx/conf/nginx.conf` should be enough to test.

To start:

```
./scripts/nginx-start
```

You can test the basic functionality with:

```
curl -H “Cookie: session_token=<token>” http://127.0.0.1:8089/service/...
```

```
./scripts/nginx-reload
```

The current implementation relies upon DNS to resolve the load balancers. This
is accomplished via the `resolver` directive under the `/service` `location`. If
you are developing locally and do not have DNS running on port 8600 (the
expectation in production) you can “fake” it with the following:

```
socat udp4-recvfrom:8600,reuseaddr,fork \
	udp-sendto:`cat /etc/resolv.conf | grep nameserver | sed ‘s/nameserver \(\.*\)/\1/g’`:53
```

`socat` can be installed via `homebrew` on OS X or via a package manager on
Linux.

## Deployment

The `api-gateway` has been configured to use the deploy tools. To deploy to
production:

```
dt prep -a api-gateway -e prod -r api-gateway@master
dt push -a api-gateway -e prod
```

## Dependencies

 * [busted](http://olivinelabs.com/busted/)
 * [lua-httpclient](https://github.com/lusis/lua-httpclient) Can be installed with `luarocks`
 * [lua-cjson](https://github.com/mpx/lua-cjson)
 * [nginx](http://nginx.org/)
 * [consul-template](https://github.com/hashicorp/consul-template)

## Environement variables

 * `NGINX_BIN`: Set to the location of your nginx binary.

## TODO

 * I’m not a fan of OO in Lua. I think I would rather create an app table and
 pass it around. It would be easier to test and manage state.
