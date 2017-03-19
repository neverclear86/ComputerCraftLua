--[[
-- ProgramName  : digUnder
-- Author       : neverclear86
-- Date         : 2017.03.15
-- Version      : 1.0
--
-- 真下堀り
--]]

-- APIs =========================================================
APIDir = "/neverAPIs/"
APIs = {
  inventory = "k2T2MdcU",
  stats     = "SV1QZzAH",
  movements = "tDhuGZML",
  log       = "hmv60TYF",
}
for k,v in pairs(APIs) do
  if (fs.exists(APIDir .. k) == false) then
    shell.run("pastebin", "get", v, APIDir .. k)
  end
end
for k in pairs(APIs) do
  os.loadAPI(APIDir .. k)
end


-- Config ====================================================
local slab = "minecraft:stone_slab"



--Main ========================================================
local args = {...}
local start
-- local lower

-- if (tonumber(args[1]) ~= nil and tonumber(args[2]) ~= nil) then
if (tonumber(args[1]) ~= nil) then
  start = tonumber(args[1])
  -- lower = tonumber(args[2])
else
  print("Usage: digUnder (CurrentY)")
end

-- if (current <= lower) then
--   print("Usage: digUnder (CurrentY) (LowerY)")
-- end

local current = start
turtle.digDown()
while (turtle.down()) do
  turtle.dig()
  turtle.digDown()

  current = current - 1
end

turtle.turnRight()
turtle.turnRight()

while (current < 5) do
  turtle.dig()
  turtle.up()
  current = current + 1
end

while (turtle.dig()) do
end

inventory.placeItem(slab, "forward")
turtle.turnRight()
turtle.turnRight()
inventory.placeItem(slab, "forward")
turtle.turnRight()
turtle.turnRight()
inventory.placeItem(slab, "down")
turtle.up()
current = current + 1
inventory.placeItem(slab, "down")
if (not turtle.inspectDown()) then
  inventory.placeItem(slab, "down")
end

while (current < start - 1) do
  turtle.dig()
  turtle.up()
  current = current + 1
end
turtle.dig()

inventory.placeItem(slab, "forward")
turtle.turnRight()
turtle.turnRight()
inventory.placeItem(slab, "forward")
-- turtle.turnRight()
-- turtle.turnRight()
inventory.placeItem(slab, "down")
turtle.up()
current = current + 1
inventory.placeItem(slab, "down")
