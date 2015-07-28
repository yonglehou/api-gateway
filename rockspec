package = "api-gateway"
local VER = "1.0"
version = VER .. "-1"

source = {
  url = "https://github.com/Wikia/api-gateway.git",
}
description = {
	license = "PRIVATE",
}

dependencies = {
   "lua >= 5.3",
   "lua-resty-http = 0.1-0",
   "busted = 2.0.rc9-0",
   "lua-cjson = 2.1.0-1",
   "httpclient = 0.1.0-7",
}
