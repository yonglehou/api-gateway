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
	local status, res = pcall(function() return self.net:get(url) end)
	if status and res.body then
		local status, data = pcall(function() return cjson.new().decode(res.body) end)
		if status and data and data.user_id then
			return data.user_id
		else
			return nil
		end
	end
end

function helios:request_url(session_token)
	return string.format("%s/info?code=%s", self.helios_url, session_token)
end

return helios
