-- package Helios
local cjson = require "cjson"

local helios = {}

--
-- @param net http client supporting :get
-- @param helios URL
function helios:new(net, helios_url)
  local out = {
    net         = net,
    helios_url  = helios_url,
  }

  return setmetatable(out, { __index = self })
end

--
-- Validate a session token using Helios.
--
-- @param session token
-- @return user id | nil
--
function helios:validate_token(session_token)
  local url = self:request_url(session_token)
  local res, err = self.net:get(url)

  if res and res.body then
    local status, data = pcall(function() return cjson.new().decode(res.body) end)
    if status and data and data.user_id then
      return data.user_id
    else
      return nil
    end
  end
end

local function helios_health_check_ok(code, body)
  if code == 200 and string.find(body, "OK") then
    return true
  end

  return false
end

function helios:healthcheck()
  local status, res = pcall(function() return self.net:get(self:healthcheck_url()) end)
  if not status then
    return false, "Error connecting to Helios: " .. res
  end

  if res and helios_health_check_ok(res.code, res.body) then
    return true, nil
  else
    return false, res.err
  end
end


function helios:request_url(session_token)
  return string.format("%s/info?code=%s", self.helios_url, session_token)
end

function helios:healthcheck_url()
  return string.format("%s/heartbeat", self.helios_url)
end

return helios
