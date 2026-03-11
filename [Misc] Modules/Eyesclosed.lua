-- UhhhhhhReanim/Modules/EyesClosedDance.lua

local modules = {}
local function AddModule(m)
	table.insert(modules, m)
end

AddModule(function()
	local m = {}
	m.ModuleType = "DANCE"
	m.Name = "Eyes Closed"
	m.Description = "performative male's favorite artist but fyeeee"
	m.Assets = {"Eyesclosed.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Eyes%20Closed/Eyesclosed.anim", "Eyesclosed.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Eyes%20Closed/Eyesclosed.mp3"}

	m.Effects = true
	m.Config = function(parent: GuiBase2d)
		Util_CreateSwitch(parent, "Effects", m.Effects).Changed:Connect(function(val)
			m.Effects = val
		end)
	end
	m.LoadConfig = function(save: any)
		m.Effects = not save.NoEffects
	end
	m.SaveConfig = function()
		return {
			NoEffects = not m.Effects
		}
	end

	local animator = nil
	local start = 0
	local instances = {}
	local ringPart = nil
	local ringBars = {}
	local ringSegments = 64
	local ghostTimer = 0
	local activeGhosts = {}
	local ghostColor = Color3.fromRGB(0, 255, 255)

	local function spawnGhost(figure)
		local ghost = Instance.new("Model")
		ghost.Name = "EyesClosedGhost"
		local parts = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}
		for _, name in parts do
			local src = figure:FindFirstChild(name)
			if not src then continue end
			local p = Instance.new("Part")
			p.Name = name
			p.Anchored = true
			p.CanCollide = false
			p.CanTouch = false
			p.CanQuery = false
			p.CastShadow = false
			p.Color = ghostColor
			p.Material = Enum.Material.Neon
			p.Transparency = 0.55
			if name == "Head" then
				p.Shape = Enum.PartType.Cylinder
				p.Size = Vector3.new(src.Size.Y, src.Size.X, src.Size.Z)
				p.CFrame = src.CFrame * CFrame.Angles(0, 0, math.pi / 2)
			else
				p.Shape = Enum.PartType.Block
				p.Size = src.Size
				p.CFrame = src.CFrame
			end
			local light = Instance.new("PointLight")
			light.Brightness = 1.5
			light.Range = 5
			light.Color = ghostColor
			light.Parent = p
			p.Parent = ghost
		end
		ghost.Parent = workspace
		table.insert(activeGhosts, {model = ghost, elapsed = 0})
	end

	local function updateGhosts(dt)
		local i = 1
		while i <= #activeGhosts do
			local g = activeGhosts[i]
			g.elapsed += dt
			local alpha = g.elapsed / 1.0
			if alpha >= 1 then
				g.model:Destroy()
				table.remove(activeGhosts, i)
			else
				for _, p in g.model:GetChildren() do
					if p:IsA("BasePart") then
						p.Transparency = 0.55 + alpha * 0.45
						local t = 1 - alpha
						p.Color = Color3.fromRGB(
							math.floor(ghostColor.R * 255 * t),
							math.floor(ghostColor.G * 255 * t),
							math.floor(ghostColor.B * 255 * t)
						)
					end
				end
				i += 1
			end
		end
	end

	local function makeEmitters(parent, scale)
		local glow = Instance.new("ParticleEmitter")
		glow.Parent = parent
		glow.LightInfluence = 0
		glow.LightEmission = 1
		glow.Brightness = 2.5
		glow.ZOffset = -1
		glow.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 230, 255)),
			ColorSequenceKeypoint.new(0.4, Color3.fromRGB(80, 160, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 60, 220)),
		})
		glow.Orientation = Enum.ParticleOrientation.FacingCamera
		glow.Size = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1.4 * scale),
			NumberSequenceKeypoint.new(0.3, 1.0 * scale),
			NumberSequenceKeypoint.new(0.7, 0.45 * scale),
			NumberSequenceKeypoint.new(1, 0),
		})
		glow.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.05),
			NumberSequenceKeypoint.new(0.4, 0.3),
			NumberSequenceKeypoint.new(0.8, 0.65),
			NumberSequenceKeypoint.new(1, 1),
		})
		glow.Texture = "rbxasset://textures/particles/sparkles_main.dds"
		glow.Lifetime = NumberRange.new(0.18, 0.30)
		glow.Rate = 50
		glow.Speed = NumberRange.new(1.0 * scale, 2.5 * scale)
		glow.SpreadAngle = Vector2.new(45, 45)
		glow.Rotation = NumberRange.new(0, 360)
		glow.RotSpeed = NumberRange.new(-80, 80)
		glow.LockedToPart = false
		glow.Enabled = true
		local sparks = Instance.new("ParticleEmitter")
		sparks.Parent = parent
		sparks.LightInfluence = 0
		sparks.LightEmission = 0.7
		sparks.Brightness = 1.8
		sparks.ZOffset = 0
		sparks.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.2, Color3.fromRGB(160, 210, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 100, 255)),
		})
		sparks.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
		sparks.Size = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.07 * scale),
			NumberSequenceKeypoint.new(0.5, 0.04 * scale),
			NumberSequenceKeypoint.new(1, 0),
		})
		sparks.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(0.5, 0.35),
			NumberSequenceKeypoint.new(1, 1),
		})
		sparks.Texture = "rbxasset://textures/particles/sparkles_main.dds"
		sparks.Lifetime = NumberRange.new(0.12, 0.28)
		sparks.Rate = 65
		sparks.Speed = NumberRange.new(2.0 * scale, 5.0 * scale)
		sparks.SpreadAngle = Vector2.new(65, 65)
		sparks.Rotation = NumberRange.new(0, 360)
		sparks.RotSpeed = NumberRange.new(-120, 120)
		sparks.LockedToPart = false
		sparks.Enabled = true
		local light = Instance.new("PointLight")
		light.Brightness = 1.2
		light.Range = 5 * scale
		light.Color = Color3.fromRGB(60, 130, 255)
		light.Shadows = false
		light.Parent = parent
		return {glow, sparks, light}
	end

	local function buildFace(part, face, scale)
		local sgui = Instance.new("SurfaceGui")
		sgui.Name = "RingGui_" .. tostring(face)
		sgui.Face = face
		sgui.LightInfluence = 0
		sgui.Brightness = 4
		sgui.AlwaysOnTop = false
		sgui.MaxDistance = 60
		sgui.SizingMode = Enum.SurfaceGuiSizingMode.FixedSize
		sgui.CanvasSize = Vector2.new(256, 256)
		sgui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		sgui.Parent = part
		local bg = Instance.new("Frame")
		bg.Size = UDim2.new(1, 0, 1, 0)
		bg.BackgroundTransparency = 1
		bg.BorderSizePixel = 0
		bg.Parent = sgui
		local bars = {}
		local cx, cy = 128, 128
		local innerR = 88
		local barW = 5
		local flip = (face == Enum.NormalId.Bottom) and -1 or 1
		for i = 1, ringSegments do
			local angle = flip * (i / ringSegments) * math.pi * 2
			local bar = Instance.new("Frame")
			bar.Name = "Bar" .. i
			bar.AnchorPoint = Vector2.new(0.5, 1)
			bar.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
			bar.BorderSizePixel = 0
			bar.BackgroundTransparency = 0
			bar.Position = UDim2.new(0, cx + innerR * math.cos(angle) - barW / 2, 0, cy + innerR * math.sin(angle))
			bar.Size = UDim2.new(0, barW, 0, 2)
			bar.Rotation = math.deg(angle) + 90
			bar.Parent = bg
			local stroke = Instance.new("UIStroke")
			stroke.Color = Color3.fromRGB(140, 210, 255)
			stroke.Thickness = 1.5
			stroke.Transparency = 0.2
			stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			stroke.Parent = bar
			table.insert(bars, bar)
		end
		table.insert(instances, sgui)
		return bars
	end

	local function makeRing(figure)
		local scale = figure:GetScale()
		ringPart = Instance.new("Part")
		ringPart.Name = "RingVisualizer"
		ringPart.Anchored = true
		ringPart.CanCollide = false
		ringPart.CanTouch = false
		ringPart.CanQuery = false
		ringPart.Transparency = 1
		ringPart.Size = Vector3.new(8 * scale, 0.01, 8 * scale)
		ringPart.Parent = figure
		table.insert(instances, ringPart)
		local topBars = buildFace(ringPart, Enum.NormalId.Top, scale)
		local bottomBars = buildFace(ringPart, Enum.NormalId.Bottom, scale)
		ringBars = {}
		for i = 1, ringSegments do
			table.insert(ringBars, {top = topBars[i], bottom = bottomBars[i]})
		end
	end

	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("Eyesclosed.mp3"), "Eyes Closed", 0.8, NumberRange.new(0, 26.70))
		start = os.clock()
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Eyesclosed.anim"))
		animator.looped = true
		for _,v in instances do v:Destroy() end
		for _,g in activeGhosts do g.model:Destroy() end
		instances = {}
		ringBars = {}
		ringPart = nil
		activeGhosts = {}
		ghostTimer = 0
		if m.Effects then
			local scale = figure:GetScale()
			for _, name in {"Left Arm", "Right Arm", "Left Leg", "Right Leg"} do
				local limb = figure:FindFirstChild(name)
				if not limb then continue end
				for _, inst in makeEmitters(limb, scale) do
					table.insert(instances, inst)
				end
			end
			makeRing(figure)
		end
	end
	m.Update = function(dt: number, figure: Model)
		animator:Step(os.clock() - start)
		if m.Effects then
			ghostTimer += dt
			if ghostTimer >= 0.5 then
				ghostTimer = 0
				spawnGhost(figure)
			end
			updateGhosts(dt)
		end
		if not ringPart or #ringBars == 0 then return end
		local root = figure:FindFirstChild("HumanoidRootPart")
		if not root then return end
		local scale = figure:GetScale()
		local head = figure:FindFirstChild("Head")
		local headY = head and head.Position.Y or root.Position.Y
		ringPart.CFrame = CFrame.new(root.Position.X, headY + 3.2 * scale, root.Position.Z)
		local t = GetOverrideDanceMusicTime()
		for i, pair in ringBars do
			local frac = (i - 1) / ringSegments
			local phase = frac * math.pi * 2
			local bass = math.abs(math.sin(t * 2.1 + phase * 0.5))
			local mid = math.abs(math.sin(t * 5.3 + phase * 1.2 + 1.1))
			local treble = math.abs(math.sin(t * 11.7 + phase * 2.5 + 2.3))
			local amplitude = (bass * 0.55 + mid * 0.30 + treble * 0.15) * (0.75 + 0.25 * math.sin(t * 3.14))
			local barH = math.max(2, math.floor(amplitude * 28))
			local col = Color3.fromRGB(
				math.floor(40 + amplitude * 100),
				math.floor(120 + amplitude * 110),
				255
			)
			local sz = UDim2.new(0, 5, 0, barH)
			pair.top.Size = sz
			pair.top.BackgroundColor3 = col
			pair.bottom.Size = sz
			pair.bottom.BackgroundColor3 = col
		end
	end
	m.Destroy = function(figure: Model?)
		animator = nil
		ringPart = nil
		ringBars = {}
		for _,v in instances do v:Destroy() end
		for _,g in activeGhosts do g.model:Destroy() end
		instances = {}
		activeGhosts = {}
		ghostTimer = 0
	end
	return m
end)

return modules