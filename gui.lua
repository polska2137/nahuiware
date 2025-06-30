--[[
    One Script Setup:
    - Create RemoteEvents in ReplicatedStorage
    - Server-side anti-hit
    - Inject LocalScript into each player for GUI + fly + noclip + inputs
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Create RemoteEvents (only if not exist)
local toggleFlyEvent = ReplicatedStorage:FindFirstChild("ToggleFly")
if not toggleFlyEvent then
    toggleFlyEvent = Instance.new("RemoteEvent")
    toggleFlyEvent.Name = "ToggleFly"
    toggleFlyEvent.Parent = ReplicatedStorage
end

local toggleNoclipEvent = ReplicatedStorage:FindFirstChild("ToggleNoclip")
if not toggleNoclipEvent then
    toggleNoclipEvent = Instance.new("RemoteEvent")
    toggleNoclipEvent.Name = "ToggleNoclip"
    toggleNoclipEvent.Parent = ReplicatedStorage
end

-- Server-side player state storage
local states = {}

-- Server-side anti-hit logic
Players.PlayerAdded:Connect(function(player)
    states[player.UserId] = { flying = false, noclip = false }

    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        local userId = player.UserId

        humanoid.HealthChanged:Connect(function(newHealth)
            local state = states[userId]
            if state and (state.flying or state.noclip) then
                if newHealth < humanoid.MaxHealth then
                    humanoid.Health = humanoid.MaxHealth
                end
            end
        end)
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    states[player.UserId] = nil
end)

-- Update player states from client
toggleFlyEvent.OnServerEvent:Connect(function(player, state)
    if states[player.UserId] then
        states[player.UserId].flying = state
    end
end)

toggleNoclipEvent.OnServerEvent:Connect(function(player, state)
    if states[player.UserId] then
        states[player.UserId].noclip = state
    end
end)

-- Client LocalScript code as a string
local clientScriptSource = [[
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

local toggleFlyEvent = ReplicatedStorage:WaitForChild("ToggleFly")
local toggleNoclipEvent = ReplicatedStorage:WaitForChild("ToggleNoclip")

local flying = false
local noclip = false
local flySpeed = 75

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlyNoclipGui"
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local function createButton(text, pos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 140, 0, 45)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(30,30,40)
    btn.BorderSizePixel = 0
    btn.TextColor3 = Color3.fromRGB(200,200,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 22
    btn.Text = text .. " OFF"
    btn.AutoButtonColor = true
    btn.ZIndex = 2
    btn.ClipsDescendants = false
    btn.AnchorPoint = Vector2.new(0,0)
    btn.Name = text .. "Button"
    return btn
end

local flyButton = createButton("Fly", UDim2.new(0, 20, 0, 20))
local noclipButton = createButton("Noclip", UDim2.new(0, 20, 0, 80))

flyButton.Parent = ScreenGui
noclipButton.Parent = ScreenGui

local bodyVelocity = Instance.new("BodyVelocity")
bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
bodyVelocity.P = 3000
bodyVelocity.Velocity = Vector3.new(0,0,0)

local function updateButton(btn, state)
    if state then
        btn.Text = btn.Name:gsub("Button","") .. " ON"
        btn.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
    else
        btn.Text = btn.Name:gsub("Button","") .. " OFF"
        btn.BackgroundColor3 = Color3.fromRGB(30,30,40)
        btn.TextColor3 = Color3.fromRGB(200,200,255)
    end
end

local function setFly(state)
    flying = state
    updateButton(flyButton, flying)
    if flying then
        bodyVelocity.Parent = hrp
        humanoid.PlatformStand = true
    else
        bodyVelocity.Parent = nil
        humanoid.PlatformStand = false
        hrp.Velocity = Vector3.new(0,0,0)
    end
    toggleFlyEvent:FireServer(flying)
end

local function setNoclip(state)
    noclip = state
    updateButton(noclipButton, noclip)
    toggleNoclipEvent:FireServer(noclip)
end

flyButton.MouseButton1Click:Connect(function()
    setFly(not flying)
end)

noclipButton.MouseButton1Click:Connect(function()
    setNoclip(not noclip)
end)

RunService.Heartbeat:Connect(function()
    if flying then
        local moveVec = Vector3.new()
        local camCFrame = workspace.CurrentCamera.CFrame

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveVec += camCFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveVec -= camCFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveVec -= camCFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveVec += camCFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.E) then
            moveVec += Vector3.new(0,1,0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
            moveVec -= Vector3.new(0,1,0)
        end

        if moveVec.Magnitude > 0 then
            moveVec = moveVec.Unit * flySpeed
        end

        bodyVelocity.Velocity = moveVec
    end

    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = not noclip
        end
    end
end)

player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = character:WaitForChild("Humanoid")
    hrp = character:WaitForChild("HumanoidRootPart")

    if flying then
        setFly(true)
    end
    if noclip then
        setNoclip(true)
    end
end)
]]

-- Function to inject client script to player
local function injectLocalScript(player)
    local playerScripts = player:WaitForChild("PlayerScripts")
    -- Remove old one if exists
    for _, child in pairs(playerScripts:GetChildren()) do
        if child.Name == "FlyNoclipLocalScript" then
            child:Destroy()
        end
    end

    local localScript = Instance.new("LocalScript")
    localScript.Name = "FlyNoclipLocalScript"
    localScript.Source = clientScriptSource
    localScript.Parent = playerScripts
end

Players.PlayerAdded:Connect(function(player)
    injectLocalScript(player)
end)

-- For players already in game (in case script added while running)
for _, player in pairs(Players:GetPlayers()) do
    injectLocalScript(player)
end
