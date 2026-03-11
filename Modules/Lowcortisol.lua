-- UhhhhhhReanim/Modules/LowCortisolDance.lua

local modules = {}

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "Low Cortisol"
	m.Description = "Agnes Tachyon, Low Cortisol Uma"
	m.Assets      = {"Lowcortisol.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Low%20Cortisol/Lowcortisol.anim", "Lowcortisol.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Low%20Cortisol/Lowcortisol.mp3"}

	m.Config = function(parent)
		Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("Lowcortisol.mp3"), "Low Cortisol", 0.8, NumberRange.new(0, 999))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Lowcortisol.anim"))
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