-- UhhhhhhReanim/Modules/ShieldBashDance.lua

local modules = {}

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "Skeleton Shield Bash"
	m.Description = "RAHHHHHHHHHRGH! RAAARGH!"
	m.Assets      = {"Skellywarcry.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Skelly%20War%20Cry/Skellywarcry.anim", "Skellywarcry.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Skelly%20War%20Cry/Skellywarcry.mp3"}

	m.Config = function(parent)
		Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("Skellywarcry.mp3"), "Skeleton Shield Bash", 0.8, NumberRange.new(0, 2.5))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Skellywarcry.anim"))
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