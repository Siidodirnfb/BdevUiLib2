-- Bdev UI Label Component
local Label = {}

function Label.new(tab, config)
    config = config or {}
    local text = config.Name or "Label"

    if not tab then
        tab = _G.BdevUI.CurrentWindow and _G.BdevUI.CurrentWindow.CurrentTab
    end

    if not tab then
        warn("BdevUI: No tab found. Create a tab first.")
        return
    end

    -- Label Frame
    local labelFrame = Instance.new("Frame")
    labelFrame.Name = "LabelFrame"
    labelFrame.Parent = tab.Content
    labelFrame.BackgroundColor3 = _G.BdevUI.Theme.Secondary
    labelFrame.BorderSizePixel = 0
    labelFrame.Size = UDim2.new(1, 0, 0, 30)

    local labelCorner = Instance.new("UICorner")
    labelCorner.CornerRadius = UDim.new(0, 6)
    labelCorner.Parent = labelFrame

    -- Label Text
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Parent = labelFrame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Size = UDim2.new(1, -20, 1, 0)
    label.Font = Enum.Font.GothamSemibold
    label.Text = text
    label.TextColor3 = _G.BdevUI.Theme.Text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    -- Update canvas size
    _G.BdevUI:UpdateCanvasSize(tab)

    return label
end

return Label