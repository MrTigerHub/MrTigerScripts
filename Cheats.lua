-- INVENTORY GUI – ALLES AUTOMATISCH

local player = game.Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "InventoryGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0, 20, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Ecken
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- Titel
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "🎒 Inventar"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 24
title.Parent = frame

-- ScrollingFrame
local listFrame = Instance.new("ScrollingFrame")
listFrame.Position = UDim2.new(0, 0, 0, 40)
listFrame.Size = UDim2.new(1, 0, 1, -40)
listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
listFrame.ScrollBarImageTransparency = 0.3
listFrame.BackgroundTransparency = 1
listFrame.BorderSizePixel = 0
listFrame.Parent = frame

-- Layout
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.Parent = listFrame

-- Padding
local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 6)
padding.PaddingLeft = UDim.new(0, 6)
padding.PaddingRight = UDim.new(0, 6)
padding.Parent = listFrame

-- Alte Items löschen
local function clearItems()
	for _, child in pairs(listFrame:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end
end

-- Inventar updaten
local function updateInventory()
	clearItems()

	for _, tool in pairs(backpack:GetChildren()) do
		if tool:IsA("Tool") then
			local button = Instance.new("TextButton")
			button.Size = UDim2.new(1, -10, 0, 35)
			button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			button.TextColor3 = Color3.fromRGB(255, 255, 255)
			button.Text = tool.Name
			button.Font = Enum.Font.SourceSans
			button.TextSize = 18
			button.AutoButtonColor = true
			button.Parent = listFrame

			local btnCorner = Instance.new("UICorner")
			btnCorner.CornerRadius = UDim.new(0, 8)
			btnCorner.Parent = button

			-- OPTIONAL: Tool equippen beim Klicken
			button.MouseButton1Click:Connect(function()
				player.Character.Humanoid:EquipTool(tool)
			end)
		end
	end

	-- Canvas anpassen
	task.wait()
	listFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end

-- Events
backpack.ChildAdded:Connect(updateInventory)
backpack.ChildRemoved:Connect(updateInventory)

-- Start
updateInventory()
