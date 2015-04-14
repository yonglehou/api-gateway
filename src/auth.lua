-- package auth
local auth = {}

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
	local res = self.helios:validate_token(session_token)
	if res and res.user_id then
		return res.user_id
	end

	return nil
end


return auth
