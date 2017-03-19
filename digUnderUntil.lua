--[[
-- ProgramName  : digUnderUntil
-- Author       : neverclear86
-- Date         : 2017.03.19
-- Version      : 1.0
--
-- 真下堀りを続けて
--]]

APIDir = "/neverAPIs/"
APIs = {
  inventory = "k2T2MdcU",
  -- stats     = "SV1QZzAH",
  -- movements = "tDhuGZML",
  -- log       = "hmv60TYF",
}
for k,v in pairs(APIs) do
  if (fs.exists(APIDir .. k) == false) then
    shell.run("pastebin", "get", v, APIDir .. k)
  end
end
for k in pairs(APIs) do
  os.loadAPI(APIDir .. k)
end

local chest = "minecraft:chest"
local slab = "minecraft:stone_slab"



local args = {...}

if (tonumber(args[1]) ~= nil and tonumber(args[2]) ~= nil) then
  local start = args[1]
  local colmun = tonumber(args[2])

  for i = 1, colmun do
    if (i % 2 == 1) then
      inventory.placeItem(chest, "up")
    end
    shell.run("digUnder", start)

    local ret = {turtle.inspectUp()}
    if (ret[2].name == chest) then
      for j = 1, 16 do
        turtle.select(j)
        ret = turtle.getItemDetail()
        if (ret ~= nil and ret.name ~= chest and ret.name ~= slab) then
          turtle.dropUp()
        end
      end
    end


    turtle.turnRight()
    while(turtle.dig())do
    end
    turtle.forward()
    turtle.turnLeft()
    while(turtle.dig())do
    end

  end

else

  print ("Usage: digUnderUntil (startY) (colmun)")
end
