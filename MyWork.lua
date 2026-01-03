local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 400)
Frame.Position = UDim2.new(0, 50, 0, 50)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Parent = ScreenGui

-- Layout für Buttons
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Frame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- Funktion: Button für jedes Model erstellen
for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("Model") then
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 30)
        btn.Position = UDim2.new(0, 5, 0, 0)  -- UIListLayout regelt Y
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Text = obj.Name
        btn.Parent = Frame

        -- Klick → teleportieren
        btn.MouseButton1Click:Connect(function()
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local hrp = character.HumanoidRootPart

                -- Versuche Pivot des Models zu nehmen, sonst erste BasePart
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
                    -- Teleport + ein bisschen über dem Boden
                    hrp.CFrame = cf + Vector3.new(0, 5, 0)
                end
            end
        end)
    end
end

