local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 🔐 KEY GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0,200,0,300)
Frame.Position = UDim2.new(0,100,0,100)
Frame.BackgroundColor3 = Color3.fromRGB(0,0,0)

local SearchBox = Instance.new("TextBox")
SearchBox.Parent = Frame
SearchBox.Size = UDim2.new(1,-20,0,40)
SearchBox.Position = UDim2.new(0,10,0,10)
SearchBox.PlaceholderText = "Key eingeben"
SearchBox.Text = ""

local KEY = "BASTI"

-- 🚀 BUTTON GUI
local ScreenGuiBT = Instance.new("ScreenGui")
ScreenGuiBT.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGuiBT.Enabled = false

local FrameBT = Instance.new("Frame")
FrameBT.Parent = ScreenGuiBT
FrameBT.Size = UDim2.new(0,200,0,100)
FrameBT.Position = UDim2.new(0,100,0,450)
FrameBT.BackgroundColor3 = Color3.fromRGB(0,0,0)

local Button = Instance.new("TextButton")
Button.Parent = FrameBT
Button.Size = UDim2.new(1,-20,0,40)
Button.Position = UDim2.new(0,10,0,30)
Button.Text = "TP forward"

-- 🔑 Key Check
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
	if SearchBox.Text == KEY then
		ScreenGui.Enabled = false
		ScreenGuiBT.Enabled = true
	end
end)

-- 🚀 Teleport dahin wo du hinschaust (Kamera)
Button.MouseButton1Click:Connect(function()
	local char = LocalPlayer.Character
	if not char then return end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local distance = 50
	local lookDir = Camera.CFrame.LookVector
	local newPos = hrp.Position + lookDir * distance

	hrp.CFrame = CFrame.new(newPos, newPos + lookDir)
end)
