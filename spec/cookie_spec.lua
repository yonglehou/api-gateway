local cookie = require "cookie"
describe("basic cookie parsing functionality", function()
	it("tests that we can parse a basic cookie", function()
		local cookie_string = "session_token=1234"
		local parsed_cookie = {session_token = "1234"}
		assert.are.same(parsed_cookie, cookie.parse(cookie_string))
	end)

	it("tests that we can parse a compound cookie", function()
		local cookie_string = "session_token=1234; other_value=abced\""
		local parsed_cookie = {session_token = "1234",other_value = "abced\""}
		assert.are.same(parsed_cookie, cookie.parse(cookie_string))
	end)
end)
					
