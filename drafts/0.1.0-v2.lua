-- Ensure it runs in CoreGui so it persists properly during testing and doesn't clutter StarterGui
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- Clean up any existing instance of this menu first
if CoreGui:FindFirstChild("ModernModMenu") then
    CoreGui.ModernModMenu:Destroy()
end

-- =============================================================================
-- STYLING & CONFIGURATION
-- =============================================================================
local THEME = {
    Background = Color3.fromRGB(20, 20, 25),
    Sidebar = Color3.fromRGB(15, 15, 18),
    AccentGlow = Color3.fromRGB(115, 75, 255),
    AccentNeon = Color3.fromRGB(0, 200, 255),
    TextMain = Color3.fromRGB(240, 240, 245),
    TextDark = Color3.fromRGB(140, 140, 150),
    ElementBg = Color3.fromRGB(28, 28, 35),
    ElementInput = Color3.fromRGB(35, 35, 45)
}

local TWEEN_INFO = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- =============================================================================
-- UTILITY FUNCTIONS
-- =============================================================================
local function create(className, properties)
    local instance = Instance.new(className)
    for k, v in pairs(properties) do
        instance[k] = v
    end
    return instance
end

local function applyCorner(parent, radius)
    return create("UICorner", { CornerRadius = UDim.new(0, radius or 8), Parent = parent })
end

local function applyStroke(parent, color, thickness, transparency)
    return create("UIStroke", {
        Color = color,
        Thickness = thickness or 1,
        Transparency = transparency or 0.8,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent
    })
end

local function createGradient(parent, color1, color2)
    return create("UIGradient", {
        Color = ColorSequence.new(color1, color2),
        Rotation = 45,
        Parent = parent
    })
end

-- =============================================================================
-- INTERACTION & ANIMATION HELPERS
-- =============================================================================
local function makeDraggable(gui, handle)
    local dragging, dragInput, dragStart, startPos
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            TweenService:Create(gui, TweenInfo.new(0.1, Enum.EasingStyle.Out), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end)
end

local function addHoverEffect(button, normalBg, hoverBg)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TWEEN_INFO, { BackgroundColor3 = hoverBg }):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TWEEN_INFO, { BackgroundColor3 = normalBg }):Play()
    end)
end

-- =============================================================================
-- CORE FRAMEWORK INITIALIZATION
-- =============================================================================
local ScreenGui = create("ScreenGui", {
    Name = "ModernModMenu",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = CoreGui
})

-- Shadow Overlay Effect
local Shadow = create("Frame", {
    Name = "Shadow",
    Position = UDim2.new(0.5, -275, 0.5, -175),
    Size = UDim2.new(0, 550, 0, 350),
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency = 0.6,
    Parent = ScreenGui
})
applyCorner(Shadow, 12)

-- Main Frame
local MainFrame = create("Frame", {
    Name = "MainFrame",
    Position = UDim2.new(0, 0, 0, 0),
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = THEME.Background,
    ClipsDescendants = true,
    Parent = Shadow
})
applyCorner(MainFrame, 12)
applyStroke(MainFrame, THEME.AccentGlow, 1.5, 0.6)

-- Sidebar Canvas
local Sidebar = create("Frame", {
    Name = "Sidebar",
    Size = UDim2.new(0, 160, 1, 0),
    BackgroundColor3 = THEME.Sidebar,
    Parent = MainFrame
})
applyCorner(Sidebar, 12)

-- Brand / Title
local Title = create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 50),
    BackgroundTransparency = 1,
    Text = "TMscript",
    TextColor3 = THEME.TextMain,
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    XAlignment = Enum.TextXAlignment.Center,
    Parent = Sidebar
})

-- Top Bar / Drag Handle Window Controls
local DragHandle = create("Frame", {
    Name = "DragHandle",
    Position = UDim2.new(0, 160, 0, 0),
    Size = UDim2.new(1, -160, 0, 40),
    BackgroundTransparency = 1,
    Parent = MainFrame
})
makeDraggable(Shadow, DragHandle)

-- Control Buttons Container
local Controls = create("Frame", {
    Position = UDim2.new(1, -70, 0, 10),
    Size = UDim2.new(0, 60, 0, 20),
    BackgroundTransparency = 1,
    Parent = DragHandle
})

local MinimizeBtn = create("TextButton", {
    Size = UDim2.new(0, 20, 0, 20),
    BackgroundColor3 = THEME.ElementBg,
    Text = "-",
    TextColor3 = THEME.TextMain,
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    Parent = Controls
})
applyCorner(MinimizeBtn, 6)

local CloseBtn = create("TextButton", {
    Position = UDim2.new(1, -20, 0, 0),
    Size = UDim2.new(0, 20, 0, 20),
    BackgroundColor3 = Color3.fromRGB(80, 30, 30),
    Text = "×",
    TextColor3 = THEME.TextMain,
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    Parent = Controls
})
applyCorner(CloseBtn, 6)

-- Container for Pages
local PageContainer = create("Frame", {
    Name = "PageContainer",
    Position = UDim2.new(0, 175, 0, 50),
    Size = UDim2.new(1, -190, 1, -65),
    BackgroundTransparency = 1,
    Parent = MainFrame
})

-- Sidebar Layout
local TabList = create("Frame", {
    Position = UDim2.new(0, 10, 0, 60),
    Size = UDim2.new(1, -20, 1, -70),
    BackgroundTransparency = 1,
    Parent = Sidebar
})
local TabLayout = create("UIListLayout", {
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 6),
    Parent = TabList
})

-- =============================================================================
-- SYSTEM LOGIC & PAGE MANAGEMENT
-- =============================================================================
local tabs = {}
local activeTab = nil

local function createTab(name)
    local page = create("ScrollingFrame", {
        Name = name .. "Page",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = THEME.AccentNeon,
        Visible = false,
        Parent = PageContainer
    })
    create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10),
        Parent = page
    })
    
    local button = create("TextButton", {
        Name = name .. "Btn",
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = THEME.Sidebar,
        Text = "  " .. name,
        TextColor3 = THEME.TextDark,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TabList
    })
    applyCorner(button, 6)
    applyStroke(button, THEME.ElementBg, 1, 0.5)
    
    button.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.Page.Visible = false
            t.Button.TextColor3 = THEME.TextDark
            TweenService:Create(t.Button, TWEEN_INFO, { BackgroundColor3 = THEME.Sidebar }):Play()
        end
        page.Visible = true
        button.TextColor3 = THEME.TextMain
        TweenService:Create(button, TWEEN_INFO, { BackgroundColor3 = THEME.ElementBg }):Play()
    end)
    
    tabs[name] = { Page = page, Button = button }
    if not activeTab then
        activeTab = tabs[name]
        page.Visible = true
        button.TextColor3 = THEME.TextMain
        button.BackgroundColor3 = THEME.ElementBg
    end
    return page
end

-- Component Builder Utility
local function createControlRow(parent, labelText)
    local row = create("Frame", {
        Size = UDim2.new(1, -5, 0, 45),
        BackgroundColor3 = THEME.ElementBg,
        Parent = parent
    })
    applyCorner(row, 8)
    applyStroke(row, Color3.fromRGB(255,255,255), 1, 0.95)
    
    local label = create("TextLabel", {
        Position = UDim2.new(0, 12, 0, 0),
        Size = UDim2.new(0.4, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = labelText,
        TextColor3 = THEME.TextMain,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row
    })
    
    local interactStructure = create("Frame", {
        Position = UDim2.new(0.5, 0, 0.1, 0),
        Size = UDim2.new(0.5, -10, 0.8, 0),
        BackgroundTransparency = 1,
        Parent = row
    })
    
    return interactStructure
end

local function addInputGroup(parent, label, defaultText, callback)
    local container = createControlRow(parent, label)
    
    local box = create("TextBox", {
        Size = UDim2.new(0.6, -5, 1, 0),
        BackgroundColor3 = THEME.ElementInput,
        Text = defaultText,
        TextColor3 = THEME.TextMain,
        PlaceholderText = "Val...",
        Font = Enum.Font.Gotham,
        TextSize = 12,
        ClearTextOnFocus = false,
        Parent = container
    })
    applyCorner(box, 6)
    
    local btn = create("TextButton", {
        Position = UDim2.new(0.6, 5, 0, 0),
        Size = UDim2.new(0.4, -5, 1, 0),
        BackgroundColor3 = THEME.AccentGlow,
        Text = "SET",
        TextColor3 = THEME.TextMain,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        Parent = container
    })
    applyCorner(btn, 6)
    createGradient(btn, THEME.AccentGlow, THEME.AccentNeon)
    
    btn.MouseButton1Click:Connect(function()
        callback(box.Text)
        TweenService:Create(btn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true), { Size = UDim2.new(0.4, -2, 1, -2) }):Play()
    end)
end

-- =============================================================================
-- BUILDING PAGES & EXECUTING FEATURES
-- =============================================================================
local playerPage = createTab("Player")

-- Helper to safely grab Humanoid
local function getHumanoid()
    local lp = Players.LocalPlayer
    if lp and lp.Character then
        return lp.Character:FindFirstChildOfClass("Humanoid")
    end
    return nil
end

-- WalkSpeed
addInputGroup(playerPage, "Walk Speed", "16", function(val)
    local hum = getHumanoid()
    if hum then hum.WalkSpeed = tonumber(val) or 16 end
end)

-- JumpHeight
addInputGroup(playerPage, "Jump Height", "50", function(val)
    local hum = getHumanoid()
    if hum then
        hum.UseJumpPower = false
        hum.JumpHeight = tonumber(val) or 50
    end
end)

-- HipHeight
addInputGroup(playerPage, "Hip Height", "0", function(val)
    local hum = getHumanoid()
    if hum then hum.HipHeight = tonumber(val) or 0 end
end)

-- Gravity
addInputGroup(playerPage, "World Gravity", "196.2", function(val)
    Workspace.Gravity = tonumber(val) or 196.2
end)

-- Field of View (FOV)
addInputGroup(playerPage, "Field of View", "70", function(val)
    local cam = Workspace.CurrentCamera
    if cam then cam.FieldOfView = tonumber(val) or 70 end
end)

-- Additional structural tab for preview balance
local visualPage = createTab("Visuals")
createControlRow(visualPage, "ESP Toggle (Placeholder)")
createControlRow(visualPage, "Chams (Placeholder)")

-- =============================================================================
-- INTERACTION OPERATIONS (MINIMIZE / CLOSE)
-- =============================================================================
local minimized = false
local regularSize = Shadow.Size

MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    local targetSize = minimized and UDim2.new(0, 550, 0, 45) or regularSize
    
    TweenService:Create(Shadow, TWEEN_INFO, { Size = targetSize }):Play()
    MainFrame.ClipsDescendants = true
end)

CloseBtn.MouseButton1Click:Connect(function()
    local closeTween = TweenService:Create(Shadow, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 550, 0, 0),
        BackgroundTransparency = 1
    })
    closeTween:Play()
    closeTween.Completed:Connect(function()
        ScreenGui:Destroy()
    end)
end)

-- Window controls styling triggers
addHoverEffect(MinimizeBtn, THEME.ElementBg, THEME.ElementInput)
addHoverEffect(CloseBtn, Color3.fromRGB(80, 30, 30), Color3.fromRGB(130, 40, 40))

print("[TMscript]: Loaded successfully.")
