

lon = {}

function lon.serialize(tbl)
  return textutils.serialize(tbl)
end

function lon.unserialize(str)
  return textutils.unserialize(str)
end


--- Lonファイルにテーブルを保存
-- @param string filename 保存するファイル名
-- @param table  tbl      保存するデータ
function lon.save(filename, tbl)
  local file = fs.open(filename, "w")
  file.write(lon.serialize(tbl))
  file.close()
end


--- Lonファイルを読み込み
-- @param   string filename 保存するファイル名
-- @return  string          読み込んだデータ
function lon.load(filename)
  if not fs.exists(filename) then
    return nil
  end
  local file = fs.open(filename, "r")
  local tbl = lon.unserialise(file.readAll())
  file.close()
  return tbl
end

return lon
