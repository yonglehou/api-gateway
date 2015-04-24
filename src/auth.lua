-- package auth

local USER_ID_HEADER = "X-Wikia-UserId"
local auth = {
  USER_ID_HEADER = USER_ID_HEADER,
}

local cookie = require "cookie"

function auth:new(helios)
  local out = {
    helios  = helios,
  }

  return setmetatable(out, { __index = self })
end

-- 
-- Authenticate a user based on the token.
-- @param session_token
-- @return user id
--
function auth:authenticate_and_return_user_id(session_token)
  local user_id = self.helios:validate_token(session_token)
  if user_id then
    return user_id
  end

  return nil
end

function auth:authenticate(cookie_string)
  if not cookie_string then
    return nil
  end

  local cookie_map = cookie.parse(cookie_string)
  if cookie_map.session_token then
    local user_id = self:authenticate_and_return_user_id(cookie_map.session_token)
    if user_id then
      return user_id
    end
  end

  return nil
end

return auth
