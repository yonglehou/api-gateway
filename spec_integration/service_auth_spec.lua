local client = require('httpclient').new()
local cjson = require "cjson"
local auth = require "auth"

local USERNAME = os.getenv("USERNAME")
local PASSWORD = os.getenv("PASSWORD")
local LOGIN_URL = os.getenv("LOGIN_URL") or "https://services.wikia.com/helios/token"
local SERVICE_URL = os.getenv("SERVICE_URL")


client:set_default("ssl_opts", { ["verify"] = "none" })

function login(url, username, password)
  res = client:post(url, string.format("username=%s&password=%s", username, password),
  { ["headers"] = { ["Content-Type"] = "application/x-www-form-urlencoded" } })
  status, data = pcall(function() return cjson.new().decode(res.body) end)
  if status and data and data.user_id then
    return data
  end

  return nil
end

describe("try login", function()
  it("login is successful", function()
    local response = login(LOGIN_URL, USERNAME, PASSWORD)
    assert.truthy(response)
    assert.truthy(tonumber(response.user_id) > 0)
    assert.truthy(response.access_token)
  end)
end)
  
describe("authenticated request", function()
  before_each(function()
    user = login(LOGIN_URL, USERNAME, PASSWORD)
  end)

  it("service request is successful", function()
    local response = client:get(SERVICE_URL, { ["headers"] = { [auth.ACCESS_TOKEN_HEADER] = user.access_token } })
    assert.truthy(response)
    assert.are.equal(200, response.code)
  end)
end)
