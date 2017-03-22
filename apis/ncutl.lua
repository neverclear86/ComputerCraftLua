--[[
  Program Name  : ncutl
  Author        : neverclear86
  Date          : 2017.03.20

  ユーティリティなやつ
]]


function getOpts(args, optStr)

  local result = {}
  local extra = {}

  local len = string.len(optStr)
  local i = 1
  while (i <= len) do
    local opt = string.sub(optStr, i, i)

    if (string.sub(optStr, i + 1, i + 1) == ":") then
      result[opt] = ""

      i = i + 1
      opt = opt .. ":"
    else
      result[opt] = false
    end

    i = i + 1
  end

  for key, value in ipairs(args) do
    if (string.sub(value, 1, 1) == "-") then
      for i = 2, string.len(value) do
        local opt = string.sub(value, i, i)

        if (result[opt] ~= nil) then
          if (type(result[opt]) == "string") then
            if (args[key + 1] ~= nil) then
              result[opt] = args[key + 1]
              table.remove(args, key + 1)
            else
              error("option requires an argument -- '" .. opt .. "'")
            end
          else
            result[opt] = true
          end
        else
          error("invalid option -- '" .. opt .. "'")
        end

      end

    else
      table.insert(extra, value)
    end
  end

  return result, extra

end


function getFileParent(file)
  local rev = string.reverse(file)
  local pos = string.find(rev, "/")
  local rdi = string.sub(rev, pos)
  local par = string.reverse(rdi)
  return par
end

function getFileName(file)
  local rev = string.reverse(file)
  local pos = string.find(rev, "/")
  local rfi = string.sub(rev, 1, pos)
  local name = string.reverse(rfi)
  return name
end
