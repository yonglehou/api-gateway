local cors = {}

local whitelist = {
  ".*\\.wikia.com$",
  "wikia.com$",
  ".*\\.wikia-dev.com",
  "wikia-dev.com$",
}

function cors.origin_matches_whitelist(origin_value) 
  if origin_value == nil then
    return false
  end
  for i, pattern in ipairs(whitelist) do
    if string.match(origin_value, pattern) ~= nil then
      return true
    end
  end
  return false
end

return cors
