-- Place this script directly inside a Coin BasePart
local coin = script.Parent
local Players = game:GetService("Players")

local collected = false
local REFRESH_TIME = 10 -- Seconds before coin respawns

coin.Touched:Connect(function(hit)
    if collected then return end
    
    local player = Players:GetPlayerFromCharacter(hit.Parent)
    if player then
        local leaderstats = player:FindFirstChild("leaderstats")
        if leaderstats then
            collected = true
            leaderstats.Coins.Value += 1
            
            -- Hide the coin
            coin.Transparency = 1
            coin.CanTouch = false
            
            -- Optional: Play coin collect sound
            
            -- Respawn coin
            task.wait(REFRESH_TIME)
            coin.Transparency = 0
            coin.CanTouch = true
            collected = false
        end
    end
end)
