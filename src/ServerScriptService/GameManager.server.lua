local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage:WaitForChild("Config"))

local restartEvent = Instance.new("RemoteEvent")
restartEvent.Name = "RestartRunEvent"
restartEvent.Parent = ReplicatedStorage

restartEvent.OnServerEvent:Connect(function(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        -- Reset stage to 1 and respawn
        leaderstats.Stage.Value = 1
        player:LoadCharacter()
    end
end)

-- When a character loads, teleport them to their current stage
local function OnCharacterAdded(character, player)
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")

    -- Wait a brief moment to ensure leaderstats is loaded
    task.wait(0.1)

    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local stageNum = leaderstats.Stage.Value
        
        -- Look for the checkpoint part in Workspace.Checkpoints
        local checkpointsFolder = workspace:FindFirstChild("Checkpoints")
        if checkpointsFolder then
            local targetCheckpoint = checkpointsFolder:FindFirstChild(tostring(stageNum))
            if targetCheckpoint and targetCheckpoint:IsA("BasePart") then
                -- Teleport slightly above the checkpoint
                rootPart.CFrame = targetCheckpoint.CFrame + Vector3.new(0, 3, 0)
            end
        end
    end
    
    humanoid.Died:Connect(function()
        -- Optional: Add death particles or sound here
    end)
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        OnCharacterAdded(character, player)
    end)
end)
