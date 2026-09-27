local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local TweenService = game:GetService("TweenService")

local Config = require(ReplicatedStorage:WaitForChild("Config"))

-- Deterministic generation
math.randomseed(8675309)

local START_POS = Vector3.new(0, 50, 0)
local PATH_DIR = Vector3.new(0, 0, -1)
local PLATFORM_WIDTH = 12
local PLATFORM_LENGTH = 12
local PLATFORM_THICKNESS = 1

local CHECKPOINTS_FOLDER = Instance.new("Folder")
CHECKPOINTS_FOLDER.Name = "Checkpoints"
CHECKPOINTS_FOLDER.Parent = workspace

local OBSTACLES_FOLDER = Instance.new("Folder")
OBSTACLES_FOLDER.Name = "GeneratedObstacles"
OBSTACLES_FOLDER.Parent = workspace

local COINS_FOLDER = Instance.new("Folder")
COINS_FOLDER.Name = "Coins"
COINS_FOLDER.Parent = workspace

-- Colors
local COLORS = {
    Color3.fromRGB(255, 89, 89),
    Color3.fromRGB(255, 175, 89),
    Color3.fromRGB(255, 237, 89),
    Color3.fromRGB(117, 255, 89),
    Color3.fromRGB(89, 219, 255),
    Color3.fromRGB(164, 89, 255),
    Color3.fromRGB(255, 89, 211)
}

local function getTemplate(scriptName)
    local templates = ServerStorage:FindFirstChild("ObbyTemplates")
    if templates then
        return templates:FindFirstChild(scriptName)
    end
    return nil
end

local function applyScript(part, scriptName)
    local template = getTemplate(scriptName)
    if template then
        local clone = template:Clone()
        clone.Parent = part
    else
        warn("Could not find " .. scriptName .. " in ServerStorage.ObbyTemplates!")
    end
end

local function createPart(size, pos, color, material, parent)
    local part = Instance.new("Part")
    part.Size = size
    part.Position = pos
    part.Color = color
    part.Material = material or Enum.Material.SmoothPlastic
    part.Anchored = true
    part.Parent = parent
    return part
end

local function createSign(part, text)
    local surfaceGui = Instance.new("SurfaceGui")
    surfaceGui.Face = Enum.NormalId.Top
    surfaceGui.Parent = part
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextScaled = true
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.Font = Enum.Font.FredokaOne
    textLabel.Parent = surfaceGui
end

local function generateStage(stageNum, startPos)
    local difficulty = math.clamp(stageNum / Config.MAX_STAGES, 0, 1)
    local stageColor = COLORS[(stageNum % #COLORS) + 1]
    
    -- Create Checkpoint
    local cp = createPart(Vector3.new(PLATFORM_WIDTH, PLATFORM_THICKNESS, PLATFORM_LENGTH), startPos, stageColor, Enum.Material.Neon, CHECKPOINTS_FOLDER)
    cp.Name = tostring(stageNum)
    if stageNum == Config.MAX_STAGES then
        applyScript(cp, "FinishPad.server.lua")
        createSign(cp, "FINISH!")
    else
        applyScript(cp, "Checkpoint.server.lua")
        createSign(cp, "Stage " .. stageNum)
    end
    
    if stageNum == Config.MAX_STAGES then return startPos end -- End of generation
    
    local currentPos = startPos
    local numObstacles = math.floor(3 + (difficulty * 3))
    local gapDistance = 12 + (difficulty * 6)
    
    for i = 1, numObstacles do
        currentPos = currentPos + (PATH_DIR * gapDistance)
        
        -- Choose obstacle type based on difficulty and random
        local r = math.random()
        
        if r < 0.2 then
            -- Standard Jump
            createPart(Vector3.new(8, PLATFORM_THICKNESS, 8), currentPos, stageColor, Enum.Material.SmoothPlastic, OBSTACLES_FOLDER)
            
            -- 30% chance for a coin
            if math.random() < 0.3 then
                local coin = createPart(Vector3.new(2, 2, 2), currentPos + Vector3.new(0, 4, 0), Color3.fromRGB(255, 215, 0), Enum.Material.Neon, COINS_FOLDER)
                coin.Shape = Enum.PartType.Cylinder
                coin.Orientation = Vector3.new(0, 0, 90)
                applyScript(coin, "Coin.server.lua")
            end
            
        elseif r < 0.4 then
            -- Kill Brick Jump
            local base = createPart(Vector3.new(10, PLATFORM_THICKNESS, 10), currentPos, stageColor, Enum.Material.SmoothPlastic, OBSTACLES_FOLDER)
            local kb = createPart(Vector3.new(10.2, PLATFORM_THICKNESS/2, 2), currentPos + Vector3.new(0, PLATFORM_THICKNESS, 0), Color3.fromRGB(255, 0, 0), Enum.Material.Neon, OBSTACLES_FOLDER)
            applyScript(kb, "KillBrick.server.lua")
            
        elseif r < 0.6 then
            -- Speed Pad Long Jump
            local pad = createPart(Vector3.new(6, PLATFORM_THICKNESS, 6), currentPos, Color3.fromRGB(0, 255, 0), Enum.Material.Neon, OBSTACLES_FOLDER)
            applyScript(pad, "SpeedPad.server.lua")
            createSign(pad, ">>")
            -- Make the gap after this pad wider
            gapDistance = 25 + (difficulty * 10)
            
        elseif r < 0.8 then
            -- Narrow beam
            createPart(Vector3.new(2, PLATFORM_THICKNESS, gapDistance + 5), currentPos - (PATH_DIR * gapDistance/2), stageColor, Enum.Material.SmoothPlastic, OBSTACLES_FOLDER)
            
        else
            -- Zig Zag
            local offset = (i % 2 == 0) and 8 or -8
            local pos = currentPos + Vector3.new(offset, 0, 0)
            createPart(Vector3.new(6, PLATFORM_THICKNESS, 6), pos, stageColor, Enum.Material.SmoothPlastic, OBSTACLES_FOLDER)
            currentPos = pos -- Update current pos to be off-center
        end
        
        -- Reset gap distance after speed pad
        if gapDistance > 25 then
            gapDistance = 12 + (difficulty * 6)
        end
        
        -- Slight elevation change
        currentPos = currentPos + Vector3.new(0, math.random(-1, 2), 0)
    end
    
    -- Return the start position for the NEXT stage (after the last obstacle)
    return currentPos + (PATH_DIR * gapDistance)
end

-- Generate the whole Obby
local nextPos = START_POS
for stage = 1, Config.MAX_STAGES do
    nextPos = generateStage(stage, nextPos)
end

-- Add initial SpawnLocation
local spawnLoc = Instance.new("SpawnLocation")
spawnLoc.Size = Vector3.new(12, 1, 12)
spawnLoc.Position = START_POS + (PATH_DIR * -15)
spawnLoc.Color = Color3.fromRGB(200, 200, 200)
spawnLoc.Parent = workspace
