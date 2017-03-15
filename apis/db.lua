--[[
--  API Name    : db
--  Author      : neverclear86
--  Version     : 0.9
--
--  Operate Database
--
-- Logs
--
--]]

-- Constant
local COLUMN_NAME = 1
local COLUMN_TYPE = 2


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


--###################################################
local dbDir = "/databases/"
local dbName = "default/"

local datatype = {
  "number" , "string", "boolean", "datetime"
}

local constraint = {
  "pk", "fk", "notnil", "unique"
}


function useDatabase(database)
  dbName = database .. "/"
end

local function getTableProperties(tableName)
  local ret = {}
  local proStr
  local i = 1
  local propH = fs.open(dbDir .. dbName .. tableName .. "/" .. tableName .. ".propeties", "r")
  proStr = propH.readLine()
  while (proStr ~= nil) do
    ret[i] = split(proStr, ":")
    i = i + 1
    proStr = propH.readLine()
  end
  propH.close()

  return ret
end

local function validateColumnProperty(str)
  local column = split(str, ":")

  for k, v in ipairs(column) do
    if (k == 1) then
      -- Do Nothing --
    elseif (k == 2) then  --DataType check
      if(v ~= "") then
        local i = 1
        while (i <= #datatype and v ~= datatype[i]) do
          i = i + 1
        end
        if (i > #datatype) then
          print("error")
          return false
        end
      end
    else                  --Constraint check
      local i = 1
      while (i <= #constraint and v ~= constraint[i]) do
        i = i + 1
      end
      if(i > #constraint) then
        print("error")
        return false
      end
    end
  end
  return true
end

local function validateDataType(data, dataType)
  if (data ~= nil) then
    if (dataType == "number" or dataType == "datetime") then
      if (tonumber(data) ~= nil) then
        return true
      else
        return false
      end

    elseif (dataType == "string" or dataType == "boolean") then
      if (type(data) == dataType) then
        return true
      else
        return false
      end

    else
      return false

    end
  else
    return true
  end
end

local function toBoolean(data)
  if (data == "true") then
    return true
  elseif (data == "false") then
    return false
  else
    print("Error:db#120: Can't convert boolean")
    return nil
  end
end

local function toRawData(data, dataType)
  if (dataType == "number" or dataType == "datetime") then
    return tonumber(data)
  elseif (dataType == "boolean") then
    return toBoolean(data)
  elseif (dataType == "string") then
    return data
  end
end

local function loadLike()
  loadstring(
    "function like(str, patternStr) " ..
      "local pattern = '' " ..
      "for i = 1, string.len(patternStr) do  " ..
        "local char = string.sub(patternStr, i, i) " ..
        "if (char == '_') then " ..
          "char = '%a' " ..
        "elseif (char == '%') then " ..
          "char = '.*' " ..
        "end " ..
        "pattern = pattern .. char " ..
      "end " ..
      "return string.match(str, pattern) == str " ..
    "end "
  )()
end

--###################################################################################################################################--

--[[
    How to use:
    db.createTable("tableName", "column1:dataType[:constraint1:constraint2]", ...)
]]
function createTable(tableName, ...)
  local tblPath = dbDir .. dbName .. tableName .. "/"
  if (fs.exists(tblPath)) then
    print("Table:" .. tableName .. " already exists.")
    return false
  end

  local args = {...}
  local tblH = fs.open(tblPath .. tableName .. ".tbl", "w")
  tblH.close()

  local propH = fs.open(tblPath .. tableName .. ".propeties", "w")
  for k, v in ipairs(args) do
    propH.writeLine(v)
  end
  propH.close()
  return true
end


--[[
    How to use:
    db.dropTable("tablename")
]]
function dropTable(tableName)
  local tblPath = dbDir .. dbName .. tableName
  if (fs.exists(tblPath) == true) then
    fs.delete(tblPath)
    return true
  else
    print("Table:" .. tableName .. " don't exists")
    return false
  end
end


--[[
    How to use:
    db.insert("tablename", "abcde", 10, true)
]]
function insert(tableName, ...)
  local propety = getTableProperties(tableName)
  local values = {...}
  local dataStr = ""
  local error = false
  for i = 1, #propety do
    if (validateDataType(values[i], propety[i][COLUMN_TYPE]) == true) then
      dataStr = dataStr .. tostring(values[i]) .. ","
    else
      print("Error:db#212:")
      return false
    end
  end
  dataStr = string.sub(dataStr, 1, -2)

  local tblH = fs.open(dbDir .. dbName .. tableName .. "/" .. tableName ..".tbl" , "a")
  tblH.writeLine(dataStr)
  tblH.close()

  return true

end


--[[
    How to use:
    db.select("tablename", "*")
    db.select("tablename", "col1, col2", "like(col1, %abc%) and col2 < 30 or col3 == true", "col1 DESC, col2")
]]
function select(tableName, columnsStr, conditions, orderStr)
  local propety = getTableProperties(tableName)
  local columns = {}
  if (columnsStr == "*") then
    for i = 1, #propety do
      table.insert(columns, propety[i][COLUMN_NAME])
    end
  else
    columns = split(columnsStr, ",")
    --kakuyo
  end

  local length = {}
  for i,v in ipairs(propety) do
    table.insert(length, string.len(v[1]))
  end

  local tblH = fs.open(dbDir .. dbName .. tableName .. "/" .. tableName .. ".tbl", "r")
  local originTable = {}
  local row = 1
  local rowData = split(tblH.readLine(), ",")
  while (rowData ~= nil) do
    originTable[row] = {}
    for i = 1, #rowData do
      originTable[row][propety[i][COLUMN_NAME]] = toRawData(rowData[i], propety[i][COLUMN_TYPE])

      if (length[i] < string.len(rowData[i])) then
        length[i] = string.len(rowData[i])
      end

    end
    row = row + 1
    rowData = split(tblH.readLine(), ",")
  end
  tblH.close()

  local idx = 1
  for i = 1, #propety do
    if (propety[i][COLUMN_NAME] ~= columns[idx]) then
      table.remove(length, idx)
      idx = idx - 1
    end
    idx = idx + 1
  end

  local retTable = {}

  --WHERE
  row = 1
  for i,v in ipairs(originTable) do
    local whereResult
    if (conditions ~= nil) then
      local varStr = ""
      for j = 1, #propety do
        local quotation = ""
        if (propety[j][COLUMN_TYPE] == "string") then
          quotation = "\'"
        end
        varStr = varStr .. propety[j][COLUMN_NAME] .. "=" .. quotation .. tostring(originTable[i][propety[j][COLUMN_NAME]]) .. quotation .. ";"
      end
      loadLike()
      whereResult = assert(loadstring(varStr .. "return " .. conditions))()
    else
      whereResult = true
    end

    if (whereResult) then
      retTable[row] = {}
      for j = 1, #columns do
        retTable[row][columns[j]] = v[columns[j]]
      end
      row = row + 1
    end
  end


  --ORDER BY
  if (orderStr ~= nil) then
    local order = split(orderStr, ",")
    for i = 1, #order do
      order[i] = split(order[i], " ")
    end

    for orderIdx = #order, 1, -1 do
      if (order[orderIdx][2] == nil or string.lower(order[orderIdx][2]) == "asc") then
        for i = 1, #retTable do
          for j = #retTable, i + 1, -1 do
            local thisData = retTable[j][order[orderIdx][1]]
            local prevData = retTable[j - 1][order[orderIdx][1]]
            if (type(thisData) == "boolean" and type(prevData) == "boolean") then
              thisData = tostring(thisData)
              prevData = tostring(prevData)
            end

            if (thisData == nil or prevData ~= nil and thisData < prevData) then
              local temp = retTable[j]
              retTable[j] = retTable[j - 1]
              retTable[j - 1] = temp
            end
          end
        end

      elseif (string.lower(order[orderIdx][2]) == "desc") then
        for i = 1, #retTable do
          for j = #retTable, i + 1, -1 do
            local thisData = retTable[j][order[orderIdx][1]]
            local prevData = retTable[j - 1][order[orderIdx][1]]
            if (type(thisData) == "boolean" and type(prevData) == "boolean") then
              thisData = tostring(thisData)
              prevData = tostring(prevData)
            end

            if (thisData ~= nil and prevData == nil or thisData > prevData) then
              local temp = retTable[j]
              retTable[j] = retTable[j - 1]
              retTable[j - 1] = temp
            end
          end
        end
      end

    end

  end


  retTable.print = function()
    --Header
    local header = "|" .. string.rep(" ", string.len(table.maxn(retTable))) .. " |"
    for i,v in ipairs(length) do
      header = header .. columns[i] ..string.rep(" ", v - string.len(columns[i])) .. " |"
    end

    print(string.rep("-", string.len(header)))
    print(header)
    print(string.rep("-", string.len(header)))

    --Body
    for i,v in ipairs(retTable) do
      local str = "|" .. string.rep(" ", string.len(table.maxn(retTable)) - string.len(i)) .. i .. " |"
      for j,w in ipairs(length) do
        str = str .. tostring(v[columns[j]]) .. string.rep(" ", w - string.len(tostring(v[columns[j]]))) .. " |"
      end
      print(str)
    end

    print(string.rep("-", string.len(header)))

  end

  return retTable
end

--[[
How to use:
db.
]]
function delete(tableName, conditions)
  local newTable = select(tableName, "*", "not (" .. conditions .. ")")
  local propety = getTableProperties(tableName)

  local tblH = fs.open(dbDir .. dbName .. tableName .. "/" .. tableName .. ".tbl", "w")

  for i,v in ipairs(newTable) do
    local str = ""
    for j, w in ipairs(propety) do
      str = str .. tostring(v[w[1]]) .. ","
    end
    str = string.sub(str, 1, -2)
    tblH.writeLine(str)
  end

  tblH.close()

end


--[[
    How to use:
    db.
]]
function update(tableName, setStr, conditions)
  local propety = getTableProperties(tableName)
  local newTable = select(tableName, "*")
  local set = split(setStr, ",")
  for i = 1, #set do
    set[i] = split(set[i], "=")
  end

  for i = 1, #newTable do
    local varStr = ""
    for j = 1, #propety do
      local quotation = ""
      if (propety[j][COLUMN_TYPE] == "string") then
        quotation = "\'"
      end
      varStr = varStr .. propety[j][COLUMN_NAME] .. "=" .. quotation .. tostring(newTable[i][propety[j][COLUMN_NAME]]) .. quotation .. ";"
    end

    local whereResult
    if (conditions ~= nil) then
      loadLike()
      whereResult = assert(loadstring(varStr .. "return " .. conditions))()
    else
      whereResult = true
    end

    if (whereResult) then
      for j = 1, #set do
        newTable[i][set[j][1]] = assert(loadstring(varStr .. "return " .. set[j][2]))()
      end
    end

  end

  local tblH = fs.open(dbDir .. dbName .. tableName .. "/" .. tableName .. ".tbl", "w")

  for i,v in ipairs(newTable) do
    local str = ""
    for j, w in ipairs(propety) do
      str = str .. tostring(v[w[1]]) .. ","
    end
    str = string.sub(str, 1, -2)
    tblH.writeLine(str)
  end

  tblH.close()

end

--[[ EOF ]]
