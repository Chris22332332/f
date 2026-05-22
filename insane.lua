-- =============================================
-- INSANE CHAOS SCRIPT v2.1
-- For Roblox Executors
-- =============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

-- Settings
local config = {
    Speed = 120,
    JumpPower = 350,
    FlySpeed = 160,
    ChaosAmount = 120
}

-- God Mode
humanoid.MaxHealth = 9e9
humanoid.Health = 9e9
humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)

humanoid.WalkSpeed = config.Speed
humanoid.JumpPower = config.JumpPower

-- Noclip
local noclipEnabled = false
RunService.Stepped:Connect(function()
    if noclipEnabled and character then
        for _, v in pairs(character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- Fly System
local flying = false
local bodyVelocity = Instance.new("BodyVelocity")
local bodyGyro = Instance.new("BodyGyro")

bodyGyro.P = 90000
bodyGyro.MaxTorque = Vector3.new(90000, 90000, 90000)
bodyVelocity.MaxForce = Vector3.new(90000, 90000, 90000)

local function startFlying()
    if flying then return end
    flying = true
    bodyVelocity.Parent = root
    bodyGyro.Parent = root

    task.spawn(function()
        while flying and character and character.Parent do
            local camera = Workspace.CurrentCamera
            local direction = Vector3.new()

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction += camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction -= camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction -= camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction += camera.CFrame.RightVector end

            bodyVelocity.Velocity = direction.Magnitude > 0 and direction.Unit * config.FlySpeed or Vector3.new()
            bodyGyro.CFrame = camera.CFrame
            task.wait()
        end
    end)
end

local function stopFlying()
    flying = false
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
end

-- Kill All
local function killAll()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("Humanoid") then
            plr.Character.Humanoid.Health = 0
        end
    end
end

-- Chaos Spam
local function spawnChaos()
    for i = 1, config.ChaosAmount do
        local part = Instance.new("Part")
        part.Size = Vector3.new(math.random(8, 35), math.random(8, 35), math.random(8, 35))
        part.Color = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
        part.Position = root.Position + Vector3.new(math.random(-80,80), math.random(60,180), math.random(-80,80))
        part.Anchored = false
        part.CanCollide = true
        part.Parent = Workspace
        part.Velocity = Vector3.new(math.random(-250,250), math.random(150,400), math.random(-250,250))
    end
end

-- Keybinds
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.F then
        noclipEnabled = not noclipEnabled
        print("Noclip:", noclipEnabled)
        
    elseif input.KeyCode == Enum.KeyCode.G then
        flying = not flying
        if flying then startFlying() else stopFlying() end
        print("Fly:", flying)
        
    elseif input.KeyCode == Enum.KeyCode.H then
        killAll()
        print("Killed all players")
        
    elseif input.KeyCode == Enum.KeyCode.J then
        spawnChaos()
        print("CHAOS SPAWNED!")
        
    elseif input.KeyCode == Enum.KeyCode.K then
        config.Speed += 30
        humanoid.WalkSpeed = config.Speed
        print("Speed increased to:", config.Speed)
    end
end)

print("🔥 INSANE SCRIPT LOADED 🔥")
print("F = Noclip | G = Fly | H = Kill All | J = Chaos Spam | K = Speed Boost")
