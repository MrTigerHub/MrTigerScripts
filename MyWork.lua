local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- 🔹 Character sicher holen
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local hrp = Character:WaitForChild("HumanoidRootPart")

-- 🔹 Key GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer.PlayerGui

local FrameKey = Instance.new("Frame")
FrameKey.Parent = ScreenGui
FrameKey.Size = UDim2.new(0,200,0,150)
FrameKey.Position = UDim2.new(0,100,0,100)
FrameKey.BackgroundColor3 = Color3.fromRGB(0,0,0)

local SearchBox = Instance.new("TextBox")
SearchBox.Parent = FrameKey
SearchBox.Size = UDim2.new(1,-20,0,40)
SearchBox.Position = UDim2.new(0,10,0,10)
SearchBox.PlaceholderText = "Key eingeben"
SearchBox.Text = ""

local KEY = "BASTI"

-- 🔹 TP Buttons GUI
local FrameTP = Instance.new("Frame")
FrameTP.Parent = ScreenGui
FrameTP.Size = UDim2.new(0,200,0,180)
FrameTP.Position = UDim2.new(0,100,0,260)
FrameTP.BackgroundColor3 = Color3.fromRGB(0,0,0)
FrameTP.Visible = false

local ButtonForward = Instance.new("TextButton")
ButtonForward.Parent = FrameTP
ButtonForward.Size = UDim2.new(1,-20,0,40)
ButtonForward.Position = UDim2.new(0,10,0,10)
ButtonForward.Text = "TP Forward"

local ButtonUp = Instance.new("TextButton")
ButtonUp.Parent = FrameTP
ButtonUp.Size = UDim2.new(1,-20,0,40)
ButtonUp.Position = UDim2.new(0,10,0,60)
ButtonUp.Text = "TP Up"

local ButtonDown = Instance.new("TextButton")
ButtonDown.Parent = FrameTP
ButtonDown.Size = UDim2.new(1,-20,0,40)
ButtonDown.Position = UDim2.new(0,10,0,110)
ButtonDown.Text = "TP Down"

-- 🔑 Key prüfen
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    if SearchBox.Text == KEY then
        FrameKey.Visible = false
        FrameTP.Visible = true
    end
end)

-- 🚀 TP Funktionen
ButtonForward.MouseButton1Click:Connect(function()
    hrp.CFrame = hrp.CFrame * CFrame.new(0,0,-20)
end)

ButtonUp.MouseButton1Click:Connect(function()
    hrp.CFrame = hrp.CFrame * CFrame.new(0,30,0)
end)

ButtonDown.MouseButton1Click:Connect(function()
    hrp.CFrame = hrp.CFrame * CFrame.new(0,-30,0)
end)

-- 🔹 Allowed Objects GUI
local allowedNames = {
    "log",
    "Lost Child",
    "Lost Child2",
    "Lost Child3",
    "Lost Child4",
    "fuel Canister",
    "fuel",
    "Tank Kanister",
    "Coal",
    "Kohle"
}

local FrameLabel = Instance.new("ScrollingFrame")
FrameLabel.Parent = ScreenGui
FrameLabel.Size = UDim2.new(0,200,0,300)
FrameLabel.Position = UDim2.new(0,320,0,100)
FrameLabel.BackgroundColor3 = Color3.fromRGB(50,50,50)
FrameLabel.CanvasSize = UDim2.new(0,0,0,0)
FrameLabel.ScrollBarThickness = 8

local Layout = Instance.new("UIListLayout")
Layout.Parent = FrameLabel
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Padding = UDim.new(0,5)

-- Titel
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = FrameLabel
TitleLabel.Size = UDim2.new(1,0,0,30)
TitleLabel.Position = UDim2.new(0,0,0,0)
TitleLabel.Text = "Allowed Objects"
TitleLabel.TextColor3 = Color3.fromRGB(255,255,255)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextScaled = true
TitleLabel.ZIndex = 2

-- X / + Buttons
local CloseButton = Instance.new("TextButton")
CloseButton.Parent = FrameLabel
CloseButton.Size = UDim2.new(0,25,0,25)
CloseButton.Position = UDim2.new(1,-30,0,5)
CloseButton.Text = "X"
CloseButton.ZIndex = 2

local OpenButton = Instance.new("TextButton")
OpenButton.Parent = FrameLabel
OpenButton.Size = UDim2.new(0,25,0,25)
OpenButton.Position = UDim2.new(1,-30,0,35)
OpenButton.Text = "+"
OpenButton.ZIndex = 2

CloseButton.MouseButton1Click:Connect(function()
    FrameLabel.Size = UDim2.new(0,200,0,40)
end)

OpenButton.MouseButton1Click:Connect(function()
    FrameLabel.Size = UDim2.new(0,200,0,300)
end)

-- 🔹 Case-insensitive Vergleich Funktion
local function stringEqualsIgnoreCase(str1, str2)
    return string.lower(str1) == string.lower(str2)
end

-- 🔹 Liste automatisch aktualisieren (jetzt Buttons mit TP)
local function UpdateList()
    -- Alte Buttons löschen
    for _, child in ipairs(FrameLabel:GetChildren()) do
        if child:IsA("TextButton") and child ~= CloseButton and child ~= OpenButton then
            child:Destroy()
        end
    end

    -- Workspace-Objekte prüfen
    for _, obj in ipairs(Workspace:GetDescendants()) do
        for _, name in ipairs(allowedNames) do
            if stringEqualsIgnoreCase(name, obj.Name) then
                local Button = Instance.new("TextButton")
                Button.Parent = FrameLabel
                Button.Size = UDim2.new(1, -10, 0, 25)
                Button.Text = obj.Name
                Button.TextColor3 = Color3.fromRGB(255,255,255)
                Button.BackgroundColor3 = Color3.fromRGB(80,80,80)
                Button.TextScaled = true

                -- 🟢 Teleport bei Klick
                Button.MouseButton1Click:Connect(function()
                    if obj:IsA("BasePart") then
                        hrp.CFrame = obj.CFrame + Vector3.new(0,5,0)
                    elseif obj:FindFirstChild("HumanoidRootPart") then
                        hrp.CFrame = obj.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
                    end
                end)

                break
            end
        end
    end

    -- ScrollFrame anpassen
    FrameLabel.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 10)
end

-- Liste beim Start erstellen
UpdateList()

-- Automatisch aktualisieren
Workspace.DescendantAdded:Connect(UpdateList)
Workspace.DescendantRemoving:Connect(UpdateList)

