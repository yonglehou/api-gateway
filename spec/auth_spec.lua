local auth = require "auth"
local helios = require "mocks.gateway.helios"

describe("authentication tests", function()
  describe("successful authentication", function()
    before_each(function()
      session_token = "abcdef"
      expected_user_id = 1234
    end)

    it("tests that we get a userid back", function()
      local helios = helios:new(expected_user_id)
      spy.on(helios, "validate_token")

      local auth_client = auth:new(helios)

      local user_id = auth_client:authenticate_and_return_user_id(session_token)
      assert.are.equal(expected_user_id, user_id)
      assert.spy(helios.validate_token).was.called()
    end)

    it("test that we get null when validate_token fails with an empty map", function()
      local helios = helios:new(nil)
      spy.on(helios, "validate_token")

      local auth_client = auth:new(helios)

      local user_id = auth_client:authenticate_and_return_user_id(session_token)
      assert.are.equal(nil, user_id)
      assert.spy(helios.validate_token).was.called()
    end)

    it("test that we get null when validate_token fails", function()
      local helios = helios:new(nil)
      spy.on(helios, "validate_token")

      local auth_client = auth:new(helios)

      local user_id = auth_client:authenticate_and_return_user_id(session_token)
      assert.are.equal(nil, user_id)
      assert.spy(helios.validate_token).was.called()
    end)
  end)
end)
