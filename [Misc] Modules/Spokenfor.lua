-- UhhhhhhReanim/Modules/SpokenForDance.lua

local modules = {}

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "Spoken For"
	m.Description = "Jamie p and teto never misses"
	m.Assets      = {"Spokenfor.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Spoken%20For/Spokenfor.anim", "Spokenfor.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Spoken%20For/Spokenfor.mp3", "Spokenfor.rbxm@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Spoken%20For/Spokenfor.rbxm"}

	m.Effects = true
	m.Config = function(parent)
		Util_CreateSwitch(parent, "Effects", m.Effects).Changed:Connect(function(val)
			m.Effects = val
		end)
	end
	m.SaveConfig = function()
		return {
			NoEffects = not m.Effects
		}
	end
	m.LoadConfig = function(save)
		m.Effects = not save.NoEffects
	end

	local animator = nil
	local start    = 0
	local instances = {}
	local HideCF = CFrame.new(0, -9e9, 0)

	local starFlashes = {7.5, 8.3, 9.2, 10.0, 31.8, 32.6, 33.4, 34.3}
	local ExplodeDuration = 0.25
	local FallDuration = 0.4
	local FullRadius = 2.5
	local StarYOffset = 1
	local StarZOffset = -2

	local lyrics = {
		{0,    3.2,  "The daze of blood stains, cruel and gory"},
		{3.2,  7.5,  "Visions of violence are overpowering, yeah"},
		{10.3, 13.7, "Puking my guts out almost hourly"},
		{13.7, 17.2, "Shaving off the numbers of this fucking body"},
		{17.2, 20.6, "I can't read the messages, they come so quickly"},
		{20.6, 24.1, "Please, I'm begging anybody, come and save me"},
		{24.1, 27.7, "I don't get the messages, they don't come to me"},
		{27.7, 31.6, "Everything that I can say is spoken for me, yeah"},
	}

	local starLandedCF = {}

	local function easeOutBack(t)
		local c1 = 1.70158
		local c3 = c1 + 1
		return 1 + c3 * math.pow(t - 1, 3) + c1 * math.pow(t - 1, 2)
	end

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("Spokenfor.mp3"), "Spoken For", 0.8, NumberRange.new(0, 999))

		start        = os.clock()
		animator     = AnimLib.Animator.new()
		animator.rig = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Spokenfor.anim"))
		animator.looped = true
		animator.speed  = 1

		for _, v in instances do v:Destroy() end
		instances = {}
		starLandedCF = {}

		local scale = figure:GetScale()
		local arm = figure:FindFirstChild("Right Arm")

		if arm then
			local micModel = Instance.new("Model")
			micModel.Name = "SpokenForMic"

			local handle = Instance.new("Part")
			handle.Name = "MicHandle"
			handle.Color = Color3.fromRGB(233, 72, 91)
			handle.Material = Enum.Material.SmoothPlastic
			handle.Anchored = false
			handle.CanCollide = false
			handle.CanTouch = false
			handle.CanQuery = false
			handle.Size = Vector3.new(1, 0.5, 0.5) * scale
			handle.Shape = Enum.PartType.Cylinder
			handle.Parent = micModel

			local grip = Instance.new("Weld")
			grip.Name = "MicGrip"
			grip.Part0 = arm
			grip.Part1 = handle
			grip.C0 = CFrame.new(0, -1 * scale, 0, 0, 0, 1, 0, 1, 0, -1, 0, 0)
			grip.Parent = micModel

			local ring = Instance.new("Part")
			ring.Name = "MicRing"
			ring.Color = Color3.fromRGB(255, 255, 255)
			ring.Material = Enum.Material.SmoothPlastic
			ring.Anchored = false
			ring.CanCollide = false
			ring.CanTouch = false
			ring.CanQuery = false
			ring.Size = Vector3.new(0.1, 0.6, 0.6) * scale
			ring.Shape = Enum.PartType.Cylinder
			ring.Parent = micModel

			local ringWeld = Instance.new("Weld")
			ringWeld.Name = "MicRingWeld"
			ringWeld.Part0 = handle
			ringWeld.Part1 = ring
			ringWeld.C0 = CFrame.new(0.55 * scale, 0, 0)
			ringWeld.Parent = micModel

			local ball = Instance.new("Part")
			ball.Name = "MicBall"
			ball.Color = Color3.fromRGB(240, 142, 145)
			ball.Material = Enum.Material.SmoothPlastic
			ball.Anchored = false
			ball.CanCollide = false
			ball.CanTouch = false
			ball.CanQuery = false
			ball.Size = Vector3.new(0.9, 0.9, 0.9) * scale
			ball.Shape = Enum.PartType.Ball
			ball.Parent = micModel

			local ballWeld = Instance.new("Weld")
			ballWeld.Name = "MicBallWeld"
			ballWeld.Part0 = handle
			ballWeld.Part1 = ball
			ballWeld.C0 = CFrame.new(0.875 * scale, 0, 0)
			ballWeld.Parent = micModel

			micModel.Parent = figure
			instances.Mic = micModel
		end

		if m.Effects then
			local panel = Instance.new("Part")
			panel.Transparency = 1
			panel.Anchored = true
			panel.CanCollide = false
			panel.CanTouch = false
			panel.CanQuery = false
			panel.Name = "SpokenForLyrics"
			panel.Size = Vector3.new(7, 0.75, 0) * scale
			local sgui = Instance.new("SurfaceGui")
			sgui.LightInfluence = 0
			sgui.Brightness = 1
			sgui.AlwaysOnTop = false
			sgui.MaxDistance = 1000
			sgui.SizingMode = Enum.SurfaceGuiSizingMode.FixedSize
			sgui.CanvasSize = Vector2.new(450, 40)
			sgui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			sgui.Name = "LyricsUI"
			sgui.Parent = panel
			local lyricLabel = Instance.new("TextLabel")
			lyricLabel.Name = "Line"
			lyricLabel.Position = UDim2.new(0, 0, 0, 0)
			lyricLabel.Size = UDim2.new(1, 0, 1, 0)
			lyricLabel.BackgroundTransparency = 1
			lyricLabel.FontFace = Font.fromName("PatrickHand")
			lyricLabel.TextColor3 = Color3.new(1, 1, 1)
			lyricLabel.TextStrokeTransparency = 1
			lyricLabel.TextXAlignment = Enum.TextXAlignment.Center
			lyricLabel.TextYAlignment = Enum.TextYAlignment.Center
			lyricLabel.TextScaled = true
			lyricLabel.Text = ""
			lyricLabel.Parent = sgui
			local padding = Instance.new("UIPadding")
			padding.PaddingLeft = UDim.new(0, 8)
			padding.PaddingRight = UDim.new(0, 8)
			padding.Parent = lyricLabel
			panel.Parent = figure
			instances.Panel = panel
			instances.LyricLabel = lyricLabel

			local loaded = game:GetObjects(AssetGetContentId("Spokenfor.rbxm"))[1]
			loaded:ScaleTo(scale)
			local starSource = loaded:FindFirstChild("Star", true)
			instances.Stars = {}
			if starSource then
				for i = 1, 5 do
					local s = starSource:Clone()
					s.Anchored = true
					s.CanCollide = false
					s.CanTouch = false
					s.CanQuery = false
					s.Transparency = 1
					s:PivotTo(HideCF)
					s.Parent = workspace
					table.insert(instances.Stars, s)
				end
			end
			loaded:Destroy()
		end
	end

	m.Update = function(dt, figure)
		local t = GetOverrideDanceMusicTime()
		animator:Step(os.clock() - start)

		local root = figure:FindFirstChild("HumanoidRootPart")
		if not root then return end
		local scale = figure:GetScale()

		if instances.Panel then
			instances.Panel.CFrame = root.CFrame * CFrame.new(0, -1.8 * scale, -3 * scale)
		end

		if instances.LyricLabel then
			local currentLine = ""
			for _, lyric in lyrics do
				if t >= lyric[1] and t < lyric[2] then
					currentLine = lyric[3]
					break
				end
			end
			instances.LyricLabel.Text = currentLine
		end

		local activeFlash = nil
		for _, flashT in starFlashes do
			if t >= flashT and t < flashT + 0.5 + FallDuration then
				activeFlash = flashT
				break
			end
		end

		if instances.Stars then
			for i, star in instances.Stars do
				if activeFlash then
					local elapsed = t - activeFlash
					local angle = ((i - 1) / 5) * math.pi * 2 + math.pi / 2

					if elapsed < 0.5 then
						local raw = math.min(elapsed / ExplodeDuration, 1)
						local explodeProgress = easeOutBack(raw)
						local spinAngle = (1 - raw) * math.pi
						local radius = FullRadius * scale * explodeProgress
						local offsetX = math.cos(angle) * radius
						local offsetY = math.sin(angle) * radius
						local cf = root.CFrame
							* CFrame.new(offsetX, offsetY + StarYOffset * scale, StarZOffset * scale)
							* CFrame.Angles(0, 0, spinAngle)
						star:PivotTo(cf)
						starLandedCF[i] = cf
					else
						local fallProgress = math.min((elapsed - 0.5) / FallDuration, 1)
						local eased = fallProgress * fallProgress
						local landedCF = starLandedCF[i]
						if landedCF then
							star:PivotTo(landedCF * CFrame.new(0, -6 * scale * eased, 0))
						end
					end
				else
					starLandedCF[i] = nil
					star:PivotTo(HideCF)
				end
			end
		end
	end

	m.Destroy = function(figure)
		animator = nil
		for _, v in instances do
			if typeof(v) == "Instance" then
				v:Destroy()
			elseif type(v) == "table" then
				for _, s in v do s:Destroy() end
			end
		end
		instances = {}
		starLandedCF = {}
	end

	return m
end)

return modules