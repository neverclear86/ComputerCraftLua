--[[
--  API Name    : move
--  Author      : neverclear
--  Version     : 1.0.0
--
--  Turtle Movement
--
-- Logs
--  1.0.0 (2017.10.22): 使えるようになった
--]]
if require == nil then
  function require(filename)
    local h = fs.open(filename, "r")
    local str = h.readAll()
    h.close()
    return assert(loadstring(str))()
  end
end

local Position = require("/neverclear/apis/position")
local dig = require("/neverclear/apis/block")
local logger
if log then
  logger = log
else
  logger = require("neverclear/apis/log")
  logger.file = "/logs/autolog.log"
  logger.level = "trace"
end
--------------------------------------------------------------------------------
local POSITION_FILE = "/data/position.lon"
local position = Position.load(POSITION_FILE)
--------------------------------------------------------------------------------
move = {}

local moving = {
  up = turtle.up,
  forward = turtle.forward,
  down = turtle.down,
}
local detect = {
  up = turtle.detectUp,
  forward = turtle.detect,
  down = turtle.detectDown,
}

local function _move(fud, n, direction, d, force)
  if type(n) == "boolean" then
    force = n
    n = nil
  end

  n = n or 1
  local i = 1
  while i <= n do
    local destination = direction .. "/" .. tostring(d)
    if moving[fud]() then
      position[direction] = position[direction] + d
      position:save(POSITION_FILE)
      logger.debug("Move to " .. destination)
      i = i + 1
    else
      if turtle.getFuelLevel() == 0 then
        logger.fatal("No Fuel!")
        error()
      end

      if detect[fud]() then
        if force then
          dig[fud]()
          logger.debug("Digging a block at " .. destination .. " to move")
        else
          logger.error("I can't move because there is a block at " .. destination)
        end
      else
        logger.error("Opps. I can't move to " .. destination)
      end
    end
  end
end

function move.forward(n, force)
  local direction = position.face % 2 == 0 and "z" or "x"
  local d = position.face <= 1 and 1 or -1
  _move("forward", n, direction, d, force)
end

-- function move.back(n)
--   local direction = position.face % 2 == 0 and "z" or "x"
--   local d = position.face >= 2 and 1 or -1
--   _move(turtle.back, n, direction, d)
-- end

function move.up(n, force)
  _move("up", n, "y", 1, force)
end

function move.down(n, force)
  _move("down", n, "y", -1, force)
end

move.move = {
  [0] = move.forward,
  -- [1] = move.back,
  [1] = move.up,
  [2] = move.down,
}
-- setmetatable(move.move, {
--   __call = function(t, moving, n, direction, d)
--     _move(moving, n, direction, d)
--   end
-- })


local function _turn(func, n, d)
  n = n or 1
  for i = 1, n do
    func()
    position.face = (position.face + d) % 4
    position:save(POSITION_FILE)
    logger.debug("Turn " .. (d and "right" or "left"))
  end
end

function move.right(n)
  _turn(turtle.turnRight, n, 1)
end

function move.left(n)
  _turn(turtle.turnLeft, n, -1)
end

function move.uturn()
  _turn(turtle.turnRight, 2, 1)
end

move.turn = {
  [0] = move.left,
  [1] = move.right,
}

function move.turnto()

end

-- setmetatable(move.turn, {
--   __call = function(t, moving, n, d)
--     _turn(moving, n, d)
--   end
-- })


function go(x, y, z, order, force)
  local goal = {x = tostring(x), y = tostring(y), z = tostring(z)}
  for k, v in goal do
    if v:sub(1, 1) == "~" then
      if v:len == 1 then
        goal[k] = 0
      else
        goal[k] = tonumber(v:sub(2))
      end
    else
      goal[k] = tonumber(v) - postion[k]
    end
  end

  order = order or "xyz"

  order:gsub(".", function(c)

  end)
end

function goBase(order, force)

end


move.position = position


return move
