local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage:WaitForChild("Config"))
local player = Players.LocalPlayer

-- Expects MainUI -> ShopFrame to exist in StarterGui
task.spawn(function()
    local playerGui = player:WaitForChild("PlayerGui")
    local screenGui = playerGui:WaitForChild("MainUI", 5)
    
    if screenGui then
        local shopButton = screenGui:WaitForChild("ShopButton", 5)
        local shopFrame = screenGui:WaitForChild("ShopFrame", 5)
        
        if shopButton and shopFrame then
            -- Toggle shop visibility
            shopButton.MouseButton1Click:Connect(function()
                shopFrame.Visible = not shopFrame.Visible
            end)
            
            -- Hook up buy buttons inside the shop frame
            local buySkipBtn = shopFrame:WaitForChild("BuySkipButton", 5)
            if buySkipBtn then
                buySkipBtn.MouseButton1Click:Connect(function()
                    MarketplaceService:PromptProductPurchase(player, Config.DEV_PRODUCTS.SKIP_STAGE)
                end)
            end
            
            local buyVIPBtn = shopFrame:WaitForChild("BuyVIPButton", 5)
            if buyVIPBtn then
                buyVIPBtn.MouseButton1Click:Connect(function()
                    MarketplaceService:PromptGamePassPurchase(player, Config.GAME_PASSES.VIP)
                end)
            end
        end
    end
end)
