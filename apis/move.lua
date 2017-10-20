--[[
--  API Name    : move
--  Author      : neverclear86
--  Version     : 1.0
--
--  Turtle Movement
--
-- Logs
--  1.0():
--]]
if require == nil then
  function require(filename)
    local h = fs.open(filename, "r")
    local str = h.readAll()
    h.close()
    return assert(loadstring(str))()
  end
end

local lon = require("position.lua")
local logger = log or require("log.lua")
if log then
  logger = log
else
  logger = require("log.lua")
  logger.file = "/logs/autolog.log"
  logger.level = "trace"
end
--------------------------------------------------------------------------------
local POSITION_FILE = "/data/position.lon"
local position = Position.load(POSITION_FILE)

--------------------------------------------------------------------------------
move = {}

local function _move(moving, n, direction, d, force)
  n = n or 1
  local i = 1
  while i <= n do
    local destination = direction .. "/" .. tostring(d)
    if moving() then
      position[direction] = position[direction] + d
      position:save(POSITION_FILE)
      logger.debug("Move to " .. destination)
    else
      if turtle.getFuelLevel() == 0 then
        logger.fatal("No Fuel!")
        error()
      end

      if force then
        
        logger.debug("Digging a block at " .. destination .. " to move")
      else
        logger.error("I can't move because there is a block at " .. destination)
      end
    end
  end
end

function move.forward(n)
  local direction = position.direction % 2 == 0 and "z" or "x"
  local d = position.direction <= 1 and 1 or -1
  _move(turtle.forward, n, direction, d)
end

function move.back(n)
  local direction = position.direction % 2 == 0 and "z" or "x"
  local d = position.direction >= 2 and 1 or -1
  _move(turtle.back, n, direction, d)
end

function move.up(n)
  _move(turtle.up, n, "y", 1)
end

function move.down(n)
  _move(turtle.down, n, "y", -1)
end

move.move = {
  [0] = move.forward,
  [1] = move.back,
  [2] = move.up,
  [3] = move.down,
}
-- setmetatable(move.move, {
--   __call = function(t, moving, n, direction, d)
--     _move(moving, n, direction, d)
--   end
-- })


local function _turn(moving, n, d)
  n = n or 1
  for i = 1, n do
    moving()
    position.direction = (position.direction + d) % 4
    position:save(POSITION_FILE)
    logger.debug("Turn " .. d and "right" or "left")
  end
end

function move.right(n)
  _turn(turtle.right, n, 1)
end

function move.left(n)
  _turn(turtle.left, n, -1)
end

move.turn = {
  [0] = move.left,
  [1] = move.right,
}
-- setmetatable(move.turn, {
--   __call = function(t, moving, n, d)
--     _turn(moving, n, d)
--   end
-- })

return move
