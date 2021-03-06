--[[
Small library to work with a tree farm.
Turtle needs fertilizer and saplings in
dedicated inventories around it:
- Saplings : left
- Fertilizer : back

Tested on Minecraft 1.12.2
]]--

lumberjack = {}

lumberjack.LOG_PATTERN = "[%a]+:[%a_]*log"

-- Chops down a tree in front of the turtle.
function lumberjack.chop()
    block, item = turtle.inspect()
    while block and string.match(
        item["name"],
        lumberjack.LOG_PATTERN
    ) do
        turtle.dig()
        turtle.digUp()
        turtle.up()
        block, item = turtle.inspect()
    end
    while not turtle.detectDown() do
        turtle.down()
    end
end

-- Refuel if fuel below given value
function lumberjack.checkFuel(value)
    local oldSlot = turtle.getSelectedSlot()
    if turtle.getFuelLevel() < value then
        for i = 1, 16 do
            turtle.select(i)
            if turtle.refuel() then
                break
            end
        end
    end
    turtle.select(oldSlot)
end

-- Empty inventory towards the front
function lumberjack.unload()
    local oldSlot = turtle.getSelectedSlot()
    for i = 1, 16 do
        turtle.select(i)
        turtle.drop()
    end
    turtle.select(oldSlot)
end

-- Take sapling from inventory to the left and replant
function lumberjack.replant()
    turtle.turnLeft()
    local sap = turtle.suck(1)
    turtle.turnRight()
    if sap then
        turtle.place()
    end
end

-- Take fertilizer from back, grow tree
function lumberjack.fertilize()
    turtle.turnLeft()
    turtle.turnLeft()
    local fert = turtle.suck(64)
    turtle.turnRight()
    turtle.turnRight()
    if fert then
        local _, item = turtle.inspect()
        if item then
            local name = item["name"]
            local islog = string.match(name, lumberjack.LOG_PATTERN)
            while not islog and turtle.getItemCount() > 0 do
                turtle.place()
                _, item = turtle.inspect()
                name = item["name"]
                islog = string.match(name, lumberjack.LOG_PATTERN)
            end
            turtle.turnRight()
            turtle.turnRight()
            turtle.drop()
            turtle.turnLeft()
            turtle.turnLeft()
        end
    end
end

return lumberjack
