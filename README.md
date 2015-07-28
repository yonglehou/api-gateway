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

## Local Integration Testing

The integration testing local to this repository also uses busted. To run the
integration tests do the following:

```
busted spec_integration
```

The integration tests require the following environment variables:

 * `USERNAME`: the user name used to request a token from helios
 * `PASSWORD`: the password used to request a token from helios
 * `LOGIN_URL`: the login URL for helios
 * `SERVICE_URL`: the service URL to attempt `GET` once a token has been
	 aquired. This URL should require a token for the tests to work as expected.

## Resources

 * `/healthcheck`: Returns 200 status code on success. Checks to see that the
	 helios heartbeat responds as expected.
 * `/(.*)`: Proxies requests to the services. See below for more details regarding the access token handling. And routing mechanism


If the `access_token` cookie exists and is not empty then an attempt will be
made to authenticate the token against helios and retrieve the user id of the
user to whom the token belongs. If a user id is returned from helios then that
user id will be provided in the `X-Wikia-UserId` header sent to the service.

If the `access_token` cookie is absent, expired, or invalid then no
`X-Wikia-UserId` will be sent to the service.

## Services routing

For simplicity all service/tag pairs available in Consul are rendered in upstreams.conf as endpoints able to be consumed by any lua or nginx configuration. e.g. we have three helios services A, B registered with tag (prod) and C registered with tag (testing); they will be rendered in upstreams as

```
upstream prod_helios {
   server A<ip>:A<port>;
   server B<ip>:B<port>;
}
# and

upstream testing_helios {
	server C<ip>:C<port>;
}
```


### Default routing

For default configuration special tag "expose.production" and tag prefix "expose.*" is used to automatically find and exposed specific services to outside world through the gateway.

All services tagged with *expose.production* upon successfull registration into Consul will trigger rerendering of default_locations.lua file which holds url mappings for services. Where e.g. helios with expose.production tag will be rendered as
```
url_routes['helios'] = "expose_production_helios"
-- where 'helios' is url prefix i.e. http://api-gateway.example.com/helios
-- and expose_production_helios is the name of rendered upstream where all the traffic from calls to urls prefixed with "helios" will be directed
```

*The urls are rewritten to remove the prefix*. before the request is made to final destination

For other tags prefixed with "expose.*" the formula is a little bit different. E.g. helios tagged with expose.testing will render as
```
url_routes['testing.helios'] = "expose_testing_helios"
-- where url prefix is created by first removing expose. prefix and concatenating remaining tag name with service name
```

### Configured routing

For special cases as well as legacy compatibility. Single level url prefixes (i.e. prefix = "ship" and not "sailing/ship") can be configured to be routed to any available service irregardles of this service being tagged with expose.* or not.

Configuration is taken from consul K/V prefixed with "auto_discovery/services". Where each key is rendered as:
```
url_routes[<key>] = <value>
```

## Developing with Nginx Locally

The `scripts/` director contains helpers for stopping and starting nginx. The
nginx config file in `nginx/conf/nginx.conf` should be enough to test.

To start:

```
./scripts/nginx-start
```

You can test the basic functionality with:

```
curl -H “Cookie: access_token=<token>” http://127.0.0.1:8089/service/...
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

## Contributors

 * [Artur Klajnerok](https://github.com/ArturKlajnerok)
 * [Damon Snyder](https://github.com/drsnyder)
 * [Frank Farmer](https://github.com/frankfarmer)
 * [Jarek Cellary](https://github.com/jcellary)
 * [Pawel Chojnacki](https://github.com/pchojnacki)

## TODO

 * Create an app table and pass it around. This will provide an easy and light on-ramp to
   dependency injection which should help improve the testability.
