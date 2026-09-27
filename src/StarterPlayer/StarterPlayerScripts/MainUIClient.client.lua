local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local leaderstats = player:WaitForChild("leaderstats", 10)

-- Wait for UI
local screenGui = playerGui:WaitForChild("MainUI", 10)
if not screenGui then
    warn("MainUI not found. Please follow UI_SETUP.md")
    return
end

local topHud = screenGui:WaitForChild("TopHUD")
local notifFrame = screenGui:WaitForChild("NotificationFrame")
local finishFrame = screenGui:WaitForChild("FinishFrame")

local timerLabel = topHud:WaitForChild("TimerLabel")
local stageLabel = topHud:WaitForChild("StageLabel")
local coinsLabel = topHud:WaitForChild("CoinsLabel")
local winsLabel = topHud:WaitForChild("WinsLabel")

-- State
local startTime = os.clock()
local timerActive = true
local currentStage = 1

-- Restart Event
local restartEvent = ReplicatedStorage:WaitForChild("RestartRunEvent", 5)

-- HUD Updates
local function updateHUD()
    if leaderstats then
        stageLabel.Text = "Stage: " .. leaderstats.Stage.Value
        coinsLabel.Text = "Coins: " .. leaderstats.Coins.Value
        winsLabel.Text = "Wins: " .. leaderstats.Wins.Value
    end
end

if leaderstats then
    updateHUD()
    leaderstats.Stage.Changed:Connect(function(newStage)
        updateHUD()
        
        if newStage > currentStage then
            currentStage = newStage
            
            if newStage < 30 then
                -- Checkpoint Notification
                notifFrame.TextLabel.Text = "Stage " .. newStage .. "!"
                notifFrame.Visible = true
                notifFrame.Position = UDim2.new(0.5, 0, 0.2, 0)
                
                local tweenIn = TweenService:Create(notifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Bounce), {Position = UDim2.new(0.5, 0, 0.3, 0)})
                tweenIn:Play()
                
                task.delay(2, function()
                    notifFrame.Visible = false
                end)
            elseif newStage == 30 then
                -- Finish!
                timerActive = false
                finishFrame.Visible = true
                finishFrame.TimeLabel.Text = timerLabel.Text
            end
        end
    end)
    
    leaderstats.Coins.Changed:Connect(updateHUD)
    leaderstats.Wins.Changed:Connect(updateHUD)
end

-- Timer Loop
RunService.RenderStepped:Connect(function()
    if timerActive then
        local currentTime = os.clock() - startTime
        local mins = math.floor(currentTime / 60)
        local secs = math.floor(currentTime % 60)
        local ms = math.floor((currentTime * 100) % 100)
        timerLabel.Text = string.format("%02d:%02d.%02d", mins, secs, ms)
    end
end)

-- Finish Screen Restart
local restartBtn = finishFrame:WaitForChild("RestartButton")
restartBtn.MouseButton1Click:Connect(function()
    finishFrame.Visible = false
    timerActive = true
    startTime = os.clock()
    currentStage = 1
    
    if restartEvent then
        restartEvent:FireServer()
    end
end)
