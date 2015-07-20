-- Mock
-- package auth
local auth = {}

function auth:new(authenticate_response)
  local out = { 
    authenticate_response = authenticate_response,
  }

  return setmetatable(out, { __index = self })
end

function auth:authenticate_by_cookie(cookie_string)
  return self.authenticate_response
end

function auth:authenticate_and_return_user_id(cookie_string)
  return self.authenticate_response
end

function auth:set_authenticate_response(response)
  self.authenticate_response = response
end

return auth
