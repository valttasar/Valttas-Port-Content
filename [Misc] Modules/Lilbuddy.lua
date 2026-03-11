-- UhhhhhhReanim/Modules/LilBuddyDance.lua

local modules = {}

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "Lil Buddy Was Sick"
	m.Description = "I done got rich yeah, with no advance 🤑"
	m.Assets      = {"Lilbuddy.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Lil%20Buddy/Lilbuddy.anim", "Lilbuddy.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Lil%20Buddy/Lilbuddy.mp3"}

	m.Config = function(parent)
		Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("Lilbuddy.mp3"), "Lil Buddy Was Sick", 0.8, NumberRange.new(0, 13.23))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Lilbuddy.anim"))
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