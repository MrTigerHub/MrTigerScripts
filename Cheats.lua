-- EINZIGES LocalScript: Modell-Kloner
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- RemoteEvent erstellen, falls noch nicht
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local event = ReplicatedStorage:FindFirstChild("CloneModelEvent")
if not event then
	event = Instance.new("RemoteEvent")
	event.Name = "CloneModelEvent"
	event.Parent = ReplicatedStorage
end

-- Server-Listener (wird nur einmal automatisch gesetzt)
if not event:FindFirstChild("ServerListener") then
	local s = Instance.new("BindableEvent")
	s.Name = "ServerListener"
	s.Parent = event
	event.OnServerEvent:Connect(function(playerFired, model)
		if model and model:IsA("Model") and model.PrimaryPart then
			local clone = model:Clone()
			clone.Parent = Workspace
			clone:SetPrimaryPartCFrame(model.PrimaryPart.CFrame)
		end
	end)
end

-- Funktion: ClickDetector an jedem Modell
local function setupModel(model)
	if not model:IsA("Model") then return end
	if not model.PrimaryPart then return end

	local part = model.PrimaryPart
	local click = part:FindFirstChildOfClass("ClickDetector")
	if not click then
		click = Instance.new("ClickDetector")
		click.MaxActivationDistance = 32
		click.Parent = part
	end

	click.MouseClick:Connect(function()
		-- Klone das Modell via RemoteEvent
		event:FireServer(model)
	end)
end

-- Bestehende Modelle
for _, obj in pairs(Workspace:GetChildren()) do
	setupModel(obj)
end

-- Neue Modelle
Workspace.ChildAdded:Connect(setupModel)

