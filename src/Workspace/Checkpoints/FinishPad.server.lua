-- Place this script directly inside the Finish Pad (Stage 30 Checkpoint)
local finishPad = script.Parent
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage:WaitForChild("Config"))

local touchedPlayers = {}

finishPad.Touched:Connect(function(hit)
    local player = game.Players:GetPlayerFromCharacter(hit.Parent)
    
    if player and not touchedPlayers[player] then
        local leaderstats = player:FindFirstChild("leaderstats")
        if leaderstats and leaderstats.Stage.Value == Config.MAX_STAGES - 1 then
            touchedPlayers[player] = true
            
            -- Reached the end!
            leaderstats.Stage.Value = Config.MAX_STAGES
            leaderstats.Coins.Value += Config.WIN_COIN_REWARD
            leaderstats.Wins.Value += 1
            
            -- Optional: Global announcement
            -- game.ReplicatedStorage.AnnounceEvent:FireAllClients(player.Name .. " has finished the Obby!")
            
            -- Allow them to touch it again if they reset (optional logic depending on game flow)
            task.wait(5)
            touchedPlayers[player] = nil
        end
    end
end)
