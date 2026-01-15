-- Bdev UI Library
-- A high-quality Roblox UI library for executors
-- Theme: Black, White, Gray combination

local BdevUI = {
    Version = "1.0.0",
    Author = "Bdev",
    Theme = {
        Background = Color3.fromRGB(20, 20, 20),
        Secondary = Color3.fromRGB(30, 30, 30),
        Tertiary = Color3.fromRGB(40, 40, 40),
        Accent = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 180),
        Border = Color3.fromRGB(60, 60, 60),
        Success = Color3.fromRGB(0, 255, 128),
        Warning = Color3.fromRGB(255, 165, 0),
        Error = Color3.fromRGB(255, 0, 64)
    },
    Flags = {},
    Connections = {},
    Windows = {},
    CurrentWindow = nil
}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Utility Functions
local function Create(instanceType, properties)
    local instance = Instance.new(instanceType)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

local function Tween(instance, properties, duration, style, direction)
    local tweenInfo = TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

local function Round(number, decimalPlaces)
    local mult = 10^(decimalPlaces or 0)
    return math.floor(number * mult + 0.5) / mult
end

local function GetMouse()
    return UserInputService:GetMouseLocation()
end

-- Core Library Functions
function BdevUI:CreateWindow(config)
    config = config or {}
    local windowName = config.Name or "Bdev UI"
    local startupSound = config.StartupSound or false

    -- Create ScreenGui
    local screenGui = Create("ScreenGui", {
        Name = "BdevUI_" .. windowName:gsub("%s+", ""),
        Parent = game:GetService("CoreGui"),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    -- Create Main Frame
    local mainFrame = Create("Frame", {
        Name = "MainFrame",
        Parent = screenGui,
        BackgroundColor3 = BdevUI.Theme.Background,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -300, 0.5, -200),
        Size = UDim2.new(0, 600, 0, 400),
        ClipsDescendants = true
    })

    -- Add rounded corners
    local uiCorner = Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = mainFrame
    })

    -- Create Title Bar
    local titleBar = Create("Frame", {
        Name = "TitleBar",
        Parent = mainFrame,
        BackgroundColor3 = BdevUI.Theme.Secondary,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40)
    })

    local titleCorner = Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = titleBar
    })

    -- Title Text
    local titleText = Create("TextLabel", {
        Name = "Title",
        Parent = titleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(1, -60, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = windowName,
        TextColor3 = BdevUI.Theme.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Close Button
    local closeButton = Create("TextButton", {
        Name = "Close",
        Parent = titleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -35, 0, 0),
        Size = UDim2.new(0, 30, 0, 30),
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextColor3 = BdevUI.Theme.Text,
        TextSize = 20
    })

    -- Minimize Button
    local minimizeButton = Create("TextButton", {
        Name = "Minimize",
        Parent = titleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -70, 0, 0),
        Size = UDim2.new(0, 30, 0, 30),
        Font = Enum.Font.GothamBold,
        Text = "−",
        TextColor3 = BdevUI.Theme.Text,
        TextSize = 20
    })

    -- Content Frame
    local contentFrame = Create("Frame", {
        Name = "Content",
        Parent = mainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 40),
        Size = UDim2.new(1, 0, 1, -40)
    })

    -- Tab Container
    local tabContainer = Create("Frame", {
        Name = "TabContainer",
        Parent = contentFrame,
        BackgroundColor3 = BdevUI.Theme.Tertiary,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 150, 1, 0)
    })

    -- Tab List
    local tabList = Create("ScrollingFrame", {
        Name = "TabList",
        Parent = tabContainer,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 10),
        Size = UDim2.new(1, -10, 1, -20),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = BdevUI.Theme.Border
    })

    local tabListLayout = Create("UIListLayout", {
        Parent = tabList,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })

    -- Content Container
    local contentContainer = Create("Frame", {
        Name = "ContentContainer",
        Parent = contentFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 160, 0, 0),
        Size = UDim2.new(1, -170, 1, 0)
    })

    -- Window Object
    local window = {
        Name = windowName,
        ScreenGui = screenGui,
        MainFrame = mainFrame,
        TitleBar = titleBar,
        ContentFrame = contentFrame,
        TabContainer = tabContainer,
        TabList = tabList,
        ContentContainer = contentContainer,
        Tabs = {},
        CurrentTab = nil,
        Dragging = false,
        DragOffset = Vector2.new(0, 0),
        Minimized = false,
        Connections = {}
    }

    -- Drag Functionality
    local function startDrag()
        window.Dragging = true
        local mousePos = GetMouse()
        window.DragOffset = mainFrame.Position - UDim2.new(0, mousePos.X, 0, mousePos.Y)
    end

    local function updateDrag()
        if window.Dragging then
            local mousePos = GetMouse()
            mainFrame.Position = UDim2.new(0, mousePos.X, 0, mousePos.Y) + window.DragOffset
        end
    end

    local function endDrag()
        window.Dragging = false
    end

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            startDrag()
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            updateDrag()
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            endDrag()
        end
    end)

    -- Button Events
    closeButton.MouseButton1Click:Connect(function()
        BdevUI:DestroyWindow(windowName)
    end)

    minimizeButton.MouseButton1Click:Connect(function()
        if window.Minimized then
            Tween(mainFrame, {Size = UDim2.new(0, 600, 0, 400)})
            window.Minimized = false
        else
            Tween(mainFrame, {Size = UDim2.new(0, 600, 0, 40)})
            window.Minimized = true
        end
    end)

    -- Store window
    BdevUI.Windows[windowName] = window
    BdevUI.CurrentWindow = window

    -- Startup sound
    if startupSound then
        local sound = Create("Sound", {
            SoundId = "rbxassetid://142700651",
            Volume = 0.5,
            Parent = screenGui
        })
        sound:Play()
        task.delay(1, function()
            sound:Destroy()
        end)
    end

    return window
end

function BdevUI:CreateTab(window, config)
    config = config or {}
    local tabName = config.Name or "Tab"
    local icon = config.Icon or ""

    if not window then
        window = BdevUI.CurrentWindow
    end

    if not window then
        warn("BdevUI: No window found. Create a window first.")
        return
    end

    -- Tab Button
    local tabButton = Create("TextButton", {
        Name = tabName:gsub("%s+", ""),
        Parent = window.TabList,
        BackgroundColor3 = BdevUI.Theme.Background,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -10, 0, 35),
        Font = Enum.Font.GothamSemibold,
        Text = icon .. " " .. tabName,
        TextColor3 = BdevUI.Theme.TextSecondary,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false
    })

    local tabCorner = Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = tabButton
    })

    -- Tab Content Frame
    local tabContent = Create("ScrollingFrame", {
        Name = tabName:gsub("%s+", "") .. "Content",
        Parent = window.ContentContainer,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 10),
        Size = UDim2.new(1, -10, 1, -20),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = BdevUI.Theme.Border,
        Visible = false
    })

    local contentLayout = Create("UIListLayout", {
        Parent = tabContent,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8)
    })

    local contentPadding = Create("UIPadding", {
        Parent = tabContent,
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 5)
    })

    -- Tab Object
    local tab = {
        Name = tabName,
        Button = tabButton,
        Content = tabContent,
        Elements = {},
        Layout = contentLayout
    }

    -- Tab Selection
    tabButton.MouseButton1Click:Connect(function()
        BdevUI:SelectTab(window, tab)
    end)

    -- Store tab
    window.Tabs[tabName] = tab
    table.insert(window.Tabs, tab)

    -- Auto-select first tab
    if #window.Tabs == 1 then
        BdevUI:SelectTab(window, tab)
    end

    return tab
end

function BdevUI:SelectTab(window, tab)
    if not window or not tab then return end

    -- Update tab buttons
    for _, t in pairs(window.Tabs) do
        if typeof(t) == "table" then
            if t == tab then
                Tween(t.Button, {BackgroundColor3 = BdevUI.Theme.Accent})
                t.Button.TextColor3 = BdevUI.Theme.Background
                t.Content.Visible = true
            else
                Tween(t.Button, {BackgroundColor3 = BdevUI.Theme.Background})
                t.Button.TextColor3 = BdevUI.Theme.TextSecondary
                t.Content.Visible = false
            end
        end
    end

    window.CurrentTab = tab
end

function BdevUI:DestroyWindow(windowName)
    local window = BdevUI.Windows[windowName]
    if not window then return end

    -- Cleanup connections
    for _, connection in pairs(window.Connections) do
        if connection then
            connection:Disconnect()
        end
    end

    -- Destroy GUI
    window.ScreenGui:Destroy()

    -- Remove from storage
    BdevUI.Windows[windowName] = nil
    if BdevUI.CurrentWindow == window then
        BdevUI.CurrentWindow = nil
    end
end

-- Load Components
local Button = require(script.Components.Button)
local Toggle = require(script.Components.Toggle)
local Slider = require(script.Components.Slider)
local Textbox = require(script.Components.Textbox)
local Dropdown = require(script.Components.Dropdown)
local Label = require(script.Components.Label)

-- Element Creation Functions
function BdevUI:CreateButton(tab, config)
    return Button.new(tab, config)
end

function BdevUI:CreateToggle(tab, config)
    return Toggle.new(tab, config)
end

function BdevUI:CreateSlider(tab, config)
    return Slider.new(tab, config)
end

function BdevUI:CreateTextbox(tab, config)
    return Textbox.new(tab, config)
end

function BdevUI:CreateLabel(tab, config)
    return Label.new(tab, config)
end

function BdevUI:CreateDropdown(tab, config)
    return Dropdown.new(tab, config)
end

function BdevUI:UpdateCanvasSize(tab)
    if not tab then return end

    local contentSize = tab.Layout.AbsoluteContentSize
    tab.Content.CanvasSize = UDim2.new(0, 0, 0, contentSize.Y + 20)
end

-- Notification System
function BdevUI:MakeNotification(config)
    config = config or {}
    local title = config.Name or "Notification"
    local content = config.Content or ""
    local time = config.Time or 5

    -- Notification GUI
    local notificationGui = Create("ScreenGui", {
        Name = "BdevNotification",
        Parent = game:GetService("CoreGui"),
        ResetOnSpawn = false
    })

    local notificationFrame = Create("Frame", {
        Name = "Notification",
        Parent = notificationGui,
        BackgroundColor3 = BdevUI.Theme.Background,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -250, 1, -100),
        Size = UDim2.new(0, 240, 0, 80),
        ClipsDescendants = true
    })

    local notificationCorner = Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = notificationFrame
    })

    -- Title
    local notificationTitle = Create("TextLabel", {
        Name = "Title",
        Parent = notificationFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 5),
        Size = UDim2.new(1, -20, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = BdevUI.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Content
    local notificationContent = Create("TextLabel", {
        Name = "Content",
        Parent = notificationFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 25),
        Size = UDim2.new(1, -20, 0, 50),
        Font = Enum.Font.Gotham,
        Text = content,
        TextColor3 = BdevUI.Theme.TextSecondary,
        TextSize = 12,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top
    })

    -- Progress Bar
    local progressBar = Create("Frame", {
        Name = "ProgressBar",
        Parent = notificationFrame,
        BackgroundColor3 = BdevUI.Theme.Background,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, -4),
        Size = UDim2.new(1, 0, 0, 4)
    })

    local progressFill = Create("Frame", {
        Name = "Fill",
        Parent = progressBar,
        BackgroundColor3 = BdevUI.Theme.Accent,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0)
    })

    -- Animation
    Tween(notificationFrame, {Position = UDim2.new(1, -250, 1, -100)}, 0.5, Enum.EasingStyle.Back)

    -- Auto-remove
    task.spawn(function()
        local startTime = tick()
        while task.wait() do
            local elapsed = tick() - startTime
            local progress = math.max(0, 1 - (elapsed / time))

            if progress <= 0 then
                Tween(notificationFrame, {Position = UDim2.new(1, 250, 1, -100)}, 0.5, Enum.EasingStyle.Back)
                task.wait(0.5)
                notificationGui:Destroy()
                break
            else
                progressFill.Size = UDim2.new(progress, 0, 1, 0)
            end
        end
    end)
end

-- Initialize
function BdevUI:Init()
    -- Setup theme
    print("Bdev UI Library v" .. BdevUI.Version .. " initialized!")
    print("Created by " .. BdevUI.Author)
end

-- Auto-initialize
BdevUI:Init()

return BdevUI