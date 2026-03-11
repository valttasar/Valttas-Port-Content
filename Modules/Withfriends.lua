-- UhhhhhhReanim/Modules/WithFriendsDance.lua

local modules = {}

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "With Friends"
	m.Description = "Chris? he only plays with friends.. friends.. only.. plays.. oney plays...."
	m.Assets      = {"Withfriends.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/With%20Friends/Withfriends.anim", "Withfriends.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/With%20Friends/Withfriends.mp3"}

	m.Config = function(parent)
		Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("Withfriends.mp3"), "With Friends", 0.8, NumberRange.new(0, 20.16))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Withfriends.anim"))
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