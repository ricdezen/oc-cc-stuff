while true do
    
    local left = redstone.getInput("left")
    if left then
        for i = 0, 15 do
            redstone.setAnalogOutput("right", i)
            os.sleep(0.2)
        end
        os.sleep(5)
        redstone.setAnalogOutput("right", 0)
        print("Input found")
    else
        print("No input")
    end

    os.queueEvent("fakeEvent")
    os.pullEvent()
    
end
