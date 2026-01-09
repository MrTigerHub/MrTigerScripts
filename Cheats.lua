-- ALLES-IN-EINEM MODELL-CLONER
-- In ServerScriptService einfügen

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- RemoteEvent
local event = Instance.new("RemoteEvent")
event.Name = "CloneModelEvent"
event.Parent = ReplicatedStorage

-- Server: Modell klonen
event.OnServerEvent:Connect(function(player, model)
	if model and model:IsA("Model") and model.PrimaryPart then
		local clone = model:Clone()
		clone.Parent = workspace
		clone:SetPrimaryPartCFrame(model.PrimaryPart.CFrame)
	end
end)

-- GUI erstellen für Spieler
Players.PlayerAdded:Connect(function(player)
	local gui = Instance.new("ScreenGui")
	gui.Name = "ModelClonerGui"
	gui.ResetOnSpawn = false
	gui.Parent = player:WaitForChild("PlayerGui")

	local frame = Instance.new("ScrollingFrame")
	frame.Size = UDim2.new(0, 300, 0, 400)
	frame.Position = UDim2.new(0, 10, 0.5, -200)
	frame.CanvasSize = UDim2.new(0, 0, 0, 0)
	frame.ScrollBarImageTransparency = 0
	frame.Parent = gui

	local layout = Instance.new("UIListLayout")
	layout.Parent = frame

	-- LocalScript
	local localScript = Instance.new("LocalScript")
	localScript.Parent = gui

	localScript.Source = [[
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local event = ReplicatedStorage:WaitForChild("CloneModelEvent")
		local frame = script.Parent:WaitForChild("ScrollingFrame")

		for _, obj in pairs(workspace:GetChildren()) do
			if obj:IsA("Model") and obj.PrimaryPart then
				local btn = Instance.new("TextButton")
				btn.Size = UDim2.new(1, -10, 0, 40)
				btn.Text = obj.Name
				btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
				btn.TextColor3 = Color3.new(1,1,1)
				btn.Parent = frame

				btn.MouseButton1Click:Connect(function()
					event:FireServer(obj)
				end)
			end
		end
	]]
end)
