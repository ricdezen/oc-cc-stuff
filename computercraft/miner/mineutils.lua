--[[
Library for utility functions when mining.
--]]

mineutils = {}

-- Ensure the turtle goes up by exactly
-- `blocks` blocks, digs if necessary.
function mineutils.forceUp(blocks)
    for i = 1, blocks do
        while not turtle.up() do
            turtle.digUp()
        end
    end
end

-- Ensure the turtle goes down by exactly
-- `blocks` blocks, digs if necessary.
function mineutils.forceDown(blocks)
    for i = 1, blocks do
        while not turtle.down() do
            turtle.digDown()
        end
    end
end

-- Ensure the turtle goes forward by
-- `blocks` blocks, digs if necessary.
function mineutils.forceForward(blocks)
    for i = 1, blocks do
        while not turtle.forward() do
            turtle.dig()
        end
    end
end

-- Drop items into ender chest in slot 1
-- Breaks the block in front if it cannot
-- place the chest. Items are dropped if
-- chest full.
function mineutils.enderUnload()
    turtle.select(1)
    mineutils.forcePlace()
    for i = 3, 16 do
        turtle.select(i)
        turtle.drop()
    end
    turtle.select(1)
    turtle.dig()
end

-- Refuels from ender chest in slot 2
-- Must contain only valid fuel. Will
-- break block in front if necessary.
-- Parameters: upto Stops refueling after this.
function mineutils.enderRefuel(upto)
    turtle.select(2)
    mineutils.forcePlace()
    while turtle.getFuelLevel() < upto do
        turtle.suck(1)
        turtle.refuel()
        mineutils.yield()
    end
    turtle.dig()
end

-- Ensure ender chests are in inventory
-- or ground in front. If not, throw error.
function mineutils.checkEnderChests()
    if turtle.getItemCount(1) == 0 then
        turtle.select(1)
        if not turtle.dig() then
            error("I lost Ender Chest 1!")
        end
    end
    if turtle.getItemCount(2) == 0 then
        turtle.select(2)
        if not turtle.dig() then
            error("I lost Ender Chest 2!")
        end
    end
end

-- Force forward one block and go back
function mineutils.forcePeek()
    mineutils.forceForward(1)
    turtle.turnLeft()
    turtle.turnLeft()
    mineutils.forceForward(1)
    turtle.turnLeft()
    turtle.turnLeft()
end

-- Place a block in front, digging if necessary.
function mineutils.forcePlace()
    while not turtle.place() do
        turtle.dig()
    end
end

-- Returns number of free slots
function mineutils.freeSlots()
    free = 0
    for i = 1, 16 do
        if turtle.getItemCount(i) == 0 then
            free = free + 1
        end
    end
    return free
end

-- Post a fake event in order to yield.
function mineutils.yield()
    os.queueEvent("FakeEvent")
    os.pullEvent()
end

-- Split a string over a regex.
function mineutils.splitstr(s, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    -- Loop over regex matches.
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

return mineutils
