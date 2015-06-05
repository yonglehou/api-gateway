local cors = {
  whitelist = {
    "^.*%.wikia%.com$",
    "^wikia%.com$",
    "^.*%.wikia%-dev%.com$",
    "^wikia%-dev%.com$",
  },
  allow_origin_header = 'Access-Control-Allow-Origin',
  origin_header = "Origin",
}

function cors.origin_matches_whitelist(origin_value)
  if origin_value == nil then
    return false
  end
  stripped = string.gsub(origin_value, "^https?://", "")
  for i, pattern in ipairs(cors.whitelist) do
    if string.match(stripped, pattern) ~= nil then
      return true
    end
  end
  return false
end


function cors.set_whitelisted_allow_origin_header(ngx, override_existing)  
  -- check if already set then don't override
  if ngx.header[cors.allow_origin_header] == nil or override_existing then
    local req_headers = ngx.req.get_headers(20)
    local origin = req_headers[cors.origin_header]

    if cors.origin_matches_whitelist(origin) then
      ngx.header[cors.allow_origin_header] = origin
    end
  end  
end

return cors
