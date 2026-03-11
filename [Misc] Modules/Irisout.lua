-- UhhhhhhReanim/Modules/IrisOutDance.lua

local modules = {}

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "Iris Out"
	m.Description = "Really... why didn't I kill you the first time we met? Denji"
	m.Assets      = {"Irisout.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Iris%20Out/Irisout.anim", "Irisout.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Iris%20Out/Irisout.mp3"}

	m.Config = function(parent)
		Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("Irisout.mp3"), "Iris Out", 0.8, NumberRange.new(0, 16.16))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Irisout.anim"))
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