-- Bdev UI Button Component
local Button = {}

local TweenService = game:GetService("TweenService")

function Button.new(tab, config)
    config = config or {}
    local text = config.Name or "Button"
    local callback = config.Callback or function() end

    if not tab then
        tab = _G.BdevUI.CurrentWindow and _G.BdevUI.CurrentWindow.CurrentTab
    end

    if not tab then
        warn("BdevUI: No tab found. Create a tab first.")
        return
    end

    -- Button Frame
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Name = "ButtonFrame"
    buttonFrame.Parent = tab.Content
    buttonFrame.BackgroundColor3 = _G.BdevUI.Theme.Secondary
    buttonFrame.BorderSizePixel = 0
    buttonFrame.Size = UDim2.new(1, 0, 0, 40)

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = buttonFrame

    -- Button
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Parent = buttonFrame
    button.BackgroundTransparency = 1
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Font = Enum.Font.GothamSemibold
    button.Text = text
    button.TextColor3 = _G.BdevUI.Theme.Text
    button.TextSize = 14
    button.AutoButtonColor = false

    -- Hover Effects
    button.MouseEnter:Connect(function()
        TweenService:Create(buttonFrame, TweenInfo.new(0.2), {BackgroundColor3 = _G.BdevUI.Theme.Tertiary}):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(buttonFrame, TweenInfo.new(0.2), {BackgroundColor3 = _G.BdevUI.Theme.Secondary}):Play()
    end)

    button.MouseButton1Down:Connect(function()
        TweenService:Create(buttonFrame, TweenInfo.new(0.1), {BackgroundColor3 = _G.BdevUI.Theme.Accent}):Play()
        button.TextColor3 = _G.BdevUI.Theme.Background
    end)

    button.MouseButton1Up:Connect(function()
        TweenService:Create(buttonFrame, TweenInfo.new(0.1), {BackgroundColor3 = _G.BdevUI.Theme.Secondary}):Play()
        button.TextColor3 = _G.BdevUI.Theme.Text
        callback()
    end)

    -- Update canvas size
    _G.BdevUI:UpdateCanvasSize(tab)

    return button
end

return Button