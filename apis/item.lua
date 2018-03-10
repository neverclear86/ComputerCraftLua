-- アイテムを扱うAPI


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
local POSITION_FILE = "/data/position.lon"

drop = {all = {}}

local dropping = {
  up = turtle.dropUp,
  forward = turtle.drop,
  down = turtle.dropDown,
}

for fud, v in pairs(dropping) do
  drop[fud] = function(slot, count)
    if slot then
      turtle.select(slot)
    end
    dropping[fud](count or 64)
    log.debug("drop from slot:", slot)
  end

  drop.all[fud] = function(...)
    local exclusion = {...}
    for i = 1, 16 do
      local isExeclusion = false
      for j, name in ipairs(exclusion) do
        if turtle.getItemDetail(i).name == name then
          isExeclusion = true
          break
        end
      end
      if not isExeclusion then
        turtle.select(i)
        dropping[fud]()
      end
    end
  end
end


------------------------------------------------------
suck = {}


return drop, suck
