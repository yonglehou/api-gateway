-- package Helios
local cjson = require "cjson"

local helios = {}

--
-- @param helios URL
function helios:new(ngx)
  local out = {
    ngx = ngx,
  }

  return setmetatable(out, { __index = self })
end

--
-- Validate a access token using Helios.
--
-- @param access token
-- @return user id | nil
--
function helios:validate_token(access_token)
  local url = self:sub_request_url(access_token)
  res = self.ngx.location.capture(url, {copy_all_vars = true})

  if res and res.body then
    local status, data = pcall(function() return cjson.new().decode(res.body) end)
    if status and data and data.user_id then
      return data.user_id
    else
      return nil
    end
  end
end

function helios:sub_request_url(access_token)
  return string.format("/token?code=%s", access_token)
end

return helios
