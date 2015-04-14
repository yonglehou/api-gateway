-- Mock
-- package net
local net = {}

function net:new(get_response)
	local out = { 
		get_response = get_response,
	}

	return setmetatable(out, { __index = self })
end

function net:get(uri)
	return self.get_response
end

return net
