--[[
  ProgramName : Mine3x3
  Author      : neverclear
  Update      : 2017.01.07
  Version     : 2.7

  Dig in a straight line for the number you entered.
  Automatically put the torch at 6 block intervals.
  Automatically put item in chest, if inventory is full.

  Options:
  - v : Show details of this program
  - u : Update program
  - s : Do not throw a Cobblestone
  - c : Do not check whether turtle has torches and chests
  - r : No return
  - f : force
--]]
local PROGRAM_NAME = "mine3x3"
local VERSION = 2.7
local AUTHOR = "neverclear"
local PASTEBIN = "8XznhdGD"

function version()
  print(PROGRAM_NAME .. "\nVersion:" .. VERSION .. "\nAuthor : " .. AUTHOR)
end

function updateProgram()
  fs.delete("mine3x3")
  shell.run("pastebin", "get", PASTEBIN, PROGRAM_NAME)
end

local EXIT_SUCCESS = true
local EXIT_FAILURE = false

-- #### Install API and File ####################################################
APIDir = "neverAPIs/"
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

if (fs.exists("RestartMine3x3") == false) then
  shell.run("pastebin", "get", "8Gb4dGUV", "RestartMine3x3")
end
-- local fh = fs.open("startup", "w")
-- fh.writeLine("shell.run(\"RestartMine3x3\")")
-- fh.close()


-- #### Config ######################################################
local pos = movements.getCoordinate()
local dir = movements.getDirection()

movements.setStats(movements.loadLocationLog())

dig = {
  forward = turtle.dig ,
  up      = turtle.digUp ,
  down    = turtle.digDown ,
}

detect = {
  forward = turtle.detect ,
  up      = turtle.detectUp ,
  down    = turtle.detectDown ,
}

forward = "forward"
up      = "up"
down    = "down"

Torch       = "minecraft:torch"
TorchHolder = "MoreInventoryMod:torchholder"
Chest       = "minecraft:chest"
Cobblestone = "minecraft:cobblestone"
Dirt        = "minecraft:dirt"
Coal        = "minecraft:coal"

-- #### Function ####################################################

-- Turtle Fuel
Fuel = {}
Fuel.new = function(initialFuel)
  local obj = {}
  obj.fuel = initialFuel

  obj.hasEnoughFuel = function(needFuel)
    local ret
    if (needFuel <= obj.fuel) then
      ret = true
    else
      ret = false
    end
    return ret
  end

  -- obj.addFuel = function(n)
  --   obj.fuel = obj.fuel + n
  -- end
  --
  -- obj.useFuel = function(n)
  --   obj.fuel = obj.fuel - n
  -- end

  obj.updateFuel = function()
    obj.fuel = turtle.getFuelLevel()
    return obj.fuel
  end

  obj.refuel = function(minimumFuel)
    local ret = searchItem(Coal)
    while (obj.updateFuel() < minimumFuel and ret ~= false) do
      turtle.select(ret)
      turtle.refuel()
      ret = searchItem(Coal)
    end
    if (ret ~= false) then
      ret = true
    end
    return ret
  end

  return obj
end
fuel = Fuel.new(turtle.getFuelLevel())

--------------------------------------------------------

function digUntilNoBlock(fud)
  while (detect[fud]() == true) do
    dig[fud]()
    if (fud == up) then
      sleep(0.5)
    end
  end
  return true
end

function digMove(fud)
  digUntilNoBlock(fud)
  local ret = movements.move[fud]()
  return ret
end

function decideLR(num)
  local ret = num % 2
  if (ret == 0) then
    ret = 2
  end
  return ret
end

function placeFloor(itemName)
  local ret = false
  if (turtle.detectDown() == false) then
    ret = inventory.placeItem(itemName, down)
  end
  return ret
end

function placeCeiling(itemName)
  local ret = false
  if (turtle.detectUp() == false) then
    ret = inventory.placeItem(itemName, up)
  end
  return ret
end

function checkFuel()
  local needFuel = pos.getDistance() + 128
  if (fuel.hasEnoughFuel(needFuel) == false) then
    fuel.refuel(needFuel)
  end
  local ret = true
  if ( fuel.hasEnoughFuel(needFuel) == false) then
    ret = false
  end
  return ret
end

function createStartup()
  local fh = fs.open("startup", "w")
  fh.writeLine("shell.run(\"RestartMine3x3\")")
  fh.close()
end



-- #### Main ########################################################

args = {...}
local length = nil
local holdStone = false
--local holdCoal = false
local noCheck = false
local notReturn = false
local force = false
local i = 1
while (i <= #args) do
  if (tonumber(args[i]) == nil) then
    if (string.sub(args[i], 1, 1) == "-") then
      for j = 2, string.len(args[i]) do
        if (string.sub(args[i], j, j) == "s") then
          holdStone = true
        elseif (string.sub(args[i], j, j) == "c") then
          noCheck = true
        elseif (string.sub(args[i], j, j) == "r") then
          notReturn = true
        elseif (string.sub(args[i], j, j) == "f") then
          force = true
        elseif (string.sub(args[i], j, j) == "v") then
          version()
          do return EXIT_SUCCESS end
        elseif (string.sub(args[i], j, j) == "u") then
          updateProgram()
          print("Completed Update!")
          shell.run(PROGRAM_NAME, "-v")
          do return EXIT_SUCCESS end
        else
          print("Error: No such option : -" .. string.sub(args[i], j, j))
          do return EXIT_FAILURE end
        end
      end
    else
      print("Error: option: [number, -s, -f, -r, -v, -u]")
      do return EXIT_FAILURE end
    end
  else
    if (tonumber(args[i]) > 0) then
      length = tonumber(args[i])
    else
      print("Error: Length is over 1.")
      do return EXIT_FAILURE end
    end
  end
  i = i + 1
end

term.clear()
term.setCursorPos(1, 1)

if (length == nil) then
  movements.deleteLocationLog()
  repeat
    print("Enter a length. (Recommended <=100)")
    length = tonumber(read())
  until (length ~= nil and length > 0)
end

local torchType = nil
if (inventory.searchItem(Torch) == false and inventory.searchItem(TorchHolder) == false and noCheck == false) then
  print("I don't have torch...")
  print("Please enough torches or don't use torch ?")
  read()
end
-- if (inventory.searchItem(Torch) == false and inventory.searchItem(TorchHolder) == false) then
--   torchTyep = nil
-- elseif (inventory.searchItem(Torch) == true) then
--   torchType = Torch
-- else
--   torchType = TorchHolder
-- end
if (inventory.searchItem(TorchHolder) ~= false) then
  torchType = TorchHolder
elseif (inventory.searchItem(Torch) ~= false) then
  torchType = Torch
else
  torchType = nil
end

if (inventory.searchItem(Chest) == false and noCheck == false) then
  print("I don't have chest...")
  print("Please chest or don't use chest ?")
  read()
end
local isHasChest = true
if (inventory.searchItem(Chest) == false) then
  isHasChest = false
end


if (checkFuel() == false) then
  -- Error: Not enough fuel
  print("Error: Not Enough Fuel!!")
  print("Please put coal in me. And try agein.")
  do return false end
end

createStartup()

-- Start Move

if (force == false) then
  while (turtle.detect() == false) do
    movements.forward()
  end
end

local odd = 0
if (pos.z % 2 ~= 0) then
  movements.goTo(2, "~", "~")
  movements.face(0)
  odd = 1
end

fuel.updateFuel()

local mined = 0
while (mined < length) do
  if (checkFuel() == false) then
    -- Error: Not enough fuel
    print("Error: Not Enough Fuel!!")
    break
  else

    log.writeNewFile("/logs/mine_log.log", (length - mined))

    mined = mined + 1

    digMove(forward)
    placeFloor(Cobblestone)
    digMove(up)
    if (pos.z % 6 == 0) then
      inventory.placeItem(torchType, down)
    end
    digMove(up)
    placeCeiling(Cobblestone)
    if (inventory.isFullInventory() == true) then
      if (holdStone == false) then
        local slot = inventory.searchItem(Cobblestone)
        while (slot ~= false) do
          turtle.select(slot)
          turtle.drop()
          slot = inventory.searchItem(Cobblestone)
        end
      end
    end
    if (inventory.isFullInventory() == true) then
      if (inventory.placeItem(Chest, down) == false) then
        print("Inventory is Full!!")
        break
      else
        for i = 1, 16 do
          local item = turtle.getItemDetail(i)
          if (item.name ~= Chest and item.name ~= torchType) then
            turtle.select(i)
            turtle.dropDown()
          end
        end
      end
    end

    movements.turn[decideLR(mined + 1 + odd)]()
    digMove(forward)
    placeCeiling(Cobblestone)
    digUntilNoBlock(forward)
    digMove(down)
    dig.forward()
    digMove(down)
    dig.forward()
    placeFloor(Cobblestone)
    movements.forward()
    placeFloor(Cobblestone)
    movements.turn[decideLR(mined + odd)]()
  end
  fuel.updateFuel()
end

-- Retrun to start point.
if (notReturn == false) then
  movements.goToBase("yxz")
  if (mined == length) then
    print("This program has been successfully completed.")
    print("^^")
    fs.delete("startup")
    movements.deleteLocationLog()
  end
else
  movements.goTo(0, 0, "~", "zyx")
  movements.face(0)
  fs.delete("startup")
  movements.deleteLocationLog()
end
do return EXIT_SUCCESS end

-- EOF
