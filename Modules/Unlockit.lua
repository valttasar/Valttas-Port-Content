local modules = {}

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "Unlock It"
	m.Description = "you could be ma valentino yeah ~\n\nI suggest using S.E.W.H it's so gud "
	m.Assets      = {"Unlockit.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Unlock%20It/Unlockit.anim", "Unlockit.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Unlock%20It/Unlockit.mp3", "Unlockit2.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Unlock%20It/Unlockit2.anim", "Unlockit2.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Unlock%20It/Unlockit2.mp3"}

	m.Alternative  = false
	m.MusicVariant = 1
	m.Config = function(parent)
		Util_CreateSwitch(parent, "S.E.W.H Version", m.Alternative).Changed:Connect(function(val)
			m.Alternative = val
		end)
		Util_CreateDropdown(parent, "Music Variant", {"Normal", "S.E.W.H Ver."}, m.MusicVariant).Changed:Connect(function(val)
			m.MusicVariant = val
		end)
	end

	m.LoadConfig = function(save: any)
		m.Alternative = not not save.Alternative
		m.MusicVariant = save.MusicVariant or m.MusicVariant
	end

	m.SaveConfig = function()
		return {
			Alternative = m.Alternative,
			MusicVariant = m.MusicVariant
		}
	end

	local animator = nil
	local start = 0

	m.Init = function(figure: Model)
		if m.MusicVariant == 1 then
			SetOverrideDanceMusic(AssetGetContentId("Unlockit.mp3"), "Normal", 1, NumberRange.new(0, 14.43))
		elseif m.MusicVariant == 2 then
			SetOverrideDanceMusic(AssetGetContentId("Unlockit2.mp3"), "Something EVIL Will Happen", 1, NumberRange.new(0, 14.03))
		end

		if not m.Intro then
			SetOverrideDanceMusicTime(0)
		end

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.looped = true
		animator.speed  = 1

		if m.Alternative then
			animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Unlockit2.anim"))
		else
			animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Unlockit.anim"))
		end
	end

	m.Update = function(dt, figure)
		animator:Step(os.clock() - start)
	end

	m.Destroy = function(figure)
		animator = nil
	end

	return m
end)

return modules