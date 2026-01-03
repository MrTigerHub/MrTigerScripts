local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 400)
Frame.Position = UDim2.new(0, 50, 0, 50)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Parent = ScreenGui

local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(1, -10, 1, -10)
TextLabel.Position = UDim2.new(0, 5, 0, 5)
TextLabel.BackgroundTransparency = 1
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextWrapped = true
TextLabel.TextScaled = false
TextLabel.TextYAlignment = Enum.TextYAlignment.Top
TextLabel.Parent = Frame

-- Text füllen
local text = "Models im Workspace:\n"
for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("Model") then
        text = text .. "- " .. obj.Name .. "\n"
    end
end
TextLabel.Text = text

