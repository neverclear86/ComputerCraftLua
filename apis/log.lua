-- log4cc

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

local function getinfo(level)
  local e = {pcall(error, "", level)}
  return e[2]
end


local function makeLog(level, messages)
  for i, v in ipairs(messages) do
    messages[i] = tostring(v)
  end

  local info = getinfo(5)
  local label = tostring(os.getComputerID()) .. "/" .. os.getComputerLabel() or ""
  return string.format("[%-6s][%.2f][%s] %s %s\n",
    level, os.clock(), label, info, table.concat(messages, " "))
end


local isOver = false
for i, v in ipairs(mode) do
  if v.name == log.level then
    isOver = true
  end
  log[v.name] = function(...)
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
