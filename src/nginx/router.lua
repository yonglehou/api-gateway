-- package router: A wrapper for routing requests

local router = {}

local config = require "config"
local nginx = require "nginx"

function router.route()
  local app = nginx.init(config)

  local headers = ngx.req.get_headers(100)
  local user_id = nginx.authenticate(app, headers)
  return nginx.service_proxy(ngx, user_id, headers)
end


return router
