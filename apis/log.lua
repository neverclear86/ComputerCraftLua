

local log = { __version = 1.0 }

log.level = "trace"

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
local levels = {}
for i, v in ipairs(mode) do
  levels[v.name] = i
end


for i, v in ipairs(mode) do
  log[v.name] = function(...)
    if levels[log.level] > i then
