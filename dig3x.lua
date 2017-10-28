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
  log.file = "/logs/dig3x.log"
  log.level = "info"
end
local move = require("/neverclear/apis/move")
local dig, place = require("/neverclear/apis/block")
local inventory = require("/neverclear/apis/inventory")
local getopt = require("/neverclear/util/getopt")

--------------------------------------------------------------------------------
local function dig3x(args, opt)
  local depth = args[1]
  local width = tonumber(args[2])

  for i = 1, depth do
    shell.run("dig3", i % 4 == 1 and "-t" or "", depth)
  end
end




dig3x(getopt({...}, {
  holdstone = "boolean",
}))
