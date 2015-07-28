local util = require("util")

local upstream = {
  default = require("default_locations"),
  configured = require("configured_locations"),
}

-- We use this to determine if the upstream exists. If it does not then we can
-- return a placeholder for generating a 404.
function upstream.find(request_uri) 
  local first_url_token = util.get_url_prefix(request_uri)
  
  --find appropriate backend
  local target = upstream.default[first_url_token]

  --fallback to uri configured in Consul K/V
  if target == nil or target == "" then
    target = upstream.configured[first_url_token]
  end

  --set fake upstream name in case is not found
  if target == nil or target == "" then
    target = "__not_found"
  end
  return target
end

return upstream
