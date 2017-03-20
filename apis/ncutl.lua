--[[
  Program Name  : ncutl
  Author        : neverclear86
  Date          : 2017.03.20

  ユーティリティなやつ
]]


function getOpts(args, optStr)
  -- Debug =========================
    -- local a = {...}
    -- local optStr = a[1]
    -- table.remove(a, 1)
    -- local args = a
  -- ===============================

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

  -- print("result = {")
  -- for key, value in pairs(result) do
  --   print(key .. " : " .. tostring(value))
  -- end
  -- print("}")
  -- print("extra = {")
  -- for key, value in ipairs(extra) do
  --   print(key .. " : " .. tostring(value))
  -- end
  -- print("}")

  return result, extra

end
