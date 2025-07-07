local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Setup GUI
local gui = Instance.new("ScreenGui")
gui.Name = "GregFlyGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 320)
frame.Position = UDim2.new(0.5, -130, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Greg's Fly Panel"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.Parent = frame

local dropdown = Instance.new("TextButton")
dropdown.Size = UDim2.new(1, -20, 0, 30)
dropdown.Position = UDim2.new(0, 10, 0, 40)
dropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
dropdown.TextColor3 = Color3.new(1, 1, 1)
dropdown.Font = Enum.Font.Gotham
dropdown.Text = "Select Player"
dropdown.Parent = frame

local dropdownFrame = Instance.new("ScrollingFrame")
dropdownFrame.Size = UDim2.new(1, -20, 0, 180)
dropdownFrame.Position = UDim2.new(0, 10, 0, 80)
dropdownFrame.CanvasSize = UDim2.new(0, 0, 0, 300)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
dropdownFrame.BorderSizePixel = 0
dropdownFrame.Visible = false
dropdownFrame.ScrollBarThickness = 6
dropdownFrame.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 3)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = dropdownFrame

local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(1, -20, 0, 30)
flyButton.Position = UDim2.new(0, 10, 1, -40)
flyButton.Text = "Give/Remove Fly"
flyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
flyButton.TextColor3 = Color3.new(1, 1, 1)
flyButton.Font = Enum.Font.GothamBold
flyButton.TextSize = 18
flyButton.Parent = frame

local selected = nil

local function refreshList()
    dropdownFrame:ClearAllChildren()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.Text = p.DisplayName .. " (" .. p.Name .. ")"
            btn.TextColor3 = Color3.new(1,1,1)
            btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 16
            btn.Parent = dropdownFrame

            btn.MouseButton1Click:Connect(function()
                selected = p
                dropdown.Text = "Selected: " .. p.DisplayName
                dropdownFrame.Visible = false
            end)
        end
    end
    -- Update CanvasSize after populating
    dropdownFrame.CanvasSize = UDim2.new(0,0,0,#Players:GetPlayers()*33)
end

local function makeFly(char)
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp and not hrp:FindFirstChild("GregFlyForce") then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "GregFlyForce"
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bv.P = 1500
        bv.Velocity = Vector3.new(0, 25, 0)
        bv.Parent = hrp
    end
end

local function unFly(char)
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        local force = hrp:FindFirstChild("GregFlyForce")
        if force then
            force:Destroy()
        end
    end
end

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

Players.PlayerAdded:Connect(refreshList)
Players.PlayerRemoving:Connect(refreshList)

-- Initial list fill after a slight wait for players to load
task.spawn(function()
    task.wait(1)
    refreshList()
end)
