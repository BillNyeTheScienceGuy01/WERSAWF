-- GREG'S PLAYER-FLYING ADMIN SCRIPT (FIXED VERSION)
-- Select any player from the dropdown and toggle flying force

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- UI SETUP
local gui = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local title = Instance.new("TextLabel")
local dropdown = Instance.new("TextButton")
local dropdownFrame = Instance.new("ScrollingFrame")
local layout = Instance.new("UIListLayout")
local flyButton = Instance.new("TextButton")

-- Globals
local selected = nil

-- GUI SETTINGS
gui.Name = "GregFlyGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = game.CoreGui -- Changed to CoreGui for full visibility

frame.Size = UDim2.new(0, 260, 0, 320)
frame.Position = UDim2.new(0.5, -130, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Parent = gui

-- TITLE
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Greg's Fly Panel"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.Parent = frame

-- DROPDOWN BUTTON
dropdown.Size = UDim2.new(1, -20, 0, 30)
dropdown.Position = UDim2.new(0, 10, 0, 40)
dropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
dropdown.TextColor3 = Color3.new(1, 1, 1)
dropdown.Font = Enum.Font.Gotham
dropdown.Text = "Select Player"
dropdown.Parent = frame

-- SCROLLING FRAME FOR PLAYER LIST
dropdownFrame.Size = UDim2.new(1, -20, 0, 180)
dropdownFrame.Position = UDim2.new(0, 10, 0, 80)
dropdownFrame.CanvasSize = UDim2.new(0, 0, 0, 300)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
dropdownFrame.BorderSizePixel = 0
dropdownFrame.Visible = false
dropdownFrame.ScrollBarThickness = 6
dropdownFrame.Parent = frame

-- LIST LAYOUT
layout.Padding = UDim.new(0, 3)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = dropdownFrame

-- FLY BUTTON
flyButton.Size = UDim2.new(1, -20, 0, 30)
flyButton.Position = UDim2.new(0, 10, 1, -40)
flyButton.Text = "Give/Remove Fly"
flyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
flyButton.TextColor3 = Color3.new(1, 1, 1)
flyButton.Font = Enum.Font.GothamBold
flyButton.TextSize = 18
flyButton.Parent = frame

-- FLY FUNCTIONS
local function makeFly(char)
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if hrp and not hrp:FindFirstChild("GregFlyForce") then
		local bv = Instance.new("BodyVelocity")
		bv.Name = "GregFlyForce"
		bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		bv.Velocity = Vector3.new(0, 25, 0)
		bv.P = 1500
		bv.Parent = hrp
	end
end

local function unFly(char)
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if hrp then
		local force = hrp:FindFirstChild("GregFlyForce")
		if force then force:Destroy() end
	end
end

-- REFRESH PLAYER LIST
local function refreshList()
	dropdownFrame:ClearAllChildren()
	layout.Parent = dropdownFrame
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			local b = Instance.new("TextButton")
			b.Size = UDim2.new(1, 0, 0, 30)
			b.Text = p.Name
			b.TextColor3 = Color3.new(1, 1, 1)
			b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			b.Font = Enum.Font.Gotham
			b.TextSize = 16
			b.Parent = dropdownFrame
			b.MouseButton1Click:Connect(function()
				selected = p
				dropdown.Text = "Selected: " .. p.Name
				dropdownFrame.Visible = false
			end)
		end
	end
end

-- BUTTON LOGIC
flyButton.MouseButton1Click:Connect(function()
	if selected and selected.Character then
		local hrp = selected.Character:FindFirstChild("HumanoidRootPart")
		if hrp and hrp:FindFirstChild("GregFlyForce") then
			unFly(selected.Character)
		else
			makeFly(selected.Character)
		end
	end
end)

dropdown.MouseButton1Click:Connect(function()
	dropdownFrame.Visible = not dropdownFrame.Visible
end)

-- PLAYER LIST LISTENERS
Players.PlayerAdded:Connect(refreshList)
Players.PlayerRemoving:Connect(refreshList)
refreshList()
