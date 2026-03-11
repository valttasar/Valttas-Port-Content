-- UhhhhhhReanim/Modules/BirdbrainV2Dance.lua

local modules = {}

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "Birdbrain V2"
	m.Description = "Basically that rare birdbrain variant from birdbrain v1"
	m.Assets      = {"Birdbrainv2.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Birdbrain%20V2/Birdbrainv2.anim", "BirdbrainAlt.mp3"}

	m.Config = function(parent)
		Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("BirdbrainAlt.mp3"), "Birdbrain V2", 0.8, NumberRange.new(0, 999))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Birdbrainv2.anim"))
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