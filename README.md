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

## Dependencies

The development dependencies:
	* [busted](http://olivinelabs.com/busted/)
