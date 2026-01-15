-- Bdev UI Toggle Component
local Toggle = {}

local TweenService = game:GetService("TweenService")

function Toggle.new(tab, config)
    config = config or {}
    local text = config.Name or "Toggle"
    local default = config.Default or false
    local callback = config.Callback or function() end
    local flag = config.Flag or ""

    if not tab then
        tab = _G.BdevUI.CurrentWindow and _G.BdevUI.CurrentWindow.CurrentTab
    end

    if not tab then
        warn("BdevUI: No tab found. Create a tab first.")
        return
    end

    -- Toggle Frame
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "ToggleFrame"
    toggleFrame.Parent = tab.Content
    toggleFrame.BackgroundColor3 = _G.BdevUI.Theme.Secondary
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Size = UDim2.new(1, 0, 0, 40)

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggleFrame

    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Parent = toggleFrame
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 10, 0, 0)
    title.Size = UDim2.new(1, -60, 1, 0)
    title.Font = Enum.Font.GothamSemibold
    title.Text = text
    title.TextColor3 = _G.BdevUI.Theme.Text
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left

    -- Toggle Switch
    local toggleSwitch = Instance.new("Frame")
    toggleSwitch.Name = "Switch"
    toggleSwitch.Parent = toggleFrame
    toggleSwitch.BackgroundColor3 = _G.BdevUI.Theme.Background
    toggleSwitch.BorderSizePixel = 0
    toggleSwitch.Position = UDim2.new(1, -45, 0.5, -10)
    toggleSwitch.Size = UDim2.new(0, 35, 0, 20)

    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = toggleSwitch

    -- Toggle Knob
    local toggleKnob = Instance.new("Frame")
    toggleKnob.Name = "Knob"
    toggleKnob.Parent = toggleSwitch
    toggleKnob.BackgroundColor3 = _G.BdevUI.Theme.TextSecondary
    toggleKnob.BorderSizePixel = 0
    toggleKnob.Position = UDim2.new(0, 2, 0.5, -8)
    toggleKnob.Size = UDim2.new(0, 16, 0, 16)

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = toggleKnob

    -- Toggle Button (invisible overlay)
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Parent = toggleFrame
    toggleButton.BackgroundTransparency = 1
    toggleButton.Size = UDim2.new(1, 0, 1, 0)

    -- Toggle Logic
    local toggled = default
    _G.BdevUI.Flags[flag] = toggled

    local function updateToggle()
        if toggled then
            TweenService:Create(toggleSwitch, TweenInfo.new(0.2), {BackgroundColor3 = _G.BdevUI.Theme.Success}):Play()
            TweenService:Create(toggleKnob, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0.5, -8)}):Play()
            TweenService:Create(toggleKnob, TweenInfo.new(0.2), {BackgroundColor3 = _G.BdevUI.Theme.Text}):Play()
        else
            TweenService:Create(toggleSwitch, TweenInfo.new(0.2), {BackgroundColor3 = _G.BdevUI.Theme.Background}):Play()
            TweenService:Create(toggleKnob, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
            TweenService:Create(toggleKnob, TweenInfo.new(0.2), {BackgroundColor3 = _G.BdevUI.Theme.TextSecondary}):Play()
        end
        callback(toggled)
    end

    updateToggle()

    toggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        _G.BdevUI.Flags[flag] = toggled
        updateToggle()
    end)

    -- Update canvas size
    _G.BdevUI:UpdateCanvasSize(tab)

    return toggleButton
end

return Toggle