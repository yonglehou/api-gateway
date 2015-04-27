local globals = {}

function globals.declare(name, value)
  rawset(_G, name, value)
end

return globals
