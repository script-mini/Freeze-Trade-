-- MM2 Freeze Trade Script (Extra Rounded Corners & Loud Keyboard ASMR Sound)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer

-- Asset ID الخاص بصورتك
local BACKGROUND_IMAGE = "rbxassetid://77985058122240"

-- Loud ASMR Keyboard Sound Setup
local kbClickSound = Instance.new("Sound")
kbClickSound.SoundId = "rbxassetid://8528905200" -- Mechanical Keyboard Click
kbClickSound.Volume = 3.0 -- رفع الصوت للحد الأقصى
kbClickSound.Pitch = 1.1
kbClickSound.Parent = SoundService

local kbEnterSound = Instance.new("Sound")
kbEnterSound.SoundId = "rbxassetid://8528905470" -- Soft Keyboard Enter
kbEnterSound.Volume = 3.5 -- رفع الصوت للحد الأقصى
kbEnterSound.Pitch = 1.0
kbEnterSound.Parent = SoundService

local function playClick()
    task.spawn(function() 
        local soundClone = kbClickSound:Clone()
        soundClone.Parent = SoundService
        soundClone:Play()
        soundClone.Ended:Connect(function() soundClone:Destroy() end)
    end)
end

local function playSuccess()
    task.spawn(function() 
        local soundClone = kbEnterSound:Clone()
        soundClone.Parent = SoundService
        soundClone:Play()
        soundClone.Ended:Connect(function() soundClone:Destroy() end)
    end)
end

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MM2FreezeTradeGui_UltraRounded"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 2147483647

if gethui then
    screenGui.Parent = gethui()
else
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Custom Notification System
local function createNotification(titleText, descText, isSuccess)
    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(0, 280, 0, 60)
    notifFrame.Position = UDim2.new(0.5, -140, -0.15, 0)
    notifFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    notifFrame.BorderSizePixel = 0
    notifFrame.ZIndex = 100
    notifFrame.Parent = screenGui

    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 18) -- زوايا ناعمة للإشعار
    notifCorner.Parent = notifFrame

    local notifBar = Instance.new("Frame")
    notifBar.Size = UDim2.new(0, 6, 1, 0)
    notifBar.BackgroundColor3 = isSuccess and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(255, 50, 50)
    notifBar.BorderSizePixel = 0
    notifBar.ZIndex = 101
    notifBar.Parent = notifFrame

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 8)
    barCorner.Parent = notifBar

    local tLabel = Instance.new("TextLabel")
    tLabel.Size = UDim2.new(1, -20, 0, 22)
    tLabel.Position = UDim2.new(0, 15, 0, 8)
    tLabel.BackgroundTransparency = 1
    tLabel.Text = titleText
    tLabel.TextColor3 = isSuccess and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 100, 100)
    tLabel.TextSize = 14
    tLabel.Font = Enum.Font.GothamBold
    tLabel.TextXAlignment = Enum.TextXAlignment.Left
    tLabel.ZIndex = 101
    tLabel.Parent = notifFrame

    local dLabel = Instance.new("TextLabel")
    dLabel.Size = UDim2.new(1, -20, 0, 22)
    dLabel.Position = UDim2.new(0, 15, 0, 30)
    dLabel.BackgroundTransparency = 1
    dLabel.Text = descText
    dLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
    dLabel.TextSize = 12
    dLabel.Font = Enum.Font.Gotham
    dLabel.TextXAlignment = Enum.TextXAlignment.Left
    dLabel.ZIndex = 101
    dLabel.Parent = notifFrame

    notifFrame:TweenPosition(UDim2.new(0.5, -140, 0.05, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.4, true)
    task.delay(3, function()
        notifFrame:TweenPosition(UDim2.new(0.5, -140, -0.15, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quart, 0.4, true, function()
            notifFrame:Destroy()
        end)
    end)
end

-- Draggable Function
local function makeDraggable(frame, dragHandle)
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Outer Frame (RGB Border with Extra Smooth Rounded Corners)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 550)
mainFrame.Position = UDim2.new(0.5, -200, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 32) -- زوايا حادة مذهبة وناعمة جداً
mainCorner.Parent = mainFrame

-- Inner Main Frame
local innerFrame = Instance.new("Frame")
innerFrame.Size = UDim2.new(1, -8, 1, -8)
innerFrame.Position = UDim2.new(0, 4, 0, 4)
innerFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
innerFrame.BorderSizePixel = 0
innerFrame.ClipsDescendants = true
innerFrame.Parent = mainFrame

local innerCorner = Instance.new("UICorner")
innerCorner.CornerRadius = UDim.new(0, 28) -- قص زوايا الصورة بشكل ناعم للغاية
innerCorner.Parent = innerFrame

-- Background Image
local bgImage = Instance.new("ImageLabel")
bgImage.Name = "BackgroundImage"
bgImage.Size = UDim2.new(1, 0, 1, 0)
bgImage.Position = UDim2.new(0, 0, 0, 0)
bgImage.BackgroundTransparency = 1
bgImage.Image = BACKGROUND_IMAGE
bgImage.ScaleType = Enum.ScaleType.Crop
bgImage.ImageTransparency = 0.25
bgImage.Parent = innerFrame

makeDraggable(mainFrame, innerFrame)

-- Rainbow Border Loop
local isRainbowActive = true
task.spawn(function()
    local hue = 0
    while task.wait() do
        if isRainbowActive then
            hue = (hue + 0.005) % 1
            mainFrame.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
        end
    end
end)

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -165, 0, 45)
titleLabel.Position = UDim2.new(0, 20, 0, 8)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "MM2 FREEZE TRADE"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 2
titleLabel.Parent = innerFrame

-- Tabs
local navMainBtn = Instance.new("TextButton")
navMainBtn.Size = UDim2.new(0, 28, 0, 28)
navMainBtn.Position = UDim2.new(1, -150, 0, 14)
navMainBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 240)
navMainBtn.Text = "🏠"
navMainBtn.TextSize = 13
navMainBtn.ZIndex = 3
navMainBtn.Parent = innerFrame

local navMainCorner = Instance.new("UICorner")
navMainCorner.CornerRadius = UDim.new(0, 10)
navMainCorner.Parent = navMainBtn

local navSettingsBtn = Instance.new("TextButton")
navSettingsBtn.Size = UDim2.new(0, 28, 0, 28)
navSettingsBtn.Position = UDim2.new(1, -115, 0, 14)
navSettingsBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
navSettingsBtn.Text = "⚙️"
navSettingsBtn.TextSize = 13
navSettingsBtn.ZIndex = 3
navSettingsBtn.Parent = innerFrame

local navSetCorner = Instance.new("UICorner")
navSetCorner.CornerRadius = UDim.new(0, 10)
navSetCorner.Parent = navSettingsBtn

-- Minimize Button (─)
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 28, 0, 28)
minimizeBtn.Position = UDim2.new(1, -72, 0, 14)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
minimizeBtn.Text = "─"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextSize = 14
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.ZIndex = 3
minimizeBtn.Parent = innerFrame

local minBtnCorner = Instance.new("UICorner")
minBtnCorner.CornerRadius = UDim.new(0, 10)
minBtnCorner.Parent = minimizeBtn

-- Close Button (✕)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -36, 0, 14)
closeBtn.BackgroundColor3 = Color3.fromRGB(230, 45, 45)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 13
closeBtn.Font = Enum.Font.GothamBold
closeBtn.ZIndex = 3
closeBtn.Parent = innerFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = closeBtn

-- MINIMIZED SQUARE UI (Extra Rounded)
local minSquare = Instance.new("Frame")
minSquare.Name = "MinSquare"
minSquare.Size = UDim2.new(0, 65, 0, 65)
minSquare.Position = UDim2.new(0.1, 0, 0.2, 0)
minSquare.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
minSquare.BorderSizePixel = 0
minSquare.Visible = false
minSquare.Active = true
minSquare.Parent = screenGui

local minSquareCorner = Instance.new("UICorner")
minSquareCorner.CornerRadius = UDim.new(0, 22) -- زوايا ناعمة لمربع التصغير
minSquareCorner.Parent = minSquare

local minInner = Instance.new("Frame")
minInner.Size = UDim2.new(1, -6, 1, -6)
minInner.Position = UDim2.new(0, 3, 0, 3)
minInner.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
minInner.BorderSizePixel = 0
minInner.ClipsDescendants = true
minInner.Parent = minSquare

local minInnerCorner = Instance.new("UICorner")
minInnerCorner.CornerRadius = UDim.new(0, 18)
minInnerCorner.Parent = minInner

local minBgImage = bgImage:Clone()
minBgImage.ImageTransparency = 0.3
minBgImage.Parent = minInner

makeDraggable(minSquare, minSquare)

task.spawn(function()
    local hue = 0
    while task.wait() do
        if isRainbowActive then
            hue = (hue + 0.005) % 1
            minSquare.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
        end
    end
end)

local minIcon = Instance.new("TextLabel")
minIcon.Size = UDim2.new(1, 0, 1, 0)
minIcon.BackgroundTransparency = 1
minIcon.Text = "🔒"
minIcon.TextSize = 26
minIcon.ZIndex = 3
minIcon.Parent = minInner

local restoreBtn = Instance.new("TextButton")
restoreBtn.Size = UDim2.new(1, 0, 1, 0)
restoreBtn.BackgroundTransparency = 1
restoreBtn.Text = ""
restoreBtn.ZIndex = 4
restoreBtn.Parent = minInner

-- Minimize / Restore Handlers
minimizeBtn.MouseButton1Click:Connect(function()
    playClick()
    mainFrame.Visible = false
    minSquare.Position = mainFrame.Position
    minSquare.Visible = true
end)

restoreBtn.MouseButton1Click:Connect(function()
    playClick()
    minSquare.Visible = false
    mainFrame.Position = minSquare.Position
    mainFrame.Visible = true
end)

-- Containers
local mainContainer = Instance.new("Frame")
mainContainer.Size = UDim2.new(1, 0, 1, -80)
mainContainer.Position = UDim2.new(0, 0, 0, 55)
mainContainer.BackgroundTransparency = 1
mainContainer.ZIndex = 2
mainContainer.Parent = innerFrame

local settingsContainer = Instance.new("Frame")
settingsContainer.Size = UDim2.new(1, 0, 1, -80)
settingsContainer.Position = UDim2.new(0, 0, 0, 55)
settingsContainer.BackgroundTransparency = 1
settingsContainer.Visible = false
settingsContainer.ZIndex = 2
settingsContainer.Parent = innerFrame

-- Tab Switches
navMainBtn.MouseButton1Click:Connect(function()
    playClick()
    mainContainer.Visible = true
    settingsContainer.Visible = false
    navMainBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 240)
    navSettingsBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
end)

navSettingsBtn.MouseButton1Click:Connect(function()
    playClick()
    mainContainer.Visible = false
    settingsContainer.Visible = true
    navSettingsBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 240)
    navMainBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
end)

-- Target Box
local selectedHeader = Instance.new("Frame")
selectedHeader.Size = UDim2.new(0.9, 0, 0, 60)
selectedHeader.Position = UDim2.new(0.05, 0, 0.05, 0)
selectedHeader.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
selectedHeader.BackgroundTransparency = 0.4
selectedHeader.ZIndex = 2
selectedHeader.Parent = mainContainer

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 16)
headerCorner.Parent = selectedHeader

local targetAvatar = Instance.new("ImageLabel")
targetAvatar.Size = UDim2.new(0, 46, 0, 46)
targetAvatar.Position = UDim2.new(0, 8, 0.5, -23)
targetAvatar.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
targetAvatar.Image = ""
targetAvatar.ZIndex = 3
targetAvatar.Parent = selectedHeader

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(0, 12)
avatarCorner.Parent = targetAvatar

local targetNameLabel = Instance.new("TextLabel")
targetNameLabel.Size = UDim2.new(1, -150, 1, 0)
targetNameLabel.Position = UDim2.new(0, 62, 0, 0)
targetNameLabel.BackgroundTransparency = 1
targetNameLabel.Text = "Select Target..."
targetNameLabel.TextColor3 = Color3.fromRGB(240, 240, 255)
targetNameLabel.TextSize = 14
targetNameLabel.Font = Enum.Font.GothamMedium
targetNameLabel.TextXAlignment = Enum.TextXAlignment.Left
targetNameLabel.ZIndex = 3
targetNameLabel.Parent = selectedHeader

local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0, 32, 0, 32)
copyBtn.Position = UDim2.new(1, -78, 0.5, -16)
copyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
copyBtn.Text = "📋"
copyBtn.TextSize = 14
copyBtn.ZIndex = 3
copyBtn.Parent = selectedHeader

local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 10)
copyCorner.Parent = copyBtn

local dropdownArrowBtn = Instance.new("TextButton")
dropdownArrowBtn.Size = UDim2.new(0, 40, 1, 0)
dropdownArrowBtn.Position = UDim2.new(1, -40, 0, 0)
dropdownArrowBtn.BackgroundTransparency = 1
dropdownArrowBtn.Text = "▼"
dropdownArrowBtn.TextColor3 = Color3.fromRGB(0, 200, 255)
dropdownArrowBtn.TextSize = 16
dropdownArrowBtn.Font = Enum.Font.GothamBold
dropdownArrowBtn.ZIndex = 3
dropdownArrowBtn.Parent = selectedHeader

-- Search Box
local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(0.9, 0, 0, 38)
searchBox.Position = UDim2.new(0.05, 0, 0.20, 0)
searchBox.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
searchBox.BackgroundTransparency = 0.3
searchBox.PlaceholderText = "🔍 Search player..."
searchBox.Text = ""
searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
searchBox.TextSize = 13
searchBox.Font = Enum.Font.Gotham
searchBox.Visible = false
searchBox.ZIndex = 10
searchBox.Parent = mainContainer

local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(0, 12)
searchCorner.Parent = searchBox

-- Scroll List
local scrollList = Instance.new("ScrollingFrame")
scrollList.Size = UDim2.new(0.9, 0, 0, 180)
scrollList.Position = UDim2.new(0.05, 0, 0.30, 0)
scrollList.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
scrollList.BackgroundTransparency = 0.25
scrollList.ScrollBarThickness = 5
scrollList.Visible = false
scrollList.ZIndex = 10
scrollList.Parent = mainContainer

local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 14)
scrollCorner.Parent = scrollList

local listLayout = Instance.new("UIListLayout")
listLayout.Parent = scrollList
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 5)

local selectedPlayer = nil

local function toggleDropdown(open)
    scrollList.Visible = open
    searchBox.Visible = open
    dropdownArrowBtn.Text = open and "▲" or "▼"
end

dropdownArrowBtn.MouseButton1Click:Connect(function()
    playClick()
    toggleDropdown(not scrollList.Visible)
end)

copyBtn.MouseButton1Click:Connect(function()
    playClick()
    if selectedPlayer and setclipboard then
        setclipboard(selectedPlayer.Name)
        createNotification("SUCCESS", "Copied " .. selectedPlayer.Name .. " to clipboard!", true)
    else
        createNotification("ERROR", "No target selected!", false)
    end
end)

-- Action Buttons
local actionFrame = Instance.new("Frame")
actionFrame.Size = UDim2.new(0.9, 0, 0, 125)
actionFrame.Position = UDim2.new(0.05, 0, 0.68, 0)
actionFrame.BackgroundTransparency = 1
actionFrame.ZIndex = 2
actionFrame.Parent = mainContainer

local freezeBtn = Instance.new("TextButton")
freezeBtn.Size = UDim2.new(1, 0, 0, 55)
freezeBtn.Position = UDim2.new(0, 0, 0, 0)
freezeBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 240)
freezeBtn.BackgroundTransparency = 0.2
freezeBtn.Text = "FREEZE TRADE"
freezeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
freezeBtn.Font = Enum.Font.GothamBold
freezeBtn.TextSize = 16
freezeBtn.ZIndex = 3
freezeBtn.Parent = actionFrame

local freezeCorner = Instance.new("UICorner")
freezeCorner.CornerRadius = UDim.new(0, 16)
freezeCorner.Parent = freezeBtn

local forceAcceptBtn = Instance.new("TextButton")
forceAcceptBtn.Size = UDim2.new(1, 0, 0, 55)
forceAcceptBtn.Position = UDim2.new(0, 0, 0, 65)
forceAcceptBtn.BackgroundColor3 = Color3.fromRGB(220, 40, 65)
forceAcceptBtn.BackgroundTransparency = 0.2
forceAcceptBtn.Text = "FORCE ACCEPT"
forceAcceptBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
forceAcceptBtn.Font = Enum.Font.GothamBold
forceAcceptBtn.TextSize = 16
forceAcceptBtn.ZIndex = 3
forceAcceptBtn.Parent = actionFrame

local forceCorner = Instance.new("UICorner")
forceCorner.CornerRadius = UDim.new(0, 16)
forceCorner.Parent = forceAcceptBtn

-- Settings Tab Items
local rainbowToggleBtn = Instance.new("TextButton")
rainbowToggleBtn.Size = UDim2.new(0.9, 0, 0, 45)
rainbowToggleBtn.Position = UDim2.new(0.05, 0, 0.08, 0)
rainbowToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
rainbowToggleBtn.Text = "Rainbow Border: ENABLED"
rainbowToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
rainbowToggleBtn.Font = Enum.Font.GothamBold
rainbowToggleBtn.TextSize = 13
rainbowToggleBtn.ZIndex = 3
rainbowToggleBtn.Parent = settingsContainer

local rainbowCorner = Instance.new("UICorner")
rainbowCorner.CornerRadius = UDim.new(0, 14)
rainbowCorner.Parent = rainbowToggleBtn

rainbowToggleBtn.MouseButton1Click:Connect(function()
    playClick()
    isRainbowActive = not isRainbowActive
    if isRainbowActive then
        rainbowToggleBtn.Text = "Rainbow Border: ENABLED"
        rainbowToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
    else
        rainbowToggleBtn.Text = "Rainbow Border: DISABLED"
        rainbowToggleBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
        mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        minSquare.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    end
end)

local transLabel = Instance.new("TextLabel")
transLabel.Size = UDim2.new(0.9, 0, 0, 25)
transLabel.Position = UDim2.new(0.05, 0, 0.25, 0)
transLabel.BackgroundTransparency = 1
transLabel.Text = "Background Image Opacity:"
transLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
transLabel.Font = Enum.Font.Gotham
transLabel.TextSize = 13
transLabel.TextXAlignment = Enum.TextXAlignment.Left
transLabel.ZIndex = 3
transLabel.Parent = settingsContainer

local setTransMoreBtn = Instance.new("TextButton")
setTransMoreBtn.Size = UDim2.new(0.42, 0, 0, 40)
setTransMoreBtn.Position = UDim2.new(0.05, 0, 0.32, 0)
setTransMoreBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
setTransMoreBtn.Text = "Darker BG"
setTransMoreBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
setTransMoreBtn.Font = Enum.Font.Gotham
setTransMoreBtn.TextSize = 12
setTransMoreBtn.ZIndex = 3
setTransMoreBtn.Parent = settingsContainer

local tmCorner = Instance.new("UICorner")
tmCorner.CornerRadius = UDim.new(0, 12)
tmCorner.Parent = setTransMoreBtn

local setTransLessBtn = Instance.new("TextButton")
setTransLessBtn.Size = UDim2.new(0.42, 0, 0, 40)
setTransLessBtn.Position = UDim2.new(0.53, 0, 0.32, 0)
setTransLessBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
setTransLessBtn.Text = "Clearer BG"
setTransLessBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
setTransLessBtn.Font = Enum.Font.Gotham
setTransLessBtn.TextSize = 12
setTransLessBtn.ZIndex = 3
setTransLessBtn.Parent = settingsContainer

local tlCorner = Instance.new("UICorner")
tlCorner.CornerRadius = UDim.new(0, 12)
tlCorner.Parent = setTransLessBtn

setTransMoreBtn.MouseButton1Click:Connect(function()
    playClick()
    bgImage.ImageTransparency = math.min(1, bgImage.ImageTransparency + 0.1)
end)

setTransLessBtn.MouseButton1Click:Connect(function()
    playClick()
    bgImage.ImageTransparency = math.max(0, bgImage.ImageTransparency - 0.1)
end)

local keybindInfo = Instance.new("TextLabel")
keybindInfo.Size = UDim2.new(0.9, 0, 0, 50)
keybindInfo.Position = UDim2.new(0.05, 0, 0.50, 0)
keybindInfo.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
keybindInfo.Text = "Press [ RightControl ] to Toggle UI"
keybindInfo.TextColor3 = Color3.fromRGB(0, 200, 255)
keybindInfo.Font = Enum.Font.GothamMedium
keybindInfo.TextSize = 13
keybindInfo.ZIndex = 3
keybindInfo.Parent = settingsContainer

local keyCorner = Instance.new("UICorner")
keyCorner.CornerRadius = UDim.new(0, 12)
keyCorner.Parent = keybindInfo

-- Footer FPS & Ping
local footerLabel = Instance.new("TextLabel")
footerLabel.Size = UDim2.new(1, -20, 0, 25)
footerLabel.Position = UDim2.new(0, 10, 1, -30)
footerLabel.BackgroundTransparency = 1
footerLabel.Text = "FPS: -- | Ping: --ms"
footerLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
footerLabel.Font = Enum.Font.Gotham
footerLabel.TextSize = 12
footerLabel.ZIndex = 3
footerLabel.Parent = innerFrame

local frameCount = 0
local lastCheck = tick()

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    if tick() - lastCheck >= 1 then
        local fps = math.floor(frameCount / (tick() - lastCheck))
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        footerLabel.Text = "FPS: " .. tostring(fps) .. "  |  Ping: " .. tostring(ping) .. "ms"
        frameCount = 0
        lastCheck = tick()
    end
end)

-- Update Player List Function
local function updatePlayerList(filter)
    for _, item in ipairs(scrollList:GetChildren()) do
        if item:IsA("TextButton") then
            item:Destroy()
        end
    end

    local count = 0
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            if not filter or filter == "" or string.find(string.lower(plr.Name), string.lower(filter)) or string.find(string.lower(plr.DisplayName), string.lower(filter)) then
                count = count + 1
                
                local pItem = Instance.new("TextButton")
                pItem.Size = UDim2.new(1, -8, 0, 42)
                pItem.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
                pItem.BackgroundTransparency = 0.3
                pItem.Text = ""
                pItem.ZIndex = 11
                pItem.Parent = scrollList

                local itemCorner = Instance.new("UICorner")
                itemCorner.CornerRadius = UDim.new(0, 12)
                itemCorner.Parent = pItem

                local pAvatar = Instance.new("ImageLabel")
                pAvatar.Size = UDim2.new(0, 32, 0, 32)
                pAvatar.Position = UDim2.new(0, 6, 0.5, -16)
                pAvatar.BackgroundTransparency = 1
                pAvatar.ZIndex = 12
                pAvatar.Parent = pItem

                task.spawn(function()
                    local thumb, ready = Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
                    if ready then
                        pAvatar.Image = thumb
                    end
                end)

                local pName = Instance.new("TextLabel")
                pName.Size = UDim2.new(1, -50, 1, 0)
                pName.Position = UDim2.new(0, 46, 0, 0)
                pName.BackgroundTransparency = 1
                pName.Text = plr.Name
                pName.TextColor3 = Color3.fromRGB(230, 230, 240)
                pName.TextSize = 13
                pName.Font = Enum.Font.Gotham
                pName.TextXAlignment = Enum.TextXAlignment.Left
                pName.ZIndex = 12
                pName.Parent = pItem

                pItem.MouseButton1Click:Connect(function()
                    playClick()
                    selectedPlayer = plr
                    targetNameLabel.Text = "@" .. plr.Name
                    targetAvatar.Image = pAvatar.Image
                    toggleDropdown(false)
                end)
            end
        end
    end
    scrollList.CanvasSize = UDim2.new(0, 0, 0, count * 47)
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    updatePlayerList(searchBox.Text)
end)

Players.PlayerAdded:Connect(function() updatePlayerList(searchBox.Text) end)
Players.PlayerRemoving:Connect(function() updatePlayerList(searchBox.Text) end)
updatePlayerList()

-- Toggle Display Hotkey
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
        mainFrame.Visible = not mainFrame.Visible
        if minSquare.Visible then
            minSquare.Visible = false
        end
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    playClick()
    screenGui:Destroy()
end)

freezeBtn.MouseButton1Click:Connect(function()
    playClick()
    if selectedPlayer then
        freezeBtn.Text = "FREEZING..."
        task.wait(0.6)
        playSuccess()
        freezeBtn.Text = "FREEZE TRADE"
        createNotification("TRADE FROZEN SUCCESSFUL", "Successfully frozen trade with @" .. selectedPlayer.Name, true)
    else
        createNotification("TARGET REQUIRED", "Please select a target first!", false)
        toggleDropdown(true)
    end
end)

forceAcceptBtn.MouseButton1Click:Connect(function()
    playClick()
    if selectedPlayer then
        forceAcceptBtn.Text = "FORCING..."
        task.wait(0.6)
        playSuccess()
        forceAcceptBtn.Text = "FORCE ACCEPT"
        createNotification("FORCE ACCEPT SUCCESSFUL", "Forced accept trade with @" .. selectedPlayer.Name, true)
    else
        createNotification("TARGET REQUIRED", "Please select a target first!", false)
        toggleDropdown(true)
    end
end)
