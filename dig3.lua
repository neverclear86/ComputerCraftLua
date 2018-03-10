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

move = move or require("/neverclear/apis/move")
local dig, place = require("/neverclear/apis/block")
local drop, suck = require("/neverclear/apis/item")
local inventory = require("/neverclear/apis/inventory")
local getopt = require("/neverclear/util/getopt")
local Table = require("/neverclear/util/Table")


local torch = "minecraft:torch"
local torchHolder = "MoreInventoryMod:torchholder"
local cobbleStone = "minecraft:cobblestone"
local charcoal = "minecraft:charcoal"


local function digup()
  dig.up(true)
end

local function digforward()
  dig.forward(true)
end

local function digdown()
  dig.down(true)
end

local function dropStone()
  local tmp = inventory.getItemCountSum(cobbleStone) >= 64
  while tmp do
    local slot = inventory.searchItem(cobbleStone)
    if slot then
      drop.forward(slot)
    else
      tmp = false
    end
  end
end

local function refuel()
  -- あとで木炭以外もやる
  local slot = inventory.searchItem(charcoal)
  local minFuel = move.position.x + move.position.y + move.position.z + 10
  while slot and turtle.getFuelLevel() < minFuel do
    turtle.select(slot)
    turtle.refuel()
  end
end


local function putItemsAtHome()
  local tmp = {x = move.position.x, y = move.position.y, z = move.position.z, face = move.position.face}
  move.goBase("yxz", true)
  move.face(2)
  drop.all.forward(torch, torchHolder)
  move.go(tmp.x, tmp.y, tmp.z, "yzx", true)
  move.face(tmp.face)
end


local function dig3(args, opt)
  if not opt.noreset then
    move.position:reset()
  end


  local shouldUseTorch = opt.t or opt.torch
  local n = tonumber(args[1])
  for i = 1, n do
    parallel.waitForAll(digup, digforward, digdown, not opt.holdstone and dropStone or nil, refuel)
    log.info("dig3", i)

    local torchSlot = inventory.searchItem(torch) or inventory.searchItem(torchHolder)
    if shouldUseTorch and torchSlot and i % 6 == 0 then
      place.down(torchSlot)
    end

    -- 燃料のNASA✋
    local minFuel = move.position.x + move.position.y + move.position.z + 10
    if turtle.getFuelLevel() < minFuel then
      move.goBase("yxz")
      error("NoFuel!!!!")
    end

    -- アイテム多すぎぃ！
    if inventory.isFullInventory() then
      putItemsAtHome()
    end

    move.forward()

    i = i + 1
  end
  parallel.waitForAll(digup, digdown)
end


dig3(getopt({...}, {
  t = "boolean", torch = "boolean",
  holdstone = "boolean",
  noreset = "boolean",
}))
