local Library = loadstring(game:HttpGet("https://github.com/kirby-lol/lua/raw/refs/heads/main/ui-library/kirby/main.lua"))()

local Window = Library:CreateWindow({
    Title = "Kirby.lol",
    Icon = "rbxassetid://17376881029",
})

local Tabs = {
    Main = Library:AddTab(Window, {Game = "Main"}),
    Teleport = Library:AddTab(Window, {Game = "Teleport"})
}

local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Wait for character to load
local function getHumanoidRootPart()
    local character = Player.Character or Player.CharacterAdded:Wait()
    return character:WaitForChild("HumanoidRootPart")
end

local HumanoidRootPart = getHumanoidRootPart()

-- Flags
local autoFarmEnabled = false
local autoAttackEnabled = false
local autoSkillsEnabled = false
local attacking = false
local skills = false

-- Skill timing
local skillTimer = 0
local skillStep = 1

-- Update logic
local function updateAttackState()
    attacking = autoFarmEnabled and autoAttackEnabled
end

local function updateSkillsState()
    skills = autoFarmEnabled and autoSkillsEnabled
end

-- UI Toggles
Library:AddToggle(Tabs.Main, {
    Title = "Auto Farm",
    Callback = function(state)
        autoFarmEnabled = state
        updateAttackState()
        updateSkillsState()
    end
})

Library:AddToggle(Tabs.Main, {
    Title = "Auto Attack",
    Callback = function(state)
        autoAttackEnabled = state
        updateAttackState()
    end
})

Library:AddToggle(Tabs.Main, {
    Title = "Auto Skills",
    Callback = function(state)
        autoSkillsEnabled = state
        skillTimer = 0
        skillStep = 1
        updateSkillsState()
    end
})

-- Input functions
local function clickCenter(x, y)
    task.spawn(function()
        if UserInputService.TouchEnabled then
            VirtualInputManager:SendTouchEvent(x, y, 0, true, game)
            task.wait(0.05)
            VirtualInputManager:SendTouchEvent(x, y, 0, false, game)
        else
            VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
            task.wait(0.05)
            VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
        end
    end)
end

local function clickMobileAttack()
    local playerGui = Player:FindFirstChild("PlayerGui")
    local mobileGui = playerGui and playerGui:FindFirstChild("Mobile")

    if not mobileGui then return false end

    local attackButton = mobileGui:FindFirstChild("Attack")
    if not (attackButton and (attackButton:IsA("ImageButton") or attackButton:IsA("TextButton"))) then return false end
    if not attackButton.Visible then return false end

    -- Ensure UI is rendered
    task.wait(0.15)

    local absPos = attackButton.AbsolutePosition
    local absSize = attackButton.AbsoluteSize
    local centerX = absPos.X + absSize.X / 2
    local centerY = absPos.Y + absSize.Y / 2

    VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 0)
    task.wait(0.05)
    VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 0)

    return true
end

local function pressKey(key)
    VirtualInputManager:SendKeyEvent(true, key, false, game)
    VirtualInputManager:SendKeyEvent(false, key, false, game)
end

-- AutoFarm logic
local mobFolder = workspace:WaitForChild("Enemy"):WaitForChild("Mob")
local currentMob = nil

local function getRandomMob()
    local mobs = mobFolder:GetChildren()
    if #mobs > 0 then
        return mobs[math.random(1, #mobs)]
    end
    return nil
end
-- Detect device type once
local isMobile = UserInputService.TouchEnabled
print("Device Detected:", isMobile and "Mobile" or "PC")

RunService.RenderStepped:Connect(function(dt)
    if autoFarmEnabled then
        if not currentMob or not currentMob:IsDescendantOf(mobFolder) then
            currentMob = getRandomMob()
        end

        if currentMob and currentMob:FindFirstChild("HumanoidRootPart") and HumanoidRootPart then
            local mobHRP = currentMob.HumanoidRootPart
            local backPosition = mobHRP.CFrame * CFrame.new(0, 0, 10)
            HumanoidRootPart.CFrame = CFrame.new(backPosition.Position, mobHRP.Position)

            -- Perform attack based on device
            if autoAttackEnabled then
                if isMobile then
                    clickMobileAttack()
                else
                    local viewport = workspace.CurrentCamera.ViewportSize
                    local x = viewport.X / 2
                    local y = viewport.Y / 2
                    clickCenter(x, y)
                end
            end
        end
    else
        currentMob = nil
    end

    if attacking then
        if isMobile then
            clickMobileAttack()
        else
            local viewport = workspace.CurrentCamera.ViewportSize
            local x = viewport.X / 2
            local y = viewport.Y / 2
            clickCenter(x, y)
        end
    end

    if skills then
        skillTimer = skillTimer + dt

        if skillStep == 1 and skillTimer >= 0.1 then
            pressKey("Z")
            skillStep = 2
            skillTimer = 0
        elseif skillStep == 2 and skillTimer >= 0.1 then
            pressKey("X")
            skillStep = 3
            skillTimer = 0
        elseif skillStep == 3 and skillTimer >= 0.1 then
            pressKey("C")
            skillStep = 1
            skillTimer = 0
        end
    else
        skillTimer = 0
        skillStep = 1
    end
end)


return Library
