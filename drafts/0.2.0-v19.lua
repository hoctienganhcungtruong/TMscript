local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local VirtualUser = game:GetService("VirtualUser")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("ModernUI") then
    playerGui.ModernUI:Destroy()
end

local Theme = {
    Background = Color3.fromRGB(11, 11, 14),
    Surface = Color3.fromRGB(18, 18, 24),
    SurfaceAccent = Color3.fromRGB(26, 26, 36),
    Accent = Color3.fromRGB(0, 162, 255),
    AccentGlow = Color3.fromRGB(0, 110, 255),
    TextMain = Color3.fromRGB(255, 255, 255),
    TextMuted = Color3.fromRGB(140, 140, 155),
    Border = Color3.fromRGB(35, 35, 45),
    FontMain = Enum.Font.Gotham,
    FontBold = Enum.Font.GothamBold,
    TweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
}

local modernScreenGui = Instance.new("ScreenGui")
modernScreenGui.Name = "ModernUI"
modernScreenGui.ResetOnSpawn = false
modernScreenGui.Parent = playerGui

local floatingMinimizedIcon = Instance.new("TextButton")
floatingMinimizedIcon.Name = "FloatingIcon"
floatingMinimizedIcon.Size = UDim2.new(0, 40, 0, 40)
floatingMinimizedIcon.Position = UDim2.new(0, 30, 0, 30)
floatingMinimizedIcon.Text = "UI"
floatingMinimizedIcon.TextScaled = false
floatingMinimizedIcon.TextSize = 12
floatingMinimizedIcon.TextColor3 = Theme.TextMain
floatingMinimizedIcon.Font = Theme.FontBold
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

local mainUIFrame = Instance.new("Frame")
mainUIFrame.Name = "MainFrame"
mainUIFrame.Size = UDim2.new(0, 310, 0, 310)
mainUIFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainUIFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainUIFrame.BackgroundColor3 = Theme.Background
mainUIFrame.BorderSizePixel = 0
mainUIFrame.Parent = modernScreenGui
mainUIFrame.Active = true
mainUIFrame.ClipsDescendants = false

Instance.new("UICorner", mainUIFrame).CornerRadius = UDim.new(0, 8)
local frameStroke = Instance.new("UIStroke", mainUIFrame)
frameStroke.Color = Theme.Border
frameStroke.Thickness = 1

local dragging = false
local dragInput
local dragStart
local startPos
local BORDER_SIZE = 5

local function StartDrag(input)
    dragging = true
    dragStart = input.Position
    startPos = mainUIFrame.Position

    local conn
    conn = input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
            dragging = false
            dragInput = nil
            conn:Disconnect()
        end
    end)
end

local function ConnectDrag(frame)
    frame.Active = true

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            StartDrag(input)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
end

local function CreateDragBorder(name, size, position)
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.Size = size
    frame.Position = position
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.ZIndex = 10
    frame.Parent = mainUIFrame

    ConnectDrag(frame)

    return frame
end

local topBorder = CreateDragBorder("TopBorder", UDim2.new(1, 0, 0, BORDER_SIZE), UDim2.new(0, 0, 0, 0))
local bottomBorder = CreateDragBorder("BottomBorder", UDim2.new(1, 0, 0, BORDER_SIZE), UDim2.new(0, 0, 1, -BORDER_SIZE))
local leftBorder = CreateDragBorder("LeftBorder", UDim2.new(0, BORDER_SIZE, 1, -BORDER_SIZE * 2), UDim2.new(0, 0, 0, BORDER_SIZE))
local rightBorder = CreateDragBorder("RightBorder", UDim2.new(0, BORDER_SIZE, 1, -BORDER_SIZE * 2), UDim2.new(1, -BORDER_SIZE, 0, BORDER_SIZE))

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart

        mainUIFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

local headerBar = Instance.new("Frame")
headerBar.Name = "Header"
headerBar.Size = UDim2.new(1, 0, 0, 36)
headerBar.BackgroundColor3 = Theme.Surface
headerBar.BorderSizePixel = 0
headerBar.Parent = mainUIFrame
ConnectDrag(headerBar)

local headerTitle = Instance.new("TextLabel")
headerTitle.Size = UDim2.new(1, -60, 1, 0)
headerTitle.Position = UDim2.new(0, 12, 0, 0)
headerTitle.BackgroundTransparency = 1
headerTitle.Text = "DASHBOARD"
headerTitle.TextColor3 = Theme.TextMain
headerTitle.Font = Theme.FontBold
headerTitle.TextSize = 11
headerTitle.TextXAlignment = Enum.TextXAlignment.Left
headerTitle.Parent = headerBar

local shadow = Instance.new("ImageLabel")
shadow.Parent = mainUIFrame
shadow.BackgroundTransparency = 1
shadow.Size = UDim2.new(1, 40, 1, 40)
shadow.Position = UDim2.new(0.5, -20, 0.5, -20)
shadow.Image = "rbxassetid://6015897843"
shadow.ImageColor3 = Color3.new(0,0,0)
shadow.ImageTransparency = 0.6
shadow.ZIndex = -1

local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Name = "ContentScroll"
contentFrame.Parent = mainUIFrame
contentFrame.Position = UDim2.new(0, 0, 0, 36)
contentFrame.Size = UDim2.new(1, 0, 1, -36)
contentFrame.BackgroundTransparency = 1
contentFrame.ScrollBarThickness = 4
contentFrame.ScrollBarImageColor3 = Theme.SurfaceAccent
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentFrame.ClipsDescendants = true
contentFrame.ZIndex = 2

local list = Instance.new("UIListLayout")
list.Parent = contentFrame
list.Padding = UDim.new(0, 6)
list.SortOrder = Enum.SortOrder.LayoutOrder

local padding = Instance.new("UIPadding", contentFrame)
padding.PaddingLeft = UDim.new(0, 12)
padding.PaddingRight = UDim.new(0, 12)
padding.PaddingTop = UDim.new(0, 10)
padding.PaddingBottom = UDim.new(0, 10)

list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 20)
end)

local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinButton"
minimizeButton.Size = UDim2.new(0, 22, 0, 22)
minimizeButton.Position = UDim2.new(1, -28, 0, 7)
minimizeButton.Text = "—"
minimizeButton.TextSize = 9
minimizeButton.BackgroundColor3 = Theme.SurfaceAccent
minimizeButton.TextColor3 = Theme.TextMuted
minimizeButton.Font = Theme.FontBold
minimizeButton.BorderSizePixel = 0
minimizeButton.ZIndex = 11
minimizeButton.Parent = headerBar

Instance.new("UICorner", minimizeButton).CornerRadius = UDim.new(0, 4)
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

local function CreateRowContainer(size)
    local row = Instance.new("Frame")
    row.Size = size or UDim2.new(1, 0, 0, 30)
    row.BackgroundTransparency = 1
    row.ClipsDescendants = true
    row.Parent = contentFrame
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
    button.TextSize = 11
    button.BackgroundColor3 = Theme.Surface
    button.BorderSizePixel = 0
    button.ZIndex = 3
    button.Parent = parent

    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 4)
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

local function createCollapsible(parent, title)
    if modernScreenGui and modernScreenGui.ZIndexBehavior ~= Enum.ZIndexBehavior.Global then
        modernScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    end

    local container = Instance.new("Frame")
    container.Name = title .. "Container"
    container.Size = UDim2.new(1, 0, 0, 32)
    container.BackgroundTransparency = 1
    container.ClipsDescendants = false
    container.ZIndex = 10
    container.Parent = parent

    local button = Instance.new("TextButton")
    button.Name = "Toggle"
    button.Size = UDim2.new(1, 0, 0, 32)
    button.BackgroundColor3 = Theme.Surface
    button.Text = "▼ " .. title
    button.TextColor3 = Theme.TextMain
    button.Font = Theme.FontBold
    button.TextSize = 11
    button.BorderSizePixel = 0
    button.ZIndex = 12
    button.Parent = container

    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 4)
    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.Border
    stroke.Parent = button

    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, 0, 0, 0)
    content.Position = UDim2.new(0, 0, 0, 36)
    content.BackgroundColor3 = Theme.Surface
    content.BackgroundTransparency = 0.4
    content.ClipsDescendants = true
    content.ZIndex = 11
    content.Parent = container

    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 6)
    contentCorner.Parent = content

    local contentStroke = Instance.new("UIStroke")
    contentStroke.Color = Theme.Border
    contentStroke.Transparency = 0.5
    contentStroke.Parent = content

    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingLeft = UDim.new(0, 6)
    contentPadding.PaddingRight = UDim.new(0, 6)
    contentPadding.PaddingTop = UDim.new(0, 6)
    contentPadding.PaddingBottom = UDim.new(0, 6)
    contentPadding.Parent = content

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = content

    local expanded = false

    local function updateSize()
        local internalHeight = layout.AbsoluteContentSize.Y
        local paddingHeight = 12
        local targetContentHeight = expanded and (internalHeight > 0 and (internalHeight + paddingHeight) or 45) or 0

        TweenService:Create(content, Theme.TweenInfo, { Size = UDim2.new(1, 0, 0, targetContentHeight) }):Play()

        local targetContainerHeight = 32 + (expanded and (targetContentHeight + 6) or 0)
        TweenService:Create(container, Theme.TweenInfo, { Size = UDim2.new(1, 0, 0, targetContainerHeight) }):Play()

        button.Text = (expanded and "▲ " or "▼ ") .. title
    end

    button.MouseButton1Click:Connect(function()
        expanded = not expanded
        updateSize()
    end)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if expanded then updateSize() end
    end)

    task.defer(function() updateSize() end)

    return {
        Frame = container,
        Content = content,
        Toggle = button
    }
end

local function createPlayerCard(player, parent)
    local card = Instance.new("Frame")
    card.Name = player.Name .. "Card"
    card.Size = UDim2.new(1, 0, 0, 50)
    card.BackgroundColor3 = Theme.Surface
    card.BorderSizePixel = 0
    card.ZIndex = 100
    card.Parent = parent

    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", card)
    stroke.Color = Theme.Border
    stroke.Thickness = 1

    local clickBtn = Instance.new("TextButton")
    clickBtn.Name = "ClickTrigger"
    clickBtn.Size = UDim2.new(1, 0, 1, 0)
    clickBtn.BackgroundTransparency = 1
    clickBtn.Text = ""
    clickBtn.ZIndex = 150
    clickBtn.Parent = card

    local avatar = Instance.new("ImageLabel")
    avatar.Name = "Avatar"
    avatar.Size = UDim2.new(0, 38, 0, 38)
    avatar.Position = UDim2.new(0, 6, 0.5, -19)
    avatar.BackgroundTransparency = 1
    avatar.ZIndex = 101
    avatar.Parent = card
    Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)

    task.spawn(function()
        local success, image = pcall(function()
            return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
        end)
        if success then avatar.Image = image end
    end)

    local displayName = Instance.new("TextLabel")
    displayName.Name = "DisplayName"
    displayName.Size = UDim2.new(1, -55, 0, 18)
    displayName.Position = UDim2.new(0, 50, 0, 6)
    displayName.BackgroundTransparency = 1
    displayName.Text = player.DisplayName
    displayName.TextColor3 = Theme.TextMain
    displayName.Font = Theme.FontBold
    displayName.TextSize = 11
    displayName.TextXAlignment = Enum.TextXAlignment.Left
    displayName.ZIndex = 101
    displayName.Parent = card

    local username = Instance.new("TextLabel")
    username.Name = "Username"
    username.Size = UDim2.new(1, -55, 0, 16)
    username.Position = UDim2.new(0, 50, 0, 24)
    username.BackgroundTransparency = 1
    username.Text = "@" .. player.Name
    username.TextColor3 = Theme.TextMuted
    username.Font = Theme.FontMain
    username.TextSize = 10
    username.TextXAlignment = Enum.TextXAlignment.Left
    username.ZIndex = 101
    username.Parent = card

    local selected = false

    local function updateVisual()
        if selected then
            TweenService:Create(card, Theme.TweenInfo, {BackgroundColor3 = Theme.SurfaceAccent}):Play()
            TweenService:Create(stroke, Theme.TweenInfo, {Color = Theme.Accent, Thickness = 2}):Play()
            TweenService:Create(displayName, Theme.TweenInfo, {TextColor3 = Theme.Accent}):Play()
        else
            TweenService:Create(card, Theme.TweenInfo, {BackgroundColor3 = Theme.Surface}):Play()
            TweenService:Create(stroke, Theme.TweenInfo, {Color = Theme.Border, Thickness = 1}):Play()
            TweenService:Create(displayName, Theme.TweenInfo, {TextColor3 = Theme.TextMain}):Play()
        end
    end

    clickBtn.MouseEnter:Connect(function()
        if not selected then TweenService:Create(card, Theme.TweenInfo, {BackgroundColor3 = Theme.SurfaceAccent}):Play() end
    end)
    
    clickBtn.MouseLeave:Connect(function()
        if not selected then TweenService:Create(card, Theme.TweenInfo, {BackgroundColor3 = Theme.Surface}):Play() end
    end)

    clickBtn.MouseButton1Click:Connect(function()
        selected = not selected
        updateVisual()
    end)

    return {
        Card = card,
        Player = player,
        IsSelected = function() return selected end
    }
end

local function createSlider(parent, title, min, max, default, onChanged)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 42)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 14)
    label.BackgroundTransparency = 1
    label.Text = title .. ": " .. tostring(default)
    label.TextColor3 = Theme.TextMain
    label.Font = Theme.FontMain
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, 0, 0, 8)
    bar.Position = UDim2.new(0, 0, 0, 24)
    bar.BackgroundColor3 = Theme.Surface
    bar.BorderSizePixel = 0
    bar.Parent = frame
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Theme.Accent
    fill.BorderSizePixel = 0
    fill.Parent = bar
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0)
    knob.BackgroundColor3 = Theme.TextMain
    knob.BorderSizePixel = 0
    knob.Parent = bar
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local dragging = false
    local value = default

    local function setValueFromX(x)
        local percent = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        value = math.floor(min + (max - min) * percent)
        local alpha = (value - min) / (max - min)

        fill.Size = UDim2.new(alpha, 0, 1, 0)
        knob.Position = UDim2.new(alpha, 0, 0.5, 0)
        label.Text = title .. ": " .. tostring(value)

        if onChanged then onChanged(value) end
    end

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            setValueFromX(input.Position.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            setValueFromX(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    return {
        Frame = frame,
        GetValue = function() return value end
    }
end
local wsRow = CreateRowContainer()
local walkSpeedInput = CreateTextInput(wsRow, " WalkSpeed...", UDim2.new(0, 95, 1, 0))
local setWalkSpeedButton = CreateButton(wsRow, "SetWalkSpeed", "Set WalkSpeed", UDim2.new(1, -101, 1, 0), UDim2.new(0, 101, 0, 0))

local jhRow = CreateRowContainer()
local jumpHeightInput = CreateTextInput(jhRow, " JumpHeight...", UDim2.new(0, 95, 1, 0))
local setJumpHeightButton = CreateButton(jhRow, "SetJumpHeight", "Set JumpHeight", UDim2.new(1, -101, 1, 0), UDim2.new(0, 101, 0, 0))

local fovRow = CreateRowContainer()
local fovInput = CreateTextInput(fovRow, " Field of View...", UDim2.new(0, 95, 1, 0))
local setFOVButton = CreateButton(fovRow, "SetFOV", "Set FOV", UDim2.new(1, -101, 1, 0), UDim2.new(0, 101, 0, 0))

local rowUtil1 = CreateRowContainer()
local infiniteJumpButton = CreateButton(rowUtil1, "InfiniteJump", "Infinite Jump", UDim2.new(0, 140, 1, 0))
local antiAFKButton = CreateButton(rowUtil1, "AntiAFK", "Anti-AFK", UDim2.new(0, 140, 1, 0), UDim2.new(0, 146, 0, 0))

local rowUtil2 = CreateRowContainer()
local noclipButton = CreateButton(rowUtil2, "Btn_Noclip", "Noclip", UDim2.new(0, 140, 1, 0))
local instantInteractButton = CreateButton(rowUtil2, "InstantInteract", "Instant Interact", UDim2.new(0, 140, 1, 0), UDim2.new(0, 146, 0, 0))

local rowUtil3 = CreateRowContainer()
local positionButton = CreateButton(rowUtil3, "PlayerPosition", "Show Position", UDim2.new(1, 0, 1, 0))

local tpInputRow = CreateRowContainer()
local xInput = CreateTextInput(tpInputRow, " X", UDim2.new(0, 90, 1, 0))
local yInput = CreateTextInput(tpInputRow, " Y", UDim2.new(0, 90, 1, 0), UDim2.new(0, 98, 0, 0))
local zInput = CreateTextInput(tpInputRow, " Z", UDim2.new(0, 90, 1, 0), UDim2.new(0, 196, 0, 0))

local tpButtonRow = CreateRowContainer()
local teleportButton = CreateButton(tpButtonRow, "Teleport", "Teleport to Coordinates")

local cameraCollapsible = createCollapsible(contentFrame, "Camera Lock Settings")

local lockRow = CreateRowContainer()
lockRow.Parent = cameraCollapsible.Content
local toggleLockBtn = CreateButton(lockRow, "ToggleLockCam", "Lock Camera: OFF", UDim2.new(1, 0, 1, 0))

local sliderContainer = Instance.new("Frame")
sliderContainer.Size = UDim2.new(1, 0, 0, 45)
sliderContainer.BackgroundTransparency = 1
sliderContainer.Parent = cameraCollapsible.Content

-- TẠO UI TARGET PARTS R6
local partsCollapsible = createCollapsible(cameraCollapsible.Content, "Target Part (R6)")
local r6Parts = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}
local partButtons = {}

_G.TargetPartName = _G.TargetPartName or "Head"

for _, partName in ipairs(r6Parts) do
    local partRow = CreateRowContainer()
    partRow.Size = UDim2.new(1, 0, 0, 26)
    partRow.BackgroundTransparency = 1
    partRow.Active = false
    partRow.Parent = partsCollapsible.Content
    
    local actualPartName = partName:gsub(" ", "") 
    local btn = CreateButton(partRow, "Btn_" .. actualPartName, partName, UDim2.new(1, 0, 1, 0))
    local realButton = typeof(btn) == "table" and btn.Button or btn
    
    if realButton and realButton:IsA("GuiObject") then
        realButton.ZIndex = 100
        realButton.Active = true
        
        realButton.MouseEnter:Connect(function()
            if _G.TargetPartName ~= actualPartName then realButton.BackgroundColor3 = Theme.SurfaceAccent end
        end)
        
        realButton.MouseLeave:Connect(function()
            if _G.TargetPartName ~= actualPartName then realButton.BackgroundColor3 = Theme.Surface end
        end)
        
        realButton.MouseButton1Click:Connect(function()
            _G.TargetPartName = actualPartName
            for pName, b in pairs(partButtons) do
                if pName == _G.TargetPartName then
                    b.BackgroundColor3 = Theme.SurfaceAccent
                    b.TextColor3 = Theme.Accent
                else
                    b.BackgroundColor3 = Theme.Surface
                    b.TextColor3 = Theme.TextMain
                end
            end
        end)
        partButtons[actualPartName] = realButton
    end
end

task.defer(function()
    if partButtons[_G.TargetPartName] then
        partButtons[_G.TargetPartName].BackgroundColor3 = Theme.SurfaceAccent
        partButtons[_G.TargetPartName].TextColor3 = Theme.Accent
    end
end)

-- TẠO UI PLAYER LIST MONITOR
local playersCollapsible = createCollapsible(contentFrame, "Player List Monitor")

setWalkSpeedButton.MouseButton1Click:Connect(function()
    local n = tonumber(walkSpeedInput.Text)
    local char = localPlayer.Character
    if n and char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = n
    end
end)

setJumpHeightButton.MouseButton1Click:Connect(function()
    local n = tonumber(jumpHeightInput.Text)
    local char = localPlayer.Character
    if n and char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpHeight = n
    end
end)

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

setFOVButton.MouseButton1Click:Connect(function()
    local n = tonumber(fovInput.Text)
    if n then
        n = math.clamp(n, 10, 120)
        local camera = workspace.CurrentCamera
        if camera then camera.FieldOfView = n end
    end
end)

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

local positionFrame = Instance.new("Frame")
positionFrame.Name = "PositionFrame"
positionFrame.Size = UDim2.new(0, 140, 0, 30)
positionFrame.Position = UDim2.new(0, 30, 0, 90)
positionFrame.BackgroundColor3 = Theme.Surface
positionFrame.BorderSizePixel = 0
positionFrame.Visible = false
positionFrame.Active = true
positionFrame.Draggable = true
positionFrame.Parent = modernScreenGui

Instance.new("UICorner", positionFrame).CornerRadius = UDim.new(0, 4)
local posStroke = Instance.new("UIStroke", positionFrame)
posStroke.Color = Theme.Accent
posStroke.Thickness = 1
posStroke.Transparency = 0.4

local posLabel = Instance.new("TextLabel")
posLabel.Size = UDim2.new(1, -16, 1, 0)
posLabel.Position = UDim2.new(0, 8, 0, 0)
posLabel.BackgroundTransparency = 1
posLabel.TextColor3 = Theme.TextMain
posLabel.Font = Theme.FontBold
posLabel.TextSize = 10
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

-- Lock Cam
_G.CircleRadiusValue = _G.CircleRadiusValue or 100
_G.PlayerCardObjects = _G.PlayerCardObjects or {}

-- 1. KHỞI TẠO VÒNG TRÒN VẼ (DRAWING API)
if not _G.FOVCircle then
    local FOVCircle = Drawing.new("Circle")
    FOVCircle.Color = Theme.Accent
    FOVCircle.Thickness = 2
    FOVCircle.Filled = false
    FOVCircle.Transparency = 0.8
    FOVCircle.Visible = false
    FOVCircle.Radius = _G.CircleRadiusValue
    _G.FOVCircle = FOVCircle
end

local camera = workspace.CurrentCamera
local circleEnabled = false

-- SỬA LỖI SLIDER: Đồng bộ callback thay đổi giá trị trực tiếp vào Slider thông qua tham số thứ 6
local radiusSlider = createSlider(sliderContainer, "Circle Radius", 10, 400, _G.CircleRadiusValue, function(value)
    _G.CircleRadiusValue = value
    if _G.FOVCircle then
        _G.FOVCircle.Radius = value
    end
end)

-- BẤM NÚT BẬT / TẮT CAMERA LOCK
toggleLockBtn.MouseButton1Click:Connect(function()
    circleEnabled = not circleEnabled
    if _G.FOVCircle then
        _G.FOVCircle.Visible = circleEnabled
    end
    
    if circleEnabled then
        toggleLockBtn.Text = "Lock Camera: ON"
        toggleLockBtn.TextColor3 = Theme.Accent
    else
        toggleLockBtn.Text = "Lock Camera: OFF"
        toggleLockBtn.TextColor3 = Theme.TextMain
    end
end)

-- HÀM TÌM NGƯỜI CHƠI GẦN TÂM CHUỘT NHẤT ĐƯỢC CHỌN (ĐÃ BỔ SUNG CHỐNG CRASH)
local function getClosestSelectedPlayerToCursor()
    local closestPart = nil
    local shortestDistance = _G.CircleRadiusValue
    local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)

    for _, obj in ipairs(_G.PlayerCardObjects) do
        if obj.IsSelected and obj.IsSelected() and obj.Player.Character then
            local char = obj.Player.Character
            local targetPart = char:FindFirstChild(_G.TargetPartName) or char:FindFirstChild("HumanoidRootPart")
            
            if targetPart then
                local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local target2DPos = Vector2.new(screenPos.X, screenPos.Y)
                    local distance = (target2DPos - screenCenter).Magnitude
                    
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPart = targetPart
                    end
                end
            end
        end
    end
    return closestPart
end

-- HÀM KIỂM TRA PHẠM VI FOV XEM CÓ AI BÊN TRONG KHÔNG
local function isAnyPlayerInFOV()
    local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    for _, obj in ipairs(_G.PlayerCardObjects) do
        if obj.IsSelected and obj.IsSelected() and obj.Player.Character then
            local char = obj.Player.Character
            local targetPart = char:FindFirstChild(_G.TargetPartName) or char:FindFirstChild("HumanoidRootPart")
            if targetPart then
                local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local target2DPos = Vector2.new(screenPos.X, screenPos.Y)
                    local distance = (target2DPos - screenCenter).Magnitude
                    if distance <= _G.CircleRadiusValue then
                        return true
                    end
                end
            end
        end
    end
    return false
end

-- SỬA LỖI NẠP DANH SÁCH: Quét phòng game thực tế đổ vào UI (Chống Empty)
local function refreshPlayerList()
    for _, obj in ipairs(_G.PlayerCardObjects) do
        if obj.Card then obj.Card:Destroy() end
    end
    table.clear(_G.PlayerCardObjects)

    if not playersCollapsible or not playersCollapsible.Content then return end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer then
            local cardData = createPlayerCard(p, playersCollapsible.Content)
            table.insert(_G.PlayerCardObjects, cardData)
        end
    end
end

Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)
task.spawn(refreshPlayerList)

-- HÀM VÒNG LẶP RENDERSTEPPED GỘP DUY NHẤT: LOCK MƯỢT + FLICK CHUỘT KHÔNG VẬT CẢN
local flickSensitivity = 1.2
local returnSpeed = 0.07
local lastMousePos = UserInputService:GetMouseLocation()

RunService.RenderStepped:Connect(function()
    local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    
    -- Đồng bộ Vòng tròn FOV hình học
    if _G.FOVCircle and _G.FOVCircle.Visible then
        _G.FOVCircle.Position = screenCenter
        _G.FOVCircle.Radius = _G.CircleRadiusValue
        
        if isAnyPlayerInFOV() then
            _G.FOVCircle.Color = Color3.fromRGB(0, 255, 100) -- Xanh lá cây khi lọt tầm ngắm
        else
            _G.FOVCircle.Color = Theme.Accent
        end
    end
    
    -- Xử lý Flick chuột dựa trên MouseDelta
    local currentMousePos = UserInputService:GetMouseLocation()
    local mouseDelta = currentMousePos - lastMousePos
    lastMousePos = currentMousePos

    if circleEnabled then
        local targetPart = getClosestSelectedPlayerToCursor()
        if targetPart then
            local lockCFrame = CFrame.new(camera.CFrame.Position, targetPart.Position)
            
            if mouseDelta.Magnitude > 0.1 then
                -- Tay vẩy chuột tự do hoàn toàn, triệt tiêu hoàn toàn lực ghì cản của hack
                local rotationX = -mouseDelta.X * 0.002 * flickSensitivity
                local rotationY = -mouseDelta.Y * 0.002 * flickSensitivity
                local freeCamCFrame = camera.CFrame * CFrame.Angles(0, rotationX, 0) * CFrame.Angles(rotationY, 0, 0)
                
                camera.CFrame = freeCamCFrame:Lerp(lockCFrame, returnSpeed)
            else
                -- Tự động hút tâm về khi tay ngừng vẩy chuột
                camera.CFrame = camera.CFrame:Lerp(lockCFrame, 0.15)
            end
        end
    end
end)
