-- UhhhhhhReanim/Modules/ReleaseTheGhoulsDance.lua

local modules = {}

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "Release The Ghouls!"
	m.Description = "Don't you know smoking kills?"
	m.Assets      = {"Ghouls.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Release%20The%20Ghouls/Ghouls.anim", "Ghouls.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Release%20The%20Ghouls/Ghouls.mp3"}

	m.Config = function(parent)
		Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("Ghouls.mp3"), "Release The Ghouls!", 0.8, NumberRange.new(0, 52.88))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Ghouls.anim"))
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