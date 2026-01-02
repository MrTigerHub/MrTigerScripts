local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local CORRECT_KEY = "basti"
local keyAccepted = false


local KeyUI = Instance.new("ScreenGui")
KeyUI.Name = "KeyUI"
KeyUI.ResetOnSpawn = false
KeyUI.Parent = PlayerGui

local Frame = Instance.new("Frame", KeyUI)
Frame.Size = UDim2.new(0, 300, 0, 150)
Frame.Position = UDim2.new(0.5, -150, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.BorderSizePixel = 0
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,12)

local BastiHub = Instance.new("TextLabel")
BastiHub.Parent = Frame
BastiHub.Size = UDim2.new(1, -20, 0, 25)
BastiHub.Position = UDim2.new(0, 10, 0, -5)
BastiHub.BackgroundTransparency = 1
BastiHub.Text = "MrTigerHub"
BastiHub.TextColor3 = Color3.fromRGB(255, 255, 255)
BastiHub.TextScaled = true
BastiHub.Font = Enum.Font.GothamBold

local TextBox = Instance.new("TextBox", Frame)
TextBox.Size = UDim2.new(1, -20, 0, 40)
TextBox.Position = UDim2.new(0, 10, 0, 20)
TextBox.PlaceholderText = "Key eingeben..."
TextBox.Text = ""
TextBox.ClearTextOnFocus = false
TextBox.BackgroundColor3 = Color3.fromRGB(45,45,45)
TextBox.TextColor3 = Color3.new(1,1,1)

local Button = Instance.new("TextButton", Frame)
Button.Size = UDim2.new(1, -20, 0, 40)
Button.Position = UDim2.new(0, 10, 0, 80)
Button.Text = "Enter"
Button.BackgroundColor3 = Color3.fromRGB(255,85,0)
Button.TextColor3 = Color3.new(1,1,1)


Button.MouseButton1Click:Connect(function()
	if TextBox.Text == CORRECT_KEY then
		keyAccepted = true
		KeyUI:Destroy()
	else
		TextBox.Text = ""
		TextBox.PlaceholderText = "Falscher Key!"
	end
end)

repeat task.wait() until keyAccepted

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- =====================
-- ITEM ESP LISTE
-- =====================
local teleportTargets = {
    "Raygun",
    "Revolver",
    "Revolver Ammo",
    "Rifle",
    "Rifle Ammo",
    "Riot Shield",
    "Sapling",
    "Seed Box",
    "Sheet Metal",
    "Spear",
    "Steak",
    "Stronghold Diamond Chest",
    "Tyre",
    "UFO Component",
    "UFO Junk",
    "Washing Machine",
    "Wolf",
    "Wolf Corpse",
    "Wolf Pelt"
}

-- =====================
-- AIMBOT TARGETS
-- =====================
local AimbotTargets = {
    "Alien",
    "Alpha Wolf",
    "Wolf",
    "Crossbow Cultist",
    "Cultist",
    "Bunny",
    "Bear",
    "Polar Bear"
}

-- =====================
-- SETTINGS
-- =====================
local espEnabled = false
local npcESPEnabled = false
local AimbotEnabled = false
local smoothness = 0.2
local aimbotCheckInterval = 0.02
local lastAimbotCheck = 0

-- =====================
-- ITEM ESP FUNCTION
-- =====================
local function createESP(item)
    if item:FindFirstChild("ESP_Billboard") then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Billboard"
    billboard.Size = UDim2.new(0, 100, 0, 40)
    billboard.AlwaysOnTop = true
    billboard.Adornee = item
    billboard.Parent = item

    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = item.Name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0
    label.TextScaled = true

    if not item:FindFirstChild("ESP_Highlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_Highlight"
        highlight.FillColor = Color3.fromRGB(255, 85, 0)
        highlight.OutlineColor = Color3.fromRGB(0, 100, 0)
        highlight.FillTransparency = 0.25
        highlight.OutlineTransparency = 0
        highlight.Parent = item
    end
end

-- =====================
-- AIMBOT LOGIC
-- =====================
RunService.RenderStepped:Connect(function()
    if not AimbotEnabled then return end
    if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end

    if tick() - lastAimbotCheck < aimbotCheckInterval then return end
    lastAimbotCheck = tick()

    local mousePos = UserInputService:GetMouseLocation()
    local closestTarget
    local shortestDistance = math.huge

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and table.find(AimbotTargets, obj.Name) then
            local head = obj:FindFirstChild("Head")
            if head then
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < shortestDistance then
                        shortestDistance = dist
                        closestTarget = head
                    end
                end
            end
        end
    end

    if closestTarget then
        local currentCF = Camera.CFrame
        local targetCF = CFrame.new(Camera.CFrame.Position, closestTarget.Position)
        Camera.CFrame = currentCF:Lerp(targetCF, smoothness)
    end
end)

-- =====================
-- FLY LOGIC
-- =====================
local flying = false
local flySpeed = 60
local flyConnection

local function toggleFly(state)
    flying = state

    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end

    if flying then
        flyConnection = RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            local move = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move -= Vector3.new(0,1,0) end

            hrp.Velocity = move.Unit * flySpeed
        end)
    end
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Q then
        toggleFly(not flying)
    end
end)

