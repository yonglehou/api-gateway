local helios = require "gateway.helios"

describe("validate_token tests", function()
  
  describe("valid response", function()

    before_each(function()
      expected_user_id = 12345
      token = "abcde"
      ngx_mock = {
        location = {
          capture = nil
        }
      }

    end)

    it("tests that we get a userid back", function()
      ngx_mock.location.capture = function(path, params)
        return { body = string.format("{\"user_id\":%d}", expected_user_id) }
      end

      local s = spy.on(ngx_mock.location, "capture")

      local helios = helios:new(ngx_mock)
      local user_id = helios:validate_token(token)
      assert.are.equal(expected_user_id, user_id)
      assert.spy(s).was.called_with(helios:sub_request_url(token), {copy_all_vars = true})
    end)

    it("tests that we survive bad data back", function()
      ngx_mock.location.capture = function(path, params)
        return ""
      end

      local s = spy.on(ngx_mock.location, "capture")

      local helios = helios:new(ngx_mock, "http://helios")
      local user_id = helios:validate_token(token)
      assert.are.equal(nil, user_id)
      assert.spy(s).was.called_with(helios:sub_request_url(token), {copy_all_vars = true})
    end)
  end)
end)
