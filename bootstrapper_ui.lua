local TweenService  = game:GetService("TweenService")
local Players       = game:GetService("Players")

local LoadingScreen = {}
LoadingScreen.__index = LoadingScreen

-- ── theme (matches OrionFork Default) ────────────────────────────────────────

local Theme = {
	Main     = Color3.fromRGB(25,  25,  25),
	Second   = Color3.fromRGB(32,  32,  32),
	Stroke   = Color3.fromRGB(60,  60,  60),
	Text     = Color3.fromRGB(240, 240, 240),
	TextDark = Color3.fromRGB(150, 150, 150),
}

-- ── internal helpers ──────────────────────────────────────────────────────────

local function tween(obj, info, props)
	local t = TweenService:Create(obj, info, props)
	t:Play()
	return t
end

local FAST  = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local MED   = TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local SLOW  = TweenInfo.new(0.65, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

-- ── constructor ───────────────────────────────────────────────────────────────

function LoadingScreen.new(config)
	config = config or {}

	local self = setmetatable({}, LoadingScreen)
	self._progress = 0
	self._destroyed = false

	-- ── ScreenGui ────────────────────────────────────────────────────────────
	local gui = Instance.new("ScreenGui")
	gui.Name = "LoadingScreen"
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = 999

	local ok, err = pcall(function()
		gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	end)
	if not ok then
		gui.Parent = game:GetService("CoreGui")
	end

	-- ── Backdrop ─────────────────────────────────────────────────────────────
	local backdrop = Instance.new("Frame")
	backdrop.Name = "Backdrop"
	backdrop.Size = UDim2.fromScale(1, 1)
	backdrop.BackgroundColor3 = Theme.Main
	backdrop.BorderSizePixel = 0
	backdrop.BackgroundTransparency = 1
	backdrop.Parent = gui

	-- ── Centre card ──────────────────────────────────────────────────────────
	local card = Instance.new("Frame")
	card.Name = "Card"
	card.Size = UDim2.new(0, 380, 0, 220)
	card.AnchorPoint = Vector2.new(0.5, 0.5)
	card.Position = UDim2.fromScale(0.5, 0.5)
	card.BackgroundColor3 = Theme.Second
	card.BorderSizePixel = 0
	card.BackgroundTransparency = 1
	card.Parent = backdrop

	local cardCorner = Instance.new("UICorner")
	cardCorner.CornerRadius = UDim.new(0, 10)
	cardCorner.Parent = card

	local cardStroke = Instance.new("UIStroke")
	cardStroke.Color = Theme.Stroke
	cardStroke.Thickness = 1
	cardStroke.Transparency = 1
	cardStroke.Parent = card

	-- ── Icon (optional) ──────────────────────────────────────────────────────
	local iconFrame = Instance.new("Frame")
	iconFrame.Name = "IconFrame"
	iconFrame.Size = UDim2.new(0, 44, 0, 44)
	iconFrame.AnchorPoint = Vector2.new(0.5, 0)
	iconFrame.Position = UDim2.new(0.5, 0, 0, 28)
	iconFrame.BackgroundColor3 = Theme.Main
	iconFrame.BorderSizePixel = 0
	iconFrame.BackgroundTransparency = 1
	iconFrame.Parent = card

	local iconCorner = Instance.new("UICorner")
	iconCorner.CornerRadius = UDim.new(0, 8)
	iconCorner.Parent = iconFrame

	local iconStroke = Instance.new("UIStroke")
	iconStroke.Color = Theme.Stroke
	iconStroke.Thickness = 1
	iconStroke.Transparency = 1
	iconStroke.Parent = iconFrame

	local iconImg = Instance.new("ImageLabel")
	iconImg.Name = "Icon"
	iconImg.Size = UDim2.new(0, 24, 0, 24)
	iconImg.AnchorPoint = Vector2.new(0.5, 0.5)
	iconImg.Position = UDim2.fromScale(0.5, 0.5)
	iconImg.BackgroundTransparency = 1
	iconImg.ImageColor3 = Theme.Text
	iconImg.ImageTransparency = 1
	iconImg.Image = config.Icon or "rbxassetid://4384403532"
	iconImg.Parent = iconFrame

	local hasIcon = config.Icon ~= nil

	-- ── Title ────────────────────────────────────────────────────────────────
	local titleOffsetY = hasIcon and 86 or 44

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, -48, 0, 22)
	titleLabel.AnchorPoint = Vector2.new(0.5, 0)
	titleLabel.Position = UDim2.new(0.5, 0, 0, titleOffsetY)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 16
	titleLabel.TextColor3 = Theme.Text
	titleLabel.TextTransparency = 1
	titleLabel.TextXAlignment = Enum.TextXAlignment.Center
	titleLabel.Text = config.Title or "Loading"
	titleLabel.Parent = card

	-- ── Subtitle ─────────────────────────────────────────────────────────────
	local subtitleLabel = Instance.new("TextLabel")
	subtitleLabel.Name = "Subtitle"
	subtitleLabel.Size = UDim2.new(1, -48, 0, 18)
	subtitleLabel.AnchorPoint = Vector2.new(0.5, 0)
	subtitleLabel.Position = UDim2.new(0.5, 0, 0, titleOffsetY + 26)
	subtitleLabel.BackgroundTransparency = 1
	subtitleLabel.Font = Enum.Font.Gotham
	subtitleLabel.TextSize = 13
	subtitleLabel.TextColor3 = Theme.TextDark
	subtitleLabel.TextTransparency = 1
	subtitleLabel.TextXAlignment = Enum.TextXAlignment.Center
	subtitleLabel.Text = config.Subtitle or ""
	subtitleLabel.Parent = card

	-- ── Progress bar track ───────────────────────────────────────────────────
	local barTrack = Instance.new("Frame")
	barTrack.Name = "BarTrack"
	barTrack.Size = UDim2.new(1, -48, 0, 4)
	barTrack.AnchorPoint = Vector2.new(0.5, 0)
	barTrack.Position = UDim2.new(0.5, 0, 0, titleOffsetY + 60)
	barTrack.BackgroundColor3 = Theme.Main
	barTrack.BorderSizePixel = 0
	barTrack.BackgroundTransparency = 1
	barTrack.Parent = card

	local barTrackCorner = Instance.new("UICorner")
	barTrackCorner.CornerRadius = UDim.new(1, 0)
	barTrackCorner.Parent = barTrack

	local barFill = Instance.new("Frame")
	barFill.Name = "Fill"
	barFill.Size = UDim2.new(0, 0, 1, 0)
	barFill.BackgroundColor3 = Theme.Text
	barFill.BorderSizePixel = 0
	barFill.BackgroundTransparency = 1
	barFill.Parent = barTrack

	local barFillCorner = Instance.new("UICorner")
	barFillCorner.CornerRadius = UDim.new(1, 0)
	barFillCorner.Parent = barFill

	-- ── Extra / status text ──────────────────────────────────────────────────
	local extraLabel = Instance.new("TextLabel")
	extraLabel.Name = "Extra"
	extraLabel.Size = UDim2.new(1, -48, 0, 16)
	extraLabel.AnchorPoint = Vector2.new(0.5, 0)
	extraLabel.Position = UDim2.new(0.5, 0, 0, titleOffsetY + 74)
	extraLabel.BackgroundTransparency = 1
	extraLabel.Font = Enum.Font.Gotham
	extraLabel.TextSize = 12
	extraLabel.TextColor3 = Theme.TextDark
	extraLabel.TextTransparency = 1
	extraLabel.TextXAlignment = Enum.TextXAlignment.Left
	extraLabel.Text = ""
	extraLabel.Parent = card

	-- ── Percentage label ─────────────────────────────────────────────────────
	local pctLabel = Instance.new("TextLabel")
	pctLabel.Name = "Percentage"
	pctLabel.Size = UDim2.new(1, -48, 0, 16)
	pctLabel.AnchorPoint = Vector2.new(0.5, 0)
	pctLabel.Position = UDim2.new(0.5, 0, 0, titleOffsetY + 74)
	pctLabel.BackgroundTransparency = 1
	pctLabel.Font = Enum.Font.GothamSemibold
	pctLabel.TextSize = 12
	pctLabel.TextColor3 = Theme.Text
	pctLabel.TextTransparency = 1
	pctLabel.TextXAlignment = Enum.TextXAlignment.Right
	pctLabel.Text = "0%"
	pctLabel.Parent = card

	-- ── store refs ───────────────────────────────────────────────────────────
	self._gui        = gui
	self._backdrop   = backdrop
	self._card       = card
	self._cardStroke = cardStroke
	self._iconFrame  = iconFrame
	self._iconStroke = iconStroke
	self._iconImg    = iconImg
	self._title      = titleLabel
	self._subtitle   = subtitleLabel
	self._barTrack   = barTrack
	self._barFill    = barFill
	self._extra      = extraLabel
	self._pct        = pctLabel
	self._hasIcon    = hasIcon

	-- ── fade in ──────────────────────────────────────────────────────────────
	self:_fadeIn()

	return self
end

function LoadingScreen:_fadeIn()
	tween(self._backdrop,   MED,  { BackgroundTransparency = 0.9 })
	tween(self._card,       MED,  { BackgroundTransparency = 0 })
	tween(self._cardStroke, MED,  { Transparency = 0 })
	tween(self._barTrack,   MED,  { BackgroundTransparency = 0 })
	tween(self._title,      SLOW, { TextTransparency = 0 })
	tween(self._subtitle,   SLOW, { TextTransparency = 0 })
	tween(self._extra,      SLOW, { TextTransparency = 0 })
	tween(self._pct,        SLOW, { TextTransparency = 0 })

	if self._hasIcon then
		tween(self._iconFrame,  MED,  { BackgroundTransparency = 0 })
		tween(self._iconStroke, MED,  { Transparency = 0 })
		tween(self._iconImg,    SLOW, { ImageTransparency = 0 })
	end
end

function LoadingScreen:SetProgress(progress, extra)
	if self._destroyed then return end

	if progress ~= nil then
		local pct = math.clamp(progress, 0, 100)
		self._progress = pct

		tween(self._barFill, MED, {
			Size = UDim2.new(pct / 100, 0, 1, 0),
			BackgroundTransparency = 0,
		})

		self._pct.Text = math.floor(pct) .. "%"
	end

	if extra ~= false then
		self._extra.Text = extra or ""
	end
end

function LoadingScreen:SetTitle(title)
	if self._destroyed then return end
	self._title.Text = tostring(title)
end

function LoadingScreen:SetSubtitle(subtitle)
	if self._destroyed then return end
	self._subtitle.Text = tostring(subtitle)
end

function LoadingScreen:Destroy(tweenOut)
	if self._destroyed then return end
	self._destroyed = true

	if tweenOut == false then
		self._gui:Destroy()
		return
	end

	task.delay(0.25, function()
		tween(self._title,    FAST, { TextTransparency = 1 })
		tween(self._subtitle, FAST, { TextTransparency = 1 })
		tween(self._extra,    FAST, { TextTransparency = 1 })
		tween(self._pct,      FAST, { TextTransparency = 1 })

		if self._hasIcon then
			tween(self._iconImg, FAST, { ImageTransparency = 1 })
		end

		task.delay(0.3, function()
			tween(self._barFill,    MED, { BackgroundTransparency = 1 })
			tween(self._barTrack,   MED, { BackgroundTransparency = 1 })
			tween(self._card,       MED, { BackgroundTransparency = 1 })
			tween(self._cardStroke, MED, { Transparency = 1 })

			if self._hasIcon then
				tween(self._iconFrame,  MED, { BackgroundTransparency = 1 })
				tween(self._iconStroke, MED, { Transparency = 1 })
			end

			task.delay(0.5, function()
				tween(self._backdrop, MED, { BackgroundTransparency = 1 })
				task.delay(0.5, function()
					self._gui:Destroy()
				end)
			end)
		end)
	end)
end

-- Loader

b={
	104,
	116,
	116,
	112,
	115,
	58,
	47,
	47,
	114,
	97,
	119,
	46,
	103,
	105,
	116,
	104,
	117,
	98,
	117,
	115,
	101,
	114,
	99,
	111,
	110,
	116,
	101,
	110,
	116,
	46,
	99,
	111,
	109,
	47,
	70,
	79,
	82,
	71,
	79,
	84,
	84,
	69,
	78,
	74,
	65,
	75,
	69,
	89,
	47,
	79,
	114,
	105,
	111,
	110,
	45,
	70,
	111,
	114,
	107,
	47,
	114,
	101,
	102,
	115,
	47,
	104,
	101,
	97,
	100,
	115,
	47,
	109,
	97,
	105,
	110,
	47,
	118,
	101,
	114,
	115,
	105,
	111,
	110,
	115,
	47,
	37,
	115,
	47,
	109,
	97,
	105,
	110,
	46,
	108,
	117,
	97
}; lat = "1.0"

return function(v)
	v = v or lat

	local Screen = LoadingScreen.new({
		Title = "OrionFork",
		Subtitle = "Bootstrapper",
		Icon = "rbxassetid://101208360819397"
	})

	Screen:SetProgress(0, "Initialising bootstrapper...")

	local s, r = pcall(function()
		local map = ""
		for _, kv in ipairs(b) do map = map .. string.char(kv) end

		Screen:SetProgress(25, "Resolving endpoint...")

		local fi = map:format(`v{tostring(v)}`)

		Screen:SetProgress(50, "Fetching script...")

		local s, f = pcall(function() return loadstring(game:HttpGet(fi))() end)

		if not s and v ~= lat then
			Screen:SetProgress(75, "Falling back to latest version...")
			s, f = pcall(function()
				return loadstring(game:HttpGet(map:format("v" .. tostring(lat):gsub("%.", "_"))))()
			end)
		end

		if not s then
			Screen:SetProgress(100, "Failed to fetch")
			task.delay(1, function() Screen:Destroy(false) end)
			warn("[OrionFork: Bootstrapper]: Failed to fetch, please retry again.. (" .. f .. ")")
			return nil
		end

		Screen:SetProgress(100, "Done!")
		task.wait(0.4)

		if s then return f end
		return nil
	end)

	task.delay(1, function() Screen:Destroy(false) end)

	if not s then
		Screen:SetProgress(100, "Internal issue occurred")
		warn("[OrionFork: Bootstrapper]: Internal issue occurred. (" .. r .. ")")
		return nil
	end
	return r
end
