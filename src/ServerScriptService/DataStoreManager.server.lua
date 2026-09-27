local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local PlayerDataStore = DataStoreService:GetDataStore("ObbyData_v1")

local function SaveData(player)
    if not loadedPlayers[player] then
        warn("Not saving data for " .. player.Name .. " because it failed to load initially.")
        return
    end

    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return end

    local data = {
        Stage = leaderstats.Stage.Value,
        Coins = leaderstats.Coins.Value,
        Wins = leaderstats.Wins.Value
    }

    local success, err = pcall(function()
        PlayerDataStore:SetAsync(tostring(player.UserId), data)
    end)

    if not success then
        warn("Failed to save data for " .. player.Name .. ": " .. tostring(err))
    end
end

local loadedPlayers = {}

Players.PlayerAdded:Connect(function(player)
    -- leaderstats is created by Leaderstats.server.lua
    local leaderstats = player:WaitForChild("leaderstats", 10)
    if not leaderstats then return end

    local data
    local success, err = pcall(function()
        data = PlayerDataStore:GetAsync(tostring(player.UserId))
    end)

    if success then
        if data then
            leaderstats.Stage.Value = data.Stage or 1
            leaderstats.Coins.Value = data.Coins or 0
            leaderstats.Wins.Value = data.Wins or 0
        end
        -- Mark as successfully loaded so we know it's safe to save later
        loadedPlayers[player] = true
    else
        warn("Failed to load data for " .. player.Name .. ": " .. tostring(err))
        -- In a real game, you might want to kick the player here so their data isn't at risk
        -- player:Kick("Failed to load your data. Please rejoin.")
    end
end)

Players.PlayerRemoving:Connect(function(player)
    SaveData(player)
    loadedPlayers[player] = nil
end)

game:BindToClose(function()
    for _, player in ipairs(Players:GetPlayers()) do
        SaveData(player)
    end
end)
