local function pixelsToScale(pxX, pxY)
    local screenSize = workspace.CurrentCamera.ViewportSize
    local scaleX = pxX / screenSize.X
    local scaleY = pxY / screenSize.Y
    return UDim2.new(scaleX, 0, scaleY, 0)
end

local SearcherUILibrary = {}


function SearcherUILibrary:CreateWindow(config)
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local player = game.Players.LocalPlayer



local dragging
local dragInput
local dragStart
local startPos

-- Create the Frame
local pingfps = Instance.new("Frame", ScreenGui)
pingfps.BackgroundColor3 = Color3.fromRGB(251, 111, 146)
pingfps.AnchorPoint = Vector2.new(1, 0)
pingfps.Position = UDim2.new(1, -10, 0, 10)
pingfps.BackgroundTransparency = 0.1
pingfps.BorderSizePixel = 0
pingfps.Size = UDim2.new(0.09, 0, 0.03, 0)

local pingfpsPadding = Instance.new("UIPadding", pingfps)
pingfpsPadding.PaddingLeft = UDim.new(0, 3)

local pingfpsCorners = Instance.new("UICorner")
pingfpsCorners.CornerRadius = UDim.new(0, 5)
pingfpsCorners.Parent = pingfps

local icon = Instance.new("ImageLabel")
icon.Size = UDim2.new(0, 23, 0, 23)
icon.Position = UDim2.new(0.02, 0, 0.12, 0)
icon.BackgroundTransparency = 1
icon.BorderSizePixel = 0
icon.Parent = pingfps
icon.Image = "rbxassetid://124789592999813"

local pingLabel = Instance.new("TextLabel")
pingLabel.Size = UDim2.new(0, 71, 0, 28)
pingLabel.Position = UDim2.new(0.153, 0, 0.037, 0)
pingLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
pingLabel.BackgroundTransparency = 1
pingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
pingLabel.Font = Enum.Font.ArialBold
pingLabel.TextSize = 14
pingLabel.TextXAlignment = Enum.TextXAlignment.Left
pingLabel.TextTruncate = Enum.TextTruncate.AtEnd
pingLabel.Parent = pingfps

local pingLabelPadding = Instance.new("UIPadding", pingLabel)
pingLabelPadding.PaddingLeft = UDim.new(0, 5)

-- Function to update ping
local function updatePing()
    while true do
        local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
        pingLabel.Text = "Ping: " .. math.floor(ping)
        task.wait(1) -- Update every second
    end
end

-- Run the function in a separate thread
task.spawn(updatePing)

local fps = Instance.new("TextLabel")
fps.Size = UDim2.new(0, 74, 0, 28) 
fps.Position = UDim2.new(0.564, 0, 0.037, 0) 
fps.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
fps.BackgroundTransparency = 1
fps.TextColor3 = Color3.fromRGB(255, 255, 255)
fps.Font = Enum.Font.ArialBold
fps.TextSize = 14
fps.TextXAlignment = Enum.TextXAlignment.Left 
fps.TextTruncate = Enum.TextTruncate.AtEnd 
fps.Parent = pingfps

local lastTime = tick()
local frameCount = 0

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local currentTime = tick()
    if currentTime - lastTime >= 1 then
        fps.Text = "FPS: " .. frameCount
        frameCount = 0
        lastTime = currentTime
    end
end)

-- Dragging Functionality
local function onInputBegan(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = pingfps.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end

local function onInputChanged(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        pingfps.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end

pingfps.InputBegan:Connect(onInputBegan)
UserInputService.InputChanged:Connect(onInputChanged)

    local MainFrame = Instance.new("Frame")
MainFrame.Size = pixelsToScale(600, 500)
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(16, 20, 16)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.BackgroundTransparency = 0
MainFrame.Parent = ScreenGui

local dragging = false
local dragInput, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

MainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

    local mainframecorner = Instance.new("UICorner")
    mainframecorner.CornerRadius = UDim.new(0, 9)
    mainframecorner.Parent = MainFrame

    local ToggleButton = Instance.new("ImageButton")
ToggleButton.Parent = ScreenGui
ToggleButton.Image = "rbxassetid://73368083993183"
ToggleButton.Position = UDim2.new(0.5, -25, 0, -50) -- Start off-screen at the top center
ToggleButton.Size = UDim2.new(0, 40, 0, 40)
ToggleButton.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
ToggleButton.BackgroundTransparency = 1
ToggleButton.BorderSizePixel = 0
ToggleButton.Active = true
ToggleButton.Draggable = true

-- Tweening function
local function tweenToggleButton()
    local tweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

    -- Adjusted target position closer to the top of the screen
    local targetPosition = UDim2.new(0.5, -25, 0, -25)
    
    local tween = tweenService:Create(ToggleButton, tweenInfo, {Position = targetPosition})
    tween:Play()
end


ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    ToggleButton.Visible = false
end)


tweenToggleButton()

    local ToggleButtoncorners = Instance.new("UICorner")
    ToggleButtoncorners.CornerRadius = UDim.new(0, 4)
    ToggleButtoncorners.Parent = ToggleButton

    
local scripttitle = Instance.new("TextLabel")
scripttitle.Size = UDim2.new(0, 400, 0, 45) 
scripttitle.Position = UDim2.new(0, 0, 0, 0) 
scripttitle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
scripttitle.BackgroundTransparency = 1
scripttitle.TextColor3 = Color3.fromRGB(255, 255, 255)
scripttitle.Font = Enum.Font.ArialBold
scripttitle.TextSize = 22
scripttitle.TextXAlignment = Enum.TextXAlignment.Left 
scripttitle.TextTruncate = Enum.TextTruncate.AtEnd 
scripttitle.Text = config.Title or "Script Name"
scripttitle.Parent = MainFrame

    local scripttitlePadding = Instance.new("UIPadding", scripttitle)
    scripttitlePadding.PaddingLeft = UDim.new(0, 10)

    local Line2 = Instance.new("Frame")
    Line2.Parent = MainFrame
    Line2.BackgroundColor3 = Color3.fromRGB(42, 47, 42)
    Line2.Position = UDim2.new(0.288, 0, 0.09, 0)
    Line2.BorderSizePixel = 0
    Line2.Size = UDim2.new(0, 1, 0, 455)

    local Line1 = Instance.new("Frame")
    Line1.Parent = MainFrame
    Line1.BackgroundColor3 = Color3.fromRGB(42, 47, 42)
    Line1.Position = UDim2.new(0, 0, 0.09, 0)
    Line1.BorderSizePixel = 0
    Line1.Size = UDim2.new(1, 0, 0, 1)


local Players = game:GetService("Players")
local player = Players.LocalPlayer
local tweenService = game:GetService("TweenService")



local Close = Instance.new("ImageButton")
Close.Name = "CloseButton" -- It's good practice to name your instances
Close.Size = UDim2.new(0, 20, 0, 20)
Close.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Close.Position = UDim2.new(0.943, 0, 0.024, 0)
Close.BorderSizePixel = 0
Close.BackgroundTransparency = 1
Close.Image = "rbxassetid://74016884449424"
Close.ImageColor3 = Color3.fromRGB(176, 196, 177)
Close.Parent = MainFrame -- Assuming MainFrame is defined elsewhere

Close.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        ScreenGui2:Destroy()
end)


local function tweenHue(button, targetColor)
    tweenService:Create(button, TweenInfo.new(0.25), {ImageColor3 = targetColor}):Play()
end

Close.MouseEnter:Connect(function()

    tweenHue(Close, Color3.fromRGB(255, 255, 255))
end)

Close.MouseLeave:Connect(function()
    tweenHue(Close, Color3.fromRGB(176, 196, 177))
end)



    local Minimize = Instance.new("ImageButton")
    Minimize.Size = UDim2.new(0, 20, 0, 20)
    Minimize.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Minimize.Position = UDim2.new(0.883, 0, 0.024, 0)
    Minimize.BorderSizePixel = 0
    Minimize.BackgroundTransparency = 1
    Minimize.Image = "rbxassetid://120235853891230"
    Minimize.ImageColor3 = Color3.fromRGB(187, 204, 187)
    Minimize.Parent = MainFrame
    Minimize.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ToggleButton.Visible = true
    end)


Minimize.MouseEnter:Connect(function()
    tweenHue(Minimize, Color3.fromRGB(255, 255, 255))
end)

Minimize.MouseLeave:Connect(function()
    tweenHue(Minimize, Color3.fromRGB(176, 196, 177))
end)



    return {
        MainFrame = MainFrame,
        Tabs = {},
    }
end

function SearcherUILibrary:AddTab(window, config)
    local TabFrame = window.MainFrame:FindFirstChild("TabFrame") or Instance.new("ScrollingFrame", window.MainFrame)
    TabFrame.Size = UDim2.new(0, 173, 0, 454)
    TabFrame.Position = UDim2.new(0, 0, 0.092, 0)
    TabFrame.BackgroundTransparency = 1
    TabFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    TabFrame.BorderSizePixel = 0
    TabFrame.Name = "TabFrame"
    TabFrame.ScrollBarThickness = 2
    TabFrame.ScrollBarImageColor3 = Color3.fromRGB(176, 196, 177)
    TabFrame.ScrollingEnabled = true
    TabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

    local TabFramePadding = Instance.new("UIPadding", TabFrame)
    TabFramePadding.PaddingLeft = UDim.new(0, 10)
    TabFramePadding.PaddingTop = UDim.new(0, 5)

    local ListLayout = Instance.new("UIListLayout", TabFrame)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 5)

    local function updateTabScrolling()
        TabFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
        TabFrame.ScrollingEnabled = TabFrame.CanvasSize.Y.Offset > TabFrame.AbsoluteSize.Y
    end

    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateTabScrolling)
    updateTabScrolling()

    local TabButton = Instance.new("TextButton", TabFrame)
    TabButton.Size = UDim2.new(0, 150, 0, 40)
    TabButton.BackgroundTransparency = 1
    TabButton.BackgroundColor3 = Color3.fromRGB(26, 45, 26) -- Default background color
    TabButton.BorderSizePixel = 0
    TabButton.AutoButtonColor = false
    TabButton.Text = ""

    local TabButtonFrameCorners = Instance.new("UICorner")
    TabButtonFrameCorners.CornerRadius = UDim.new(0, 4)
    TabButtonFrameCorners.Parent = TabButton

    local Tab2 = Instance.new("Frame", TabButton) -- Renamed to TabFrameInner
    Tab2.Name = "TabFrameInner"
    Tab2.BackgroundColor3 = Color3.fromRGB(26, 45, 26) -- Default background color
    Tab2.Position = UDim2.new(0, 0, 0, 0)
    Tab2.BorderSizePixel = 0
    Tab2.Size = UDim2.new(0, 155, 0, 40)
    Tab2.BackgroundTransparency = 0

    local Tab2FrameCorners = Instance.new("UICorner")
    Tab2FrameCorners.CornerRadius = UDim.new(0, 8)
    Tab2FrameCorners.Parent = Tab2

    local TabIcon = Instance.new("ImageLabel")
    TabIcon.Parent = Tab2
    TabIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabIcon.BackgroundTransparency = 1.000
    TabIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TabIcon.BorderSizePixel = 0
    TabIcon.Position = UDim2.new(0, 5, 0, 5)
    TabIcon.Size = UDim2.new(0, 30, 0, 30)
    TabIcon.Image = "rbxassetid://95479947015470"
    TabIcon.ImageColor3 = Color3.fromRGB(176, 196, 177)

    local TabLabel = Instance.new("TextLabel", TabButton)
    TabLabel.Size = UDim2.new(0, 155, 0, 40)
    TabLabel.Text = (config.Game or "Untitled")
    TabLabel.Font = Enum.Font.ArialBold
    TabLabel.TextSize = 18
    TabLabel.TextColor3 = Color3.fromRGB(176, 196, 177)
    TabLabel.BackgroundTransparency = 1
    TabLabel.TextXAlignment = Enum.TextXAlignment.Left
    TabLabel.TextYAlignment = Enum.TextYAlignment.Center
    TabLabel.TextWrapped = true

    local TextLabelPadding = Instance.new("UIPadding", TabLabel)
    TextLabelPadding.PaddingLeft = UDim.new(0, 43)

    local TweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(
        0.25, -- Duration of the tween
        Enum.EasingStyle.Quad, -- Easing style (you can experiment with others)
        Enum.EasingDirection.Out -- Easing direction
    )

    TabButton.MouseEnter:Connect(function()
        if window.SelectedTab ~= TabButton then
            local textTween = TweenService:Create(TabLabel, tweenInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)})
            local iconTween = TweenService:Create(TabIcon, tweenInfo, {ImageColor3 = Color3.fromRGB(255, 255, 255)})
            textTween:Play()
            iconTween:Play()
        end
    end)

    TabButton.MouseLeave:Connect(function()
        if window.SelectedTab ~= TabButton then
            local textTween = TweenService:Create(TabLabel, tweenInfo, {TextColor3 = Color3.fromRGB(176, 196, 177)})
            local iconTween = TweenService:Create(TabIcon, tweenInfo, {ImageColor3 = Color3.fromRGB(176, 196, 177)})
            textTween:Play()
            iconTween:Play()
        end
    end)

    local ContentFrame = Instance.new("ScrollingFrame", window.MainFrame)
    ContentFrame.Size = UDim2.new(0, 427, 0, 454)
    ContentFrame.Position = UDim2.new(0.288, 0, 0.092, 0)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ContentFrame.BorderSizePixel = 0
    ContentFrame.ScrollBarThickness = 4
    ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(90, 90, 90)
    ContentFrame.ScrollingEnabled = false
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Visible = false

    local ContentFramePadding = Instance.new("UIPadding", ContentFrame)
    ContentFramePadding.PaddingLeft = UDim.new(0, 15)
    ContentFramePadding.PaddingTop = UDim.new(0, 5)

    local ContentLayout = Instance.new("UIListLayout", ContentFrame)
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 10)

    local function updateContentScrolling()
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
        ContentFrame.ScrollingEnabled = ContentFrame.CanvasSize.Y.Offset > ContentFrame.AbsoluteSize.Y
    end

    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateContentScrolling)
    updateContentScrolling()

    local function onTabButtonClick()
        -- Revert the appearance of the previously selected tab, if there was one
        if window.SelectedTab then
            local previousTabInner = window.SelectedTab:FindFirstChild("TabFrameInner")
            local previousTabLabel = window.SelectedTab:FindFirstChild("TextLabel")
            local previousTabIcon = previousTabInner and previousTabInner:FindFirstChildOfClass("ImageLabel")

            if previousTabInner then
                previousTabInner.BackgroundTransparency = 0
            end
            if previousTabLabel then
                local previousTextTween = TweenService:Create(previousTabLabel, tweenInfo, {TextColor3 = Color3.fromRGB(176, 196, 177)})
                previousTextTween:Play()
            end
            if previousTabIcon then
                local previousIconTween = TweenService:Create(previousTabIcon, tweenInfo, {ImageColor3 = Color3.fromRGB(176, 196, 177)})
                previousIconTween:Play()
            end
        end

        -- Hide all content frames
        for _, child in ipairs(window.MainFrame:GetChildren()) do
            if child:IsA("ScrollingFrame") and child.Name == "ContentFrame" then
                child.Visible = false
            end
        end

        -- Update the appearance of the newly selected tab
        local currentTextTween = TweenService:Create(TabLabel, tweenInfo, {TextColor3 = Color3.fromRGB(48, 209, 88)})
        local currentIconTween = TweenService:Create(TabIcon, tweenInfo, {ImageColor3 = Color3.fromRGB(48, 209, 88)})
        currentTextTween:Play()
        currentIconTween:Play()
        Tab2.BackgroundTransparency = 0
        ContentFrame.Visible = true
        window.SelectedTab = TabButton
    end

    TabButton.MouseButton1Click:Connect(onTabButtonClick)

    window.Tabs[config.Game or "Untitled"] = {
        Button = TabButton,
        Frame = ContentFrame
    }

    if not window.SelectedTab then
        window.SelectedTab = TabButton
        local initialTextTween = TweenService:Create(TabLabel, tweenInfo, {TextColor3 = Color3.fromRGB(48, 209, 88)})
        local initialIconTween = TweenService:Create(TabIcon, tweenInfo, {ImageColor3 = Color3.fromRGB(48, 209, 88)})
        initialTextTween:Play()
        initialIconTween:Play()
        Tab2.BackgroundTransparency = 0
        ContentFrame.Visible = true
    else
        ContentFrame.Visible = false
        local initialUnselectedTextTween = TweenService:Create(TabLabel, tweenInfo, {TextColor3 = Color3.fromRGB(176, 196, 177)})
        local initialUnselectedIconTween = TweenService:Create(TabIcon, tweenInfo, {ImageColor3 = Color3.fromRGB(176, 196, 177)})
        initialUnselectedTextTween:Play()
        initialUnselectedIconTween:Play()
    end

    return {
        ContentFrame = ContentFrame,
        TabButton = TabButton,
        Sections = window.Tabs[config.Game or "Untitled"].Sections
    }
end









function SearcherUILibrary:AddDivider(tab, config)
    local ContentFrame = tab.ContentFrame

    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(0, 460, 0, 16)
    Divider.BackgroundTransparency = 1
    Divider.Parent = ContentFrame

    local DividerLabel = Instance.new("TextLabel")
    DividerLabel.Size = UDim2.new(0, 363, 0, 16)
    DividerLabel.BackgroundTransparency = 1
    DividerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    DividerLabel.Font = Enum.Font.ArialBold
    DividerLabel.TextSize = 20
    DividerLabel.TextXAlignment = Enum.TextXAlignment.Left
    DividerLabel.TextTruncate = Enum.TextTruncate.AtEnd
    DividerLabel.Text = config.Text or "Divider"
    DividerLabel.Parent = Divider

    local SectionContentFrame = Instance.new("Frame")
    SectionContentFrame.Name = "SectionContentFrame"
    SectionContentFrame.Size = UDim2.new(0, 390, 0, 50)
    SectionContentFrame.BackgroundColor3 = Color3.fromRGB(21,30,21,255)
    SectionContentFrame.BackgroundTransparency = 0
    SectionContentFrame.BorderSizePixel = 0
    SectionContentFrame.Parent = ContentFrame

    local SectionContentFrameCorners = Instance.new("UICorner")
    SectionContentFrameCorners.CornerRadius = UDim.new(0, 8)
    SectionContentFrameCorners.Parent = SectionContentFrame

    tab.SectionContentFrame = SectionContentFrame

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 0)
    ListLayout.Parent = SectionContentFrame

    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        SectionContentFrame.Size = UDim2.new(0, 390, 0, ListLayout.AbsoluteContentSize.Y)

        local children = SectionContentFrame:GetChildren()
        for _, child in ipairs(children) do
            if child:IsA("Frame") or child:IsA("TextButton") then
                local line = child:FindFirstChild("DividerLine")
                if line then
                    line:Destroy()
                end
            end
        end

        local validChildren = {}
        for _, child in ipairs(children) do
            if child:IsA("Frame") or child:IsA("TextButton") then
                table.insert(validChildren, child)
            end
        end

        for i = 1, #validChildren - 1 do
            local child = validChildren[i]
            local line = Instance.new("Frame")
            line.Name = "DividerLine"
            line.Size = UDim2.new(1.023, 0, 0, 1)
            line.Position = UDim2.new(-0.023, 0, 1, 0)
            line.BackgroundTransparency = 0.1
            line.BackgroundColor3 = Color3.fromRGB(38,44,38,255)
            line.Parent = child
            line.BorderSizePixel = 0

        end
    end)

    return SectionContentFrame
end

function SearcherUILibrary:AddDropdown(tab, section, config)
    local SectionFrame = tab.SectionContentFrame
    local ScreenGui2 = Instance.new("ScreenGui", game.CoreGui)

    local DropdownButtonFrame = Instance.new("TextButton")
    DropdownButtonFrame.Size = UDim2.new(0, 390, 0, 44)
    DropdownButtonFrame.BackgroundTransparency = 1
    DropdownButtonFrame.BackgroundColor3 = Color3.fromRGB(255, 143, 171)
    DropdownButtonFrame.BorderSizePixel = 0
    DropdownButtonFrame.Font = Enum.Font.ArialBold
    DropdownButtonFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropdownButtonFrame.TextSize = 17
    DropdownButtonFrame.TextXAlignment = Enum.TextXAlignment.Left
    DropdownButtonFrame.Text = config.Title or "Dropdown"
    DropdownButtonFrame.Parent = SectionFrame

    Instance.new("UIPadding", DropdownButtonFrame).PaddingLeft = UDim.new(0, 10)

    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Size = UDim2.new(0, 140, 0, 30)
    DropdownButton.Position = UDim2.new(0.6, 0, 0.18, 0)
    DropdownButton.BackgroundColor3 = Color3.fromRGB(26, 46, 26)
    DropdownButton.Font = Enum.Font.ArialBold
    DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropdownButton.TextSize = 17
    DropdownButton.TextXAlignment = Enum.TextXAlignment.Center
    DropdownButton.Text = ""
    DropdownButton.Parent = DropdownButtonFrame

    Instance.new("UICorner", DropdownButton).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", DropdownButton)
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(48, 209, 88)
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Transparency = 0.6

    local DropdownList = Instance.new("Frame")
    DropdownList.Name = "DropdownList"
    DropdownList.Size = UDim2.new(0, 140, 0, 0)
    DropdownList.BackgroundColor3 = Color3.fromRGB(26, 46, 26)
    DropdownList.BorderSizePixel = 0
    DropdownList.Visible = false
    DropdownList.ZIndex = 200
    DropdownList.Parent = ScreenGui2

    Instance.new("UICorner", DropdownList).CornerRadius = UDim.new(0, 6)

    local dropdownListLayout = Instance.new("UIListLayout", DropdownList)
    dropdownListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    dropdownListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    dropdownListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    dropdownListLayout.Padding = UDim.new(0, 2, 0, 2)

    local ScrollingFrame = nil
    local function AddItem(text, isLast)
        local itemButton = Instance.new("TextButton")
        itemButton.Size = UDim2.new(1, 0, 0, 30)
        itemButton.BackgroundColor3 = Color3.fromRGB(255, 194, 209)
        itemButton.BorderSizePixel = 0
        itemButton.Text = text
        itemButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        itemButton.BackgroundTransparency = 1
        itemButton.ZIndex = 201
        itemButton.Parent = (ScrollingFrame or DropdownList)
        itemButton.Font = Enum.Font.ArialBold
        itemButton.TextSize = 14
        itemButton.TextXAlignment = Enum.TextXAlignment.Left

        Instance.new("UIPadding", itemButton).PaddingLeft = UDim.new(0, 5)

        itemButton.MouseButton1Click:Connect(function()
            DropdownButton.Text = text
            if config.ItemSelected then
                config.ItemSelected(text)
            end
            DropdownList.Visible = false
            Blocker.Visible = false
        end)

        if not isLast then
            local separator = Instance.new("Frame")
            separator.Size = UDim2.new(1, 0, 0, 1)
            separator.BackgroundColor3 = Color3.fromRGB(48, 209, 88)
            separator.BackgroundTransparency = 0.6
            separator.Parent = (ScrollingFrame or DropdownList)
            separator.ZIndex = 202
        end
    end

    if config.Items then
        if #config.Items > 5 then
            ScrollingFrame = Instance.new("ScrollingFrame")
            ScrollingFrame.Size = UDim2.new(1, 0, 0, 150)
            ScrollingFrame.BackgroundColor3 = Color3.fromRGB(26, 46, 26)
            ScrollingFrame.BorderSizePixel = 0
            ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #config.Items * 30.5)
            ScrollingFrame.ScrollBarThickness = 0
            ScrollingFrame.BackgroundTransparency = 1
            ScrollingFrame.ZIndex = 201
            ScrollingFrame.Parent = DropdownList
            ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(200, 200, 200)

            local ScrollingFrameCorner = Instance.new("UICorner")
            ScrollingFrameCorner.CornerRadius = UDim.new(0, 6)
            ScrollingFrameCorner.Parent = ScrollingFrame

            local scrollingLayout = Instance.new("UIListLayout", ScrollingFrame)
            scrollingLayout.SortOrder = Enum.SortOrder.LayoutOrder
            scrollingLayout.Padding = UDim.new(0, 0, 0, 0)

            for i, item in ipairs(config.Items) do
                AddItem(item, i == #config.Items)
            end

            DropdownList.Size = UDim2.new(0, 140, 0, 150)
        else
            for i, item in ipairs(config.Items) do
                AddItem(item, i == #config.Items)
            end
            local totalHeight = #config.Items * 30
            DropdownList.Size = UDim2.new(0, 140, 0, totalHeight)
        end
    end

    local RunService = game:GetService("RunService")
    local connection
    local Blocker = Instance.new("TextButton")
    Blocker.Name = "DropdownBlocker"
    Blocker.BackgroundTransparency = 0.5
    Blocker.Text = ""
    Blocker.AutoButtonColor = false
    Blocker.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Blocker.Visible = false
    Blocker.ZIndex = 199
    Blocker.Parent = ScreenGui2
    Instance.new("UICorner", Blocker).CornerRadius = UDim.new(0, 6)

    DropdownButton.MouseButton1Click:Connect(function()
        DropdownList.Visible = not DropdownList.Visible

        if DropdownList.Visible then
            Blocker.Visible = true
            Blocker.ZIndex = DropdownList.ZIndex - 1

            local absPos = DropdownButton.AbsolutePosition
            local absSize = DropdownButton.AbsoluteSize
            DropdownList.Position = UDim2.new(0, absPos.X, 0.005, absPos.Y + absSize.Y)

            -- Sync blocker size and position with dropdown list
            Blocker.Size = DropdownList.Size
            Blocker.Position = DropdownList.Position

            if connection then connection:Disconnect() end
            connection = RunService.RenderStepped:Connect(function()
                if DropdownList.Visible then
                    local absPos = DropdownButton.AbsolutePosition
                    local absSize = DropdownButton.AbsoluteSize
                    DropdownList.Position = UDim2.new(0, absPos.X, 0.005, absPos.Y + absSize.Y)

                    Blocker.Size = DropdownList.Size
                    Blocker.Position = DropdownList.Position
                else
                    if connection then
                        connection:Disconnect()
                        connection = nil
                    end
                end
            end)

            Blocker.MouseButton1Click:Connect(function()
                DropdownList.Visible = false
                Blocker.Visible = false
            end)
        else
            if connection then
                connection:Disconnect()
                connection = nil
            end
            Blocker.Visible = false
        end
    end)

    return DropdownButton
end




function SearcherUILibrary:AddButton(tab, section, config)

local SectionFrame = tab.SectionContentFrame

    local ButtonFrame = Instance.new("TextButton")
    ButtonFrame.Size = UDim2.new(0, 390, 0, 44)
    ButtonFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ButtonFrame.BorderSizePixel = 0
    ButtonFrame.Parent = SectionFrame
    ButtonFrame.BackgroundTransparency = 1
    ButtonFrame.Font = Enum.Font.SourceSansBold
    ButtonFrame.TextColor3 = Color3.fromRGB(176, 196, 177)
    ButtonFrame.TextSize = 20
    ButtonFrame.AutoButtonColor = false
    ButtonFrame.TextXAlignment = Enum.TextXAlignment.Left
    ButtonFrame.Text = config.Title or ""

    local ButtonFrameIcon = Instance.new("ImageLabel")
    ButtonFrameIcon.Parent = ButtonFrame
    ButtonFrameIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ButtonFrameIcon.BackgroundTransparency = 1.000
    ButtonFrameIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ButtonFrameIcon.BorderSizePixel = 0
    ButtonFrameIcon.Position = UDim2.new(0.93, 0, 0.299, 0)
    ButtonFrameIcon.Size = UDim2.new(0, 17, 0, 17)
    ButtonFrameIcon.Image = "rbxassetid://132097119298377"


    local ButtonFramePadding = Instance.new("UIPadding", ButtonFrame)
    ButtonFramePadding.PaddingLeft = UDim.new(0, 10)


    local tweenService = game:GetService("TweenService")
    local hoverTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    local hoverColorTween = tweenService:Create(ButtonFrame, hoverTweenInfo, {BackgroundTransparency = 0.8})
    local normalColorTween = tweenService:Create(ButtonFrame, hoverTweenInfo, {BackgroundTransparency = 1})

    ButtonFrame.MouseEnter:Connect(function()
        hoverColorTween:Play()
    end)

    ButtonFrame.MouseLeave:Connect(function()
        normalColorTween:Play()
    end)

    local ExecuteButtonCorners = Instance.new("UICorner")
    ExecuteButtonCorners.CornerRadius = UDim.new(0, 3)
    ExecuteButtonCorners.Parent = ExecuteButton

    ButtonFrame.MouseButton1Click:Connect(function()
        if config.Callback then
            config.Callback()
        end
    end)

    return ButtonFrame
end


local TweenService = game:GetService("TweenService")



function SearcherUILibrary:AddToggle(tab, section, config)
    local SectionFrame = tab.SectionContentFrame

    local ToggleFrame = Instance.new("TextButton")
    ToggleFrame.Size = UDim2.new(0, 390, 0, 44)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(255, 143, 171)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = SectionFrame
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Font = Enum.Font.ArialBold
    ToggleFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleFrame.TextSize = 17
    ToggleFrame.AutoButtonColor = false
    ToggleFrame.TextXAlignment = Enum.TextXAlignment.Left
    ToggleFrame.Text = config.Title or ""

    local ToggleFrameCorners = Instance.new("UICorner")
    ToggleFrameCorners.CornerRadius = UDim.new(0, 3)
    ToggleFrameCorners.Parent = ToggleFrame

    local ToggleFramePadding = Instance.new("UIPadding", ToggleFrame)
    ToggleFramePadding.PaddingLeft = UDim.new(0, 10)

    -- Create the toggle button frame
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(0, 50, 0, 25)
    toggleFrame.Position = UDim2.new(1, -60, 0.5, -12)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(21,30,21,255)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = ToggleFrame
    
    local toggleframecorners = Instance.new("UICorner")
    toggleframecorners.CornerRadius = UDim.new(0, 50)
    toggleframecorners.Parent = toggleFrame

    local uiStroke = Instance.new("UIStroke")
    uiStroke.Thickness = 1
    uiStroke.Color = Color3.fromRGB(48, 209, 88)
    uiStroke.Transparency = 0.6
    uiStroke.Parent = toggleFrame

    -- Create the toggle circle
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Size = UDim2.new(0, 20, 0, 20)
    toggleCircle.Position = UDim2.new(0, 2, 0, 2.5)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleCircle.BorderSizePixel = 0
    toggleCircle.Parent = toggleFrame

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(1, 0)
    uiCorner.Parent = toggleCircle

    -- Toggle state
    local isOn = false

    local function toggle()
        isOn = not isOn
        if isOn then
            toggleCircle:TweenPosition(UDim2.new(1, -22, 0, 2.5), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.2, true)
            toggleFrame.BackgroundColor3 = Color3.fromRGB(48, 209, 88)  
            toggleFrame.BackgroundTransparency = 0.4
            toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255) 
        else
            toggleCircle:TweenPosition(UDim2.new(0, 2, 0, 2.5), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.2, true)
            toggleFrame.BackgroundColor3 = Color3.fromRGB(21,30,21,255)
            toggleFrame.BackgroundTransparency = 1
            toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        end

        -- Call the callback function and pass the toggle state
        if config.Callback then
            config.Callback(isOn)
        end
    end

    -- Connect the toggle function to mouse and touch input
    toggleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            toggle()
        end
    end)

    return ToggleFrame
end





function SearcherUILibrary:AddSlider(tab, section, config)
    local SectionFrame = tab.SectionContentFrame

    local slider = Instance.new("TextButton")
    slider.Parent = SectionFrame
    slider.BackgroundColor3 = Color3.fromRGB(0, 390, 0, 44)
    slider.Position = UDim2.new(0, 0, 0, 0)
    slider.Size = UDim2.new(0, 460, 0, 40)
    slider.BackgroundTransparency = 1
    slider.Text = config.Title or "Slider"
    slider.TextSize = 16
    slider.Font = Enum.Font.ArialBold
    slider.TextColor3 = Color3.fromRGB(255, 255, 255)
    slider.AutoButtonColor = false
    slider.Active = false
    slider.TextXAlignment = Enum.TextXAlignment.Left

    local sliderCorners = Instance.new("UICorner")
    sliderCorners.CornerRadius = UDim.new(0, 4)
    sliderCorners.Parent = slider

    local sliderPadding = Instance.new("UIPadding")
    sliderPadding.Parent = slider
    sliderPadding.PaddingLeft = UDim.new(0, 10)

    local sliderBar = Instance.new("Frame")
    sliderBar.Name = "SliderBar"
    sliderBar.Parent = slider
    sliderBar.Size = UDim2.new(0, 200, 0, 5)
    sliderBar.Position = UDim2.new(0.73, -90, 0.55, -5)
    sliderBar.BackgroundColor3 = Color3.fromRGB(255, 194, 209)
    sliderBar.BorderSizePixel = 0

    local sliderButton = Instance.new("ImageButton")
    sliderButton.Name = "SliderButton"
    sliderButton.Parent = sliderBar
    sliderButton.Size = UDim2.new(0, 15, 0, 15)
    sliderButton.Position = UDim2.new(0.5, -7.5, 0.2, -10) -- Centered position
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 179, 198)
    sliderButton.Image = ""
    sliderButton.BorderSizePixel = 0
    sliderButton.AutoButtonColor = false

    local sliderButtonCorners = Instance.new("UICorner")
    sliderButtonCorners.CornerRadius = UDim.new(0, 50)
    sliderButtonCorners.Parent = sliderButton

    local sliderLine = Instance.new("Frame")
    sliderLine.Name = "SliderLine"
    sliderLine.Parent = sliderBar
    sliderLine.Size = UDim2.new(0, 0, 0, 7)
    sliderLine.Position = UDim2.new(0, 0, 0, 0)
    sliderLine.BackgroundColor3 = Color3.fromRGB(255, 179, 198) 
    sliderLine.BorderSizePixel = 0
    

    local valueBox = Instance.new("TextBox")
    valueBox.Parent = slider
    valueBox.Size = UDim2.new(0, 30, 0, 30)
    valueBox.Position = UDim2.new(0.44, 0, 0.113, 0)
    valueBox.BackgroundColor3 = Color3.fromRGB(255, 143, 171)
    valueBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueBox.TextSize = 14
    valueBox.Font = Enum.Font.ArialBold
    valueBox.Text = tostring(config.Min or 0)
    valueBox.TextTruncate = Enum.TextTruncate.AtEnd

    local valueboxstroke = Instance.new("UIStroke")
    valueboxstroke.Thickness = 1
    valueboxstroke.Color = Color3.fromRGB(215, 244, 210)
    valueboxstroke.Parent = valueBox
    valueboxstroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local valueBoxCorners = Instance.new("UICorner")
    valueBoxCorners.CornerRadius = UDim.new(0, 4)
    valueBoxCorners.Parent = valueBox

    local sliderValue = config.Min or 0
    local maxValue = config.Max or 100

    local function updateSlider(position)
        local relativePos = math.clamp(position, 0, 1)
        sliderButton.Position = UDim2.new(relativePos, -7.5, 0.8, -10)
        sliderLine.Size = UDim2.new(relativePos, 0, 0, 5)
        sliderValue = math.floor(relativePos * (maxValue - config.Min) + config.Min)
        valueBox.Text = tostring(sliderValue)
        if config.Callback then
            config.Callback(sliderValue)
        end
    end

    local function startDragging(input)
        local moveConnection
        local releaseConnection

        moveConnection = game:GetService("UserInputService").InputChanged:Connect(function(inputChanged)
            if inputChanged.UserInputType == Enum.UserInputType.MouseMovement or inputChanged.UserInputType == Enum.UserInputType.Touch then
                local relativePos = (inputChanged.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X
                updateSlider(relativePos)
            end
        end)

        releaseConnection = game:GetService("UserInputService").InputEnded:Connect(function(inputEnded)
            if inputEnded.UserInputType == Enum.UserInputType.MouseButton1 or inputEnded.UserInputType == Enum.UserInputType.Touch then
                moveConnection:Disconnect()
                releaseConnection:Disconnect()
            end
        end)
    end

    sliderButton.MouseButton1Down:Connect(startDragging)
    sliderButton.TouchTap:Connect(startDragging)

    valueBox.FocusLost:Connect(function(enterPressed)
        local inputValue = tonumber(valueBox.Text)
        if inputValue then
            local clampedValue = math.clamp(inputValue, config.Min, maxValue)
            local relativePos = (clampedValue - config.Min) / (maxValue - config.Min)
            updateSlider(relativePos)
        else
            valueBox.Text = tostring(config.Min)
            updateSlider(0)
        end
    end)

    updateSlider((sliderValue - config.Min) / (maxValue - config.Min))

    return slider
end



local Library = SearcherUILibrary

local Window = Library:CreateWindow({
    Title = "Zygarde",
    Icon = "rbxassetid://17376881029",
})

local Tabs = {
    Main = Library:AddTab(Window, {Game = "Tab1"}),
    Teleport = Library:AddTab(Window, {Game = "Tab2"}),

}

Library:AddDivider(Tabs.Main, {
    Text = "Auto Farm"
})

Library:AddToggle(Tabs.Main, "Auto Farm", {
    Title = "Auto Equip Rod",
    Callback = function(state)
    print("lolll")
    end
})


SearcherUILibrary:AddDropdown(Tabs.Main, "Auto Farm", {
    Title = "Select an Option",  -- Title of the dropdown button
    Items = { "Option 1", "Option 2", "Option 3", "Option 1", "Option 1", "Option 1" },  -- List of dropdown items
    ItemSelected = function(selectedItem)
        print("You selected: " .. selectedItem)
    end
})


Library:AddButton(Tabs.Main, "Auto Farm", {
    Title = "Run",
    Callback = function()
        print("Clicked")
    end
})

Library:AddButton(Tabs.Main, "Auto Farm", {
    Title = "gay",
    Callback = function()
        print("Clicked")
    end
})

Library:AddButton(Tabs.Main, "Auto Farm", {
    Title = "Run",
    Callback = function()
        print("Clicked")
    end
})

Library:AddSlider(Tabs.Main, "Auto Farm", {
    Title = "Slider",
    Min = 50, -- starting point
    Max = 100, -- end point
    Callback = function(value)
        print("Slider value:", value)
    end
})


Library:AddDivider(Tabs.Main, {
    Text = "Test"
})

Library:AddButton(Tabs.Main, "Test", {
    Title = "Run",
    Callback = function()
        print("Clicked")
    end
})


return SearcherUILibrary
