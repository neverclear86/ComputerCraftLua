
Direction = {}
Direction.new = function()
  local obj = {}
  obj.dir = 0

  obj.updateDir = function(lr)
    obj.dir = obj.dir + lr
    obj.dir = (obj.dir + 4) % 4
  end

  obj.face = function(dir)
    if ((dir + 1) % 4 == obj.dir) then
      turtle.turnLeft()
      obj.updateDir(-1)
    else
      while (obj.dir ~= dir) do
        turtle.turnRight()
        obj.updateDir(1)
      end
    end
  end

  return obj
end
direction = Direction.new()

args = {...}
if (args[1] == "r") then
  direction.face(3)
else
  direction.face(1)
end
for i = 1, 3 do
  turtle.forward()
end
direction.face(0)
