package = "api_gateway"
local VER = "0.1"
version = VER .. "-0"

source = {
  url = "file://src",
}
description = {
	license = "PRIVATE",
}

build = {
  type = "command"
}

dependencies = {
   "lua >= 5.3",
   "lua-resty-http = 0.06-0",
   "busted = 2.0.rc9-0",
   "lua-cjson = 2.1.0-1",
   "httpclient = 0.1.0-7",
}
