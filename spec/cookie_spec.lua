local cookie = require "cookie"
describe("cookie parsing", function()
	it("tests that we can parse a basic cookie", function()
		local cookie_string = "session_token=1234"
		local parsed_cookie = {session_token = "1234"}
		assert.are.same(parsed_cookie, cookie.parse(cookie_string))
	end)

	it("tests a nil value to parse", function()
		local cookie_string = nil
		assert.are.same({}, cookie.parse(cookie_string))
		
	end)

	describe("compound cookie parsing", function()
		before_each(function()
			cookie_string = "session_token=1234; other_value=abced\""
			parsed_cookie = {session_token = "1234",other_value = "abced\""}
		end)

		it("tests that we can parse a compound cookie", function()
			assert.are.same(parsed_cookie, cookie.parse(cookie_string))
		end)

		it("test that we find the cookie we expect", function()
			local cookie_map = cookie.parse(cookie_string)
			assert.are.same(parsed_cookie.session_token, cookie_map.session_token)
		end)
	end)
end)
					
