--[[
    OrionFork Theme System
    Drop-in extension for OrionLib (FORGOTTENJAKEY/Orion-Fork)
]]

local OrionThemes = {}
OrionThemes.__index = OrionThemes

-- ─────────────────────────────────────────────
--  Built-in Preset Themes
-- ─────────────────────────────────────────────

local Presets = {

	-- Original OrionFork default (dark grey)
	Default = {
		Main     = Color3.fromRGB(25,  25,  25),
		Second   = Color3.fromRGB(32,  32,  32),
		Stroke   = Color3.fromRGB(60,  60,  60),
		Divider  = Color3.fromRGB(60,  60,  60),
		Text     = Color3.fromRGB(240, 240, 240),
		TextDark = Color3.fromRGB(150, 150, 150),
	},

	-- Deep navy / cold-blue
	Midnight = {
		Main     = Color3.fromRGB(13,  17,  38),
		Second   = Color3.fromRGB(20,  26,  54),
		Stroke   = Color3.fromRGB(45,  55,  100),
		Divider  = Color3.fromRGB(40,  50,  90),
		Text     = Color3.fromRGB(220, 225, 255),
		TextDark = Color3.fromRGB(110, 120, 170),
	},

	-- Warm rose / dark crimson
	Crimson = {
		Main     = Color3.fromRGB(28,  10,  14),
		Second   = Color3.fromRGB(40,  15,  20),
		Stroke   = Color3.fromRGB(100, 30,  45),
		Divider  = Color3.fromRGB(90,  25,  38),
		Text     = Color3.fromRGB(255, 220, 225),
		TextDark = Color3.fromRGB(170, 100, 115),
	},

	-- Forest / olive green
	Forest = {
		Main     = Color3.fromRGB(12,  22,  14),
		Second   = Color3.fromRGB(18,  34,  21),
		Stroke   = Color3.fromRGB(40,  80,  45),
		Divider  = Color3.fromRGB(35,  70,  40),
		Text     = Color3.fromRGB(210, 240, 215),
		TextDark = Color3.fromRGB(100, 155, 110),
	},

	-- Soft charcoal with purple accent
	Amethyst = {
		Main     = Color3.fromRGB(22,  18,  35),
		Second   = Color3.fromRGB(32,  26,  50),
		Stroke   = Color3.fromRGB(80,  60,  130),
		Divider  = Color3.fromRGB(70,  52,  115),
		Text     = Color3.fromRGB(235, 225, 255),
		TextDark = Color3.fromRGB(140, 120, 190),
	},

	-- Clean light / white UI
	Light = {
		Main     = Color3.fromRGB(245, 245, 248),
		Second   = Color3.fromRGB(230, 230, 235),
		Stroke   = Color3.fromRGB(190, 190, 200),
		Divider  = Color3.fromRGB(200, 200, 210),
		Text     = Color3.fromRGB(30,  30,  40),
		TextDark = Color3.fromRGB(100, 100, 115),
	},

	-- Warm sepia / tan
	Sepia = {
		Main     = Color3.fromRGB(30,  22,  14),
		Second   = Color3.fromRGB(44,  32,  20),
		Stroke   = Color3.fromRGB(100, 72,  40),
		Divider  = Color3.fromRGB(90,  65,  35),
		Text     = Color3.fromRGB(250, 235, 210),
		TextDark = Color3.fromRGB(170, 140, 100),
	},

	-- Cyberpunk neon-teal on near-black
	Neon = {
		Main     = Color3.fromRGB(8,   10,  18),
		Second   = Color3.fromRGB(12,  16,  28),
		Stroke   = Color3.fromRGB(0,   210, 200),
		Divider  = Color3.fromRGB(0,   170, 160),
		Text     = Color3.fromRGB(200, 255, 252),
		TextDark = Color3.fromRGB(0,   160, 150),
	},

	-- Slate / monochrome blue-grey
	Slate = {
		Main     = Color3.fromRGB(20,  26,  32),
		Second   = Color3.fromRGB(30,  38,  46),
		Stroke   = Color3.fromRGB(65,  80,  95),
		Divider  = Color3.fromRGB(55,  68,  82),
		Text     = Color3.fromRGB(220, 228, 235),
		TextDark = Color3.fromRGB(115, 135, 155),
	},
}

-- ─────────────────────────────────────────────
--  Internal helpers
-- ─────────────────────────────────────────────

local THEME_KEYS = { "Main", "Second", "Stroke", "Divider", "Text", "TextDark" }

local function validateTheme(theme)
	for _, key in ipairs(THEME_KEYS) do
		if typeof(theme[key]) ~= "Color3" then
			error(("OrionThemes: theme is missing key '%s' or it is not a Color3"):format(key), 3)
		end
	end
end

local function getColorProperty(object)
	if object:IsA("Frame") or object:IsA("TextButton") then
		return "BackgroundColor3"
	elseif object:IsA("ScrollingFrame") then
		return "ScrollBarImageColor3"
	elseif object:IsA("UIStroke") then
		return "Color"
	elseif object:IsA("TextLabel") or object:IsA("TextBox") then
		return "TextColor3"
	elseif object:IsA("ImageLabel") or object:IsA("ImageButton") then
		return "ImageColor3"
	end
	return nil
end

-- ─────────────────────────────────────────────
--  Public API
-- ─────────────────────────────────────────────

function OrionThemes:Init(orionLib)
	assert(type(orionLib) == "table", "OrionThemes:Init() expects the OrionLib table")

	self._lib = orionLib

	for name, data in pairs(Presets) do
		orionLib.Themes[name] = data
	end

	orionLib.SetTheme = function(_, themeName)
		self:Apply(themeName)
	end

	return self
end

function OrionThemes:Apply(themeName)
	local lib = self._lib
	assert(lib, "OrionThemes: call :Init(OrionLib) first")

	local theme = lib.Themes[themeName]
	assert(theme, ("OrionThemes: theme '%s' not found. Use :List() to see available themes."):format(tostring(themeName)))

	lib.SelectedTheme = themeName
	
	for typeKey, objects in pairs(lib.ThemeObjects) do
		local colour = theme[typeKey]
		if colour then
			for _, object in ipairs(objects) do
				if object and object.Parent then
					local prop = getColorProperty(object)
					if prop then
						pcall(function()
							object[prop] = colour
						end)
					end
				end
			end
		end
	end
end

function OrionThemes:Register(name, data, apply)
	local lib = self._lib
	assert(lib, "OrionThemes: call :Init(OrionLib) first")
	assert(type(name) == "string" and #name > 0, "OrionThemes:Register() – name must be a non-empty string")
	validateTheme(data)

	lib.Themes[name] = data

	if apply then
		self:Apply(name)
	end
end

function OrionThemes:Unregister(name)
	assert(name ~= "Default", "OrionThemes: cannot unregister the Default theme")
	local lib = self._lib
	assert(lib, "OrionThemes: call :Init(OrionLib) first")

	if lib.Themes[name] then
		lib.Themes[name] = nil
	end
end

function OrionThemes:List()
	local lib = self._lib
	assert(lib, "OrionThemes: call :Init(OrionLib) first")

	local names = {}
	for name in pairs(lib.Themes) do
		table.insert(names, name)
	end
	table.sort(names)
	return names
end

function OrionThemes:Current()
	local lib = self._lib
	assert(lib, "OrionThemes: call :Init(OrionLib) first")
	return lib.SelectedTheme
end

function OrionThemes:Blend(themeA, themeB, alpha)
	local lib = self._lib
	assert(lib, "OrionThemes: call :Init(OrionLib) first")

	local a = lib.Themes[themeA]
	local b = lib.Themes[themeB]
	assert(a, ("OrionThemes:Blend – unknown theme '%s'"):format(tostring(themeA)))
	assert(b, ("OrionThemes:Blend – unknown theme '%s'"):format(tostring(themeB)))

	alpha = math.clamp(alpha, 0, 1)
	local blended = {}
	for _, key in ipairs(THEME_KEYS) do
		blended[key] = a[key]:Lerp(b[key], alpha)
	end
	return blended
end

function OrionThemes:Tween(targetTheme, duration)
	local lib = self._lib
	assert(lib, "OrionThemes: call :Init(OrionLib) first")
	assert(lib.Themes[targetTheme], ("OrionThemes:Tween – unknown theme '%s'"):format(tostring(targetTheme)))

	duration = duration or 0.5
	local fromName = lib.SelectedTheme
	
	local steps = math.max(1, math.floor(duration / (1/60)))
	local stepTime = duration / steps

	task.spawn(function()
		for i = 1, steps do
			local alpha = i / steps
			local blended = self:Blend(fromName, targetTheme, alpha)
			for typeKey, objects in pairs(lib.ThemeObjects) do
				local colour = blended[typeKey]
				if colour then
					for _, object in ipairs(objects) do
						if object and object.Parent then
							local prop = getColorProperty(object)
							if prop then
								pcall(function() object[prop] = colour end)
							end
						end
					end
				end
			end
			task.wait(stepTime)
		end
		lib.SelectedTheme = targetTheme
	end)
end

function OrionThemes:MakeThemeTab(Window, i)
	local lib = self._lib
	assert(lib,    "OrionThemes: call :Init(OrionLib) first")
	assert(Window, "OrionThemes:MakeThemeTab() – Window is nil")

	-- ── internal state ────────────────────────────────────────────────────────
	local tweenSpeed   = 0.4
	local customName   = "MyTheme"
	local customColors = {}

	-- seed pickers from the live theme
	local function syncCustomFromTheme(name)
		local t = lib.Themes[name]
		if not t then return end
		for _, k in ipairs(THEME_KEYS) do
			customColors[k] = t[k]
		end
	end
	syncCustomFromTheme(lib.SelectedTheme)

	-- ── tab ───────────────────────────────────────────────────────────────────
	local Tab = Window:MakeTab({
		Name = "Themes",
		Icon = "layers",
		Index = i or 998
	})

	-- ── SECTION: Preset Themes ────────────────────────────────────────────────
	Tab:AddSection({ Name = "Preset Themes" })

	local function sortedNames()
		local list = {}
		for name in pairs(lib.Themes) do
			table.insert(list, name)
		end
		table.sort(list)
		return list
	end

	Tab:AddDropdown({
		Name    = "Select Theme",
		Default = self:Current(),
		Options = sortedNames(),
		Callback = function(picked)
			if not lib.Themes[picked] then return end
			self:Tween(picked, tweenSpeed)
			syncCustomFromTheme(picked)
		end,
	})

	-- ── SECTION: Transition Speed ─────────────────────────────────────────────
	--Tab:AddSection({ Name = "Transition" })

	--Tab:AddSlider({
	--	Name      = "Tween Speed",
	--	Min       = 1,
	--	Max       = 20,
	--	Default   = 4,   -- 4 → 0.4 s
	--	Color     = Color3.fromRGB(255, 255, 255),
	--	Increment = 1,
	--	ValueName = "× 0.1 s",
	--	Callback  = function(val)
	--		tweenSpeed = val / 10
	--	end,
	--})

	-- ── SECTION: Custom Theme Builder ─────────────────────────────────────────
	Tab:AddSection({ Name = "Custom Theme Builder" })

	for _, key in ipairs(THEME_KEYS) do
		local k = key
		Tab:AddColorpicker({
			Name     = k,
			Default  = customColors[k],
			Flag     = "__OrionThemes_Custom_" .. k,
			Callback = function(color)
				customColors[k] = color
			end,
		})
	end

	Tab:AddTextbox({
		Name          = "Theme Name",
		Default       = customName,
		TextDisappear = false,
		Callback      = function(text)
			local trimmed = text and text:match("^%s*(.-)%s*$") or ""
			if #trimmed > 0 then customName = trimmed end
		end,
	})

	Tab:AddButton({
		Name = "Apply Custom Theme",
		Callback = function()
			-- validate
			for _, k in ipairs(THEME_KEYS) do
				if typeof(customColors[k]) ~= "Color3" then
					lib:MakeNotification({
						Name    = "Theme Error",
						Content = "All six colour fields must be set before applying.",
						Image   = "alert-circle",
						Time    = 4,
					})
					return
				end
			end

			-- deep-copy so future picker changes don't mutate the saved theme
			local snapshot = {}
			for _, k in ipairs(THEME_KEYS) do
				snapshot[k] = customColors[k]
			end

			lib.Themes[customName] = snapshot
			self:Tween(customName, tweenSpeed)

			lib:MakeNotification({
				Name    = "Custom Theme Applied",
				Content = '"' .. customName .. '" is now active.',
				Image   = "check-circle",
				Time    = 2,
			})
		end,
	})

	-- ── SECTION: Utilities ────────────────────────────────────────────────────
	Tab:AddSection({ Name = "Utilities" })

	Tab:AddButton({
		Name = "Reset to Default",
		Callback = function()
			self:Tween("Default", tweenSpeed)
			syncCustomFromTheme("Default")
			lib:MakeNotification({
				Name    = "Theme Reset",
				Content = "Reverted to the Default theme.",
				Image   = "rotate-ccw",
				Time    = 2,
			})
		end,
	})

	Tab:AddButton({
		Name = "Copy Active Theme Code",
		Callback = function()
			local curName  = self:Current()
			local curTheme = lib.Themes[curName]
			if not curTheme then return end

			local lines = { ('OrionThemes:Register("%s", {'):format(curName) }
			for _, k in ipairs(THEME_KEYS) do
				local c = curTheme[k]
				lines[#lines + 1] = ('    %s = Color3.fromRGB(%d, %d, %d),'):format(
					k,
					math.round(c.R * 255),
					math.round(c.G * 255),
					math.round(c.B * 255)
				)
			end
			lines[#lines + 1] = "})"
			local code = table.concat(lines, "\n")

			if setclipboard then setclipboard(code)
			elseif toclipboard then toclipboard(code)
			elseif syn and syn.write_clipboard then syn.write_clipboard(code) end
			
			lib:MakeNotification({
				Name    = "Copied!",
				Content = 'Theme code for "' .. curName .. '" is in your clipboard.',
				Image   = "clipboard",
				Time    = 3,
			})
		end,
	})

	return Tab
end

return OrionThemes
