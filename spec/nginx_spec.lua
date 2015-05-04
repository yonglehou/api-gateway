local globals = require "test.helpers.globals"
local auth = require "auth"
local auth_mock = require "mocks.auth"

describe("nginx module tests", function()

  before_each(function()
    req_mock = {
      set_header = function(h, v) end
    }
    ngx_mock = {
      req = mock(req_mock),
      exec = function(p) end
    }

    ngx = mock(ngx_mock)

    -- ngx is referenced in the lua-resty-http preamble. we could get rid of
    -- this dependency if we use the ngx.location.capture for all sub requests
    globals.declare("ngx",
    {
      socket = { tcp = nil },
      re = { match = nil }
    })
  end)

  describe("service proxy tests", function()
    
    it("will set the user id header when supplied", function()
      local nginx = require "nginx"
      local user_id = 1234;
      local ret = nginx.service_proxy(ngx, user_id)

      assert.stub(ngx.exec).was.called_with("@service")

      assert.stub(ngx.req.set_header).was_called_with(auth.USER_ID_HEADER, user_id)
      assert.stub(ngx.req.set_header).was_called_with("Cookie", "")
    end)

    it("will clear the user id header when the user id is not supplied", function()
      local nginx = require "nginx"
      local user_id = nil;
      local ret = nginx.service_proxy(ngx, user_id)

      assert.stub(ngx.exec).was.called_with("@service")

      assert.stub(ngx.req.set_header).was_called_with(auth.USER_ID_HEADER, "")
      assert.stub(ngx.req.set_header).was_called_with("Cookie", "")
    end)

  end)

  describe("authenticate tests", function()
    it("returns nil when the cookie_string is nil", function()
      local nginx = require "nginx"
      assert.are.equal(nil, nginx.authenticate({}, nil))
      assert.are.equal(nil, nginx.authenticate({}, ""))
    end)

    it("returns nil when authenticate returns nil", function()
      local auth = auth_mock:new(nil)
      local nginx = require "nginx"
      assert.are.equal(nil, nginx.authenticate({ auth = auth }, "foo=abcd"))
    end)

    it("returns the user id provided by authenticate", function()
      local user_id = 12345;
      local auth = auth_mock:new(user_id)
      local nginx = require "nginx"
      assert.are.equal(user_id, nginx.authenticate({ auth = auth }, "foo=abcd"))
    end)
  end)
end)
