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

return util
