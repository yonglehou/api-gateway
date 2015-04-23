-- package util

local util = {}

function util.strip_trailing_slash(string)
  return string:gsub("/$", "")
end

return util
