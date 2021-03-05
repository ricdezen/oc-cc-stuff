while true do
    
    local right = redstone.getInput("right")
    if right then
        redstone.setAnalogOutput("back", 1)
        os.sleep(0.2)
        redstone.setAnalogOutput("left", 1)
        os.sleep(0.2)
        redstone.setAnalogOutput("left", 2)
        os.sleep(0.2)
        redstone.setAnalogOutput("left", 4)
        os.sleep(0.2)
        os.sleep(4.5)
        redstone.setAnalogOutput("back", 0)
        redstone.setAnalogOutput("left", 0)
        print("Input found")
    else
        print("No input")
    end

    os.queueEvent("fakeEvent")
    os.pullEvent()
    
end
