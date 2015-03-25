--------------------------------------------------------------------------------
-- Module Declaration
--

local core = Apollo.GetPackage("Gemini:Addon-1.1").tPackage:GetAddon("RaidCore")

local mod = core:NewBoss("DSFrostWing", 52)
if not mod then return end

mod:RegisterEnableMob("Frostfelsen-Lawine", "Frostbringer-Hexenmeister") -- Frost-Boulder Avalanche, Frostbringer Warlock

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
	if unitName == "Frost-Boulder Avalanche" and (health == 85 or health == 55 or health == 31) then
		core:AddMsg("CYCLONE", "CYCLONE SOON", 5, "Info", "Blue")
	elseif unitName == "Frost-Boulder Avalanche" and health == 22 then
		core:AddMsg("PHASE2", "PHASE 2 SOON", 5, "Info", "Blue")		
	end
end

function mod:OnSpellCastStart(unitName, castName, unit)
	if unitName == "Frostfelsen-Lawine" and castName == "Eiszapfensturm" then -- Frost-Boulder Avalanche, Icicle Storm
		core:StopBar("SHATTER")
		core:AddMsg("ICICLE", "ICICLE !!", 5, "Alert")
		core:AddBar("ICICLE", "ICICLE", 22)
		icicleSpell = true
	elseif unitName == "Frostfelsen-Lawine" and castName == "Zerschmettern" then -- Frost-Boulder Avalanche, Shatter
		core:AddMsg("SHATTER", "SHATTER !!", 5, "Alert")
		core:AddBar("SHATTER", "SHATTER", 30)
	elseif unitName == "Frostfelsen-Lawine" and castName == "Wirbelsturm" then -- Frost-Boulder Avalanche, Cyclone
		core:AddMsg("CYCLONE", "CYCLONE", 5, "RunAway")
		core:AddBar("RUN", "RUNNNN", 23, 1)
		if icicleSpell then
			core:AddBar("1ST", "1ST ABILITY", 33)
			core:AddBar("2ND", "2ND ABILITY", 40.5)
			core:AddBar("3RD", "3RD ABILITY", 48)
			--core:AddBar("ICICLE", "ICICLE", 48)
		else
			core:AddBar("SHATTER", "SHATTER", 50)
		end
		core:AddBar("CYCLONE", "CYCLONE", 90, 1)
	end
end


function mod:OnCombatStateChanged(unit, bInCombat)
	if unit:GetType() == "NonPlayer" and bInCombat then
		local sName = unit:GetName()
		if sName == "Frostfelsen-Lawine" then -- Frost-Boulder Avalanche
			self:Start()
			icicleSpell = false
			core:AddUnit(unit)
			core:WatchUnit(unit)
			core:AddBar("ICICLE", "~ICICLE", 17)
			core:AddBar("SHATTER", "~SHATTER", 30)
			core:StartScan()
		elseif sName == "Frostbringer-Hexenmeister" then -- Frostbringer Warlock
			self:Start()
			core:AddUnit(unit)
			core:AddBar("WAVES", "FROST WAVE", 30)
		end
	end
end
