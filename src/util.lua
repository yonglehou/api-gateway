-- package util

local util = {}

function util.strip_trailing_slash(s)
  local out, _ = string.gsub(s, "/+$", "")
  return out
end

function util.strip_leading_slash(s)
  local out, _ = string.gsub(s, "^/+", "")
  return out
end

function util.get_rest_after_url_prefix(s)
  return util.process_url_with_prefix(s, "%2")
end

function util.get_url_prefix(s)
  return util.process_url_with_prefix(s, "%1")
end

function util.process_url_with_prefix(s, selector)
  local stripped = util.strip_leading_slash(s)
  local out, _ = string.gsub(stripped, "^([^/]*)(/?.*)", selector)
  return out
end

return util
