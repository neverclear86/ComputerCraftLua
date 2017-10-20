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

drop = {}


local function _drop(do)
end

function drop.up()
  _drop(turtle.dropUp)
end

function drop.forward()
end

function drop.down()
end


function dropAll(fud)
  if (fud == nil) then
    fud = "forward"
  end
  for i = 1, 16 do
    turtle.select(i)
    drop[fud]()
  end
  turtle.select(1)
end


------------------------------------------------------
suck = {}
