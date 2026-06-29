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

--// Theme Configuration (Sleek Dark Premium)
local THEME = {
    Background = Color3.fromRGB(15, 15, 18),
    CardBG = Color3.fromRGB(24, 24, 30),
    CardHover = Color3.fromRGB(32, 32, 42),
    Accent = Color3.fromRGB(0, 162, 255),
    AccentGlow = Color3.fromRGB(0, 162, 255),
    Text = Color3.fromRGB(245, 245, 247),
    MutedText = Color3.fromRGB(130, 130, 145),
    Border = Color3.fromRGB(38, 38, 45),
    FontMain = Enum.Font.BuilderSansMedium,
    FontBold = Enum.Font.BuilderSansBold
}

--// ScreenGui
local modernScreenGui = Instance.new("ScreenGui")
modernScreenGui.Name = "ModernUI"
modernScreenGui.ResetOnSpawn = false
modernScreenGui.Parent = playerGui

--// Floating Minimized Pill Icon
local floatingMinimizedIcon = Instance.new("TextButton")
floatingMinimizedIcon.Name = "FloatingIcon"
floatingMinimizedIcon.Size = UDim2.new(0, 50, 0, 50)
floatingMinimizedIcon.Position = UDim2.new(0, 30, 0, 30)
floatingMinimizedIcon.Text = "UI"
floatingMinimizedIcon.TextSize = 16
floatingMinimizedIcon.TextColor3 = THEME.Text
floatingMinimizedIcon.Font = THEME.FontBold
floatingMinimizedIcon.Visible = false
floatingMinimizedIcon.BackgroundColor3 = THEME.Background
floatingMinimizedIcon.BorderSizePixel = 0
floatingMinimizedIcon.Active = true
floatingMinimizedIcon.Draggable = true

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(1, 0)
iconCorner.Parent = floatingMinimizedIcon

local iconStroke = Instance.new("UIStroke")
iconStroke.Color = THEME.Accent
iconStroke.Thickness = 1.5
iconStroke.Transparency = 0.3
iconStroke.Parent = floatingMinimizedIcon

floatingMinimizedIcon.Parent = modernScreenGui

---------------------------------------------------------------------
-- MAIN FRAME
---------------------------------------------------------------------
local mainUIFrame = Instance.new("Frame")
mainUIFrame.Name = "MainFrame"
mainUIFrame.Size = UDim2.new(0, 360, 0, 320)
mainUIFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainUIFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainUIFrame.BackgroundColor3 = THEME.Background
mainUIFrame.BorderSizePixel = 0
mainUIFrame.Active = true
mainUIFrame.Draggable = true
mainUIFrame.ClipsDescendants = true

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 14)
frameCorner.Parent = mainUIFrame

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = THEME.Border
frameStroke.Thickness = 1
frameStroke.Parent = mainUIFrame

-- Drop Shadow
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.BackgroundTransparency = 1
shadow.Size = UDim2.new(1, 30, 1, 30)
shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Image = "rbxassetid://6015897843"
shadow.ImageColor3 = Color3.new(0, 0, 0)
shadow.ImageTransparency = 0.6
shadow.ZIndex = -1
shadow.Parent = mainUIFrame

-- Header Title
local headerTitle = Instance.new("TextLabel")
headerTitle.Name = "HeaderTitle"
headerTitle.Size = UDim2.new(1, -60, 0, 45)
headerTitle.Position = UDim2.new(0, 16, 0, 0)
headerTitle.BackgroundTransparency = 1
headerTitle.Text = "Dashboard"
headerTitle.TextColor3 = THEME.Text
headerTitle.TextSize = 18
headerTitle.Font = THEME.FontBold
headerTitle.TextXAlignment = Enum.TextXAlignment.Left
headerTitle.Parent = mainUIFrame

---------------------------------------------------------------------
-- MINIMIZE BUTTON
---------------------------------------------------------------------
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinButton"
minimizeButton.Size = UDim2.new(0, 28, 0, 28)
minimizeButton.Position = UDim2.new(1, -16, 0, 22)
minimizeButton.AnchorPoint = Vector2.new(1, 0.5)
minimizeButton.Text = "—"
minimizeButton.TextSize = 12
minimizeButton.BackgroundColor3 = THEME.CardBG
minimizeButton.TextColor3 = THEME.MutedText
minimizeButton.Font = THEME.FontMain
minimizeButton.BorderSizePixel = 0
minimizeButton.Parent = mainUIFrame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 8)
minCorner.Parent = minimizeButton

local minStroke = Instance.new("UIStroke")
minStroke.Color = THEME.Border
minStroke.Thickness = 1
minStroke.Parent = minimizeButton

minimizeButton.MouseEnter:Connect(function()
    TweenService:Create(minimizeButton, TweenInfo.new(0.15), {BackgroundColor3 = THEME.CardHover, TextColor3 = THEME.Text}):Play()
end)
minimizeButton.MouseLeave:Connect(function()
    TweenService:Create(minimizeButton, TweenInfo.new(0.15), {BackgroundColor3 = THEME.CardBG, TextColor3 = THEME.MutedText}):Play()
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
-- SCROLLABLE CONTENT AREA
---------------------------------------------------------------------
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Name = "ContentScroll"
contentFrame.Position = UDim2.new(0, 16, 0, 50)
contentFrame.Size = UDim2.new(1, -32, 1, -65)
contentFrame.BackgroundTransparency = 1
contentFrame.ScrollBarThickness = 4
contentFrame.ScrollBarImageColor3 = THEME.Border
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentFrame.Parent = mainUIFrame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 8)
listLayout.Parent = contentFrame

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end)

---------------------------------------------------------------------
-- UI CREATION HELPERS (Fixed Layout Architecture)
---------------------------------------------------------------------
local function CreateRowContainer(layoutOrder)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -4, 0, 36)
    row.BackgroundTransparency = 1
    row.LayoutOrder = layoutOrder or 0
    row.Parent = contentFrame

    local rowLayout = Instance.new("UIListLayout")
    rowLayout.FillDirection = Enum.FillDirection.Horizontal
    rowLayout.SortOrder = Enum.SortOrder.LayoutOrder
    rowLayout.Padding = UDim.new(0, 8)
    rowLayout.Parent = row

    return row
end

local function CreateButton(parent, text, sizeScaleX)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(sizeScaleX or 1, 0, 1, 0)
    button.Text = text
    button.TextColor3 = THEME.Text
    button.Font = THEME.FontMain
    button.TextSize = 14
    button.BackgroundColor3 = THEME.CardBG
    button.BorderSizePixel = 0
    button.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button

    local stroke = Instance.new("UIStroke")
    stroke.Color = THEME.Border
    stroke.Thickness = 1
    stroke.Parent = button

    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = THEME.CardHover, BorderSizePixel = 0}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.15), {Color = THEME.Accent}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = THEME.CardBG}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.15), {Color = THEME.Border}):Play()
    end)

    return button, stroke
end

local function CreateTextInput(parent, placeholder, sizeScaleX)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(sizeScaleX or 1, 0, 1, 0)
    box.PlaceholderText = placeholder
    box.BackgroundColor3 = THEME.CardBG
    box.ClearTextOnFocus = false
    box.Text = ""
    box.TextColor3 = THEME.Text
    box.PlaceholderColor3 = THEME.MutedText
    box.Font = THEME.FontMain
    box.TextSize = 14
    box.BorderSizePixel = 0
    box.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = box

    local stroke = Instance.new("UIStroke")
    stroke.Color = THEME.Border
    stroke.Thickness = 1
    stroke.Parent = box

    box.Focused:Connect(function()
        TweenService:Create(stroke, TweenInfo.new(0.15), {Color = THEME.Accent}):Play()
    end)
    box.FocusLost:Connect(function()
        TweenService:Create(stroke, TweenInfo.new(0.15), {Color = THEME.Border}):Play()
    end)

    return box
end

---------------------------------------------------------------------
-- GENERATING INTERFACE ROWS
---------------------------------------------------------------------
-- Row 1: WalkSpeed
local row1 = CreateRowContainer(1)
local walkSpeedInput = CreateTextInput(row1, "WalkSpeed (e.g. 32)", 0.4)
local setWalkSpeedButton = CreateButton(row1, "Set Speed", 0.6)

-- Row 2: JumpHeight
local row2 = CreateRowContainer(2)
local jumpHeightInput = CreateTextInput(row2, "JumpHeight (e.g. 50)", 0.4)
local setJumpHeightButton = CreateButton(row2, "Set Jump", 0.6)

-- Row 3: FOV
local row3 = CreateRowContainer(3)
local fovInput = CreateTextInput(row3, "Field of View", 0.4)
local setFOVButton = CreateButton(row3, "Set FOV", 0.6)

-- Row 4: Toggles (Inf Jump & Anti-AFK side-by-side)
local row4 = CreateRowContainer(4)
local infiniteJumpButton = CreateButton(row4, "Infinite Jump", 0.5)
local antiAFKButton = CreateButton(row4, "Anti-AFK", 0.5)

-- Row 5: Toggles Part 2 (Noclip & Instant Interact)
local row5 = CreateRowContainer(5)
local noclipButton = CreateButton(row5, "Noclip", 0.5)
local instantInteractButton = CreateButton(row5, "Instant Interact", 0.5)

-- Row 6: Live Position Toggle
local row6 = CreateRowContainer(6)
local positionButton = CreateButton(row6, "Show Live Coordinates", 1)

-- Row 7: Teleport Coordinates (X, Y, Z split equally)
local row7 = CreateRowContainer(7)
local xInput = CreateTextInput(row7, "X", 0.33)
local yInput = CreateTextInput(row7, "Y", 0.33)
local zInput = CreateTextInput(row7, "Z", 0.34)

-- Row 8: Teleport Action
local row8 = CreateRowContainer(8)
local teleportButton = CreateButton(row8, "Teleport to Coordinates", 1)

---------------------------------------------------------------------
-- FUNCTIONAL LOGIC & CONNECTIONS
---------------------------------------------------------------------

-- Walkspeed Execution
setWalkSpeedButton.MouseButton1Click:Connect(function()
    local n = tonumber(walkSpeedInput.Text)
    local char = localPlayer.Character
    if n and char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = n
    end
end)

-- Jump Height Execution
setJumpHeightButton.MouseButton1Click:Connect(function()
    local n = tonumber(jumpHeightInput.Text)
    local char = localPlayer.Character
    if n and char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpHeight = n
    end
end)

-- FOV Execution
setFOVButton.MouseButton1Click:Connect(function()
    local n = tonumber(fovInput.Text)
    if n then
        n = math.clamp(n, 10, 120)
        local camera = workspace.CurrentCamera
        if camera then camera.FieldOfView = n end
    end
end)

-- Infinite Jump Logic
local infiniteJumpEnabled = false
local infiniteJumpConnection
infiniteJumpButton.MouseButton1Click:Connect(function()
    infiniteJumpEnabled = not infiniteJumpEnabled
    infiniteJumpButton.Text = infiniteJumpEnabled and "Infinite Jump: ON" or "Infinite Jump"
    infiniteJumpButton.TextColor3 = infiniteJumpEnabled and THEME.Accent or THEME.Text

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

-- Anti-AFK Logic
local antiAFKEnabled = false
local antiAFKConnection
antiAFKButton.MouseButton1Click:Connect(function()
    antiAFKEnabled = not antiAFKEnabled
    antiAFKButton.Text = antiAFKEnabled and "Anti-AFK: ON" or "Anti-AFK"
    antiAFKButton.TextColor3 = antiAFKEnabled and THEME.Accent or THEME.Text

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

-- Noclip Framework
local noclipEnabled = false
local noclipConnection

local function EnableNoclip()
    if noclipConnection then return end
    noclipConnection = RunService.Stepped:Connect(function()
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
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
end

noclipButton.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    noclipButton.TextColor3 = noclipEnabled and THEME.Accent or THEME.Text
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

-- Instant Interact Logic
local instantInteractEnabled = false
local instantInteractConnection

local function EnableInstantInteract()
    if instantInteractConnection then return end
    instantInteractConnection = ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
        if fireproximityprompt then fireproximityprompt(prompt) end
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
    instantInteractButton.TextColor3 = instantInteractEnabled and THEME.Accent or THEME.Text
    if instantInteractEnabled then
        instantInteractButton.Text = "Instant Interact: ON"
        EnableInstantInteract()
    else
        instantInteractButton.Text = "Instant Interact"
        DisableInstantInteract()
    end
end)

---------------------------------------------------------------------
-- LIVE OVERLAY POSITION COORDINATES
---------------------------------------------------------------------
local positionFrame = Instance.new("Frame")
positionFrame.Name = "PositionFrame"
positionFrame.Size = UDim2.new(0, 160, 0, 36)
positionFrame.Position = UDim2.new(0, 30, 1, -70)
positionFrame.BackgroundColor3 = THEME.Background
positionFrame.BorderSizePixel = 0
positionFrame.Visible = false
positionFrame.Active = true
positionFrame.Draggable = true
positionFrame.Parent = modernScreenGui

local posCorner = Instance.new("UICorner")
posCorner.CornerRadius = UDim.new(0, 8)
posCorner.Parent = positionFrame

local posStroke = Instance.new("UIStroke")
posStroke.Color = THEME.Accent
posStroke.Thickness = 1
posStroke.Parent = positionFrame

local posLabel = Instance.new("TextLabel")
posLabel.Size = UDim2.new(1, 0, 1, 0)
posLabel.BackgroundTransparency = 1
posLabel.TextColor3 = THEME.Text
posLabel.Font = THEME.FontBold
posLabel.TextSize = 13
posLabel.Text = "X: 0 | Y: 0 | Z: 0"
posLabel.Parent = positionFrame

local positionEnabled = false
positionButton.MouseButton1Click:Connect(function()
    positionEnabled = not positionEnabled
    positionFrame.Visible = positionEnabled
    positionButton.Text = positionEnabled and "Show Coordinates: ON" or "Show Coordinates"
    positionButton.TextColor3 = positionEnabled and THEME.Accent or THEME.Text
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

-- Teleport Execution
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
