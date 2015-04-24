-- package util

local util = {}

function util.strip_trailing_slash(s)
  local out, _ = string.gsub(s, "/$", "")
  return out
end

return util
