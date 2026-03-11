-- UhhhhhhReanim/Modules/Schadenfreude.lua

local modules = {}

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "Schadenfreude"
	m.Description = "Can you feel the scha-den-freu-de?"
	m.Assets      = {
		"Scoutlaugh.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Schadenfreude/Scoutlaugh.anim", "Scoutlaugh.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Schadenfreude/Scoutlaugh.mp3",
		"Pyrolaugh.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Schadenfreude/Pyrolaugh.anim", "Pyrolaugh.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Schadenfreude/Pyrolaugh.mp3",
		"Mediclaugh.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Schadenfreude/Mediclaugh.anim", "Mediclaugh.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Schadenfreude/Mediclaugh.mp3",
		"Heavylaugh.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Schadenfreude/Heavylaugh.anim", "Heavylaugh.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Schadenfreude/Heavylaugh.mp3",
		"Demomanlaugh.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Schadenfreude/Demomanlaugh.anim", "Demomanlaugh.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Schadenfreude/Demomanlaugh.mp3",
		"Sniperlaugh.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Schadenfreude/Sniperlaugh.anim", "Sniperlaugh.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Schadenfreude/Sniperlaugh.mp3",
		"Spylaugh.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Schadenfreude/Spylaugh.anim", "Spylaugh.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Schadenfreude/Spylaugh.mp3",
		"Soldierlaugh.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Schadenfreude/Soldierlaugh.anim", "Soldierlaugh.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Schadenfreude/Soldierlaugh.mp3",
		"Engineerlaugh.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Schadenfreude/Engineerlaugh.anim", "Engineerlaugh.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Schadenfreude/Engineerlaugh.mp3",
	}

	local mercenaries = {"Scout", "Pyro", "Medic", "Heavy", "Demoman", "Sniper", "Spy", "Soldier", "Engineer"}

	m.Variant = 1
	m.Config = function(parent)
		Util_CreateDropdown(parent, "Mercenary", mercenaries, m.Variant).Changed:Connect(function(val)
			m.Variant = val
		end)
	end
	m.LoadConfig = function(save)
		m.Variant = save.Variant or m.Variant
	end
	m.SaveConfig = function()
		return {
			Variant = m.Variant
		}
	end

	local animator = nil
	local start = 0

	m.Init = function(figure)
		local name = mercenaries[m.Variant]
		SetOverrideDanceMusic(AssetGetContentId(name .. "laugh.mp3"), "TF2 Schadenfreude - " .. name, 1)
		start = os.clock()
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename(name .. "laugh.anim"))
		animator.looped = true
		animator.speed = 1
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