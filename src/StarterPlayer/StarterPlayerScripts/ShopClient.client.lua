local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Config = require(ReplicatedStorage:WaitForChild("Config"))
local player = Players.LocalPlayer

task.spawn(function()
    local playerGui = player:WaitForChild("PlayerGui")
    local screenGui = playerGui:WaitForChild("MainUI", 10)
    if not screenGui then return end
    
    local shopButton = screenGui:WaitForChild("ShopButton")
    local shopFrame = screenGui:WaitForChild("ShopFrame")
    local feedbackLabel = shopFrame:WaitForChild("FeedbackLabel")
    
    -- Toggle Shop
    shopButton.MouseButton1Click:Connect(function()
        shopFrame.Visible = not shopFrame.Visible
        if shopFrame.Visible then
            feedbackLabel.Text = ""
        end
    end)
    
    -- Purchase Prompts
    local buySkipBtn = shopFrame:WaitForChild("ScrollingFrame"):WaitForChild("BuySkipButton")
    buySkipBtn.MouseButton1Click:Connect(function()
        MarketplaceService:PromptProductPurchase(player, Config.DEV_PRODUCTS.SKIP_STAGE)
    end)
    
    local buyCoinsBtn = shopFrame:WaitForChild("ScrollingFrame"):WaitForChild("BuyCoinsButton")
    buyCoinsBtn.MouseButton1Click:Connect(function()
        MarketplaceService:PromptProductPurchase(player, Config.DEV_PRODUCTS.COINS_100)
    end)
    
    local buyVIPBtn = shopFrame:WaitForChild("ScrollingFrame"):WaitForChild("BuyVIPButton")
    buyVIPBtn.MouseButton1Click:Connect(function()
        MarketplaceService:PromptGamePassPurchase(player, Config.GAME_PASSES.VIP)
    end)
    
    -- Purchase Feedback
    MarketplaceService.PromptProductPurchaseFinished:Connect(function(userId, productId, isPurchased)
        if userId == player.UserId and isPurchased then
            feedbackLabel.Text = "Purchase Successful!"
            feedbackLabel.TextColor3 = Color3.new(0, 1, 0)
        elseif userId == player.UserId and not isPurchased then
            feedbackLabel.Text = "Purchase Cancelled."
            feedbackLabel.TextColor3 = Color3.new(1, 0, 0)
        end
    end)
    
    MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(playerObj, passId, isPurchased)
        if playerObj == player and isPurchased then
            feedbackLabel.Text = "Pass Purchased!"
            feedbackLabel.TextColor3 = Color3.new(0, 1, 0)
        end
    end)
end)
