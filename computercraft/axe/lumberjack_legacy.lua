--[[
Small library to work with a tree farm.
Turtle needs to be put with a series of inventories to the right.
Each inventory must hold only one type of item (i.e. Barrels/drawers).

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

-- Take sapling from drawers on the back-right, replant.
-- Parameters:
-- name : string Name of the sapling.
function lumberjack.replant(name)
    turtle.turnRight()
    local sap = lumberjack.pullItem(name, 1)
    turtle.turnLeft()
    if sap then
        turtle.place()
    end
end

-- Take fertilizer from back, grow tree
-- Parameters:
-- name : string Name of the fertilizer
function lumberjack.fertilize(name)
    turtle.turnRight()
    local fert = lumberjack.pullItem(name, 64)
    turtle.turnLeft()
    if fert then
        local _, item = turtle.inspect()
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

-- Try to suck from inventories to the right looking for specific item.
-- Returns: true if item matching the name was found, false otherwise.
function lumberjack.pullItem(name, amount)
    local steps = 0
    local found = false
    while true do
        turtle.turnRight()
        -- No Barrel -> exit.
        if not turtle.inspect() then
            turtle.turnRight()
            turtle.turnRight()
            break
        end
        turtle.suck(1)
        meta = turtle.getItemDetail(turtle.getSelectedSlot())
        -- Found Barrel -> suck and exit.
        if meta and meta["name"] == name then
            turtle.suck(amount - 1)
            turtle.turnRight()
            found = true
            break
        end
        turtle.drop()
        turtle.turnLeft()
        -- Can't go forward -> exit.
        if turtle.forward() then
            steps = steps + 1
        else
            turtle.turnRight()
            turtle.turnRight()
            break
        end
    end
    -- Go back to starting position.
    for i = 1, steps do
        turtle.forward()
    end
    turtle.turnRight()
    turtle.turnRight()
    return found
end

return lumberjack
