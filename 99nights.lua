local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local CORRECT_KEY = "basti"

function startMainScript()

	print("MAIN SCRIPT GESTARTET") -- DEBUG (SEHR WICHTIG)

	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local UserInputService = game:GetService("UserInputService")
	local LocalPlayer = Players.LocalPlayer
	local Camera = workspace.CurrentCamera

	-- ===== TEST: AIMBOT =====
	local AimbotEnabled = true

	RunService.RenderStepped:Connect(function()
		if not AimbotEnabled then return end
		if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end

		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj:IsA("Model") and obj.Name == "Wolf" then
				local head = obj:FindFirstChild("Head")
				if head then
					Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
					break
				end
			end
		end
	end)

	-- ===== TEST: FLY =====
	local flying = false
	UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.Q then
			flying = not flying
		end
	end)

	RunService.RenderStepped:Connect(function()
		if not flying then return end
		local char = LocalPlayer.Character
		if not char then return end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not hrp then return end
		hrp.Velocity = Camera.CFrame.LookVector * 60
	end)

end



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
		KeyUI:Destroy()
		print("Main script startet")
		task.spawn(startMainScript) -- 🔥 WICHTIG
	else
		TextBox.Text = ""
		TextBox.PlaceholderText = "Falscher Key!"
	end
end)



