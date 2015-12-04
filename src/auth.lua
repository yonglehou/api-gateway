-- package auth

local USER_ID_HEADER = "X-Wikia-UserId"
local ACCESS_TOKEN_HEADER = "X-Wikia-AccessToken"

local auth = {
  USER_ID_HEADER = USER_ID_HEADER,
  ACCESS_TOKEN_HEADER = ACCESS_TOKEN_HEADER,
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
-- @param access_token
-- @return user id
--
function auth:authenticate_and_return_user_id(access_token)
  local user_id = self.helios:validate_token(access_token)
  if user_id then
    return user_id
  end

  return nil
end

function auth:access_token_to_user_id(cookie_string)
  local cookie_map = cookie.parse(cookie_string)
  if cookie_map.access_token then
    return self:authenticate_and_return_user_id(cookie_map.access_token)
  end

  return nil
end

function auth:authenticate_by_cookie(cookie_thing)
  if not cookie_thing then
    return nil
  end

  -- if there are multiple 'Cookie' headers then ngx.req.headers()['Cookie']
  -- will be a table (array)
  -- see https://github.com/openresty/lua-nginx-module#ngxreqget_headers
  if is_table(cookie_thing) then
    for _, cookie_string in ipairs(cookie_thing) do
      local user_id = self:access_token_to_user_id(cookie_string)
      if user_id then
        return user_id
      end
    end
  else
    return self:access_token_to_user_id(cookie_thing)
  end
end

function is_table(thing)
  return type(thing) == "table"
end

return auth
