-- package nginx: An nginx auth handler

local nginx = {}
local net = require "httpclient"
local auth = require "auth"
local helios = require "gateway.helios"
local cookie = require "cookie"

function nginx.init(config)
  local client = net.new()
  client:set_default("timeout", config.SERVICE_HTTP_TIMEOUT)
  local helios = helios:new(client, config.HELIOS_URL)
  local auth = auth:new(helios)

  return {
    auth = auth,
    helios = helios,
    client = client
  }
end

function nginx.healthcheck(app)
  local is_up, res = app.helios:healthcheck()
  if is_up then
    ngx.say("Service status: OK")
  else
    ngx.status = ngx.HTTP_INTERNAL_SERVER_ERROR
    ngx.say("Error connecting to helios: " .. res)
  end
end



function nginx.authenticate(auth, cookie_string)
  local cookie_map = cookie.parse(cookie_string)
  if cookie_map.session_token then
    return auth:authenticate_and_return_user_id(cookie_map.session_token)
  end

  return nil
end

return nginx
