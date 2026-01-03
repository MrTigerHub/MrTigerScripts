local TextLabel = Instance.new("TextLabel")

local text = "Models im Workspace:\n"

for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("Model") then
        text = text .. "- " .. obj.Name .. "\n"
    end
end

TextLabel.Text = text
