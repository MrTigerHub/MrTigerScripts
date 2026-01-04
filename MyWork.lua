local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Character sicher holen
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local hrp = Character:WaitForChild("HumanoidRootPart")

-- 🔐 KEY GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer.PlayerGui

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0,200,0,300)
Frame.Position = UDim2.new(0,100,0,100)
Frame.BackgroundColor3 = Color3.fromRGB(0,0,0)

local SearchBox = Instance.new("TextBox")
SearchBox.Parent = Frame
SearchBox.Size = UDim2.new(1,-20,0,40)
SearchBox.Position = UDim2.new(0,10,0,10)
SearchBox.Text = ""
SearchBox.PlaceholderText = "Key eingeben"

local KEY = "BASTI"

-- 🚀 BUTTON GUI
local ScreenGuiBT = Instance.new("ScreenGui")
ScreenGuiBT.Parent = LocalPlayer.PlayerGui
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

local ButtonUP = Instance.new("TextButton")
ButtonUP.Parent = FrameBT
ButtonUP.Size = UDim2.new(1, -20,0,40)
ButtonUP.Position = UDim2.new(0,10,0,80)
ButtonUP.Text = "TP Up"
ButtonUP.MouseButton1Click:Connect(function()
       hrp.CFrame = hrp.CFrame * CFrame.new(0, 30, 0)
end       


local ButtonDown = Instance.new("TextButton")
ButtonDown.Parent = FrameBT
ButtonDown.Size = UDim2.new(1, -20,0,40)
ButtonDown.Position = UDim2.new(0,10,0,120)
ButtonDown.Text = "TP Down"
ButtonDown.MouseButton1Click:Connect(function()
       hrp.CFrame = hrp.CFrame * CFrame.new(0, -30, 0)
end       

-- 🔑 Key prüfen (RICHTIG!)
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
	if SearchBox.Text == KEY then
		Frame.Visible = false
		ScreenGuiBT.Enabled = true
	end
end)

-- 🚀 TP nach vorne
Button.MouseButton1Click:Connect(function()
	hrp.CFrame = hrp.CFrame * CFrame.new(0,0,-20)
end)


