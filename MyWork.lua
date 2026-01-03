local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Hauptframe mit ScrollBar
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(0, 300, 0, 400)
ScrollingFrame.Position = UDim2.new(0, 50, 0, 50)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- wird später angepasst
ScrollingFrame.ScrollBarThickness = 10
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ScrollingFrame.Parent = ScreenGui

-- Layout für Buttons
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollingFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- Funktion: Button für ein Model erstellen
local function addModelButton(obj)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, 0) -- Y wird von UIListLayout geregelt
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = obj.Name
    btn.Parent = ScrollingFrame

    -- Klick → teleportieren
    btn.MouseButton1Click:Connect(function()
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local hrp = character.HumanoidRootPart

            -- Pivot oder erste BasePart des Models
            local cf
            if pcall(function() cf = obj:GetPivot() end) then
                -- Pivot erfolgreich
            else
                local part = obj:FindFirstChildWhichIsA("BasePart")
                if part then
                    cf = part.CFrame
                end
            end

            if cf then
                hrp.CFrame = cf + Vector3.new(0, 5, 0) -- etwas über dem Boden
            end
        end
    end)
end

-- Alle bestehenden Models anzeigen
for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("Model") then
        addModelButton(obj)
    end
end

-- CanvasSize automatisch anpassen, wenn Buttons hinzugefügt werden
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end)

-- Neue Models automatisch hinzufügen
workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("Model") then
        addModelButton(obj)
    end
end)


