--[[
Small library to work with a tree farm.
Setup with a drawer controller and a buffer chest
on consecutive sides, counter-clockwise.
i.e.: drawer behind, buffer chest right.

Tested on Minecraft 1.16.5
]]--

lumberjack = {}

lumberjack.SAPLING_TAG = "minecraft:saplings"
lumberjack.FERTILIZER_TAG = "forge:fertilizer"
lumberjack.LOG_PATTERN = "[%a]+:[%a_]+log"

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
function lumberjack.fertilize()
    turtle.turnLeft()
    turtle.turnLeft()
    local fert = lumberjack.pullFertilizer()
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

-- Pull some item from an inventory in front.
-- Expects selected slot to be empty.
-- Returns: true if item matching the tag was found, false otherwise.
function lumberjack.pullItem(tag, amount)
    buf = peripheral.wrap("left")
    inv = peripheral.wrap("front")
    for i = 1, inv.size() do
        meta = inv.getItemDetail(i)
        if meta and meta["tags"][tag] then
            buf.pullItems("front", i, amount)
            turtle.turnLeft()
            turtle.suck()
            turtle.turnRight()
            return true
        end
    end
    return false
end

-- Pull a sapling from an inventory in front
function lumberjack.pullSapling()
    return lumberjack.pullItem(lumberjack.SAPLING_TAG, 1)
end

-- Pull fertilizer from an inventory in front
function lumberjack.pullFertilizer()
    return lumberjack.pullItem(lumberjack.FERTILIZER_TAG, 64)
end

return lumberjack
