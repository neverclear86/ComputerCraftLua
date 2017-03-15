--[[
--  API Name    : inventory
--  Author      : neverclear86
--  Version     : 1.0
--
--  Turtle's Inventory Controller API
--
--  Logs
--    1.0(2016.06.25): Create serchItemFrom(), serchItem(), serchItemAll(), compressItem(), isSpaceInventory(), isSpaceInventory(), placeItem()
--
--]]

place = {
  forward = turtle.place ,
  up      = turtle.placeUp ,
  down    = turtle.placeDown ,
}

function searchItemFrom(itemName, startSlot)
  local i = startSlot
  while (i <= 16 and (turtle.getItemDetail(i) == nil or turtle.getItemDetail(i).name ~= itemName)) do
    i = i + 1
  end
  if (i > 16) then
    i = false
  end
  return i
end

function searchItem(itemName)
  return searchItemFrom(itemName, 1)
end

function searchItemAll(itemName)
  local ret = {}
  local i = 1
  local slot = searchItemFrom(itemName, 1)
  while (slot ~= false and slot < 16) do
    ret[i] = slot
    slot = searchItemFrom(itemName, slot + 1)
    i = i + 1
  end
  return ret
end

function compressItem()
  for i = 1, 16 do
    local itemName = turtle.getItemDetail(i)
    local count = turtle.getItemCount(i)
    if (itemName ~= nil and count < 64) then
      for j = i + 1, 16 do
        local slot = searchItemFrom(itemName.name, j)
        if (slot ~= false) then
          turtle.select(slot)
          turtle.transferTo(i)
        end
      end
    end
  end
end

function isSpaceInventory()
  local slot = 1
  local ret = false
  while (ret == false and slot <= 16) do
    if (turtle.getItemCount(slot) == 0) then
      ret = true
    end
    slot = slot + 1
  end
  return ret
end

function isFullInventory()
  local ret = true
  if (isSpaceInventory() ~= true) then
    compressItem()
    ret = not isSpaceInventory()
  else
    ret = false
  end
  return ret
end

function placeItem(itemName, fud)
  local slot = searchItem(itemName)
  local ret = false
  if (slot ~= false) then
    turtle.select(slot)
    place[fud]()
    ret = true
  end
  return ret
end
