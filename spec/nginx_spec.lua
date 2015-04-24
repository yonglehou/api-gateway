local globals = require "test.helpers.globals"
local auth = require "auth"

describe("service proxy tests", function()

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

  it("will set the user id header when supplied", function()
    local nginx = require "nginx"
    local user_id = 1234;
    local ret = nginx.service_proxy(ngx, "/user-preference", user_id)

    assert.stub(ngx.exec).was.called_with(
      string.format("%s/%s", nginx.SERVICE_PROXY_PATH, "/user-preference"))

    assert.stub(ngx.req.set_header).was_called_with(auth.USER_ID_HEADER, user_id)
  end)

  it("will clear the user id header when the user id is not supplied", function()
    local nginx = require "nginx"
    local user_id = nil;
    local ret = nginx.service_proxy(ngx, "/user-preference", user_id)

    assert.stub(ngx.exec).was.called_with(
      string.format("%s/%s", nginx.SERVICE_PROXY_PATH, "/user-preference"))

    assert.stub(ngx.req.set_header).was_called_with(auth.USER_ID_HEADER, "")
  end)

end)
