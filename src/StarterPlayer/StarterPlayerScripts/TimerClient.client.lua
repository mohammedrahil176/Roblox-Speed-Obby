local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local startTime = os.clock()
local timerActive = true

-- In a real game, you would create a ScreenGui -> TextLabel in StarterGui.
-- This script expects to find that UI.

local playerGui = player:WaitForChild("PlayerGui")
-- Using pcall to avoid breaking if UI isn't built yet in Studio
task.spawn(function()
    local screenGui = playerGui:WaitForChild("MainUI", 5)
    if screenGui then
        local timerLabel = screenGui:WaitForChild("TopBar"):WaitForChild("TimerLabel", 5)
        
        RunService.RenderStepped:Connect(function()
            if timerActive and timerLabel then
                local currentTime = os.clock() - startTime
                local mins = math.floor(currentTime / 60)
                local secs = math.floor(currentTime % 60)
                local ms = math.floor((currentTime * 100) % 100)
                timerLabel.Text = string.format("%02d:%02d.%02d", mins, secs, ms)
            end
        end)
    else
        warn("MainUI not found. Please create the UI in StarterGui.")
    end
end)
