if require == nil then
  function require(filename)
    local h = fs.open(filename, "r")
    local str = h.readAll()
    h.close()
    return assert(loadstring(str))()
  end
end

if not log then
  log = require("/neverclear/apis/log")
  log.file = "/logs/mine3.log"
  log.level = "info"
end

local move = require("/neverclear/apis/move")
local dig, place = require("/neverclear/apis/block")
local inventory = require("/neverclear/apis/inventory")
local getopt = require("/neverclear/util/getopt")


local torch = "minecraft:torch"


local function digup()
  dig.up(true)
end

local function digforward()
  dig.forward(true)
end

local function digdown()
  dig.down(true)
end



local function dig3(args, opt)
  local shouldUseTorch = opt.t or opt.torch
  local n = tonumber(args[1])
  for i = 1, n do
    parallel.waitForAll(digup, digforward, digdown)
    log.info("dig3", i)

    if shouldUseTorch and inventory.searchItem(torch) and i % 6 == 0 then
      place.down(inventory.searchItem(torch))
    end

    move.forward()

    i = i + 1
  end
  parallel.waitForAll(digup, digdown)
end


dig3(getopt({...}, {
  t = "boolean", torch = "boolean",

}))
