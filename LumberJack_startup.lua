--[[
-- ProgramName  : LumberJack_startup
-- Author       : neverclear
-- Date         : 2017.03.21
-- Version      : 1.0
--]]

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

function readFile(fileName)
  local fh = fs.open(fileName, "r")
  local ret = {}
  local line = fh.readLine()
  while (line) do
    table.insert(ret, line)
    line = fh.readLine()
  end
  fh.close()

  return ret
end

mov.setStats(mov.loadLocationLog())


if (not mov.coordinate.isOrigin()) then
  mov.goTo("~", 7, "~", "xyz", true)
  mov.goToBase("zyx", true)
  mov.face(2)
  inv.dropAll("forward")
  mov.face(0)
end

local cmd = readFile("logs/last.cmd")
shell.run(unpack(cmd))
