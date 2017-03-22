--[[
-- ProgramName  : LumberJack
-- Author       : neverclear
-- Date         : 2017.03.19
-- Version      : 0.9
-- Cut Wood!!!
-- Birch only
-- 敷き詰め型なら大きさ自由
-- 途中で止まっても所定の位置に戻る
--]]
local VERSION = "0.9"
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
local MAP_FILE = "logs/" .. ncutl.getFileName(shell.getRunningProgram()) .. ".map"



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
  -- print("-s : ")
  print("-t : Select tree type.")
  print("     [oak | spruce | birch | jungle]")
  print("     or [0 | 1 | 2 | 3]")
  print("     Default: BIRCH")
  print("-h : Show help.")
  error()
end



function writeFile(fileName, mode, ...)
  local fh = fs.open(fileName, mode)
  for i = 1, select("#", ...) do
    local line = select(i, ...)
    fh.writeLine(line)
  end
  fh.close()
end

function readMap()
  local fh = fs.open(MAP_FILE, "r")
  local ret = {}
  local line = fh.readLine()
  while (line) do
    table.insert(ret, tonumber(line))
    line = fh.readLine()
  end
  fh.close()

  return ret
end



function prompt()
  while (true) do
    print(">")
    local cmd = read()
  end
end


--#### Main Program ###############################################################
local args = {...}

writeFile("logs/last.cmd", "w", shell.getRunningProgram(),  unpack(args))

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
local mon = peripheral.wrap("top")
if (mon) then
  -- term.redirect(mon)
end
-- term.setCursorPos(1,2)

--  スタートアップの処理

if (fs.exists("startup")) then
  fs.delete("startup")
end
shell.run("pastebin", "get", "NXjP2PRm", "startup")


term.clear()
term.setCursorPos(1, 1)
term.write(shell.getRunningProgram())
-- Loooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooop
function main()

while (true) do
  local map = nil
  if (fs.exists(MAP_FILE)) then
    map = readMap()
    area = depth * #map
    print(#map)
  end

  inv.compressItem()
  if (inv.getItemCountSum(SAPLING, treeType) < area) then
    mov.face(2)
    for i = 1, math.ceil(area / 64) do
      turtle.suck()
    end
  end

  local isEnough
  if(inv.getItemCountSum(SAPLING, treeType) < area) then
    isEnough = false
    term.setCursorPos(1, 2)
    term.clearLine()
    term.write("Sapliiiiiiiiiiing!!!!!")
  else
    isEnough = true
  end
  mov.face(0)

  if (isEnough) then
    term.setCursorPos(1, 2)
    term.clearLine()
    term.write("Cutting...")



    mov.forward(true)
    if (map) then
      mov.goTo(map[1], "~", "~", "xyz", true)
      mov.face(0)
    end

    for i = 1, map and #map or width do
      local isThere = false
      for j = 1, depth do
        local ins = {turtle.inspect()}
        local isWood = ins[2].name == WOOD
        turtle.dig()
        mov.forward(true)

        local insD = {turtle.inspectDown()}
        local isSapling = insD[2].name == SAPLING


        if (isWood) then
          local insUp = {turtle.inspectUp()}
          while (insUp[2].name == WOOD) do
            mov.up(true)
            insUp = {turtle.inspectUp()}
          end
          mov.goTo("~", 0, "~", "yxz", true)
          turtle.digDown()
          inv.placeItem("down", SAPLING, treeType)
        end

        if (isWood or isSapling) then
          isThere = true
        end

      end

      mov.forward(true)

      if (isThere and not map) then
        writeFile(MAP_FILE, "a", mov.coordinate.x)
      end


      if (mov.coordinate.x + 1 < width) then
        mov.turn[i % 2 + 1]()

        if (map) then
          mov.goTo(map[i + 1], "~", "~", "xyz", true)
        else
          mov.forward(true)
        end
        mov.turn[i % 2 + 1]()
      end
    end

    mov.goToBase("yzx", true)
    mov.face(2)

    inv.dropAll("forward")

    mov.face(0)

  end

  for i = 600, 0, -1 do
    term.setCursorPos(1, 2)
    term.clearLine()
    term.write("CT@ " .. i .. "s")
    sleep(1)
  end
  -- term.cleraLine()

end
end

parallel.waitForAny(main, prompt)
