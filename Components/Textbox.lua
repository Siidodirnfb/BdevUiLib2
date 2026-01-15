-- Bdev UI Textbox Component
local Textbox = {}

local TweenService = game:GetService("TweenService")

function Textbox.new(tab, config)
    config = config or {}
    local text = config.Name or "Textbox"
    local placeholder = config.Placeholder or "Enter text..."
    local default = config.Default or ""
    local callback = config.Callback or function() end
    local flag = config.Flag or ""

    if not tab then
        tab = _G.BdevUI.CurrentWindow and _G.BdevUI.CurrentWindow.CurrentTab
    end

    if not tab then
        warn("BdevUI: No tab found. Create a tab first.")
        return
    end

    -- Textbox Frame
    local textboxFrame = Instance.new("Frame")
    textboxFrame.Name = "TextboxFrame"
    textboxFrame.Parent = tab.Content
    textboxFrame.BackgroundColor3 = _G.BdevUI.Theme.Secondary
    textboxFrame.BorderSizePixel = 0
    textboxFrame.Size = UDim2.new(1, 0, 0, 40)

    local textboxCorner = Instance.new("UICorner")
    textboxCorner.CornerRadius = UDim.new(0, 6)
    textboxCorner.Parent = textboxFrame

    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Parent = textboxFrame
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 10, 0, 0)
    title.Size = UDim2.new(1, -20, 0, 20)
    title.Font = Enum.Font.GothamSemibold
    title.Text = text
    title.TextColor3 = _G.BdevUI.Theme.Text
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left

    -- Textbox Input
    local textbox = Instance.new("TextBox")
    textbox.Name = "Input"
    textbox.Parent = textboxFrame
    textbox.BackgroundColor3 = _G.BdevUI.Theme.Background
    textbox.BorderSizePixel = 0
    textbox.Position = UDim2.new(0, 10, 0, 22)
    textbox.Size = UDim2.new(1, -20, 0, 18)
    textbox.Font = Enum.Font.Gotham
    textbox.PlaceholderText = placeholder
    textbox.Text = default
    textbox.TextColor3 = _G.BdevUI.Theme.Text
    textbox.TextSize = 12
    textbox.ClearTextOnFocus = false

    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 4)
    inputCorner.Parent = textbox

    -- Focus Effects
    textbox.Focused:Connect(function()
        TweenService:Create(textbox, TweenInfo.new(0.2), {BackgroundColor3 = _G.BdevUI.Theme.Tertiary}):Play()
    end)

    textbox.FocusLost:Connect(function(enterPressed)
        TweenService:Create(textbox, TweenInfo.new(0.2), {BackgroundColor3 = _G.BdevUI.Theme.Background}):Play()
        local inputText = textbox.Text
        _G.BdevUI.Flags[flag] = inputText
        callback(inputText, enterPressed)
    end)

    -- Update canvas size
    _G.BdevUI:UpdateCanvasSize(tab)

    return textbox
end

return Textbox