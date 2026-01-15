# Bdev UI Library

A high-quality, modern Roblox UI library designed specifically for executors. Features a sleek black, white, and gray theme with smooth animations and professional design.

![Bdev UI Preview](https://via.placeholder.com/800x400/202020/FFFFFF?text=Bdev+UI+Preview)

## ✨ Features

- **Modern Design**: Clean black, white, and gray theme with rounded corners
- **Smooth Animations**: Tween-based transitions for all interactions
- **Modular Architecture**: Well-organized component system
- **Notification System**: Built-in notification popup system
- **Flag System**: Easy state management for toggles, sliders, etc.
- **Drag & Drop**: Movable windows with smooth dragging
- **Responsive UI**: Auto-adjusting canvas sizes
- **Executor Optimized**: Designed specifically for Roblox exploit environments

## 🚀 Quick Start

```lua
-- Load the library
local BdevUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/BdevUiLib/main/BdevUI.lua"))()

-- Create a window
local Window = BdevUI:CreateWindow({
    Name = "My Script",
    StartupSound = true  -- Optional startup sound
})

-- Create a tab
local MainTab = BdevUI:CreateTab(Window, {
    Name = "Main",
    Icon = "🏠"  -- Optional icon
})

-- Add elements
BdevUI:CreateButton(MainTab, {
    Name = "Click Me!",
    Callback = function()
        print("Button clicked!")
    end
})

BdevUI:CreateToggle(MainTab, {
    Name = "Enable Feature",
    Default = false,
    Flag = "MyFeature",
    Callback = function(value)
        print("Toggle is now:", value)
    end
})
```

## 📚 Documentation

### Core Functions

#### CreateWindow(config)
Creates a new UI window.

**Parameters:**
- `config.Name` (string): Window title
- `config.StartupSound` (boolean, optional): Play startup sound

**Returns:** Window object

#### CreateTab(window, config)
Creates a new tab in the specified window.

**Parameters:**
- `window`: Window object returned by CreateWindow
- `config.Name` (string): Tab name
- `config.Icon` (string, optional): Tab icon

**Returns:** Tab object

### UI Components

#### CreateButton(tab, config)
Creates a clickable button.

**Parameters:**
- `tab`: Tab object
- `config.Name` (string): Button text
- `config.Callback` (function): Function to call when clicked

#### CreateToggle(tab, config)
Creates a toggle switch.

**Parameters:**
- `tab`: Tab object
- `config.Name` (string): Toggle label
- `config.Default` (boolean, optional): Default state
- `config.Flag` (string, optional): Unique identifier for state management
- `config.Callback` (function): Function called with new state

#### CreateSlider(tab, config)
Creates a draggable slider.

**Parameters:**
- `tab`: Tab object
- `config.Name` (string): Slider label
- `config.Min` (number): Minimum value
- `config.Max` (number): Maximum value
- `config.Default` (number, optional): Default value
- `config.Flag` (string, optional): Unique identifier
- `config.Callback` (function): Function called with new value

#### CreateTextbox(tab, config)
Creates a text input field.

**Parameters:**
- `tab`: Tab object
- `config.Name` (string): Textbox label
- `config.Placeholder` (string, optional): Placeholder text
- `config.Default` (string, optional): Default text
- `config.Flag` (string, optional): Unique identifier
- `config.Callback` (function): Function called with text and enter press state

#### CreateDropdown(tab, config)
Creates a dropdown selection menu.

**Parameters:**
- `tab`: Tab object
- `config.Name` (string): Dropdown label
- `config.Options` (table): Array of option strings
- `config.Default` (string, optional): Default selected option
- `config.Flag` (string, optional): Unique identifier
- `config.Callback` (function): Function called with selected option

#### CreateLabel(tab, config)
Creates a text label for displaying information.

**Parameters:**
- `tab`: Tab object
- `config.Name` (string): Label text

### Notification System

#### MakeNotification(config)
Shows a notification popup.

**Parameters:**
- `config.Name` (string): Notification title
- `config.Content` (string): Notification message
- `config.Time` (number, optional): Display duration in seconds (default: 5)

### State Management

The library includes a built-in flag system for managing component states:

```lua
-- Access flag values
local isEnabled = BdevUI.Flags["MyFeature"]

-- Set flag values
BdevUI.Flags["MyFeature"] = true

-- Get all flags
for flag, value in pairs(BdevUI.Flags) do
    print(flag .. ":", value)
end
```

### Window Management

#### DestroyWindow(windowName)
Closes and destroys a window.

**Parameters:**
- `windowName` (string): Name of the window to destroy

## 🎨 Theme System

The library uses a black, white, and gray color scheme:

```lua
BdevUI.Theme = {
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
}
```

## 📁 Project Structure

```
BdevUiLib/
├── BdevUI.lua              # Main library file
├── Components/             # Modular components
│   ├── Button.lua
│   ├── Toggle.lua
│   ├── Slider.lua
│   ├── Textbox.lua
│   ├── Dropdown.lua
│   └── Label.lua
├── Examples/               # Example scripts
│   ├── Example.lua         # Full feature demo
│   ├── SimpleExample.lua   # Basic usage
│   └── AdvancedExample.lua # Complex UI demo
└── README.md              # This documentation
```

## 💡 Examples

### Basic Example
```lua
local BdevUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/BdevUiLib/main/BdevUI.lua"))()

local Window = BdevUI:CreateWindow({Name = "My Script"})
local Tab = BdevUI:CreateTab(Window, {Name = "Main"})

BdevUI:CreateLabel(Tab, {Name = "Hello, World!"})
BdevUI:CreateButton(Tab, {
    Name = "Click Me",
    Callback = function()
        BdevUI:MakeNotification({
            Name = "Success!",
            Content = "Button clicked!",
            Time = 3
        })
    end
})
```

### Advanced Example
```lua
local Window = BdevUI:CreateWindow({Name = "Advanced UI", StartupSound = true})

local CombatTab = BdevUI:CreateTab(Window, {Name = "Combat", Icon = "⚔️"})
local VisualTab = BdevUI:CreateTab(Window, {Name = "Visual", Icon = "👁️"})

-- Combat features
BdevUI:CreateToggle(CombatTab, {
    Name = "Aimbot",
    Default = false,
    Flag = "AimbotEnabled",
    Callback = function(value)
        print("Aimbot:", value)
    end
})

BdevUI:CreateSlider(CombatTab, {
    Name = "FOV",
    Min = 10,
    Max = 180,
    Default = 90,
    Flag = "AimbotFOV"
})

-- Visual features
BdevUI:CreateToggle(VisualTab, {
    Name = "ESP",
    Default = false,
    Flag = "ESPEnabled"
})

BdevUI:CreateDropdown(VisualTab, {
    Name = "ESP Color",
    Options = {"Red", "Blue", "Green", "White"},
    Default = "White",
    Flag = "ESPColor"
})
```

## 🔧 Advanced Usage

### Custom Callbacks
```lua
BdevUI:CreateSlider(MainTab, {
    Name = "Speed",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        -- Update game speed
        game:GetService("RunService").RenderStepped:Wait()
        -- Apply speed changes here
    end
})
```

### State Persistence
```lua
-- Save settings
local function saveSettings()
    local settings = {}
    for flag, value in pairs(BdevUI.Flags) do
        settings[flag] = value
    end
    -- Save to file or datastore
end

-- Load settings
local function loadSettings()
    -- Load from file or datastore
    local settings = {} -- Your loaded settings
    for flag, value in pairs(settings) do
        BdevUI.Flags[flag] = value
    end
end
```

### Notification System
```lua
-- Success notification
BdevUI:MakeNotification({
    Name = "Success!",
    Content = "Operation completed successfully!",
    Time = 3
})

-- Error notification
BdevUI:MakeNotification({
    Name = "Error",
    Content = "Something went wrong!",
    Time = 5
})
```

## ⚡ Performance

- **Lightweight**: Minimal memory footprint
- **Optimized**: Efficient tween usage
- **Smooth**: 60 FPS animations
- **Responsive**: Fast UI updates

## 🛠️ Compatibility

- **Roblox Executors**: Fully compatible with all major executors
- **Roblox Versions**: Works on all Roblox versions
- **Multiple Instances**: Support for multiple windows

## 📄 License

This project is open source and available under the MIT License.

## 👨‍💻 Author

**Bdev** - Creator of Bdev UI Library

## 🤝 Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for bugs and feature requests.

## 📞 Support

If you need help or have questions, feel free to reach out!

---

**Made with ❤️ for the Roblox community**