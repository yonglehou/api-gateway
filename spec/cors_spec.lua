local cors = require "cors"
describe("Validate whitelist checking method", function()
  it("domain whitelist detect proper origin domains", function()
    assert.are.same(true, cors.origin_matches_whitelist("http://wikia.com"))
    assert.are.same(true, cors.origin_matches_whitelist("http://stargate.test.wikia.com"))
    assert.are.same(true, cors.origin_matches_whitelist("https://stargate.test.wikia.com"))
    assert.are.same(true, cors.origin_matches_whitelist("https://stargate.test.wikia-dev.com"))
    assert.are.same(true, cors.origin_matches_whitelist("http://wikia-dev.com"))
  end)
  it("domain whitelist detect improper origin domains", function()
    assert.are.same(false, cors.origin_matches_whitelist("http://wikia-inc.com"))
    assert.are.same(false, cors.origin_matches_whitelist("http://one.wikia-inc.com"))
    assert.are.same(false, cors.origin_matches_whitelist("http://google.com"))
    assert.are.same(false, cors.origin_matches_whitelist("http://fakewebsitewikia.com"))
    assert.are.same(false, cors.origin_matches_whitelist("http://www.wikia.com.fakewebsite"))
    assert.are.same(false, cors.origin_matches_whitelist("http2://wikia.com"))
    assert.are.same(false, cors.origin_matches_whitelist("gopher://wikia.com"))
  end)  
end)

describe("Response CORS header handling", function()
  -- args are passed to supplied method
  function ngx_headers_allow_origin_and_origin(assert_fn, origin, response_headers, ngx_modifying_fn, ...)
    ngx = {
      req = {
        get_headers = function(...)
          local rv = {}
          rv[cors.origin_header] = origin
          return rv
        end,
      },
      header = response_headers,
    }
    ngx_modifying_fn(ngx, unpack({...}))

    assert_fn(origin, ngx.header[cors.allow_origin_header])
  end

  it("Response header allow origin is set correctly when origin matches whitelist", function()    
    ngx_headers_allow_origin_and_origin(assert.are.equal, "http://wikia.com", {}, cors.set_whitelisted_allow_origin_header, true)
    ngx_headers_allow_origin_and_origin(assert.are.equal, "http://wikia.com", {}, cors.set_whitelisted_allow_origin_header, false)

    ngx_headers_allow_origin_and_origin(assert.are.equal, "https://stargate.test.wikia-dev.com", {}, cors.set_whitelisted_allow_origin_header, false)
  end)

  it("Response header allow origin is not set when origin doesn't matche the whitelist", function()    
    ngx_headers_allow_origin_and_origin(assert.are_not.equal, "http://fakewikia.com", {}, cors.set_whitelisted_allow_origin_header, false)
  end)

  describe("When Access-Control-Allow-Origin header alread exists", function()
    local existing_headers = {}
    existing_headers[cors.allow_origin_header] = "https://something.else"

    it("Response header allow origin is not overriden when override is not set", function()
      ngx_headers_allow_origin_and_origin(assert.are_not.equal, "http://wikia.com", existing_headers, cors.set_whitelisted_allow_origin_header, false)
    end)

    it("Response header allow origin is overriden when override is set", function()
      ngx_headers_allow_origin_and_origin(assert.are.equal, "http://wikia.com", existing_headers, cors.set_whitelisted_allow_origin_header, true)
    end)
  end)  
end)

describe("Response Vary header handling", function()
  describe("When Vary header already exists", function()
    it("Correctly appends Origin to old header", function()
      local ngx = {
        header = {
          Vary = "something"
        }
      }
      cors.add_origin_to_vary_header(ngx)
      assert.are.equal("something,Origin", ngx.header[cors.vary_header])
    end)  
  end)

  describe("When there is no Vary Header", function()
    it("Correctly sets Vary header", function()
      local ngx = {
        header = {}
      }
      cors.add_origin_to_vary_header(ngx)
      assert.are.equal("Origin", ngx.header[cors.vary_header])    
    end)
  end)
end)