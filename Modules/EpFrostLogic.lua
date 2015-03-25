--------------------------------------------------------------------------------
-- Module Declaration
--

local core = Apollo.GetPackage("Gemini:Addon-1.1").tPackage:GetAddon("RaidCore")

local mod = core:NewBoss("EpFrostLogic", 52)
if not mod then return end

mod:RegisterEnableBossPair("Hydroflux", "Mnémésis") -- Mnemesis
mod:RegisterRestrictZone("EpFrostLogic", "Elemental Vortex Alpha", "Elemental Vortex Beta", "Elemental Vortex Delta") -- Elemental Vortex Alpha, Elemental Vortex Beta, Elemental Vortex Delta

--------------------------------------------------------------------------------
-- Locals
--

local uPlayer = nil
local strMyName = ""
local midphase = false
local encounter_started = false

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	Print(("Module %s loaded"):format(mod.ModuleName))
	Apollo.RegisterEventHandler("UnitCreated", 			"OnUnitCreated", self)
	Apollo.RegisterEventHandler("UnitDestroyed", 		"OnUnitDestroyed", self)
	Apollo.RegisterEventHandler("UnitEnteredCombat", 	"OnCombatStateChanged", self)
	Apollo.RegisterEventHandler("SPELL_CAST_START", 	"OnSpellCastStart", self)
	Apollo.RegisterEventHandler("SPELL_CAST_END", 		"OnSpellCastEnd", self)
	--Apollo.RegisterEventHandler("CHAT_DATACHRON", 	"OnChatDC", self)
	--Apollo.RegisterEventHandler("BUFF_APPLIED", 		"OnBuffApplied", self)
	Apollo.RegisterEventHandler("DEBUFF_APPLIED", 		"OnDebuffApplied", self)
	Apollo.RegisterEventHandler("DEBUFF_REMOVED", 		"OnDebuffRemoved", self)
	Apollo.RegisterEventHandler("RAID_WIPE", 			"OnReset", self)
end


--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:OnReset()
	core:StopBar("MIDPHASE")
	core:StopBar("GRAVE")
	core:StopBar("PRISON")
	core:StopBar("DEFRAG")
	midphase = false
	encounter_started = false
end

function mod:OnSpellCastStart(unitName, castName, unit)
	local eventTime = GameLib.GetGameTime()
	--Print(eventTime .. castName .. unit:GetName())
	if unitName == "Mnémésis" and castName == "Coupe-circuit" then -- Mnemesis, Circuit Breaker
		core:StopBar("MIDPHASE")
		core:AddBar("MIDPHASE", "Middle Phase", 100, true)
		midphase = true
	elseif unitName == "Hydroflux" and castName == "Watery Grave" and self:Tank() then
		core:StopBar("GRAVE")
		core:AddBar("GRAVE", "Watery Grave", 10)
	elseif unitName == "Mnémésis" and castName == "Emprisonner" then -- Mnemesis, Imprison
		core:StopBar("PRISON")
		core:AddBar("PRISON", "Imprison", 19)
	elseif unitName == "Mnémésis" and castName == "Défragmentation" then -- Mnemesis, Defragment
		core:StopBar("DEFRAG")
		core:AddMsg("DEFRAG", "SPREAD", 5, "Beware")
		core:AddBar("DEFRAG", "~Defrag", 40, true)
	end
end

function mod:OnSpellCastEnd(unitName, castName)
	if unitName == "Mnémésis" and castName == "Coupe-circuit" then -- Mnemesis, Circuit Breaker
		midphase = false
	end
end

function mod:OnDebuffApplied(unitName, splId, unit)
	local splName = GameLib.GetSpell(splId):GetName()
	if splName == "Désintégrateur de données" then -- Data Disruptor
		if unitName == strMyName then
			core:AddMsg("DISRUPTOR", "Stay away from boss with buff!", 5, "Beware")
		end
		core:MarkUnit(unit, nil, "ORB")
	end
end

function mod:OnDebuffRemoved(unitName, splId, unit)
	local eventTime = GameLib.GetGameTime()
	local tSpell = GameLib.GetSpell(splId)
	local strSpellName = tSpell:GetName()
	if strSpellName == "Désintégrateur de données" then -- Data Disruptor
		local unitId = unit:GetId()
		if unitId then
			core:DropMark(unit:GetId())
		end
	end
end

function mod:OnUnitCreated(unit)
	local sName = unit:GetName()
	local eventTime = GameLib.GetGameTime()

	if sName == "Hachis alphanumérique" then -- Alphanumeric Hash
		local unitId = unit:GetId()
		if unitId then
			core:AddPixie(unitId, 2, unit, nil, "Red", 10, 20, 0)	
		end
	elseif sName == "Hydro Disrupter - DNT" and not midphase then
		local unitId = unit:GetId()
		if unitId then
			core:AddPixie(unitId, 1, unit, uPlayer, "Blue", 5, 10, 10)
		end
	end

	--Print(eventTime .. " - " .. sName)
end

function mod:OnUnitDestroyed(unit)
	local sName = unit:GetName()
	local eventTime = GameLib.GetGameTime()
	
	if sName == "Hachis alphanumérique" then -- Alphanumeric Hash
		local unitId = unit:GetId()
		if unitId then
			core:DropPixie(unitId)
		end
	elseif sName == "Hydro Disrupter - DNT" then -- Hydro Disrupter - DNT
		local unitId = unit:GetId()
		if unitId then
			core:DropPixie(unitId)
		end
	end
end

function mod:OnCombatStateChanged(unit, bInCombat)
	if unit:GetType() == "NonPlayer" and bInCombat then
		local sName = unit:GetName()
		local eventTime = GameLib.GetGameTime()

		if sName == "Hydroflux" then -- Hydroflux
			core:AddUnit(unit)
			core:WatchUnit(unit)
		elseif sName == "Mnémésis" then -- Mnemesis
			self:Start()
			uPlayer = GameLib.GetPlayerUnit()
			strMyName = uPlayer:GetName()
			midphase = false
			encounter_started = true
			--core:UnitDebuff(uPlayer)
			core:RaidDebuff()
			core:AddUnit(unit)
			core:WatchUnit(unit)
			core:StartScan()
			core:AddBar("MIDPHASE", "Middle Phase", 75, true)
			core:AddBar("PRISON", "Imprison", 16)
			core:AddBar("DEFRAG", "Defrag", 20, true)

			if self:Tank() then
				core:AddBar("GRAVE", "Watery Grave", 10)
			end

			--Print(eventTime .. " " .. sName .. " FIGHT STARTED ")
		end
	end
end
