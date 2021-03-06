--[[
Small library to work with a tree farm.
Turtle needs to be put with a series of inventories to the right.
Each inventory must hold only one type of item (i.e. Barrels/drawers).
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

-- Empty the buffer chest in front
-- (Drawer controller on the right)
function lumberjack.emptyBuffer()
    buf = peripheral.wrap("front")
    inv = peripheral.wrap("right")
    for i = 1, buf.size() do
        inv.pullItems("front", i)
    end
end

-- Take sapling from back, replant.
function lumberjack.replant()
    turtle.turnLeft()
    turtle.turnLeft()
    local sap = lumberjack.pullSapling()
    turtle.turnRight()
    turtle.turnRight()
    if sap then
        turtle.place()
        turtle.turnLeft()
        turtle.turnLeft()
        turtle.drop()
        turtle.turnRight()
        turtle.turnRight()
    end
end

-- Take fertilizer from back, grow tree
-- Parameters:
-- name : string Name of the fertilizer
function lumberjack.fertilize(name)
    turtle.turnLeft()
    turtle.turnLeft()
    local fert = lumberjack.pullItem(name, 64)
    turtle.turnRight()
    turtle.turnRight()
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
        turtle.turnLeft()
        turtle.turnLeft()
        turtle.drop()
        turtle.turnRight()
        turtle.turnRight()
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
            break
        end
        turtle.suck()
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
            steps += 1
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
