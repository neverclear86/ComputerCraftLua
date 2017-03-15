args = {...}
local slot = tonumber(args[1])
local detail = turtle.getItemDetail(slot)

if (detail ~= nil) then
  for i,v in pairs(detail) do
    print(v)
  end
end
