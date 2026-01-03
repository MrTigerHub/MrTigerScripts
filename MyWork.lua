-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Suchleiste
local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(0, 300, 0, 30)
SearchBox.Position = UDim2.new(0, 50, 0, 50)
SearchBox.PlaceholderText = "Suche nach Name..."
SearchBox.Text = ""
SearchBox.ClearTextOnFocus = false
SearchBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
SearchBox.TextColor3 = Color3.fromRGB(255,255,255)
SearchBox.Parent = ScreenGui

-- ScrollFrame für Buttons
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(0, 300, 0, 400)
ScrollingFrame.Position = UDim2.new(0, 50, 0, 85)
ScrollingFrame.CanvasSize = UDim2.new(0,0,0,0)
ScrollingFrame.ScrollBarThickness = 10
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ScrollingFrame.Parent = ScreenGui

-- Layout für Buttons
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollingFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0,5)

-- Tabelle für Buttons speichern
local Buttons = {}

-- Funktion: Button für ein NPC erstellen
local function addNPCButton(obj)
    if Buttons[obj] then return end -- schon existiert
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Text = obj.Name
    btn.Parent = ScrollingFrame

    -- Klick → teleportieren
    btn.MouseButton1Click:Connect(function()
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local hrp = character.HumanoidRootPart
            local cf
            if pcall(function() cf = obj:GetPivot() end) then
            else
                local part = obj:FindFirstChildWhichIsA("BasePart")
                if part then cf = part.CFrame end
            end
            if cf then
                hrp.CFrame = cf + Vector3.new(0,5,0)
            end
        end
    end)

    Buttons[obj] = btn
end

-- Alle bestehenden NPCs (Model mit Humanoid) hinzufügen
for _, obj in pairs(Workspace:GetDescendants()) do
    if obj:IsA("Model") and obj:FindFirstChildWhichIsA("Humanoid") then
        addNPCButton(obj)
    end
end

-- CanvasSize automatisch anpassen
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollingFrame.CanvasSize = UDim2.new(0,0,0,UIListLayout.AbsoluteContentSize.Y)
end)

-- Neue NPCs automatisch hinzufügen
Workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("Model") and obj:FindFirstChildWhichIsA("Humanoid") then
        addNPCButton(obj)
    end
end)

-- Suchfunktion: Buttons filtern
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local search = SearchBox.Text:lower()
    for obj, btn in pairs(Buttons) do
        if obj:IsDescendantOf(Workspace) then
            if obj.Name:lower():find(search) then
                btn.Visible = true
            else
                btn.Visible = false
            end
        else
            btn:Destroy()
            Buttons[obj] = nil
        end
    end
end)




