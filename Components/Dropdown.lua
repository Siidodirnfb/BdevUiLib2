-- Bdev UI Dropdown Component
local Dropdown = {}

local TweenService = game:GetService("TweenService")

function Dropdown.new(tab, config)
    config = config or {}
    local text = config.Name or "Dropdown"
    local options = config.Options or {}
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

    -- Dropdown Frame
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Name = "DropdownFrame"
    dropdownFrame.Parent = tab.Content
    dropdownFrame.BackgroundColor3 = _G.BdevUI.Theme.Secondary
    dropdownFrame.BorderSizePixel = 0
    dropdownFrame.Size = UDim2.new(1, 0, 0, 40)

    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 6)
    dropdownCorner.Parent = dropdownFrame

    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Parent = dropdownFrame
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 10, 0, 0)
    title.Size = UDim2.new(1, -40, 0, 20)
    title.Font = Enum.Font.GothamSemibold
    title.Text = text
    title.TextColor3 = _G.BdevUI.Theme.Text
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left

    -- Selected Value
    local selectedValue = Instance.new("TextLabel")
    selectedValue.Name = "Selected"
    selectedValue.Parent = dropdownFrame
    selectedValue.BackgroundTransparency = 1
    selectedValue.Position = UDim2.new(0, 10, 0, 20)
    selectedValue.Size = UDim2.new(1, -40, 0, 20)
    selectedValue.Font = Enum.Font.Gotham
    selectedValue.Text = default or "Select..."
    selectedValue.TextColor3 = _G.BdevUI.Theme.TextSecondary
    selectedValue.TextSize = 12
    selectedValue.TextXAlignment = Enum.TextXAlignment.Left

    -- Arrow
    local arrow = Instance.new("TextLabel")
    arrow.Name = "Arrow"
    arrow.Parent = dropdownFrame
    arrow.BackgroundTransparency = 1
    arrow.Position = UDim2.new(1, -25, 0, 10)
    arrow.Size = UDim2.new(0, 15, 0, 20)
    arrow.Font = Enum.Font.GothamBold
    arrow.Text = "▼"
    arrow.TextColor3 = _G.BdevUI.Theme.TextSecondary
    arrow.TextSize = 12

    -- Dropdown Button
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Name = "DropdownButton"
    dropdownButton.Parent = dropdownFrame
    dropdownButton.BackgroundTransparency = 1
    dropdownButton.Size = UDim2.new(1, 0, 1, 0)

    -- Options Frame (initially hidden)
    local optionsFrame = Instance.new("Frame")
    optionsFrame.Name = "OptionsFrame"
    optionsFrame.Parent = dropdownFrame
    optionsFrame.BackgroundColor3 = _G.BdevUI.Theme.Background
    optionsFrame.BorderSizePixel = 0
    optionsFrame.Position = UDim2.new(0, 0, 1, 0)
    optionsFrame.Size = UDim2.new(1, 0, 0, 0)
    optionsFrame.Visible = false
    optionsFrame.ClipsDescendants = true

    local optionsCorner = Instance.new("UICorner")
    optionsCorner.CornerRadius = UDim.new(0, 6)
    optionsCorner.Parent = optionsFrame

    local optionsList = Instance.new("UIListLayout")
    optionsList.Parent = optionsFrame
    optionsList.SortOrder = Enum.SortOrder.LayoutOrder

    -- Dropdown Logic
    local selected = default
    local expanded = false
    _G.BdevUI.Flags[flag] = selected

    local function updateDropdown()
        selectedValue.Text = selected or "Select..."
        callback(selected)
    end

    local function toggleDropdown()
        expanded = not expanded
        if expanded then
            TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
            TweenService:Create(optionsFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, math.min(#options * 25, 150))}):Play()
            optionsFrame.Visible = true
        else
            TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
            TweenService:Create(optionsFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 0)}):Play()
            task.delay(0.3, function()
                optionsFrame.Visible = false
            end)
        end
    end

    dropdownButton.MouseButton1Click:Connect(toggleDropdown)

    -- Create options
    for _, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Name = option:gsub("%s+", "")
        optionButton.Parent = optionsFrame
        optionButton.BackgroundColor3 = _G.BdevUI.Theme.Background
        optionButton.BorderSizePixel = 0
        optionButton.Size = UDim2.new(1, 0, 0, 25)
        optionButton.Font = Enum.Font.Gotham
        optionButton.Text = option
        optionButton.TextColor3 = _G.BdevUI.Theme.Text
        optionButton.TextSize = 12
        optionButton.AutoButtonColor = false

        optionButton.MouseEnter:Connect(function()
            TweenService:Create(optionButton, TweenInfo.new(0.1), {BackgroundColor3 = _G.BdevUI.Theme.Tertiary}):Play()
        end)

        optionButton.MouseLeave:Connect(function()
            TweenService:Create(optionButton, TweenInfo.new(0.1), {BackgroundColor3 = _G.BdevUI.Theme.Background}):Play()
        end)

        optionButton.MouseButton1Click:Connect(function()
            selected = option
            _G.BdevUI.Flags[flag] = selected
            updateDropdown()
            toggleDropdown()
        end)
    end

    updateDropdown()

    -- Update canvas size
    _G.BdevUI:UpdateCanvasSize(tab)

    return dropdownFrame
end

return Dropdown