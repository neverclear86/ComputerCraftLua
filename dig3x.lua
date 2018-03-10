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
move = move or require("/neverclear/apis/move")
local drop, suck = require("/neverclear/apis/item")
local getopt = require("/neverclear/util/getopt")

--------------------------------------------------------------------------------
local function dig3x(args, opt)
  move.position:reset()
  local depth = args[1]
  local width = tonumber(args[2])

  for i = 1, width do
    shell.run("dig3", i % 4 == 1 and "-t" or "", "--noreset", opt.holdstone and "--holdstone" or "", depth)
    move.turn[i % 2]()
    move.forward(true)
    move.turn[i % 2]()
  end
  move.goBase()
  move.face(2)
  drop.all.forward()
  move.face(0)
  print("GyunGyu~~~~n!!!")
end

dig3x(getopt({...}, {
  holdstone = "boolean",
}))
