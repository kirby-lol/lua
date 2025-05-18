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
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")



local autoFarmEnabled = false
local autoAttackEnabled = false
local autoSkillsEnabled = false

local attacking = false
local skills = false


local skillTimer = 0
local skillStep = 1

local function updateAttackState()
    attacking = autoFarmEnabled and autoAttackEnabled
end

local function updateskillsState()
    skills = autoFarmEnabled and autoSkillsEnabled
end

Library:AddToggle(Tabs.Main, {
    Title = "Auto Farm",
    Callback = function(state)
        autoFarmEnabled = state
        updateAttackState()
        updateskillsState()
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
        updateskillsState()
    end
})

local function tapOnUI(guiObject)
    if not guiObject or not guiObject:IsA("GuiObject") then return end

    local absPos = guiObject.AbsolutePosition
    local absSize = guiObject.AbsoluteSize
    local centerX = absPos.X + absSize.X / 2
    local centerY = absPos.Y + absSize.Y / 2

    VirtualInputManager:SendTouchEvent(Enum.UserInputType.Touch, 0, {
        [1] = Vector2.new(centerX, centerY)
    }, true, game)
    task.wait(0.05)
    VirtualInputManager:SendTouchEvent(Enum.UserInputType.Touch, 0, {
        [1] = Vector2.new(centerX, centerY)
    }, false, game)
end

-- Function to simulate clicking attack
local function clickCenter()
    if UserInputService.TouchEnabled then
        local attackButton = Player:WaitForChild("PlayerGui"):FindFirstChild("Mobile")
        if attackButton and attackButton:FindFirstChild("Attack") then
            local attackUI = attackButton.Attack

            if attackUI:IsA("ImageButton") or attackUI:IsA("TextButton") then
                tapOnUI(attackUI)
            end
        end
    else
        -- PC fallback (center screen click)
        local viewport = workspace.CurrentCamera.ViewportSize
        local x = viewport.X / 2
        local y = viewport.Y / 2

        spawn(function()
            VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
            task.wait(0.05)
            VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
        end)
    end
end

-- Simulate key presses
local function pressKey(key)
    VirtualInputManager:SendKeyEvent(true, key, false, game)
    VirtualInputManager:SendKeyEvent(false, key, false, game)
end

local mobFolder = workspace:WaitForChild("Enemy"):WaitForChild("Mob")
local currentMob = nil

local function getRandomMob()
    local mobs = mobFolder:GetChildren()
    if #mobs == 0 then return nil end
    return mobs[math.random(1, #mobs)]
end

RunService.RenderStepped:Connect(function(dt)
    if autoFarmEnabled then
        if not currentMob or not currentMob:IsDescendantOf(mobFolder) then
            currentMob = getRandomMob()
        end

        if currentMob and currentMob:FindFirstChild("HumanoidRootPart") and HumanoidRootPart then
            local mobHRP = currentMob.HumanoidRootPart
            local backPosition = mobHRP.CFrame * CFrame.new(0, 0, 10)
            HumanoidRootPart.CFrame = CFrame.new(backPosition.Position, mobHRP.Position)
        end
    else
        currentMob = nil
    end

    if attacking then
        clickCenter()
    end

    if skills then
        skillTimer = skillTimer + dt

        if skillStep == 1 then
            pressKey("Z")
            skillStep = 2
            skillTimer = 0
        elseif skillStep == 2 then
            pressKey("X")
            skillStep = 3
            skillTimer = 0
        elseif skillStep == 3 then
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
