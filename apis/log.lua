--[[
--  API Name    : log
--  Author      : neverclear86
--  Version     : 1.0
--
--  Write Log API
--
--  Logs
--
--
--]]

-- #### Function ######################################################
writeFile = function(fileName, ...)
  local fh = fs.open(filename, "a")
  for i = 1, select("#", ...) do
    local line = select(i, ...)
    fh.writeLine(line)
  end
  fh.close()
end

writeNewFile = function(filename, ...)
  local fh = fs.open(filename, "w")
  for i = 1, select("#", ...) do
    local line = select(i, ...)
    fh.writeLine(line)
  end
  fh.close()
end
