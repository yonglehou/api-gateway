local auth = require "auth"
local helios = require "mocks.gateway.helios"

describe("authentication tests", function()
  describe("authenticate_and_return_user_id", function()
    before_each(function()
      access_token = "abcdef"
      expected_user_id = 1234
    end)

    it("tests that we get a userid back", function()
      local helios = helios:new(expected_user_id)

      local auth_client = auth:new(helios)

      local user_id = auth_client:authenticate_and_return_user_id(access_token)
      assert.are.equal(expected_user_id, user_id)
    end)

    it("test that we get null when validate_token fails with an empty map", function()
      local helios = helios:new(nil)
      local auth_client = auth:new(helios)

      local user_id = auth_client:authenticate_and_return_user_id(access_token)
      assert.are.equal(nil, user_id)
    end)

    it("test that we get null when validate_token fails", function()
      local helios = helios:new(nil)

      local auth_client = auth:new(helios)

      local user_id = auth_client:authenticate_and_return_user_id(access_token)
      assert.are.equal(nil, user_id)
    end)
  end)

	describe("authenticate", function()

		it("returns nil when given a nil cookie", function()
			local auth_client = auth:new({})
			assert.are.equal(nil, auth_client:authenticate(nil))
		end)

		it("returns nil when given an empty cookie", function()
			local auth_client = auth:new({})
			assert.are.equal(nil, auth_client:authenticate(""))

		end)

		it("returns nil when given a cookie missing access_token", function()
			local auth_client = auth:new({})
			assert.are.equal(nil, auth_client:authenticate("foo=bar"))
		end)

		it("returns the user id when given a cookie with a valid access token", function()
      local helios = helios:new(expected_user_id)

      local auth_client = auth:new(helios)

      local user_id = auth_client:authenticate("access_token=abcdefg")
      assert.are.equal(expected_user_id, user_id)
		end)

	end)
end)
