if require == nil then
  function require(filename)
    local h = fs.open(filename, "r")
    local str = h.readAll()
    h.close()
    return assert(loadstring(str))()
  end
end
local lon = require("/neverclear/apis/lon")

local Position = {}

function Position.new(x, y, z, face)
  local this = {
    x = tonumber(x) or 0,
    y = tonumber(y) or 0,
    z = tonumber(z) or 0,
    face = face or 0,
  }
  setmetatable(this, {__index = Position})
  return this
end

function Position:reset()
  for k, v in pairs(self) do
    self[k] = 0
  end
end

function Position:save(filename)
  lon.save(filename, self)
end

function Position.load(filename)
  local data = lon.load(filename) or {}
  return Position.new(data.x, data.y, data.z, data.face)
end

return Position
