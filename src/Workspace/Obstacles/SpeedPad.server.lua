-- Place this script directly inside a Speed Pad BasePart
local pad = script.Parent
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage:WaitForChild("Config"))

local activePlayers = {}

pad.Touched:Connect(function(hit)
    local humanoid = hit.Parent:FindFirstChild("Humanoid")
    local player = game.Players:GetPlayerFromCharacter(hit.Parent)
    
    if humanoid and player and not activePlayers[player] then
        activePlayers[player] = true
        
        local originalSpeed = 16 -- Default Roblox walkspeed
        humanoid.WalkSpeed = Config.SPEED_BOOST_VALUE
        
        -- Optional: Add a trail or particle emitter to the player
        
        task.wait(Config.SPEED_BOOST_DURATION)
        
        if humanoid and humanoid.Parent then
            humanoid.WalkSpeed = originalSpeed
        end
        activePlayers[player] = nil
    end
end)
