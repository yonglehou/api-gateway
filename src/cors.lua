local cors = {
  whitelist = {
    "^.*%.wikia%.com$",
    "^wikia%.com$",
    "^.*%.wikia%-dev%.com$",
    "^wikia%-dev%.com$",
  },

  origin_header = "Origin",
  vary_header = "Vary",
  allow_origin_header = 'Access-Control-Allow-Origin',
  allow_headers_header = "Access-Control-Allow-Headers",
  allow_methods_header = "Access-Control-Allow-Methods",
  allow_credentials_header = "Access-Control-Allow-Credentials",

  allow_headers_default_value = "Content-Type, Accept",
  allow_methods_default_value = "POST,GET,OPTIONS,PUT,DELETE",
  allow_credentials_default_value = "true",

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

function cors.get_origin_that_matches_whitelist(ngx)
  local req_headers = ngx.req.get_headers(100)
  local origin = req_headers[cors.origin_header]

  if cors.origin_matches_whitelist(origin) then
    return origin
  else
    return nil
  end
end

function cors.set_whitelisted_allow_origin_header(ngx, override_existing)
  -- check if already set then don't override
  if ngx.header[cors.allow_origin_header] == nil or override_existing then
    local req_headers = ngx.req.get_headers(100)
    local origin = req_headers[cors.origin_header]

    if cors.origin_matches_whitelist(origin) then
      ngx.header[cors.allow_origin_header] = origin
    end
  end
end

function cors.set_whitelisted_control_headers(ngx)
  local origin = cors.get_origin_that_matches_whitelist(ngx)
  if origin ~= nil then
    ngx.header[cors.allow_origin_header] = origin
    ngx.header[cors.allow_headers_header] = cors.allow_headers_default_value
    ngx.header[cors.allow_methods_header] = cors.allow_methods_default_value
    ngx.header[cors.allow_credentials_header] = cors.allow_credentials_default_value
  else
    -- clean headers if origin doesn't match whitelist so that services will not be able to override this setting
    ngx.header[cors.allow_origin_header] = nil
    ngx.header[cors.allow_headers_header] = nil
    ngx.header[cors.allow_methods_header] = nil
    ngx.header[cors.allow_credentials_header] = nil
  end
end

function cors.add_origin_to_vary_header(ngx)
  local header = ngx.header.Vary

  if header == nil then
    header = {}
  elseif type(header) ~= "table" then
    header = { header }
  end

  table.insert(header, cors.origin_header)
  ngx.header.Vary = table.concat(header, ",")
end

return cors
