-- LOCAL SCRIPT: Pflanzen/Samen ins Inventar

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Character
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local hrp = Character:WaitForChild("HumanoidRootPart")

-- RemoteEvent zum Hinzufügen von Items ins Backpack
local pickupEvent = ReplicatedStorage:FindFirstChild("PickupItem")
if not pickupEvent then
    pickupEvent = Instance.new("RemoteEvent")
    pickupEvent.Name = "PickupItem"
    pickupEvent.Parent = ReplicatedStorage
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "PlantPickupGui"
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
title.Text = "Seeds & Plants"
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

-- Funktion um Button für ein Item zu erstellen
local function addPlantButton(obj)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-10,0,30)
    btn.Text = obj.Name
    btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Parent = frame

    btn.MouseButton1Click:Connect(function()
        -- Prüfen ob Tool, dann ins Backpack
        if obj:IsA("Tool") then
            pickupEvent:FireServer(obj)
            btn:Destroy()
        else
            warn("Dieses Objekt kann nicht ins Inventar gelegt werden:", obj.Name)
        end
    end)
end

-- Prüfen ob Objekt Pflanzen/Seed ist
local function isPlant(obj)
    local name = obj.Name:lower()
    return name:find("plant") or name:find("seed") or name:find("flower") or name:find("sapling")
end

-- Liste aktualisieren
local function updateList()
    for _, child in ipairs(frame:GetChildren()) do
        if child:IsA("TextButton") and child ~= btnClose and child ~= btnOpen then
            child:Destroy()
        end
    end

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if isPlant(obj) then
            addPlantButton(obj)
        end
    end

    frame.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
end

updateList()
Workspace.DescendantAdded:Connect(updateList)
Workspace.DescendantRemoving:Connect(updateList)
