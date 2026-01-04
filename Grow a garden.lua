-- LOCAL SCRIPT: Seltene Pflanzen GUI wie Admin Commands (max. 20 Buttons)

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Character
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local hrp = Character:WaitForChild("HumanoidRootPart")

-- RemoteEvent zum Hinzufügen ins Backpack
local pickupEvent = ReplicatedStorage:FindFirstChild("PickupItem")
if not pickupEvent then
    pickupEvent = Instance.new("RemoteEvent")
    pickupEvent.Name = "PickupItem"
    pickupEvent.Parent = ReplicatedStorage
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "RarePlantsGui"
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("ScrollingFrame")
frame.Size = UDim2.new(0,300,0,400)
frame.Position = UDim2.new(0,50,0,50)
frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
frame.CanvasSize = UDim2.new(0,0,0,0)
frame.ScrollBarThickness = 8
frame.Parent = gui

local layout = Instance.new("UIListLayout")
layout.Parent = frame
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0,5)

-- Titel
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,30)
title.Text = "Rare Plants"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.TextScaled = true
title.Parent = frame

-- Minimieren / Maximieren
local btnClose = Instance.new("TextButton")
btnClose.Size = UDim2.new(0,25,0,25)
btnClose.Position = UDim2.new(1,-30,0,5)
btnClose.Text = "X"
btnClose.Parent = frame

local btnOpen = Instance.new("TextButton")
btnOpen.Size = UDim2.new(0,25,0,25)
btnOpen.Position = UDim2.new(1,-30,0,35)
btnOpen.Text = "+"
btnOpen.Parent = frame

btnClose.MouseButton1Click:Connect(function()
    frame.Size = UDim2.new(0,300,0,40)
end)
btnOpen.MouseButton1Click:Connect(function()
    frame.Size = UDim2.new(0,300,0,400)
end)

-- Liste der seltenen Pflanzen (wie im Admin Command System)
local rarePlants = {
    "CandyBlossomSeed",
    "BoneBlossomSeed",
    "SunFlowerSeed",
    "BurnFlowerSeed",
    "GreenAppleSeed"
}

-- Prüfen, ob Objekt selten ist
local function isRarePlant(obj)
    for _, name in ipairs(rarePlants) do
        if obj.Name == name then
            return true
        end
    end
    return false
end

-- Button für Pflanze erstellen
local function addPlantButton(obj)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-10,0,30)
    btn.Text = obj.Name
    btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Parent = frame

    btn.MouseButton1Click:Connect(function()
        if obj:IsA("Tool") then
            pickupEvent:FireServer(obj)
            btn:Destroy()
        else
            warn("Dieses Objekt kann nicht ins Inventar gelegt werden:", obj.Name)
        end
    end)
end

-- Liste aktualisieren (max. 20 Buttons)
local function updateList()
    -- alte Buttons löschen
    for _, child in ipairs(frame:GetChildren()) do
        if child:IsA("TextButton") and child ~= btnClose and child ~= btnOpen then
            child:Destroy()
        end
    end

    local count = 0 -- Zähler für Buttons
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if count >= 20 then break end -- maximal 20 Buttons
        if isRarePlant(obj) then
            addPlantButton(obj)
            count = count + 1
        end
    end

    frame.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
end

-- initial update
updateList()
-- Auto-update bei neuen oder entfernten Pflanzen
Workspace.DescendantAdded:Connect(updateList)
Workspace.DescendantRemoving:Connect(updateList)
