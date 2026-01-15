-- Bdev UI Slider Component
local Slider = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

function Slider.new(tab, config)
    config = config or {}
    local text = config.Name or "Slider"
    local min = config.Min or 0
    local max = config.Max or 100
    local default = config.Default or 50
    local callback = config.Callback or function() end
    local flag = config.Flag or ""

    if not tab then
        tab = _G.BdevUI.CurrentWindow and _G.BdevUI.CurrentWindow.CurrentTab
    end

    if not tab then
        warn("BdevUI: No tab found. Create a tab first.")
        return
    end

    -- Slider Frame
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = "SliderFrame"
    sliderFrame.Parent = tab.Content
    sliderFrame.BackgroundColor3 = _G.BdevUI.Theme.Secondary
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Size = UDim2.new(1, 0, 0, 60)

    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 6)
    sliderCorner.Parent = sliderFrame

    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Parent = sliderFrame
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 10, 0, 5)
    title.Size = UDim2.new(1, -20, 0, 20)
    title.Font = Enum.Font.GothamSemibold
    title.Text = text
    title.TextColor3 = _G.BdevUI.Theme.Text
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left

    -- Value Display
    local valueDisplay = Instance.new("TextLabel")
    valueDisplay.Name = "Value"
    valueDisplay.Parent = sliderFrame
    valueDisplay.BackgroundTransparency = 1
    valueDisplay.Position = UDim2.new(1, -50, 0, 5)
    valueDisplay.Size = UDim2.new(0, 40, 0, 20)
    valueDisplay.Font = Enum.Font.GothamSemibold
    valueDisplay.Text = tostring(default)
    valueDisplay.TextColor3 = _G.BdevUI.Theme.Accent
    valueDisplay.TextSize = 14
    valueDisplay.TextXAlignment = Enum.TextXAlignment.Right

    -- Slider Bar Background
    local sliderBar = Instance.new("Frame")
    sliderBar.Name = "Bar"
    sliderBar.Parent = sliderFrame
    sliderBar.BackgroundColor3 = _G.BdevUI.Theme.Background
    sliderBar.BorderSizePixel = 0
    sliderBar.Position = UDim2.new(0, 10, 0, 35)
    sliderBar.Size = UDim2.new(1, -20, 0, 6)

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = sliderBar

    -- Slider Fill
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "Fill"
    sliderFill.Parent = sliderBar
    sliderFill.BackgroundColor3 = _G.BdevUI.Theme.Accent
    sliderFill.BorderSizePixel = 0
    sliderFill.Size = UDim2.new(0, 0, 1, 0)

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill

    -- Slider Knob
    local sliderKnob = Instance.new("Frame")
    sliderKnob.Name = "Knob"
    sliderKnob.Parent = sliderBar
    sliderKnob.BackgroundColor3 = _G.BdevUI.Theme.Text
    sliderKnob.BorderSizePixel = 0
    sliderKnob.Position = UDim2.new(0, -5, 0.5, -8)
    sliderKnob.Size = UDim2.new(0, 16, 0, 16)

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = sliderKnob

    -- Slider Logic
    local value = math.clamp(default, min, max)
    _G.BdevUI.Flags[flag] = value

    local dragging = false

    local function round(number, decimalPlaces)
        local mult = 10^(decimalPlaces or 0)
        return math.floor(number * mult + 0.5) / mult
    end

    local function updateSlider()
        local percent = (value - min) / (max - min)
        TweenService:Create(sliderFill, TweenInfo.new(0.1), {Size = UDim2.new(percent, 0, 1, 0)}):Play()
        TweenService:Create(sliderKnob, TweenInfo.new(0.1), {Position = UDim2.new(percent, -5, 0.5, -8)}):Play()
        valueDisplay.Text = tostring(round(value, 1))
        callback(value)
    end

    updateSlider()

    local function updateValue(input)
        if dragging then
            local relativeX = input.Position.X - sliderBar.AbsolutePosition.X
            local percent = math.clamp(relativeX / sliderBar.AbsoluteSize.X, 0, 1)
            value = round(min + (max - min) * percent, 1)
            _G.BdevUI.Flags[flag] = value
            updateSlider()
        end
    end

    sliderKnob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateValue(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            updateValue(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- Update canvas size
    _G.BdevUI:UpdateCanvasSize(tab)

    return sliderFrame
end

return Slider