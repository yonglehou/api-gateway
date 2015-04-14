local net = require "mocks.net"
local helios = require "gateway.helios"

describe("validate_token tests", function()
	
	describe("valid response", function()

		before_each(function()
			expected_user_id = 12345
			token = "abcde"
		end)

		it("tests that we get a userid back", function()
			local net = net:new({body = string.format("{\"user_id\":%d}", expected_user_id)})
			spy.on(net, "get")

			local helios = helios:new(net, "http://helios")
			local user_id = helios:validate_token(token)
			assert.are.equal(expected_user_id, user_id)
			assert.spy(net.get).was.called()
		end)

		it("tests that we survive bad data back", function()
			local net = net:new({body = ""})
			spy.on(net, "get")

			local helios = helios:new(net, "http://helios")
			local user_id = helios:validate_token(token)
			assert.are.equal(nil, user_id)
			assert.spy(net.get).was.called()
		end)
		
	end)

end)

