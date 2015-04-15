-- Mock
-- package Helios
local helios = {}

function helios:new(response_map)
  local out = { 
    response_map  = response_map
  }

  return setmetatable(out, { __index = self })
end

function helios:validate_token(session_token)
  return self.response_map
end

return helios
