-- Mock
-- package auth
local auth = {}

function auth:new(authenticate_response)
  local out = { 
    authenticate_response = authenticate_response,
  }

  return setmetatable(out, { __index = self })
end

function auth:authenticate(cookie_string)
  return self.authenticate_response
end

function auth:set_authenticate_response(response)
  self.authenticate_response = response
end

return auth

