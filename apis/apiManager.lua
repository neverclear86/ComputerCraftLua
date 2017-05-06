--[[
  Program Name  : apiManager
  Author        : neverclear86
  Date          : 2017.05.07

  neverclear's API の管理するやーつ

  ChangeLog:
  0.1: APIのインスコとかできた
]]

local VERSION = 1.0

local apiDir = "neverAPIs/"

local apiList = {
  inventory = "k2T2MdcU",
  stats     = "SV1QZzAH",
  movements = "tDhuGZML",
  log       = "hmv60TYF",
  ncutl     = "V7d5833K",
}


function getDir()
  return apiDir
end

function getApiNames()
  local apiNames = {}
  for k,v in pairs(apiList) do
    table.insert(apiNames, k)
  end
  return apiNames
end



function exists(name)
  return apiList[name] ~= nil
end

function isInstalled(name)
  return fs.exists(apiDir .. name)
end


function install(name)
  if exists(name) ~= false and isInstalled(name) ~= false then
    shell.run("pastebin", "get", apiList[name], apiDir .. name)
  end
end

function installAll()
  for k,v in pairs(apiList) do
    install(k)
  end
end
