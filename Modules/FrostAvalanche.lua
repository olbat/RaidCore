--------------------------------------------------------------------------------
-- Module Declaration
--

local core = Apollo.GetPackage("Gemini:Addon-1.1").tPackage:GetAddon("RaidCore")

local mod = core:NewBoss("FrostAvalanche", 52)
if not mod then return end

mod:RegisterEnableMob("Frostfelsen-Lawine") -- Frost-Boulder Avalanche

--------------------------------------------------------------------------------
-- Locals
--

local icicleSpell = false

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	Print(("Module %s loaded"):format(mod.ModuleName))
	Apollo.RegisterEventHandler("UnitEnteredCombat", 		"OnCombatStateChanged", 	self)
	Apollo.RegisterEventHandler("SPELL_CAST_START", 		"OnSpellCastStart", self)
	Apollo.RegisterEventHandler("UNIT_HEALTH", 			"OnHealthChanged", 		self)
end


--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:OnHealthChanged(unitName, health)
	if unitName == "Frost-Boulder Avalanche" and (health == 85 or health == 55 or health ==31) then
		core:AddMsg("CYCLONE", "CYCLONE SOON", 5, "Info", "Blue")
	end
end

function mod:OnSpellCastStart(unitName, castName, unit)
	if unitName == "Frostfelsen-Lawine" and castName == "Eiszapfensturm" then -- Frost-Boulder Avalanche, Icicle Storm
		core:AddMsg("ICICLE", "ICICLE !!", 5, "Alert")
		core:AddBar("ICICLE", "ICICLE", 22)
		icicleSpell = true
	elseif unitName == "Frostfelsen-Lawine" and castName == "Zerschmettern" then -- Frost-Boulder Avalanche, Shatter
		core:AddMsg("ICICLE", "SHATTER !!", 5, "Alert")
		core:AddBar("ICICLE", "SHATTER", 22)
	elseif unitName == "Frostfelsen-Lawine" and castName == "Wirbelsturm" then -- Frost-Boulder Avalanche, Cyclone
		core:AddMsg("CYCLONE", "CYCLONE", 5, "RunAway")
		core:AddBar("RUN", "CYCLONE", 23)
		core:AddBar("ICICLE", icicleSpell and "ICICLE" or "SHATTER", 48)
	end
end


function mod:OnCombatStateChanged(unit, bInCombat)
	if unit:GetType() == "NonPlayer" and bInCombat then
		local sName = unit:GetName()
		if sName == "Frostfelsen-Lawine" then -- Frost-Boulder Avalanche
			icicleSpell = false
			core:AddUnit(unit)
			core:WatchUnit(unit)
			core:StartScan()
		end
	end
end
