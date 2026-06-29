--// Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local VirtualUser = game:GetService("VirtualUser")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- Remove existing UI
if playerGui:FindFirstChild("ModernUI") then
    playerGui.ModernUI:Destroy()
end

--// Design System
local Theme = {
    Background = Color3.fromRGB(11, 11, 14),
    Surface = Color3.fromRGB(18, 18, 24),
    SurfaceAccent = Color3.fromRGB(26, 26, 36),
    Accent = Color3.fromRGB(0, 162, 255),
    TextMain = Color3.fromRGB(255, 255, 255),
    TextMuted = Color3.fromRGB(140, 140, 155),
    Border = Color3.fromRGB(35, 35, 45),
    FontMain = Enum.Font.Gotham,
    FontBold = Enum.Font.GothamBold,
    TweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
}

--// ScreenGui
local modernScreenGui = Instance.new("ScreenGui")
modernScreenGui.Name = "ModernUI"
modernScreenGui.ResetOnSpawn = false
modernScreenGui.Parent = playerGui

--// Floating minimized icon
local floatingMinimizedIcon = Instance.new("TextButton")
floatingMinimizedIcon.Name = "FloatingIcon"
floatingMinimizedIcon.Size = UDim2.new(0, 50, 0, 50)
floatingMinimizedIcon.Position = UDim2.new(0, 30, 0, 30)
floatingMinimizedIcon.Text = "UI"
floatingMinimizedIcon.TextColor3 = Theme.TextMain
floatingMinimizedIcon.Font = Theme.FontBold
floatingMinimizedIcon.TextSize = 14
floatingMinimizedIcon.Visible = false
floatingMinimizedIcon.BackgroundColor3 = Theme.Surface
floatingMinimizedIcon.BorderSizePixel = 0
floatingMinimizedIcon.Parent = modernScreenGui
floatingMinimizedIcon.Active = true
floatingMinimizedIcon.Draggable = true

Instance.new("UICorner", floatingMinimizedIcon).CornerRadius = UDim.new(1, 0)
local iconStroke = Instance.new("UIStroke", floatingMinimizedIcon)
iconStroke.Color = Theme.Accent
iconStroke.Thickness = 1.5
iconStroke.Transparency = 0.3

---------------------------------------------------------------------
-- MAIN FRAME & SIZE ADJUSTMENT
---------------------------------------------------------------------
local mainUIFrame = Instance.new("Frame")
mainUIFrame.Name = "MainFrame"
mainUIFrame.Size = UDim2.new(0, 520, 0, 360) -- Optimized size for Sidebar + Content
mainUIFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainUIFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainUIFrame.BackgroundColor3 = Theme.Background
mainUIFrame.BorderSizePixel = 0
mainUIFrame.Parent = modernScreenGui
mainUIFrame.Active = true
mainUIFrame.Draggable = true
mainUIFrame.ClipsDescendants = true

Instance.new("UICorner", mainUIFrame).CornerRadius = UDim.new(0, 12)
local frameStroke = Instance.new("UIStroke", mainUIFrame)
frameStroke.Color = Theme.Border
frameStroke.Thickness = 1

-- Header Bar
local headerBar = Instance.new("Frame")
headerBar.Name = "Header"
headerBar.Size = UDim2.new(1, 0, 0, 45)
headerBar.BackgroundColor3 = Theme.Surface
headerBar.BorderSizePixel = 0
headerBar.Parent = mainUIFrame

local headerTitle = Instance.new("TextLabel")
headerTitle.Size = UDim2.new(1, -60, 1, 0)
headerTitle.Position = UDim2.new(0, 16, 0, 0)
headerTitle.BackgroundTransparency = 1
headerTitle.Text = "PROJECT MENU"
headerTitle.TextColor3 = Theme.TextMain
headerTitle.Font = Theme.FontBold
headerTitle.TextSize = 13
headerTitle.TextXAlignment = Enum.TextXAlignment.Left
headerTitle.Parent = headerBar

-- Shadow
local shadow = Instance.new("ImageLabel")
shadow.Parent = mainUIFrame
shadow.BackgroundTransparency = 1
shadow.Size = UDim2.new(1, 40, 1, 40)
shadow.Position = UDim2.new(0.5, -20, 0.5, -20)
shadow.Image = "rbxassetid://6015897843"
shadow.ImageColor3 = Color3.new(0,0,0)
shadow.ImageTransparency = 0.6
shadow.ZIndex = -1

---------------------------------------------------------------------
-- SIDEBAR SYSTEM
---------------------------------------------------------------------
local sidebarFrame = Instance.new("Frame")
sidebarFrame.Name = "Sidebar"
sidebarFrame.Size = UDim2.new(0, 140, 1, -45)
sidebarFrame.Position = UDim2.new(0, 0, 0, 45)
sidebarFrame.BackgroundColor3 = Theme.Surface
sidebarFrame.BorderSizePixel = 0
sidebarFrame.Parent = mainUIFrame

-- Divider line between sidebar and content
local sidebarLine = Instance.new("Frame")
sidebarLine.Size = UDim2.new(0, 1, 1, 0)
sidebarLine.Position = UDim2.new(1, -1, 0, 0)
sidebarLine.BackgroundColor3 = Theme.Border
sidebarLine.BorderSizePixel = 0
sidebarLine.Parent = sidebarFrame

local sidebarList = Instance.new("UIListLayout")
sidebarList.Parent = sidebarFrame
sidebarList.Padding = UDim.new(0, 4)
sidebarList.SortOrder = Enum.SortOrder.LayoutOrder

local sidebarPadding = Instance.new("UIPadding", sidebarFrame)
sidebarPadding.PaddingLeft = UDim.new(0, 8)
sidebarPadding.PaddingRight = UDim.new(0, 8)
sidebarPadding.PaddingTop = UDim.new(0, 12)

-- Content Container
local contentContainer = Instance.new("Frame")
contentContainer.Name = "ContentContainer"
contentContainer.Size = UDim2.new(1, -140, 1, -45)
contentContainer.Position = UDim2.new(0, 140, 0, 45)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainUIFrame

---------------------------------------------------------------------
-- MINIMIZE BUTTON
---------------------------------------------------------------------
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinButton"
minimizeButton.Size = UDim2.new(0, 28, 0, 28)
minimizeButton.Position = UDim2.new(1, -36, 0, 8)
minimizeButton.Text = "—"
minimizeButton.TextSize = 12
minimizeButton.BackgroundColor3 = Theme.SurfaceAccent
minimizeButton.TextColor3 = Theme.TextMuted
minimizeButton.Font = Theme.FontBold
minimizeButton.BorderSizePixel = 0
minimizeButton.Parent = headerBar

Instance.new("UICorner", minimizeButton).CornerRadius = UDim.new(0, 6)
local minStroke = Instance.new("UIStroke", minimizeButton)
minStroke.Color = Theme.Border
minStroke.Thickness = 1

minimizeButton.MouseEnter:Connect(function()
    TweenService:Create(minimizeButton, Theme.TweenInfo, {BackgroundColor3 = Color3.fromRGB(230, 75, 75), TextColor3 = Theme.TextMain}):Play()
end)
minimizeButton.MouseLeave:Connect(function()
    TweenService:Create(minimizeButton, Theme.TweenInfo, {BackgroundColor3 = Theme.SurfaceAccent, TextColor3 = Theme.TextMuted}):Play()
end)
minimizeButton.MouseButton1Click:Connect(function()
    mainUIFrame.Visible = false
    floatingMinimizedIcon.Visible = true
end)
floatingMinimizedIcon.MouseButton1Click:Connect(function()
    floatingMinimizedIcon.Visible = false
    mainUIFrame.Visible = true
end)

---------------------------------------------------------------------
-- UI HELPERS
---------------------------------------------------------------------
local function CreatePage()
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Theme.SurfaceAccent
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.Visible = false
    scroll.Parent = contentContainer

    local list = Instance.new("UIListLayout")
    list.Parent = scroll
    list.Padding = UDim.new(0, 10)
    list.SortOrder = Enum.SortOrder.LayoutOrder

    local padding = Instance.new("UIPadding", scroll)
    padding.PaddingLeft = UDim.new(0, 16)
    padding.PaddingRight = UDim.new(0, 16)
    padding.PaddingTop = UDim.new(0, 14)
    padding.PaddingBottom = UDim.new(0, 14)

    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 20)
    end)

    return scroll
end

local function CreateRowContainer(parent)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 38)
    row.BackgroundTransparency = 1
    row.Parent = parent
    return row
end

local function CreateButton(parent, name, text, size, pos)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = size or UDim2.new(1, 0, 1, 0)
    button.Position = pos or UDim2.new(0, 0, 0, 0)
    button.Text = text
    button.TextColor3 = Theme.TextMain
    button.Font = Theme.FontMain
    button.TextSize = 13
    button.BackgroundColor3 = Theme.Surface
    button.BorderSizePixel = 0
    button.Parent = parent

    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", button)
    stroke.Color = Theme.Border
    stroke.Thickness = 1

    button.MouseEnter:Connect(function()
        TweenService:Create(button, Theme.TweenInfo, {BackgroundColor3 = Theme.SurfaceAccent}):Play()
        TweenService:Create(stroke, Theme.TweenInfo, {Color = Theme.Accent, Transparency = 0.4}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, Theme.TweenInfo, {BackgroundColor3 = Theme.Surface}):Play()
        TweenService:Create(stroke, Theme.TweenInfo, {Color = Theme.Border, Transparency = 0}):Play()
    end)

    return button
end

local function CreateTextInput(parent, placeholder, size, pos)
    local box = Instance.new("TextBox")
    box.Size = size or UDim2.new(1, 0, 1, 0)
    box.Position = pos or UDim2.new(0, 0, 0, 0)
    box.PlaceholderText = placeholder
    box.BackgroundColor3 = Theme.Background
    box.ClearTextOnFocus = false
    box.Text = ""
    box.TextColor3 = Theme.TextMain
    box.PlaceholderColor3 = Theme.TextMuted
    box.Font = Theme.FontMain
    box.TextSize = 13
    box.BorderSizePixel = 0
    box.Parent = parent
    
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", box)
    stroke.Color = Theme.Border
    stroke.Thickness = 1

    box.Focused:Connect(function()
        TweenService:Create(stroke, Theme.TweenInfo, {Color = Theme.Accent, Thickness = 1.2}):Play()
    end)
    box.FocusLost:Connect(function()
        TweenService:Create(stroke, Theme.TweenInfo, {Color = Theme.Border, Thickness = 1}):Play()
    end)

    return box
end

---------------------------------------------------------------------
-- CREATE PAGES & SEPARATE FEATURES
---------------------------------------------------------------------
local pageStats = CreatePage()
local pageUtils = CreatePage()
local pageTeleport = CreatePage()

-- Tab 1: Stats Elements
local wsRow = CreateRowContainer(pageStats)
local walkSpeedInput = CreateTextInput(wsRow, " WalkSpeed...", UDim2.new(0, 120, 1, 0))
local setWalkSpeedButton = CreateButton(wsRow, "SetWalkSpeed", "Set WalkSpeed", UDim2.new(1, -130, 1, 0), UDim2.new(0, 130, 0, 0))

local jhRow = CreateRowContainer(pageStats)
local jumpHeightInput = CreateTextInput(jhRow, " JumpHeight...", UDim2.new(0, 120, 1, 0))
local setJumpHeightButton = CreateButton(jhRow, "SetJumpHeight", "Set JumpHeight", UDim2.new(1, -130, 1, 0), UDim2.new(0, 130, 0, 0))

local fovRow = CreateRowContainer(pageStats)
local fovInput = CreateTextInput(fovRow, " Field of View...", UDim2.new(0, 120, 1, 0))
local setFOVButton = CreateButton(fovRow, "SetFOV", "Set FOV", UDim2.new(1, -130, 1, 0), UDim2.new(0, 130, 0, 0))

-- Tab 2: Utilities Elements
local rowUtil1 = CreateRowContainer(pageUtils)
local infiniteJumpButton = CreateButton(rowUtil1, "InfiniteJump", "Infinite Jump", UDim2.new(0, 164, 1, 0))
local antiAFKButton = CreateButton(rowUtil1, "AntiAFK", "Anti-AFK", UDim2.new(0, 164, 1, 0), UDim2.new(0, 174, 0, 0))

local rowUtil2 = CreateRowContainer(pageUtils)
local noclipButton = CreateButton(rowUtil2, "Btn_Noclip", "Noclip", UDim2.new(0, 164, 1, 0))
local instantInteractButton = CreateButton(rowUtil2, "InstantInteract", "Instant Interact", UDim2.new(0, 164, 1, 0), UDim2.new(0, 174, 0, 0))

-- Tab 3: Teleport Elements
local rowUtil3 = CreateRowContainer(pageTeleport)
local positionButton = CreateButton(rowUtil3, "PlayerPosition", "Show Position", UDim2.new(1, 0, 1, 0))

local tpInputRow = CreateRowContainer(pageTeleport)
local xInput = CreateTextInput(tpInputRow, " X", UDim2.new(0, 106, 1, 0))
local yInput = CreateTextInput(tpInputRow, " Y", UDim2.new(0, 106, 1, 0), UDim2.new(0, 116, 0, 0))
local zInput = CreateTextInput(tpInputRow, " Z", UDim2.new(0, 106, 1, 0), UDim2.new(0, 232, 0, 0))

local tpButtonRow = CreateRowContainer(pageTeleport)
local teleportButton = CreateButton(tpButtonRow, "Teleport", "Teleport to Coordinates")

---------------------------------------------------------------------
-- SIDEBAR NAVIGATION LOGIC
---------------------------------------------------------------------
local pages = { Stats = pageStats, Utilities = pageUtils, Teleport = pageTeleport }
local tabButtons = {}

local function switchTab(tabName)
    for name, page in pairs(pages) do
        page.Visible = (name == tabName)
    end
    for name, btn in pairs(tabButtons) do
        if name == tabName then
            TweenService:Create(btn, Theme.TweenInfo, {BackgroundColor3 = Theme.SurfaceAccent, TextColor3 = Theme.Accent}):Play()
            btn.UIStroke.Color = Theme.Accent
        else
            TweenService:Create(btn, Theme.TweenInfo, {BackgroundColor3 = Color3.fromRGB(0,0,0), BackgroundTransparency = 1, TextColor3 = Theme.TextMuted}):Play()
            btn.UIStroke.Color = Color3.fromRGB(0,0,0)
        end
    end
end

local function CreateSidebarTab(name, displayName)
    local btn = Instance.new("TextButton")
    btn.Name = name .. "Tab"
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundTransparency = 1
    btn.Text = displayName
    btn.TextColor3 = Theme.TextMuted
    btn.Font = Theme.FontMain
    btn.TextSize = 13
    btn.BorderSizePixel = 0
    btn.Parent = sidebarFrame

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(0,0,0)
    stroke.Thickness = 1

    btn.MouseButton1Click:Connect(function()
        switchTab(name)
    end)
    tabButtons[name] = btn
end

CreateSidebarTab("Stats", "Player Stats")
CreateSidebarTab("Utilities", "Utilities")
CreateSidebarTab("Teleport", "Teleportation")

-- Initialize menu on the first tab
switchTab("Stats")

---------------------------------------------------------------------
-- CORE FUNCTIONAL CONNECTIONS (PRESERVED)
---------------------------------------------------------------------

-- WalkSpeed
setWalkSpeedButton.MouseButton1Click:Connect(function()
    local n = tonumber(walkSpeedInput.Text)
    local char = localPlayer.Character
    if n and char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = n
    end
end)

-- Jump Height
setJumpHeightButton.MouseButton1Click:Connect(function()
    local n = tonumber(jumpHeightInput.Text)
    local char = localPlayer.Character
    if n and char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpHeight = n
    end
end)

-- Infinite Jump
local infiniteJumpEnabled = false
local infiniteJumpConnection
infiniteJumpButton.MouseButton1Click:Connect(function()
    infiniteJumpEnabled = not infiniteJumpEnabled
    infiniteJumpButton.Text = infiniteJumpEnabled and "Infinite Jump: ON" or "Infinite Jump"
    infiniteJumpButton.TextColor3 = infiniteJumpEnabled and Theme.Accent or Theme.TextMain

    if infiniteJumpEnabled then
        infiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
            local c = localPlayer.Character
            local h = c and c:FindFirstChild("Humanoid")
            if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    else
        if infiniteJumpConnection then infiniteJumpConnection:Disconnect() end
    end
end)

-- FOV
setFOVButton.MouseButton1Click:Connect(function()
    local n = tonumber(fovInput.Text)
    if n then
        n = math.clamp(n, 10, 120)
        local camera = workspace.CurrentCamera
        if camera then camera.FieldOfView = n end
    end
end)

-- Anti AFK
local antiAFKEnabled = false
local antiAFKConnection = nil
antiAFKButton.MouseButton1Click:Connect(function()
    antiAFKEnabled = not antiAFKEnabled
    antiAFKButton.Text = antiAFKEnabled and "Anti-AFK: ON" or "Anti-AFK"
    antiAFKButton.TextColor3 = antiAFKEnabled and Theme.Accent or Theme.TextMain

    if antiAFKEnabled then
        antiAFKConnection = localPlayer.Idle:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    else
        if antiAFKConnection then
            antiAFKConnection:Disconnect()
            antiAFKConnection = nil
        end
    end
end)

-- Noclip
local noclipEnabled = false
local NoclipConnection = nil

local function EnableNoclip()
    if NoclipConnection then return end
    NoclipConnection = RunService.Stepped:Connect(function()
        local char = localPlayer.Character
        if not char then return end
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then
                v.CanCollide = false
            end
        end
    end)
end

local function DisableNoclip()
    if NoclipConnection then
        NoclipConnection:Disconnect()
        NoclipConnection = nil
    end
end

noclipButton.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    noclipButton.TextColor3 = noclipEnabled and Theme.Accent or Theme.TextMain
    if noclipEnabled then
        EnableNoclip()
        noclipButton.Text = "Noclip: ON"
    else
        DisableNoclip()
        noclipButton.Text = "Noclip"
    end
end)

localPlayer.CharacterAdded:Connect(function()
    if noclipEnabled then
        task.wait(0.5)
        EnableNoclip()
    end
end)

-- Instant Interact
local instantInteractEnabled = false
local instantInteractConnection = nil

local function EnableInstantInteract()
    if instantInteractConnection then return end
    instantInteractConnection = ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
        fireproximityprompt(prompt)
    end)
end

local function DisableInstantInteract()
    if instantInteractConnection then
        instantInteractConnection:Disconnect()
        instantInteractConnection = nil
    end
end

instantInteractButton.MouseButton1Click:Connect(function()
    instantInteractEnabled = not instantInteractEnabled
    instantInteractButton.TextColor3 = instantInteractEnabled and Theme.Accent or Theme.TextMain
    if instantInteractEnabled then
        instantInteractButton.Text = "Instant Interact: ON"
        EnableInstantInteract()
    else
        instantInteractButton.Text = "Instant Interact"
        DisableInstantInteract()
    end
end)

-- Player Position Module
local positionFrame = Instance.new("Frame")
positionFrame.Name = "PositionFrame"
positionFrame.Size = UDim2.new(0, 160, 0, 36)
positionFrame.Position = UDim2.new(0, 30, 0, 90)
positionFrame.BackgroundColor3 = Theme.Surface
positionFrame.BorderSizePixel = 0
positionFrame.Visible = false
positionFrame.Active = true
positionFrame.Draggable = true
positionFrame.Parent = modernScreenGui

Instance.new("UICorner", positionFrame).CornerRadius = UDim.new(0, 6)
local posStroke = Instance.new("UIStroke", positionFrame)
posStroke.Color = Theme.Accent
posStroke.Thickness = 1
posStroke.Transparency = 0.4

local posLabel = Instance.new("TextLabel")
posLabel.Size = UDim2.new(1, -20, 1, 0)
posLabel.Position = UDim2.new(0, 10, 0, 0)
posLabel.BackgroundTransparency = 1
posLabel.TextColor3 = Theme.TextMain
posLabel.Font = Theme.FontBold
posLabel.TextSize = 12
posLabel.Text = "0, 0, 0"
posLabel.TextXAlignment = Enum.TextXAlignment.Center
posLabel.Parent = positionFrame

local positionEnabled = false
positionButton.MouseButton1Click:Connect(function()
    positionEnabled = not positionEnabled
    positionFrame.Visible = positionEnabled
    positionButton.Text = positionEnabled and "Show Position: ON" or "Show Position"
    positionButton.TextColor3 = positionEnabled and Theme.Accent or Theme.TextMain
end)

RunService.RenderStepped:Connect(function()
    if positionEnabled then
        local char = localPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            local pos = root.Position
            posLabel.Text = string.format("X: %d  Y: %d  Z: %d", math.floor(pos.X), math.floor(pos.Y), math.floor(pos.Z))
        end
    end
end)

-- Coordinate Teleportation
teleportButton.MouseButton1Click:Connect(function()
    local x = tonumber(xInput.Text)
    local y = tonumber(yInput.Text)
    local z = tonumber(zInput.Text)
    local char = localPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if root and x and y and z then
        root.CFrame = CFrame.new(Vector3.new(x, y, z))
    end
end)
