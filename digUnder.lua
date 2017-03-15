--[[
-- ProgramName  : digUnder
-- Author       : neverclear86
-- Date         : 2017.03.15
-- Version      : 1.0
--
-- 真下堀り
--]]

-- APIs =========================================================
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






--Main ========================================================
local args = {...}
local current
local lower

if (tonumber(args[1]) ~= nil) then
  current = tonumber(args[1])
else
  print("Usage: digUnder (CurrentY) (LowerY)")
end

if (tonumber(args[2]) ~= nil) then
  lower = tonumber(args[2])
else
  print("Usage: digUnder (CurrentY) (LowerY)")
end
