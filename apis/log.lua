

log = {}

log.level = "trace"
log.file = nil
log.stdout = true
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

local function makeLog(level, messages)
  for i, v in ipairs(messages) do
    messages[i] = tostring(v)
  end
  
  local info = debug.getinfo(3, "Sl")
  info = info.short_src .. ":" .. info.currentline

  return string.format("[%-6s][%s] %s: %s\n",
    level, os.date(), info, table.concat(messages, " "))
end


local isOver = false
for i, v in ipairs(mode) do
  log[v.name] = function(...)
    if v.name == log.level then
      isOver = true
    end
    if not isOver then
      return
    end
    
    local logstr = makeLog(v.name, {...})
    if log.stdout then
      io.write(logstr)
    end

    if log.file then
      local file = io.open(log.file, "a")
      file:write(logstr)
      file:close()
    end
  end
end
