---
-- コマンドのオプションを解析する
-- -... は一文字系のオプション(複数同時指定可)
-- --... はロングオプション(複数指定不可)
--


function formatOpt(org)
  local ret = {}
  for name, typ in pairs(org) do
    table.insert(ret, {name = name, type = typ, isLong = string.len(name) > 1})
  end
  table.sort(ret, function(a, b) return string.len(a.name) < string.len(b.name) end)
  return ret
end


function optIndex(argv)
  local idx = {}
  for i, v in ipairs(argv) do
    if string.sub(v, 1, 1) == "-" then
      table.insert(idx, i)
    end
  end
  return idx
end

function searchOpt(v, opts)
  local isLong = string.match(string.sub(v, 1, 2), "%-%-") ~= nil

  for name, typ in pairs(opts) do

  end
end

function getopt(argv, optlist)
  local idx = optIndex(argv)
end

-- tsetmain
local optlist = {
  a = false,
  b = false,
  ccc = false,
  ee = false,
}
--local args, opt = getopt(arg, optlist)
searchOpt("-a", formatOpt(optlist))
