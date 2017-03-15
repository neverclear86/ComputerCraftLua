--[[
-- ProgramName  : RestartMine3x3
-- Author       : neverclear86
-- Date         : 2016.06.30
-- Version      : 1.1
--]]

--
-- #### API ###################################################
APIDir = "neverAPIs/"
APIs = {
  stats     = "SV1QZzAH",
  movements = "tDhuGZML",
}
for k,v in pairs(APIs) do
  if (fs.exists(APIDir .. k) == false) then
    shell.run("pastebin", "get", v, APIDir .. k)
  end
end
for k in pairs(APIs) do
  os.loadAPI(APIDir .. k)
end

-- #### main #################################################
movements.setStats(movements.loadLocationLog())
if (movements.isBase() == false) then
  movements.goTo(0, 0, "~-1", "zyx")
  movements.face(0)
  local i = 1
  while (i <= 16 and turtle.detect() == false) do
    turtle.select(i)
    turtle.place()
    i = i + 1
  end
  local fh = fs.open("/logs/mine_log.log", "r")
  local length = tonumber(fh.readLine())
  fh.close()
  shell.run("mine3x3", length, "-f")
end
