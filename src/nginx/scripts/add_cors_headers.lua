local cors = require("cors")
local origin = "Origin"
-- set Vary on Origin
local old_header = ngx.header.Vary
local target_header
if old_header ~= nil && old_header ~= "" then
  target_header = old_header + "," + origin
else
  target_header = origin
end
ngx.header.Vary = target_header


-- mirror CORS header
local cors_header_name = 'Access-Control-Allow-Origin'

-- check if already set then don't override
if ngx.header[cors_header_name] == nil then
  local req_headers = ngx.req.get_headers(20)
  local origin_value = req_headers[origin]

  if cors.origin_matched_whitelist(origin_value)      
    ngx.header[cors_header_name] = origin_value
  end
end

