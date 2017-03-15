--[[
--  API Name    : stats
--  Author      : neverclear86
--  Version     : 1.0
--
--  Turtle and Computer's Stats Class
--
--  Logs
--    1.0(2016.06.25): Create [Coord Class], [Direction Class]
--
--]]

-- Turtle Statas
Coordinate = {}
Coordinate.new = function(_x, _y, _z)
  local obj = {}
  if (tonumber(_x) ~= nil and tonumber(_y) ~= nil and tonumber(_z) ~= nil) then
    obj.x = _x
    obj.y = _y
    obj.z = _z
  else
    obj.x = 0
    obj.y = 0
    obj.z = 0
  end

  obj.getXYZ = function()
    return obj.x, obj.y, obj.z
  end

  obj.updateX = function(dx)
    obj.x = obj.x + dx
  end
  obj.updateY = function(dy)
    obj.y = obj.y + dy
  end
  obj.updateZ = function(dz)
    obj.z = obj.z + dz
  end

  obj.getDistance = function()
    return math.abs(obj.x) + math.abs(obj.y) + math.abs(obj.z)
  end

  return obj
end
--##############################################################################--

Direction = {}
Direction.new = function(_dir)
  local obj = {}
  if (tonumber(_dir) ~= nil) then
    obj.dir = dir
  else
    obj.dir = 0
  end

  obj.updateDir = function(lr)
    obj.dir = (obj.dir + lr + 4) % 4
  end

  return obj
end


-- EOF
