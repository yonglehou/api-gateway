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

  describe("health check", function()
    before_each(function()
      net = net:new({body = "Service status: OK", code = 200})
      spy.on(net, "get")
      helios = helios:new(net, "http://helios")
    end)

    it("returns true when helios is up", function()
      local status, err = helios:healthcheck();
      assert.are.equal(true, status)
      assert.are.equal(nil, err)
    end)

    it ("returns false when helios fails", function()
      net:set_get_response({code = 500, err = "gateway time out"})
      local status, err = helios:healthcheck();
      assert.are.equal(false, status)
      assert.are.equal("gateway time out", err)
    end)
  end)
end)

