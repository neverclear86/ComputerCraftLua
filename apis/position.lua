if require == nil then
  function require(filename)
    local h = fs.open(filename, "r")
    local str = h.readAll()
    h.close()
    return assert(loadstring(str))()
  end
end
local lon = require("/apis/lon.lua")

local Position = {}

function Position.new(x, y, z, face)
  local this = {
    x = x or 0,
    y = y or 0,
    z = z or 0,
    face = face or 0,
  }
  setmetatable(this, {__index = Position})
  return this
end

function Position:save(filename)
  lon.save(filename, self)
end

function Position.load(filename)
  return Position.new(unpack(data))
end

return Position
