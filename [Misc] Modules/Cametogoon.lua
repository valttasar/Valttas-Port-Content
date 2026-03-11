-- UhhhhhhReanim/Modules/ICameToGoonDance.lua

local modules = {}

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "I Came To Goon"
	m.Description = "A peanut butter house, I beat it in"
	m.Assets      = {"Cametogoon.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Came%20To%20Goon/Cametogoon.anim", "Cametogoon.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Came%20To%20Goon/Cametogoon.mp3"}

	m.Config = function(parent)
		Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("Cametogoon.mp3"), "I Came To Goon", 0.8, NumberRange.new(0, 999))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Cametogoon.anim"))
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