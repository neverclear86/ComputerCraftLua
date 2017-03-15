--[[
-- ProgramName  : GoBase
-- Author       : neverclear86
-- Date         : 2016.06.27
-- Version      : 1.0
--]]

-- Read location.log and Go base

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
if (movements.loadLocationLog() == true)
  local pos = movements.getCoordinate()
  local dire = movements.getDirection()
  movements.goToBase("xyz")
end
