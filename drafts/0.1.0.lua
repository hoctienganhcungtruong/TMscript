-- Modern Glassmorphic Mod Menu Engine
-- Executable directly from Roblox Studio's Command Bar

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Safeguard against duplicate instances
if CoreGui:FindFirstChild("GlassmorphicModMenu") then
    CoreGui:FindFirstChild("GlassmorphicModMenu"):Destroy()
end

-- --- THEME CONFIGURATION ---
local Theme = {
    BgColor = Color3.fromRGB(20, 20, 28),
    BgTransparency = 0.35,
    SidebarColor = Color3.fromRGB(15, 15, 22),
    CardColor = Color3.fromRGB(30, 30, 42),
    CardTransparency = 0.4,
    AccentLeft = Color3.fromRGB(0, 180, 255),
    AccentRight = Color3.fromRGB(140, 0, 255),
    TextColor = Color3.fromRGB(245, 245, 250),
    SubTextColor = Color3.fromRGB(150, 150, 165),
    Font = Enum.Font.GothamMedium,
    FontBold = Enum.Font.GothamBold,
    AnimationsActive = true
}

-- --- STATE MANAGEMENT ---
local State = {
    InfJump = false,
    Noclip = false,
    Fly = false,
    Sprint = false,
    Spin = false,
    Rainbow = false,
    FullBright = false,
    Shadows = true,
    Fog = true,
    Blur = false,
    FlySpeed = 50,
    NormalWalkSpeed = 16
}

-- --- UTILITY FUNCTIONS ---
local function Create(className, properties)
    local instance = Instance.new(className)
    for k, v in pairs(properties) do
        instance[k] = v
    end
    return instance
end

local function Tween(object, info, properties)
    if not Theme.AnimationsActive then
        for k, v in pairs(properties) do object[k] = v end
        return nil
    end
    local tween = TweenService:Create(object, info, properties)
    tween:Play()
    return tween
end

-- --- CORE SYSTEM GENERATION ---
local ScreenGui = Create("ScreenGui", {
    Name = "GlassmorphicModMenu",
    Parent = CoreGui,
    ResetOnSpawn = false
})

-- Main Frame Shadow Effect
local ShadowHolder = Create("Frame", {
    Name = "ShadowHolder",
    Parent = ScreenGui,
    Size = UDim2.new(0, 620, 0, 420),
    Position = UDim2.new(0.5, -310, 0.5, -210),
    BackgroundTransparency = 1
})

local Shadow = Create("ImageLabel", {
    Name = "Shadow",
    Parent = ShadowHolder,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.new(1, 30, 1, 30),
    BackgroundTransparency = 1,
    Image = "rbxassetid://6014261993",
    ImageColor3 = Color3.fromRGB(0, 0, 0),
    ImageTransparency = 0.4,
    ScaleType = Enum.ScaleType.Slice,
    SliceCenter = Rect.new(49, 49, 450, 450)
})

local MainFrame = Create("Frame", {
    Name = "MainFrame",
    Parent = ShadowHolder,
    Size = UDim2.new(0, 600, 0, 400),
    Position = UDim2.new(0.5, -300, 0.5, -200),
    BackgroundColor3 = Theme.BgColor,
    BackgroundTransparency = Theme.BgTransparency,
    ClipsDescendants = false
})

Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = MainFrame })
local MainStroke = Create("UIStroke", {
    Color = Theme.AccentLeft,
    Thickness = 1.5,
    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    Parent = MainFrame
})

local MainGradient = Create("UIGradient", {
    Color = ColorSequence.new(Theme.AccentLeft, Theme.AccentRight),
    Rotation = 45,
    Parent = MainStroke
})

-- Top Bar Component
local TopBar = Create("Frame", {
    Name = "TopBar",
    Parent = MainFrame,
    Size = UDim2.new(1, 0, 0, 45),
    BackgroundTransparency = 1
})

local Title = Create("TextLabel", {
    Name = "Title",
    Parent = TopBar,
    Text = "NEXUS INFRASTRUCTURE // MOD MENU",
    Font = Theme.FontBold,
    TextSize = 14,
    TextColor3 = Theme.TextColor,
    TextXAlignment = Enum.TextXAlignment.Left,
    Position = UDim2.new(0, 20, 0, 0),
    Size = UDim2.new(0.6, 0, 1, 0),
    BackgroundTransparency = 1
})

local CloseBtn = Create("TextButton", {
    Name = "CloseBtn",
    Parent = TopBar,
    Text = "×",
    Font = Enum.Font.GothamLight,
    TextSize = 28,
    TextColor3 = Theme.TextColor,
    Position = UDim2.new(1, -40, 0, 7),
    Size = UDim2.new(0, 30, 0, 30),
    BackgroundTransparency = 1
})

local MinBtn = Create("TextButton", {
    Name = "MinBtn",
    Parent = TopBar,
    Text = "−",
    Font = Enum.Font.GothamLight,
    TextSize = 24,
    TextColor3 = Theme.TextColor,
    Position = UDim2.new(1, -75, 0, 7),
    Size = UDim2.new(0, 30, 0, 30),
    BackgroundTransparency = 1
})

-- Sidebar Component
local Sidebar = Create("Frame", {
    Name = "Sidebar",
    Parent = MainFrame,
    Size = UDim2.new(0, 160, 1, -45),
    Position = UDim2.new(0, 0, 0, 45),
    BackgroundColor3 = Theme.SidebarColor,
    BackgroundTransparency = 0.2
})
Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = Sidebar })

-- Hide bottom left corner overlap cleanly
local CornerFix = Create("Frame", {
    Size = UDim2.new(0, 12, 0, 12),
    Position = UDim2.new(1, -12, 0, 0),
    BackgroundColor3 = Theme.SidebarColor,
    BackgroundTransparency = 0.2,
    BorderSizePixel = 0,
    Parent = Sidebar
})

local TabContainer = Create("Frame", {
    Name = "TabContainer",
    Parent = Sidebar,
    Size = UDim2.new(1, -10, 1, -20),
    Position = UDim2.new(0, 5, 0, 10),
    BackgroundTransparency = 1
})
local TabListLayout = Create("UIListLayout", {
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 6),
    Parent = TabContainer
})

-- Content Layer Panel
local ContentLayer = Create("Frame", {
    Name = "ContentLayer",
    Parent = MainFrame,
    Size = UDim2.new(1, -175, 1, -60),
    Position = UDim2.new(0, 170, 0, 50),
    BackgroundTransparency = 1
})

-- --- ENGINE COMPONENT LOGIC ---

-- Drag Engine Implementation
local Dragging, DragInput, DragStart, StartPosition

local function UpdateDrag(input)
    local delta = input.Position - DragStart
    ShadowHolder.Position = UDim2.new(
        StartPosition.X.Scale, 
        StartPosition.X.Offset + delta.X, 
        StartPosition.Y.Scale, 
        StartPosition.Y.Offset + delta.Y
    )
end

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPosition = ShadowHolder.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        DragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == DragInput and Dragging then
        UpdateDrag(input)
    end
end)

-- Minimize & Close System Animations
local Minimized = false
MinBtn.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    local targetSize = Minimized and UDim2.new(0, 600, 0, 45) or UDim2.new(0, 600, 0, 400)
    local targetShadowSize = Minimized and UDim2.new(0, 620, 0, 65) or UDim2.new(0, 620, 0, 420)
    
    Tween(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = targetSize })
    Tween(ShadowHolder, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = targetShadowSize })
    
    Sidebar.Visible = not Minimized
    ContentLayer.Visible = not Minimized
end)

CloseBtn.MouseButton1Click:Connect(function()
    Tween(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { 
        Size = UDim2.new(0, 600, 0, 0),
        BackgroundTransparency = 1 
    })
    task.wait(0.2)
    ScreenGui:Destroy()
end)

-- --- DYNAMIC GENERATORS ---
local Tabs = {}
local FirstTab = true

local function CreateTab(tabName)
    local TabButton = Create("TextButton", {
        Name = tabName .. "Tab",
        Parent = TabContainer,
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = Theme.CardColor,
        BackgroundTransparency = 1,
        Text = tabName,
        Font = Theme.Font,
        TextSize = 13,
        TextColor3 = Theme.SubTextColor,
        TextXAlignment = Enum.TextXAlignment.Left,
        Position = UDim2.new(0, 10, 0, 0)
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = TabButton })
    
    -- Padding layout configuration inside the item
    local Padding = Create("UIPadding", {
        PaddingLeft = UDim.new(0, 15),
        Parent = TabButton
    })

    local Page = Create("ScrollingFrame", {
        Name = tabName .. "Page",
        Parent = ContentLayer,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Visible = false,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Theme.AccentLeft
    })
    
    local PageLayout = Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10),
        Parent = Page
    })
    
    PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 15)
    end)

    TabButton.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Page.Visible = false
            Tween(t.Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { 
                BackgroundTransparency = 1, 
                TextColor3 = Theme.SubTextColor 
            })
        end
        Page.Visible = true
        Tween(TabButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { 
            BackgroundTransparency = 0.6, 
            TextColor3 = Theme.TextColor 
        })
    end)

    if FirstTab then
        FirstTab = false
        Page.Visible = true
        TabButton.BackgroundTransparency = 0.6
        TabButton.TextColor3 = Theme.TextColor
    end

    Tabs[tabName] = { Button = TabButton, Page = Page }
    return Page
end

local function CreateSection(parent, title)
    local Label = Create("TextLabel", {
        Text = title:upper(),
        Font = Theme.FontBold,
        TextSize = 11,
        TextColor3 = Theme.AccentLeft,
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = parent
    })
    local Grad = Create("UIGradient", {
        Color = ColorSequence.new(Theme.AccentLeft, Theme.AccentRight),
        Parent = Label
    })
end

local function CreateButton(parent, text, callback)
    local Btn = Create("TextButton", {
        Size = UDim2.new(1, -5, 0, 38),
        BackgroundColor3 = Theme.CardColor,
        BackgroundTransparency = Theme.CardTransparency,
        Text = text,
        Font = Theme.Font,
        TextColor3 = Theme.TextColor,
        TextSize = 13,
        Parent = parent
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = Btn })
    local Stroke = Create("UIStroke", { Color = Color3.fromRGB(50, 50, 65), Thickness = 1, Parent = Btn })
    
    Btn.MouseEnter:Connect(function()
        Tween(Btn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(45, 45, 60) })
        Tween(Stroke, TweenInfo.new(0.2), { Color = Theme.AccentLeft })
    end)
    Btn.MouseLeave:Connect(function()
        Tween(Btn, TweenInfo.new(0.2), { BackgroundColor3 = Theme.CardColor })
        Tween(Stroke, TweenInfo.new(0.2), { Color = Color3.fromRGB(50, 50, 65) })
    end)
    Btn.MouseButton1Click:Connect(callback)
    return Btn
end

local function CreateToggle(parent, text, default, callback)
    local ToggleState = default
    
    local Frame = Create("Frame", {
        Size = UDim2.new(1, -5, 0, 38),
        BackgroundColor3 = Theme.CardColor,
        BackgroundTransparency = Theme.CardTransparency,
        Parent = parent
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = Frame })
    local Stroke = Create("UIStroke", { Color = Color3.fromRGB(50, 50, 65), Thickness = 1, Parent = Frame })

    local Label = Create("TextLabel", {
        Text = text,
        Font = Theme.Font,
        TextColor3 = Theme.TextColor,
        TextSize = 13,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(0.7, 0, 1, 0),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Frame
    })

    local SwitchBg = Create("Frame", {
        Size = UDim2.new(0, 38, 0, 20),
        Position = UDim2.new(1, -50, 0.5, -10),
        BackgroundColor3 = Color3.fromRGB(40, 40, 50),
        Parent = Frame
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = SwitchBg })

    local SwitchBall = Create("Frame", {
        Size = UDim2.new(0, 14, 0, 14),
        Position = ToggleState and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
        BackgroundColor3 = ToggleState and Theme.AccentLeft or Color3.fromRGB(120, 120, 130),
        Parent = SwitchBg
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = SwitchBall })

    local ClickBtn = Create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Parent = Frame
    })

    local function UpdateVisuals()
        local targetPos = ToggleState and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
        local targetColor = ToggleState and Theme.AccentLeft or Color3.fromRGB(120, 120, 130)
        Tween(SwitchBall, TweenInfo.new(0.2), { Position = targetPos, BackgroundColor3 = targetColor })
        Tween(Stroke, TweenInfo.new(0.2), { Color = ToggleState and Theme.AccentLeft or Color3.fromRGB(50, 50, 65) })
    end
    UpdateVisuals()

    ClickBtn.MouseButton1Click:Connect(function()
        ToggleState = not ToggleState
        UpdateVisuals()
        task.spawn(callback, ToggleState)
    end)
    return Frame
end

local function CreateTextBoxWithButton(parent, placeholder, btnText, callback)
    local Container = Create("Frame", {
        Size = UDim2.new(1, -5, 0, 38),
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    local BoxFrame = Create("Frame", {
        Size = UDim2.new(0.7, -5, 1, 0),
        BackgroundColor3 = Theme.CardColor,
        BackgroundTransparency = Theme.CardTransparency,
        Parent = Container
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = BoxFrame })
    local Stroke = Create("UIStroke", { Color = Color3.fromRGB(50, 50, 65), Thickness = 1, Parent = BoxFrame })

    local TextBox = Create("TextBox", {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        PlaceholderText = placeholder,
        Text = "",
        Font = Theme.Font,
        TextColor3 = Theme.TextColor,
        PlaceholderColor3 = Theme.SubTextColor,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = BoxFrame
    })

    local ActionBtn = Create("TextButton", {
        Size = UDim2.new(0.3, 0, 1, 0),
        Position = UDim2.new(0.7, 0, 0, 0),
        BackgroundColor3 = Theme.CardColor,
        BackgroundTransparency = Theme.CardTransparency,
        Text = btnText,
        Font = Theme.Font,
        TextColor3 = Theme.TextColor,
        TextSize = 13,
        Parent = Container
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = ActionBtn })
    local BtnStroke = Create("UIStroke", { Color = Color3.fromRGB(50, 50, 65), Thickness = 1, Parent = ActionBtn })

    ActionBtn.MouseButton1Click:Connect(function()
        callback(TextBox.Text)
    end)
    return Container
end

-- --- POPULATE PAGES ---

local PlayerPage = CreateTab("Player")
local FunPage = CreateTab("Fun")
local WorldPage = CreateTab("World")
local UtilPage = CreateTab("Utilities")
local SettingsPage = CreateTab("Settings")

-- ==========================================
-- PLAYER TAB IMPLEMENTATION
-- ==========================================
local function GetChar() return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() end
local function GetHum() return GetChar():FindFirstChildOfClass("Humanoid") end

CreateSection(PlayerPage, "Properties")
CreateTextBoxWithButton(PlayerPage, "Walkspeed (Default: 16)", "Set Speed", function(val)
    local num = tonumber(val)
    if num then 
        local hum = GetHum()
        if hum then hum.WalkSpeed = num end
        State.NormalWalkSpeed = num
    end
end)

CreateTextBoxWithButton(PlayerPage, "Jump Power / Height", "Set Jump", function(val)
    local num = tonumber(val)
    if num then
        local hum = GetHum()
        if hum then
            hum.JumpHeight = num
            hum.JumpPower = num
        end
    end
end)

CreateTextBoxWithButton(PlayerPage, "Hip Height", "Set Hip", function(val)
    local num = tonumber(val)
    if num then local hum = GetHum() if hum then hum.HipHeight = num end end
end)

CreateTextBoxWithButton(PlayerPage, "Gravity", "Set Grav", function(val)
    local num = tonumber(val)
    if num then workspace.Gravity = num end
end)

CreateTextBoxWithButton(PlayerPage, "Field of View (FOV)", "Set FOV", function(val)
    local num = tonumber(val)
    if num then Camera.FieldOfView = num end
end)

CreateTextBoxWithButton(PlayerPage, "Health Modifier", "Set HP", function(val)
    local num = tonumber(val)
    if num then local hum = GetHum() if hum then hum.Health = num end end
end)

CreateTextBoxWithButton(PlayerPage, "Max Health Mod", "Set Max HP", function(val)
    local num = tonumber(val)
    if num then local hum = GetHum() if hum then hum.MaxHealth = num end end
end)

CreateSection(PlayerPage, "Toggles & Actions")
CreateButton(PlayerPage, "Reset Player", function() pcall(function() GetChar():BreakJoints() end) end)
CreateButton(PlayerPage, "Full Heal", function() pcall(function() local h = GetHum() if h then h.Health = h.MaxHealth end end) end)

CreateToggle(PlayerPage, "Infinite Jump", false, function(t) State.InfJump = t end)
UserInputService.JumpRequest:Connect(function()
    if State.InfJump then
        local hum = GetHum()
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

CreateToggle(PlayerPage, "Noclip Core", false, function(t) State.Noclip = t end)
RunService.Stepped:Connect(function()
    if State.Noclip then
        pcall(function()
            for _, v in pairs(GetChar():GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end)
    end
end)

-- Flight Mechanics Integration
CreateToggle(PlayerPage, "Flight Node", false, function(t)
    State.Fly = t
    local char = GetChar()
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    if t then
        local bv = Create("BodyVelocity", { Name = "FlyBV", MaxForce = Vector3.new(4e5, 4e5, 4e5), Velocity = Vector3.new(0, 0, 0), Parent = root })
        local bg = Create("BodyGyro", { Name = "FlyBG", MaxTorque = Vector3.new(4e5, 4e5, 4e5), CFrame = root.CFrame, Parent = root })
        
        while State.Fly and root and root.Parent do
            local direction = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction = direction + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction = direction - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction = direction - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction = direction + Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction = direction + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then direction = direction - Vector3.new(0, 1, 0) end
            
            bv.Velocity = direction.Unit * State.FlySpeed
            if direction.Magnitude == 0 then bv.Velocity = Vector3.new(0, 0, 0) end
            bg.CFrame = Camera.CFrame
            task.wait()
        end
        if root:FindFirstChild("FlyBV") then root.FlyBV:Destroy() end
        if root:FindFirstChild("FlyBG") then root.FlyBG:Destroy() end
    end
end)

CreateToggle(PlayerPage, "Sprint Mode Toggle (Shift)", false, function(t) State.Sprint = t end)
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.LeftShift and State.Sprint then
        local hum = GetHum()
        if hum then hum.WalkSpeed = State.NormalWalkSpeed * 2 end
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftShift then
        local hum = GetHum()
        if hum then hum.WalkSpeed = State.NormalWalkSpeed end
    end
end)

-- ==========================================
-- FUN TAB IMPLEMENTATION
-- ==========================================
CreateSection(FunPage, "Character Modifiers")

CreateToggle(FunPage, "Spin Velocity", false, function(t)
    State.Spin = t
    local root = GetChar():FindFirstChild("HumanoidRootPart")
    if t and root then
        local cav = Create("BodyAngularVelocity", { Name = "SpinAV", MaxTorque = Vector3.new(0, 4e5, 0), AngularVelocity = Vector3.new(0, 15, 0), Parent = root })
        while State.Spin and root and root.Parent do task.wait() end
        if root:FindFirstChild("SpinAV") then root.SpinAV:Destroy() end
    end
end)

CreateToggle(FunPage, "Rainbow Character", false, function(t)
    State.Rainbow = t
    while State.Rainbow do
        pcall(function()
            local hue = (tick() % 5) / 5
            local color = Color3.fromHSV(hue, 1, 1)
            for _, v in pairs(GetChar():GetChildren()) do
                if v:IsA("BasePart") then v.Color = color end
            end
        end)
        task.wait()
    end
end)

CreateButton(FunPage, "Big Head Matrix", function()
    pcall(function()
        local hum = GetHum()
        if hum then
            local hs = hum:FindFirstChild("HeadScale") or Create("NumberValue", { Name = "HeadScale", Parent = hum })
            hs.Value = 3
        end
    end)
end)

local function AdjustScale(multiplier)
    pcall(function()
        local hum = GetHum()
        if hum then
            for _, scaleName in pairs({"BodyWidthScale", "BodyHeightScale", "BodyDepthScale", "HeadScale"}) do
                local val = hum:FindFirstChild(scaleName)
                if val then val.Value = val.Value * multiplier end
            end
        end
    end)
end

CreateButton(FunPage, "Scale Character: Large", function() AdjustScale(1.5) end)
CreateButton(FunPage, "Scale Character: Small", function() AdjustScale(0.5) end)

CreateButton(FunPage, "Force Sit Action", function() pcall(function() GetHum().Sit = true end) end)
CreateButton(FunPage, "Dance Animation Emote", function()
    pcall(function()
        local anim = Create("Animation", { AnimationId = "rbxassetid://182435965" })
        local track = GetHum():LoadAnimation(anim)
        track:Play()
    end)
end)

CreateButton(FunPage, "Random Spatial Teleport", function()
    pcall(function()
        local root = GetChar():FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = root.CFrame + Vector3.new(math.random(-100, 100), 0, math.random(-100, 100))
        end
    end)
end)

CreateButton(FunPage, "Freeze Mechanical Nodes", function() pcall(function() GetChar().HumanoidRootPart.Anchored = true end) end)
CreateButton(FunPage, "Unfreeze System Nodes", function() pcall(function() GetChar().HumanoidRootPart.Anchored = false end) end)


-- ==========================================
-- WORLD TAB IMPLEMENTATION
-- ==========================================
CreateSection(WorldPage, "Environmental Systems")

local OriginalBrightness = Lighting.Brightness
local OriginalAmbient = Lighting.Ambient
local OriginalShadows = Lighting.GlobalShadows

CreateToggle(WorldPage, "FullBright Module", false, function(t)
    State.FullBright = t
    if t then
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = OriginalBrightness
        Lighting.Ambient = OriginalAmbient
        Lighting.GlobalShadows = OriginalShadows
    end
end)

CreateToggle(WorldPage, "Engine Volumetric Shadows", true, function(t) Lighting.GlobalShadows = t end)
CreateToggle(WorldPage, "Render Atmosphere Fog", true, function(t) Lighting.FogEnd = t and 100000 or 0 end)

CreateTextBoxWithButton(WorldPage, "Time of Day (0-24)", "Set Time", function(val)
    local num = tonumber(val)
    if num then Lighting.ClockTime = num end
end)

CreateTextBoxWithButton(WorldPage, "Ambient RGB (R,G,B)", "Set Ambient", function(val)
    local colors = {}
    for c in string.gmatch(val, "([^,]+)") do table.insert(colors, tonumber(c)) end
    if #colors == 3 then
        Lighting.Ambient = Color3.fromRGB(colors[1], colors[2], colors[3])
    end
end)


-- ==========================================
-- UTILITIES TAB IMPLEMENTATION
-- ==========================================
CreateSection(UtilPage, "System Actions")
CreateButton(UtilPage, "Server Rejoin Request", function()
    pcall(function()
        if #Players:GetPlayers() <= 1 then
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        else
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end
    end)
end)

CreateButton(UtilPage, "Copy Vector Coordinates", function()
    pcall(function()
        local pos = GetChar().HumanoidRootPart.Position
        local str = string.format("%.2f, %.2f, %.2f", pos.X, pos.Y, pos.Z)
        -- Uses Studio's command bar output window context seamlessly
        print("[NEXUS DATA] Copied Positions: " .. str)
    end)
end)

CreateTextBoxWithButton(UtilPage, "Teleport to Vector XYZ", "Teleport", function(val)
    local coords = {}
    for c in string.gmatch(val, "([^,]+)") do table.insert(coords, tonumber(c)) end
    if #coords == 3 then
        pcall(function()
            GetChar().HumanoidRootPart.CFrame = CFrame.new(Vector3.new(coords[1], coords[2], coords[3]))
        end)
    end
end)

CreateSection(UtilPage, "Diagnostics HUD")
local FpsLabel = Create("TextLabel", { Size = UDim2.new(1, -5, 0, 25), BackgroundTransparency = 1, Font = Theme.Font, TextColor3 = Theme.TextColor, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = UtilPage })
local PingLabel = Create("TextLabel", { Size = UDim2.new(1, -5, 0, 25), BackgroundTransparency = 1, Font = Theme.Font, TextColor3 = Theme.TextColor, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = UtilPage })
local CoordLabel = Create("TextLabel", { Size = UDim2.new(1, -5, 0, 25), BackgroundTransparency = 1, Font = Theme.Font, TextColor3 = Theme.TextColor, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = UtilPage })

local fpsCount = 0
task.spawn(function()
    RunService.RenderStepped:Connect(function() fpsCount = fpsCount + 1 end)
    while task.wait(1) do
        FpsLabel.Text = "⚡ Engine Diagnostics: " .. tostring(fpsCount) .. " FPS"
        fpsCount = 0
    end
end)

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local ping = LocalPlayer:GetNetworkPing() * 1000
            PingLabel.Text = "📡 Network Response latency: " .. string.format("%.1f", ping) .. " ms"
            local pos = GetChar().HumanoidRootPart.Position
            CoordLabel.Text = string.format("📍 Space Delta XYZ: %.1f // %.1f // %.1f", pos.X, pos.Y, pos.Z)
        end)
    end
end)


-- ==========================================
-- SETTINGS TAB IMPLEMENTATION
-- ==========================================
CreateSection(SettingsPage, "Engine Visual Settings")

local InternalBlurInstance = Create("BlurEffect", { Size = 0, Parent = Lighting })
CreateToggle(SettingsPage, "Background Focus Blur", false, function(t)
    Tween(InternalBlurInstance, TweenInfo.new(0.3), { Size = t and 16 or 0 })
end)

CreateToggle(SettingsPage, "Menu Tween Animations", true, function(t)
    Theme.AnimationsActive = t
end)

CreateTextBoxWithButton(SettingsPage, "Hex Accent Color (#FF00FF)", "Set Accent", function(val)
    pcall(function()
        local cleanHex = val:gsub("#", "")
        local r = tonumber(cleanHex:sub(1,2), 16) / 255
        local g = tonumber(cleanHex:sub(3,4), 16) / 255
        local b = tonumber(cleanHex:sub(5,6), 16) / 255
        
        local newColor = Color3.new(r,g,b)
        Theme.AccentLeft = newColor
        MainGradient.Color = ColorSequence.new(newColor, Theme.AccentRight)
    end)
end)

CreateTextBoxWithButton(SettingsPage, "Scale Multiplier (0.5 - 1.5)", "Apply UI Scale", function(val)
    local num = tonumber(val)
    if num and num >= 0.5 and num <= 1.5 then
        local uiScale = MainFrame:FindFirstChildOfClass("UIScale") or Create("UIScale", { Parent = MainFrame })
        Tween(uiScale, TweenInfo.new(0.3), { Scale = num })
    end
end)

print("[NEXUS INFRASTRUCTURE] Mod Menu compiled and initialized flawlessly.")
