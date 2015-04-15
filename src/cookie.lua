-- package cookie: naive cookie parsing
-- basic functionality from https://github.com/frodsan/cookie.lua/blob/master/cookie.lua
local cookie = {}

local gmatch = string.gmatch
local sub    = string.sub
local find   = string.find

function cookie.parse(cookie_string)
  local res = {}

  if not cookie_string then
    return res
  end

  for pair in gmatch(cookie_string, "[^; ]+") do
    local eq = find(pair, "=")

    if eq then
      local key = sub(pair, 1, eq-1)
      local val = sub(pair, eq+1)

      if not res[key] then
        res[key] = val
      end
    end
  end

  return res
end

return cookie
