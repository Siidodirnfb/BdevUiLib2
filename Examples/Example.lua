-- Bdev UI Library Example
-- This script demonstrates all the features of the Bdev UI library

-- Load the library (in a real executor, you'd load this differently)
local BdevUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/BdevUiLib/main/BdevUI.lua"))()

-- Create the main window
local Window = BdevUI:CreateWindow({
    Name = "Bdev UI Example",
    StartupSound = true
})

-- Create tabs
local MainTab = BdevUI:CreateTab(Window, {
    Name = "Main",
    Icon = "🏠"
})

local SettingsTab = BdevUI:CreateTab(Window, {
    Name = "Settings",
    Icon = "⚙️"
})

local InfoTab = BdevUI:CreateTab(Window, {
    Name = "Info",
    Icon = "ℹ️"
})

-- Main Tab Elements
BdevUI:CreateLabel(MainTab, {
    Name = "Welcome to Bdev UI!"
})

BdevUI:CreateButton(MainTab, {
    Name = "Click Me!",
    Callback = function()
        print("Button clicked!")
        BdevUI:MakeNotification({
            Name = "Success!",
            Content = "Button was clicked successfully!",
            Time = 3
        })
    end
})

local toggleState = BdevUI:CreateToggle(MainTab, {
    Name = "Enable Feature",
    Default = false,
    Flag = "FeatureEnabled",
    Callback = function(value)
        print("Toggle changed to:", value)
    end
})

BdevUI:CreateSlider(MainTab, {
    Name = "Volume",
    Min = 0,
    Max = 100,
    Default = 50,
    Flag = "VolumeLevel",
    Callback = function(value)
        print("Volume set to:", value)
    end
})

BdevUI:CreateTextbox(MainTab, {
    Name = "Username",
    Placeholder = "Enter your username...",
    Default = "",
    Flag = "Username",
    Callback = function(text, enterPressed)
        print("Username set to:", text)
        if enterPressed then
            BdevUI:MakeNotification({
                Name = "Username Updated",
                Content = "Your username has been set to: " .. text,
                Time = 4
            })
        end
    end
})

BdevUI:CreateDropdown(MainTab, {
    Name = "Game Mode",
    Options = {"Classic", "Hard", "Insane", "Custom"},
    Default = "Classic",
    Flag = "GameMode",
    Callback = function(selected)
        print("Selected game mode:", selected)
    end
})

-- Settings Tab Elements
BdevUI:CreateLabel(SettingsTab, {
    Name = "UI Settings"
})

BdevUI:CreateToggle(SettingsTab, {
    Name = "Show Notifications",
    Default = true,
    Flag = "ShowNotifications",
    Callback = function(value)
        print("Notifications:", value and "enabled" or "disabled")
    end
})

BdevUI:CreateToggle(SettingsTab, {
    Name = "Auto Save",
    Default = true,
    Flag = "AutoSave",
    Callback = function(value)
        print("Auto save:", value and "enabled" or "disabled")
    end
})

BdevUI:CreateSlider(SettingsTab, {
    Name = "UI Scale",
    Min = 50,
    Max = 200,
    Default = 100,
    Flag = "UIScale",
    Callback = function(value)
        print("UI Scale set to:", value .. "%")
    end
})

BdevUI:CreateDropdown(SettingsTab, {
    Name = "Theme",
    Options = {"Dark", "Light", "Blue", "Red"},
    Default = "Dark",
    Flag = "Theme",
    Callback = function(selected)
        print("Theme changed to:", selected)
    end
})

-- Info Tab Elements
BdevUI:CreateLabel(InfoTab, {
    Name = "Library Information"
})

BdevUI:CreateLabel(InfoTab, {
    Name = "Version: " .. BdevUI.Version
})

BdevUI:CreateLabel(InfoTab, {
    Name = "Author: " .. BdevUI.Author
})

BdevUI:CreateLabel(InfoTab, {
    Name = "Theme: Black, White, Gray"
})

BdevUI:CreateButton(InfoTab, {
    Name = "Show Notification Demo",
    Callback = function()
        BdevUI:MakeNotification({
            Name = "Demo Notification",
            Content = "This is a demonstration of the notification system in Bdev UI!",
            Time = 5
        })
    end
})

BdevUI:CreateButton(InfoTab, {
    Name = "Print All Flags",
    Callback = function()
        print("--- Current Flag Values ---")
        for flag, value in pairs(BdevUI.Flags) do
            print(flag .. ":", value)
        end
        print("---------------------------")
    end
})

-- Demo notification on startup
task.delay(2, function()
    BdevUI:MakeNotification({
        Name = "Welcome!",
        Content = "Bdev UI Library loaded successfully!",
        Time = 4
    })
end)

print("Bdev UI Example loaded successfully!")
print("Created window with", #Window.Tabs, "tabs")
print("Available flags:", table.concat(table.keys(BdevUI.Flags), ", "))