

log = {}

log.level = "trace"
log.file = nil

--------------------------------------------------------------------------------

local mode = {
  {
    name = "trace",
  },
  {
    name = "debug",
  },
  {
    name = "info",
  },
  {
    name = "warn",
  },
  {
    name = "error",
  },
  {
    name = "fatal",
  },
}

local function makeLog(level, message)
end


for i, v in ipairs(mode) do
  local isOver = false
  log[v.name] = function(...)
    if v.name == log.level then
      isOver = true
    end
    if not isOver then
      return
    end
  end
end
