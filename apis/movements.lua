--[[
--  API Name    : movements
--  Author      : neverclear86
--  Version     : 1.5
--
--  Turtle Movement
--
-- Logs
--  1.0(2016.06.25): Create forward(), back(), up(), down(), right(), left(), face(), goTo(), goToBase()
--]]

-- #### API ########################################################
APIDir = "neverAPIs/"
os.loadAPI(APIDir .. "stats")
os.loadAPI(APIDir .. "log")
if (stats == nil) then
  print("Error:I can't found statsAPI")
  print("Please download statsAPI (SV1QZzAH)")
end
if (log == nil) then
  print("Error:I can't found logAPI")
  print("Please download statsAPI (hmv60TYF)")
end
-- #################################################################

coordinate = stats.Coordinate.new()
direction =  stats.Direction.new()

-- Write Location Log --
LOG_DIRECTORY = "/logs/"
LOCATION_LOG  = LOG_DIRECTORY .. "location.log"

writeLocationLog = function()
  log.writeNewFile(LOCATION_LOG, coordinate.x, coordinate.y, coordinate.z, direction.dir)
end

deleteLocationLog = function()
  fs.delete(LOCATION_LOG)
end

loadLocationLog = function()
  if (fs.exists(LOCATION_LOG) == true) then
    local fh = fs.open(LOCATION_LOG, "r")
    local x = tonumber(fh.readLine())
    local y = tonumber(fh.readLine())
    local z = tonumber(fh.readLine())
    local dir = tonumber(fh.readLine())
    return x, y, z, dir
  end
  return 0, 0, 0, 0
end
-----------------------------

-- Get Set self Stats

getCoordinate = function()
  return coordinate
end

setCoordinate = function(x, y, z)
  coordinate.x = x
  coordinate.y = y
  coordinate.z = z
end

getDirection = function()
  return direction
end

setDirection = function(d)
  direction.dir = d
end

setStats = function(x, y, z, d)
  setCoordinate(x, y, z)
  setDirection(d)
end

isBase = function()
  if (coordinate.x == 0 and coordinate.y == 0 and coordinate.z == 0) then
    return true
  else
    return false
  end
end

----------------------------

forward = function(n)
  local ret = true
  if (n == nil) then
    n = 1
  end
  for i = 1, n do
    if (turtle.forward()) then
      if (direction.dir % 2 == 0) then
        if (direction.dir == 0) then
          coordinate.updateZ(1)
        else
          coordinate.updateZ(-1)
        end
      else
        if (direction.dir == 1) then
          coordinate.updateX(1)
        else
          coordinate.updateX(-1)
        end
      end
      ret = true
    else
      ret = false
    end
    writeLocationLog()
  end
  return ret
end

up = function(n)
  local ret = true
  if (n == nil) then
    n = 1
  end
  for i = 1, n do
    if (turtle.up()) then
      coordinate.updateY(1)
      writeLocationLog()
    else
      ret = false
    end
  end
  return  ret
end

down = function(n)
  local ret = true
  if (n == nil) then
    n = 1
  end
  for i = 1, n do
    if (turtle.down()) then
      coordinate.updateY(-1)
      writeLocationLog()
    else
      ret = false
    end
  end
  return ret
end

left = function(n)
  if (n == nil) then
    n = 1
  end
  for i = 1, n do
    turtle.turnLeft()
    direction.updateDir(-1)
    writeLocationLog()
  end
  return true
end

right = function(n)
  if (n == nil) then
    n = 1
  end
  for i = 1, n do
    turtle.turnRight()
    direction.updateDir(1)
    writeLocationLog()
  end
  return true
end

face = function(dir)
  if ((dir + 1) % 4 == direction.dir) then
    left()
  else
    while (direction.dir ~= dir) do
      right()
    end
  end
  return true
end

goTo = function(x, y, z, orderStr)

  if (string.sub(x, 1, 1) == "~") then
    if (tonumber(string.sub(x, 2)) ~= nil) then
      x = tonumber(string.sub(x, 2)) + coordinate.x
    else
      x = coordinate.x
    end
  end
  if (string.sub(y, 1, 1) == "~") then
    if (tonumber(string.sub(y, 2)) ~= nil) then
      y = tonumber(string.sub(y, 2)) + coordinate.y
    else
      y = coordinate.y
    end
  end
  if (string.sub(z, 1, 1) == "~") then
    if (tonumber(string.sub(z, 2)) ~= nil) then
      z = tonumber(string.sub(z, 2)) + coordinate.z
    else
      z = coordinate.z
    end
  end


  if (orderStr == nil) then
    orderStr = "xyz"
  end

  for i = 1, 3 do
    if (string.lower(string.sub(orderStr, i, i)) == "x" and coordinate.x ~= x) then
      if (coordinate.x > x) then
        face(3)
      else
        face(1)
      end
      while (coordinate.x ~= x) do
        forward()
      end
    elseif (string.lower(string.sub(orderStr, i, i)) == "z" and coordinate.z ~= z) then
      if (coordinate.z > z) then
        face(2)
      else
        face(0)
      end
      while (coordinate.z ~= z) do
        forward()
      end
    elseif (string.lower(string.sub(orderStr, i, i)) == "y" and coordinate.y ~= y) then
      while (coordinate.y ~= y) do
        if (coordinate.y > y) then
          down()
        else
          up()
        end
      end
    else
      --[[ Do Nothing ]]--
    end
  end
end

goToBase = function(orderStr)
  if (orderStr == nil) then
    orderStr = "xyz"
  end
  goTo(0, 0, 0, orderStr)

  face(0)
end


-- Alias ----
move = {}
move[1] = forward
move[2] = up
move[3] = down
move["forward"] = forward
move["up"]      = up
move["down"]    = down

turn = {}
turn[1] = left
turn[2] = right
turn["left"] = left
turn["right"] = right


-- EOF
