-- UhhhhhhReanim/Modules/OtsukareSummerDance.lua

local modules = {}

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "Otsukare Summer"
	m.Description = "otsukare summer awai yumemishi otome wa hitoshirezu crying :sob:"
	m.Assets      = {"OtsukareSummer.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Otsukare%20Summer/OtsukareSummer.anim", "OtsukareSummer.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Otsukare%20Summer/OtsukareSummer.mp3"}

	m.Config = function(parent)
		Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("OtsukareSummer.mp3"), "Otsukare Summer", 0.8, NumberRange.new(0, 27.36))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("OtsukareSummer.anim"))
		animator.looped = true
		animator.speed  = 1
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