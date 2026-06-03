# Orion Library - NexIntegrated Fork

A versatile and feature-rich UI library for Roblox designed to simplify the creation of custom interfaces. This is a forked and improved version of the original Orion Library, enhanced with NexIntegration features and additional UI elements.

## Features

- **Easy-to-use API** - Intuitive methods for creating UI elements
- **Pre-built UI Elements** - Ready-to-use components including buttons, toggles, sliders, dropdowns, and more
- **Theme System** - Built-in theming with customizable colors
- **Configuration Management** - Automatic config saving and loading
- **Vector Input Support** - Native Vector2 and Vector3 input elements
- **Key Binding System** - Flexible key binding with hold support
- **Notifications** - Elegant notification system
- **Draggable Windows** - Fully functional draggable UI windows
- **Premium Tab Support** - Optional premium feature access with key authentication
- **Plugin System** - Load external plugins from trusted sources

## Installation

```lua
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/FORGOTTENJAKEY/Orion-Fork/main/versions/v1.0/main.lua"))()
```

## Quick Start

### Basic Setup

```lua
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/FORGOTTENJAKEY/Orion-Fork/main/versions/v1.0/main.lua"))()

local Window = OrionLib:MakeWindow({
    Name = "My Script",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "MyScript",
    IntroEnabled = true,
    IntroText = "Loading...",
    ShowIcon = true,
    Icon = "rbxassetid://8834748103"
})

-- Initialize the library
OrionLib:Init()
```

### Creating Tabs

```lua
local Tab = Window:MakeTab({
    Name = "Main",
    Icon = "home",
    PremiumOnly = false
})
```

## Window Configuration

When creating a window with `OrionLib:MakeWindow()`, you can pass the following configuration:

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `Name` | string | "Orion Library" | The name of the window |
| `ConfigFolder` | string | Window Name | Folder to store config files |
| `SaveConfig` | boolean | false | Enable automatic config saving |
| `HidePremium` | boolean | false | Hide premium text display |
| `PremiumText` | string | "Premium" | Custom premium text |
| `IntroEnabled` | boolean | true | Show intro animation |
| `IntroText` | string | "Orion Library" | Intro animation text |
| `IntroIcon` | string | Default icon | Icon for intro screen |
| `ShowIcon` | boolean | false | Display window icon |
| `Icon` | string | Default icon | Window header icon |
| `IconPosition` | UDim2 | nil | Custom icon position |
| `IconSize` | UDim2 | nil | Custom icon size |
| `CloseCallback` | function | function() end | Callback when window closes |
| `PremiumKey` | string | nil | Static premium key (optional) |

## Tab Configuration

When creating a tab with `MakeTab()`, you can use:

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `Name` | string | "Tab" | Tab name |
| `Icon` | string | "" | Tab icon (supports Feather icons) |
| `PremiumOnly` | boolean | false | Lock tab to premium users |
| `Index` | number | nil | Tab order in sidebar |
| `PremiumInfo` | table | {} | Custom premium unlock message |
| `OnUnlock` | function | nil | Callback when premium unlocked |

## UI Elements

### Labels

```lua
local Label = Tab:AddLabel("This is a label")
Label:Set("Updated label text")
```

### Paragraphs

```lua
local Para = Tab:AddParagraph("Title", "This is paragraph content")
Para:Set("Updated paragraph content")
```

### Buttons

```lua
local Button = Tab:AddButton({
    Name = "Click Me",
    Icon = "rbxassetid://3944703587",
    Callback = function()
        print("Button clicked!")
    end
})

Button:Set("New Button Text")
```

### Toggles

```lua
local Toggle = Tab:AddToggle({
    Name = "Feature Toggle",
    Default = false,
    Flag = "FeatureToggle",
    Save = true,
    Color = Color3.fromRGB(9, 99, 195),
    Callback = function(Value)
        print("Toggle state:", Value)
    end
})

Toggle:Set(true)
```

### Sliders

```lua
local Slider = Tab:AddSlider({
    Name = "Speed",
    Min = 0,
    Max = 100,
    Increment = 1,
    Default = 50,
    ValueName = "mph",
    Flag = "SpeedSlider",
    Save = true,
    Color = Color3.fromRGB(9, 149, 98),
    Callback = function(Value)
        print("Slider value:", Value)
    end
})

Slider:Set(75)
```

### Dropdowns

```lua
local Dropdown = Tab:AddDropdown({
    Name = "Choose Option",
    Options = {"Option 1", "Option 2", "Option 3"},
    Default = "Option 1",
    Flag = "MyDropdown",
    Save = true,
    Callback = function(Value)
        print("Selected:", Value)
    end
})

-- Update dropdown options dynamically
Dropdown:Refresh({"New Option 1", "New Option 2"}, true)
Dropdown:Set("New Option 1")
```

### Text Boxes

```lua
local TextBox = Tab:AddTextbox({
    Name = "Input Name",
    Default = "Default value",
    TextDisappear = false,
    OnTextChanged = function(Text)
        print("Text changed:", Text)
    end,
    Callback = function(Text)
        print("Input submitted:", Text)
    end
})

TextBox:Set("New value")
TextBox:Get() -- Returns current text
```

### Key Binds

```lua
local Bind = Tab:AddBind({
    Name = "Toggle Script",
    Default = Enum.KeyCode.F,
    Hold = false,
    Flag = "ToggleBind",
    Save = true,
    Callback = function(Holding)
        print("Key pressed!", Holding)
    end
})

Bind:Set(Enum.KeyCode.G)
```

### Color Pickers

```lua
local Colorpicker = Tab:AddColorpicker({
    Name = "Color",
    Default = Color3.fromRGB(255, 0, 0),
    Flag = "MyColor",
    Save = true,
    Callback = function(Color)
        print("Color picked:", Color)
    end
})

Colorpicker:Set(Color3.fromRGB(0, 255, 0))
```

### Vector Inputs

#### Vector3 Input

```lua
local Vec3Input = Tab:AddVector3Input({
    Name = "Position",
    Default = Vector3.new(0, 0, 0),
    Callback = function(Vector)
        print("Vector3:", Vector)
    end
})

Vec3Input:Set(Vector3.new(10, 20, 30))
Vec3Input:Get() -- Returns current Vector3
```

#### Vector2 Input

```lua
local Vec2Input = Tab:AddVector2Input({
    Name = "Size",
    Default = Vector2.new(100, 100),
    Callback = function(Vector)
        print("Vector2:", Vector)
    end
})

Vec2Input:Set(Vector2.new(50, 75))
Vec2Input:Get() -- Returns current Vector2
```

### Sections

Sections allow you to organize elements into collapsible groups:

```lua
local Section = Tab:AddSection("General Settings")

Section:AddLabel("Settings in this section")
Section:AddToggle({
    Name = "Option 1",
    Callback = function(Value)
        print("Section toggle:", Value)
    end
})
```

## Notifications

Display notifications to users:

```lua
OrionLib:MakeNotification({
    Name = "Success",
    Content = "Operation completed successfully!",
    Image = "check-circle",
    Time = 5
})
```

### Notification Configuration

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `Name` | string | "Notification" | Title text |
| `Content` | string | "Test" | Body text |
| `Image` | string | Default icon | Icon/image asset |
| `Time` | number | 15 | Duration in seconds |

## Flags and Configuration

### Using Flags

Flags allow you to access element values from anywhere in your script:

```lua
local Toggle = Tab:AddToggle({
    Name = "Feature",
    Flag = "MyFeature",
    Save = true
})

-- Later in your code:
local isEnabled = OrionLib.Flags["MyFeature"].Value
```

### Auto-Save Configuration

Enable auto-saving to persist user settings:

```lua
local Window = OrionLib:MakeWindow({
    Name = "My Script",
    SaveConfig = true,
    ConfigFolder = "MyScript"
})
```

Configuration files are saved to `ConfigFolder/[GameId].txt`

## Premium Features

### Static Premium Key

```lua
local Window = OrionLib:MakeWindow({
    Name = "My Script",
    PremiumKey = "MySecretKey123"
})

local PremiumTab = Window:MakeTab({
    Name = "Premium",
    PremiumOnly = true,
    PremiumInfo = {
        NoticeText = "Premium Feature",
        NoticeIcon = "lock",
        Icon = "rbxassetid://...",
        Info = "Exclusive Premium Content",
        Description = "This feature requires a valid premium key."
    }
})
```

### Remote Premium Authentication

The library supports remote key validation via a configured server:

```lua
local PremiumTab = Window:MakeTab({
    Name = "Premium",
    PremiumOnly = true,
    OnUnlock = function(Tab)
        -- Called when premium is unlocked
        Tab:AddLabel("Welcome to Premium!")
    end
})
```

## Theming

### Default Theme Colors

The library includes a default theme with the following colors:

```lua
OrionLib.Themes.Default = {
    Main = Color3.fromRGB(25, 25, 25),
    Second = Color3.fromRGB(32, 32, 32),
    Stroke = Color3.fromRGB(60, 60, 60),
    Divider = Color3.fromRGB(60, 60, 60),
    Text = Color3.fromRGB(240, 240, 240),
    TextDark = Color3.fromRGB(150, 150, 150)
}
```

## Plugin System

Load external plugins from trusted sources:

```lua
local Plugin = OrionLib:LoadPlugin("https://raw.githubusercontent.com/username/repo/main/plugin.lua")

if Plugin then
    Plugin:Init(OrionLib)
end
```

Trusted publishers can be configured in the misc data file. Untrusted plugins will trigger a warning notification.

## API Reference

### Window Methods

| Method | Description |
|--------|-------------|
| `MakeTab(config)` | Create a new tab |
| `MakeNotification(config)` | Show a notification |
| `Init()` | Initialize and load saved config |
| `Destroy()` | Destroy the window and cleanup |

### Tab Methods

| Method | Description |
|--------|-------------|
| `AddLabel(text)` | Add a label |
| `AddParagraph(title, content)` | Add a paragraph |
| `AddButton(config)` | Add a button |
| `AddToggle(config)` | Add a toggle |
| `AddSlider(config)` | Add a slider |
| `AddDropdown(config)` | Add a dropdown |
| `AddTextbox(config)` | Add a text box |
| `AddBind(config)` | Add a key bind |
| `AddColorpicker(config)` | Add a color picker |
| `AddVector3Input(config)` | Add a Vector3 input |
| `AddVector2Input(config)` | Add a Vector2 input |
| `AddSection(config)` | Add a section |

### Element Properties

Most elements support:
- `Value` - The current value
- `Save` - Whether to save this element
- `Flag` - String identifier for accessing via `OrionLib.Flags`
- `Callback` - Function called when value changes

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `RightShift` | Toggle UI visibility (when hidden) |

## Icon Support

The library supports Feather icons by 7kayoh. Reference icons by name:

```lua
Tab:AddButton({
    Name = "Copy",
    Icon = "copy",  -- Feather icon name
    Callback = function() end
})
```

If an icon name is not found, the raw image asset ID is used as fallback.

## Advanced Examples

### Complete Script Example

```lua
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/FORGOTTENJAKEY/Orion-Fork/main/versions/v1.0/main.lua"))()

local Window = OrionLib:MakeWindow({
    Name = "My Awesome Script",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "MyScript",
    IntroEnabled = true
})

local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "home"
})

local speedSlider = MainTab:AddSlider({
    Name = "Move Speed",
    Min = 0,
    Max = 100,
    Default = 50,
    ValueName = "units/s",
    Flag = "MoveSpeed",
    Save = true,
    Callback = function(Value)
        -- Apply speed change
    end
})

local enableFeature = MainTab:AddToggle({
    Name = "Enable Feature",
    Default = true,
    Flag = "FeatureEnabled",
    Save = true,
    Callback = function(Value)
        if Value then
            print("Feature enabled!")
        end
    end
})

MainTab:AddButton({
    Name = "Save Settings",
    Icon = "save",
    Callback = function()
        OrionLib:MakeNotification({
            Name = "Success",
            Content = "Settings saved!",
            Time = 3
        })
    end
})

OrionLib:Init()

-- Use flags to access values
game:GetService("RunService").RenderStepped:Connect(function()
    local speed = OrionLib.Flags["MoveSpeed"].Value
    local enabled = OrionLib.Flags["FeatureEnabled"].Value
    
    if enabled then
        -- Use speed value
    end
end)
```

## Troubleshooting

### Config Not Saving
- Ensure `SaveConfig` is set to `true`
- Check that `ConfigFolder` exists or can be created
- Verify you're calling `OrionLib:Init()`

### Icons Not Showing
- Make sure Feather icons can be fetched from GitHub
- Check your internet connection
- Provide fallback image asset IDs

### Premium Tab Not Appearing
- Verify `PremiumOnly` is set to `true`
- Check that a valid key is provided or remote service is available
- Ensure `PremiumInfo` table is properly configured

## Performance Tips

1. Use flags to cache frequently accessed values
2. Minimize callback function complexity
3. Use `:Set()` sparingly - only when value actually changes
4. Clean up connections when destroying UI

## Credits

- **Forker**: [FORGOTTENJAKEY](https://github.com/FORGOTTENJAKEY)
- **Original UI Framework**: Orion Library
- **Icons**: Feather Icons by 7kayoh
- **Enhanced With**: NexIntegration features

## License

This is a forked and improved version of the original Orion Library. Please refer to the original repository for license information.

## Support

For issues, feature requests, or questions:
- Visit the Discord server: [sirius.menu/discord](https://discord.gg/sirius)
- Check the GitHub repository: [FORGOTTENJAKEY/Orion-Fork](https://github.com/FORGOTTENJAKEY/Orion-Fork)
