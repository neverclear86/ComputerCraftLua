--[[
-- ProgramName  : LumberJack
-- Author       : neverclear86
-- Date         : 2017.03.19
-- Version      : 0.1
--]]

-- Cut Wood

--#### Install API ################################################################
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

-- Define ########################################################################


--#### Function ###################################################################


--#### Main Program ###############################################################
