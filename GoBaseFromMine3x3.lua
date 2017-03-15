--[[
-- ProgramName  : GoBase
-- Author       : neverclear86
-- Date         : 2016.06.27
-- Version      : 1.1
--]]

-- Read location.log and Go base from Mine3x3
-- #### API ###################################################
APIs = {
  stats     = "SV1QZzAH",
  movements = "tDhuGZML",
}
for k,v in pairs(APIs) do
  if (fs.exists(k) == false) then
    shell.run("pastebin", "get", v, k)
  end
end
for k in pairs(APIs) do
  os.loadAPI(k)
end

-- #### main #################################################
movements.setStats(movements.loadLocationLog())
if (movements.isBase() == false) then

  -- local pos = movements.getCoordinate()
  -- local dire = movements.getDirection()
  movements.goTo("~", "~", "~-1")
  movements.goToBase("yxz")
  movements.deleteLocationLog()
end
