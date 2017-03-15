-- local args = {...};
-- local length = args[1];

local MINE = "mine3x3";

shell.run(MINE, "-rcf" , "3");

local LINE_LENGTH = 120;
local length = 120;
local num = 0;
while num < length do
  shell.run(MINE, "-rcf", tostring(LINE_LENGTH - 3));

  local isOdd = num % 2 ~= 0;
  if (isOdd) then
    turtle.turnLeft();
    turtle.turnLeft();
    for i = 1, 2 do
      turtle.forward();
    end
  end

  turtle.turnRight();
  local opt = (isOdd) and "-rcf" or "-rc";
  shell.run(MINE, opt, "3");

  if (isOdd) then
    turtle.turnLeft();
    turtle.turnLeft();
    for i = 1, 2 do
      turtle.forward();
    end
  end

  turtle.turnRight();

  num = num + 3;
end
