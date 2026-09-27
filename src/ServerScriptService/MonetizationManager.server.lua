local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage:WaitForChild("Config"))

-- Dev Product Handling
local function processReceipt(receiptInfo)
    local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
    if not player then
        return Enum.ProductPurchaseDecision.NotProcessedYet
    end

    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then
        return Enum.ProductPurchaseDecision.NotProcessedYet
    end

    if receiptInfo.ProductId == Config.DEV_PRODUCTS.COINS_100 then
        leaderstats.Coins.Value += 100
        return Enum.ProductPurchaseDecision.PurchaseGranted
        
    elseif receiptInfo.ProductId == Config.DEV_PRODUCTS.SKIP_STAGE then
        if leaderstats.Stage.Value < Config.MAX_STAGES then
            leaderstats.Stage.Value += 1
            player:LoadCharacter() -- Respawn at new stage
        end
        return Enum.ProductPurchaseDecision.PurchaseGranted
    end

    return Enum.ProductPurchaseDecision.NotProcessedYet
end

MarketplaceService.ProcessReceipt = processReceipt

-- Game Pass Handling (on spawn)
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        -- Check if player owns VIP (requires error handling for UserOwnsGamePassAsync in production)
        local success, hasVIP = pcall(function()
            return MarketplaceService:UserOwnsGamePassAsync(player.UserId, Config.GAME_PASSES.VIP)
        end)
        
        if success and hasVIP then
            -- Grant VIP perks (e.g. chat tag, multiplier handled elsewhere)
            -- Apply visual effect here
        end
    end)
end)
