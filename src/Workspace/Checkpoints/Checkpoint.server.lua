-- Place this script directly inside a Checkpoint BasePart
local checkpoint = script.Parent
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage:WaitForChild("Config"))

-- The checkpoint part's name should be its stage number (e.g., "5")
local stageNumber = tonumber(checkpoint.Name)

if not stageNumber then
    warn("Checkpoint name must be a number! Found: " .. checkpoint.Name)
end

checkpoint.Touched:Connect(function(hit)
    local player = game.Players:GetPlayerFromCharacter(hit.Parent)
    if player and stageNumber then
        local leaderstats = player:FindFirstChild("leaderstats")
        if leaderstats then
            local currentStage = leaderstats.Stage
            -- Only update if they are reaching a new, higher checkpoint
            if currentStage.Value == stageNumber - 1 then
                currentStage.Value = stageNumber
                -- Optional: Play a sound or particles here
            end
        end
    end
end)
