local cors = {}

local whitelist = {
  "^.*%.wikia%.com$",
  "^wikia%.com$",
  "^.*%.wikia%-dev%.com$",
  "^wikia%-dev%.com$",
}

function cors.origin_matches_whitelist(origin_value) 
  if origin_value == nil then
    return false
  end
  stripped = string.gsub(origin_value, "^https?://", "")
  for i, pattern in ipairs(whitelist) do
    if string.match(stripped, pattern) ~= nil then
      return true
    end
  end
  return false
end

return cors
