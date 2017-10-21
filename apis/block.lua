-- ブロックを扱うAPI


if require == nil then
  function require(filename)
    local h = fs.open(filename, "r")
    local str = h.readAll()
    h.close()
    return assert(loadstring(str))()
  end
end

local logger
if log then
  logger = log
else
  logger = require("log.lua")
  logger.file = "/logs/autolog.log"
  logger.level = "trace"
end
--------------------------------------------------------------------------------

-- place = {}
--
-- function placeItem(fud, itemName, itemDamage)
--   local slot = searchItem(itemName, itemDamage)
--   local ret = false
--   if (slot ~= false) then
--     turtle.select(slot)
--     place[fud]()
--     ret = true
--   end
--   return ret
-- end
---------------------------------------------------------------
ALL = true
dig = {}

local digging = {
  up = turtle.digUp,
  forward = turtle.dig,
  down = turtle.digDown,
}

local function _dig(direction, delay, n)
  local sleep = function()
    if delay ~= 0 then
      sleep(delay)
    end
  end

  if n == ALL then
    while digging[direction]() do
      logger.debug("Dig " .. direction)
      sleep()
    end
  else
    n = n or 1
    for i = 1, n do
      digging[direction]()
      logger.debug("Dig " .. direction .. " " .. tostring(i) .. "/" .. tostring(n))
      sleep(delay)
    end
  end
end


function dig.up(n)
  _dig("up", 0.2, n)
end

function dig.forward(n)
  _dig("forward", 0, n)
end

function dig.down(n)
  _dig("down", 0, n)
end

return dig, place
