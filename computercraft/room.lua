-- assumes to be placed in the bottom
-- left corner of a room to be dug, so
-- it should dig straight and to the
-- right, with a fuel source on
-- the left and a chest on the back
-- to deposit the items

-- args:
-- width: must be odd.
-- length: if only 2 args = width, odd.
-- height: any int, digs up for > 2.
local arg = {...}

local width = tonumber(arg[1])
local length
local height
if arg[3] then
    length = tonumber(arg[2])
    height = tonumber(arg[3])
else
    length = tonumber(width)
    height = tonumber(arg[2])
end

local r_f = 0
local r_r = 1
local r_b = 2
local r_l = 3
local x0 = 1
local y0 = 1
local z0 = 1

local maxX = length
local maxY = width
local maxZ = height

local lastSupposedX
if maxY % 2 == 0 then lastSupposedX = 1 else lastSupposedX = maxX end

local xLevel = x0
local yLevel = y0
local zLevel = z0

local lastX = x0
local lastY = y0
local lastZ = z0

local x = x0
local y = y0
local z = z0
local r = r_f

-- rotates clockwise
local function turn()
    turtle.turnRight()
    r = (r + 1) % 4    
end

-- rotates till the front
local function lookForward()
    while r ~= r_f do turn() end
end

-- rotates to the left
local function lookLeft()
    while r ~= r_l do turn() end
end

-- rotates to the right
local function lookRight()
    while r ~= r_r do turn() end
end

-- rotates to the back
local function lookBack()
    while r ~= r_b do turn() end
end

-- goes up
local function up()
    if turtle.detectUp() then turtle.digUp() end
    if turtle.up() then z = z + 1 end 
end

-- goes down
local function down()
    if turtle.detectDown() then turtle.digDown() end
    if turtle.down() then z = z - 1 end
end

-- goes left
local function left()
    lookLeft()
    if turtle.detect() then turtle.dig() end
    if turtle.forward() then y = y - 1 end    
end

-- goes right
local function right()
    lookRight()
    if turtle.detect() then turtle.dig() end
    if turtle.forward() then y = y + 1 end
end

-- goes forward
local function forward()
    lookForward()
    if turtle.detect() then turtle.dig() end
    if turtle.forward() then x = x + 1 end
end

-- goes back
local function back()
    lookBack()
    if turtle.detect() then turtle.dig() end
    if turtle.forward() then x = x - 1 end
end

-- goes to a z of 1
local function toGround()
    while z > 1 do
        turtle.up()
        z = z - 1
    end
end

-- distance in blocks from the middle
local function distance()
    return math.abs(x - x0) + math.abs(y - y0) + math.abs(z - z0)
end

-- returns whether the fuel is enough to proceed
local function shouldProceed()
    return turtle.getFuelLevel() > distance()
end

-- either digs or moves on the x and y axis
local function tryToDig()
    print("Imma try to diggy hole")
    while y <= maxY do
        local xBound
        if y % 2 == 0 then xBound = 1 else xBound = maxX end
        while x ~= xBound do
            if shouldProceed() then
                if y % 2 == 0 then back() else forward() end
            else
                break
            end
        end
        if shouldProceed() and y < maxY then
            right()
        else
            break
        end
    end
end

-- goes back to 1,1,1
local function goBack()
    print("Oh fuck put it back in!")
    lastX = x
    lastY = y
    lastZ = z
    while y > y0 do
        left()
    end
    while x > x0 do
        back()
    end
    while z > z0 do
        down()
    end
end

-- goes to the furthest visited block
local function goToLast()
    while z < lastZ do
        up()
    end
    while x < lastX do
        forward()
    end
    while y < lastY do
        right()
    end
end

-- configures to try and dig the next level
local function nextLevel()
    print("level " .. z .. " is done, digging up")
    goBack()
    up()
end

-- refuel
local function refuel()
    lookLeft()
    local i = 1
    for i = 1, 16 do
        turtle.select(i)
        turtle.drop()
    end
    lookBack()
    turtle.suck()
    turtle.refuel()
end

while zLevel < maxZ or lastX ~= lastSupposedX or lastY < maxY do
    if lastX == lastSupposedX and lastY == maxY then
        up()
        lastX = 1
        lastY = 1
        lastZ = lastZ + 1
        zLevel = lastZ
    end
    goToLast()
    tryToDig()
    goBack()
    refuel()
end