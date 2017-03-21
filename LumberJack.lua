--[[
-- ProgramName  : LumberJack
-- Author       : neverclear
-- Date         : 2017.03.19
-- Version      : 0.2.2
-- Cut Wood!!!
-- Birch only
-- 敷き詰め型なら大きさ自由
-- 途中で止まっても所定の位置に戻る
--]]
local VERSION = "0.2.2"
local AUTHOR = "neverclear"
local PASTEBIN = "bWtaM4ab"


--#### Install API ################################################################
APIDir = "/neverAPIs/"
APIs = {
  inventory = "k2T2MdcU",
  stats     = "SV1QZzAH",
  movements = "tDhuGZML",
  log       = "hmv60TYF",
  ncutl     = "V7d5833K",
}
for k,v in pairs(APIs) do
  if (fs.exists(APIDir .. k) == false) then
    shell.run("pastebin", "get", v, APIDir .. k)
  end
end
for k in pairs(APIs) do
  os.loadAPI(APIDir .. k)
end

local mov = movements
local inv = inventory

-- Define ########################################################################
local WOOD = "minecraft:log"

local SAPLING = "minecraft:sapling"
local TREE_TYPE = {
  oak     = 0,
  spruce  = 1,
  birch   = 2,
  jungle  = 3,
}

--#### Function ###################################################################
function showHelp(errMessage)
  if (errMessage ~= nil) then
    if (term.isColor()) then
      term.setTextColor(colors.red)
    end
    print(shell.getRunningProgram() .. ":" .. errMessage)
    term.setTextColor(colors.white)
  end
  print("Usage: " .. shell.getRunningProgram() .. " [-h] [-t TreeType] depth width")
  print("-h : Show help.")
  print("-t : Select tree type.")
  print("     [oak | spruce | birch | jungle]")
  print("     or [0 | 1 | 2 | 3]")
  print("     Default: BIRCH")
  error()
end

--#### Main Program ###############################################################
local args = {...}

local opts, ext = ncutl.getOpts(args, "t:uvh")

if (opts.u == true) then
  fs.delete("/" .. shell.getRunningProgram())
  shell.run("pastebin", "get", PASTEBIN, "/" .. shell.getRunningProgram())
  print("Update completed.")
  shell.run("/" .. shell.getRunningProgram() , "-v")
  error()
end


if (opts.h == true) then
  showHelp()
end

if (opts.v == true) then
  print(shell.getRunningProgram() .. "\nVersion : " .. VERSION .. "\nAuthor : " .. AUTHOR)
  error()
end

local treeType
if (opts.t ~= "") then
  local errors
  if (tonumber(opts.t) ~= nil) then
    if (TREE_TYPE[opts.t] ~= nil) then
      errors = false
      treeType = TREE_TYPE[opts.t]
    else
      errors = true
    end
  else
    if (0 <= tonumber(opts.t) and tonumber(opts.t) <= 3) then
      errors = false
      treeType = tonumber(opts.t)
    else
      errors = true
    end
  end

  if (errors) then
    showHelp("Invalid value -- '-d " .. opts.t .. "'")
  end
else
  treeType = TREE_TYPE.birch
end


if (tonumber(ext[1]) == nil or tonumber(ext[2]) == nil) then
  showHelp("depth and width are numbers.")
end

local depth = tonumber(ext[1])
local width = tonumber(ext[2])
local area  = depth * width

-- Loooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooop

while (true) do
  inv.compressItem()
  if (inv.getItemCountSum(SAPLING, treeType) < area) then
    mov.turnBack()
    for i = 1, math.ceil(area / 64) do
      turtle.suck()
    end
  end

  local isEnough
  if(inv.getItemCountSum(SAPLING, treeType) < area) then
    isEnough = false
    print("Sapliiiiiiiiiiing!!!!!")
  else
    isEnough = true
  end
  mov.turnBack()

  if (isEnough) then

    if (turtle.detect()) then
      turtle.dig()
    end
    mov.forword()

    for i = 1, width do
      for j = 1, depth do
        local ret = {turtle.inspect()}
        local isWood = ret[2].name == WOOD
      end
    end



  end

  sleep(1800)

end
