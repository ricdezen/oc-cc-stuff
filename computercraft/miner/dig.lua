--[[
Program to dig out an area.
Expects to start at the top left of
the area.

Parameters:
  - Length : number The number of blocks to dig forward. Must be positive.
  - Width : number The number of blocks to dig to the right. Must be positive.
  - Depth : number The number of blocks to dig vertically. can be negative.
--]]

mineutils = require("mineutils")

function itemsAndFuel(fuel)
    if mineutils.freeSlots() < 5 then
        mineutils.enderUnload()
    end
    if turtle.getFuelLevel() < fuel then
        mineutils.enderRefuel(2 * fuel)
    end
end

if #arg < 3 then
    error("Not enough input arguments (Need 3).")
end

local length = tonumber(arg[1])
local width = tonumber(arg[2])
local depth = tonumber(arg[3])

if length <= 0 or width <= 0 or depth == 0 then
    error("Invalid parameters.")
end

mineutils.checkEnderChests()
itemsAndFuel(math.abs(depth))

-- Go to the top to dig down easily.
if depth > 1 then
    mineutils.forceUp(depth - 1)
end

-- Start below current level if depth < 0
if depth < 0 then
    turtle.digDown()
    turtle.down()
end

local direction = 1
for d = 1, math.abs(depth) do
    for w = 1, width - 1 do
        mineutils.forceForward(length - 1)
        if direction == 1 then
            turtle.turnRight()
            mineutils.forceForward(1)
            turtle.turnRight()
        else
            turtle.turnLeft()
            mineutils.forceForward(1)
            turtle.turnLeft()
        end
        direction = -direction
    itemsAndFuel(length)
    end
    mineutils.forceForward(length - 1)
    if d < math.abs(depth) then
        turtle.digDown()
        turtle.down()
        turtle.turnLeft()
        turtle.turnLeft()
    end
    itemsAndFuel(length)
end
