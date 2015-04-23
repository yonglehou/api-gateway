-- package net
-- An networking wrapper around resty.http
local http = require "resty.http"

local net = {}

function net:new(timeout)
  local out = {
    timeout = timeout,
  }

  return setmetatable(out, { __index = self })
end

function net:request(url, request_method, request_headers, body)
  if not request_headers then
    request_headers = ngx.req.get_headers(20)
  end

  local httpc = http.new()
  httpc:set_timeout(self.timeout)
  local res, err = httpc:request_uri(url,
  {
    method = request_method,
    headers = request_headers,
    body = body
  })

  return res, err
end

function net:get(url, headers)
  return self:request(url, "GET", headers)
end

return net
