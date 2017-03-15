local function split(str, delim)
  if (str == nil) then
    return nil
  end

  if (string.find(str, delim) == nil) then
    return {str}
  end

  local result = {}
  local pat = "(.-)" .. delim .. "()"
  local lastPos
  for part, pos in string.gmatch(str, pat) do
    local temp = string.gsub(part, "^%s*(.-)%s*$", "%1")
    table.insert(result, temp)
    lastPos = pos
  end
  local temp = string.gsub(string.sub(str, lastPos), "^%s*(.-)%s*$", "%1")
  table.insert(result, temp)
  return result
end

str = "col1 10"
data = split(str, " ")

for i,v in ipairs(data) do
  print(v)
end
