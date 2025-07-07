-- GREG'S PLAYER-FLYING ADMIN SCRIPT
-- Use a dropdown to select anyone in the server and toggle flight for them

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local selected = nil

local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 240, 0, 300)
frame.Position = UDim2.new(0.5, -120, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Greg's Fly Giver"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 20

local dropdown = Instance.new("TextButton", frame)
dropdown.Size = UDim2.new(1, -20, 0, 30)
dropdown.Position = UDim2.new(0, 10, 0, 40)
dropdown.Text = "Select Player"
dropdown.BackgroundColor3 = Color3.fromRGB(50,50,50)
dropdown.TextColor3 = Color3.new(1,1,1)
dropdown.Font = Enum.Font.Gotham

local dropdownFrame = Instance.new("ScrollingFrame", frame)
dropdownFrame.Size = UDim2.new(1, -20, 0, 160)
dropdownFrame.Position = UDim2.new(0, 10, 0, 80)
dropdownFrame.CanvasSize = UDim2.new(0,0,5,0)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
dropdownFrame.Visible = false

local layout = Instance.new("UIListLayout", dropdownFrame)
layout.Padding = UDim.new(0, 2)

local function makeFly(char)
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	local bv = Instance.new("BodyVelocity")
	bv.Name = "GregFlyForce"
	bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	bv.Velocity = Vector3.new(0, 25, 0)
	bv.P = 1000
	bv.Parent = hrp
end

local function unFly(char)
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	local fly = hrp:FindFirstChild("GregFlyForce")
	if fly then fly:Destroy() end
end

local function refreshList()
	dropdownFrame:ClearAllChildren()
	layout.Parent = dropdownFrame
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			local b = Instance.new("TextButton", dropdownFrame)
			b.Size = UDim2.new(1, 0, 0, 25)
			b.Text = p.Name
			b.TextColor3 = Color3.new(1,1,1)
			b.BackgroundColor3 = Color3.fromRGB(40,40,40)
			b.Font = Enum.Font.Gotham
			b.TextSize = 14
			b.MouseButton1Click:Connect(function()
				selected = p
				dropdown.Text = "Selected: "..p.Name
				dropdownFrame.Visible = false
			end)
		end
	end
end

local flyButton = Instance.new("TextButton", frame)
flyButton.Size = UDim2.new(1, -20, 0, 30)
flyButton.Position = UDim2.new(0, 10, 0, 250)
flyButton.Text = "Give/Remove Fly"
flyButton.BackgroundColor3 = Color3.fromRGB(0,150,255)
flyButton.TextColor3 = Color3.new(1,1,1)
flyButton.Font = Enum.Font.GothamBold

flyButton.MouseButton1Click:Connect(function()
	if selected and selected.Character then
		local exists = selected.Character:FindFirstChild("HumanoidRootPart") and selected.Character.HumanoidRootPart:FindFirstChild("GregFlyForce")
		if exists then unFly(selected.Character) else makeFly(selected.Character) end
	end
end)

dropdown.MouseButton1Click:Connect(function()
	dropdownFrame.Visible = not dropdownFrame.Visible
end)

Players.PlayerAdded:Connect(refreshList)
Players.PlayerRemoving:Connect(refreshList)
refreshList()
