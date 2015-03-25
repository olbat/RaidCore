--------------------------------------------------------------------------------
-- Module Declaration
--

local core = Apollo.GetPackage("Gemini:Addon-1.1").tPackage:GetAddon("RaidCore")

local mod = core:NewBoss("EpLifeLogic", 52)
if not mod then return end

mod:RegisterEnableBossPair("Mnemesis", "Viszeralus") -- Visceralus
mod:RegisterRestrictZone("EpLifeLogic", "Elemental Vortex Alpha", "Elemental Vortex Beta", "Elemental Vortex Delta") -- Elemental Vortex Alpha, Elemental Vortex Beta, Elemental Vortex Delta

--------------------------------------------------------------------------------
-- Locals
--

local uPlayer = nil
local strMyName = ""
local midphase = false
local midpos = {
	["north"] = {x = 9741.53, y = -518, z = 17823.81},
	["west"] = {x = 9691.53, y = -518, z = 17873.81},
	["south"] = {x = 9741.53, y = -518, z = 17923.81},
	["east"] = {x = 9791.53, y = -518, z = 17873.81},
}

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	Print(("Module %s loaded"):format(mod.ModuleName))
	Apollo.RegisterEventHandler("UnitEnteredCombat", 	"OnCombatStateChanged", self)
	Apollo.RegisterEventHandler("SPELL_CAST_START", 	"OnSpellCastStart", self)
	Apollo.RegisterEventHandler("UnitCreated", 			"OnUnitCreated", self)
	Apollo.RegisterEventHandler("UnitDestroyed", 		"OnUnitDestroyed", self)
	Apollo.RegisterEventHandler("DEBUFF_APPLIED", 		"OnDebuffApplied", self)
	Apollo.RegisterEventHandler("DEBUFF_REMOVED", 		"OnDebuffRemoved", self)
	Apollo.RegisterEventHandler("RAID_WIPE", 			"OnReset", self)
end


--------------------------------------------------------------------------------
-- Event Handlers
--

local function dist2unit(unitSource, unitTarget)
	if not unitSource or not unitTarget then return 999 end
	local sPos = unitSource:GetPosition()
	local tPos = unitTarget:GetPosition()

	local sVec = Vector3.New(sPos.x, sPos.y, sPos.z)
	local tVec = Vector3.New(tPos.x, tPos.y, tPos.z)

	local dist = (tVec - sVec):Length()

	return tonumber(dist)
end

function mod:OnReset()
	core:ResetMarks()
	midphase = false
end

function mod:OnDebuffApplied(unitName, splId, unit)
	local eventTime = GameLib.GetGameTime()
	local tSpell = GameLib.GetSpell(splId)
	local strSpellName = tSpell:GetName()

	if strSpellName == "Schlangen-Snack" then -- Snake Snack
		if unitName == strMyName then
			core:AddMsg("SNAKE", "SNAKE ON YOU!", 5, "RunAway")
		else
			local msgString = "SNAKE ON " .. unitName
			core:AddMsg("SNAKE", msgString, 5, "Info")
		end
		core:MarkUnit(unit, nil, "SNAKE")
	elseif strSpellName == "Lebenskraft-Fessel" then -- Life Force Shackle
		core:MarkUnit(unit, nil, "NO HEAL\nDEBUFF")
		if unitName == strMyName then
			core:AddMsg("NOHEAL", "No-Healing Debuff!", 5, "Alarm")
		end
	elseif strSpellName == "Thorns" then -- Thorns
		core:MarkUnit(unit, nil, "THORNS\nDEBUFF")
	end
	--Print(eventTime .. " " .. unitName .. "has debuff: " .. strSpellName .. " with splId: " .. splId)
end

function mod:OnDebuffRemoved(unitName, splId, unit)
	local eventTime = GameLib.GetGameTime()
	local tSpell = GameLib.GetSpell(splId)
	local strSpellName = tSpell:GetName()

	if strSpellName == "Schlangen-Snack" then -- Snake Snack
		core:DropMark(unit:GetId())
	elseif strSpellName == "Lebenskraft-Fessel" then -- Life Force Shackle
		core:DropMark(unit:GetId())
	elseif strSpellName == "Thorns" then -- Thorns
		core:DropMark(unit:GetId())
	end
end

function mod:OnUnitCreated(unit)
	local sName = unit:GetName()
	local eventTime = GameLib.GetGameTime()
	if sName == "Lebensessenz" then -- Essence of Life
		core:AddUnit(unit)
		if not midphase then
			midphase = true
			core:SetWorldMarker(midpos["north"], "North")
			core:SetWorldMarker(midpos["east"], "East")
			core:SetWorldMarker(midpos["south"], "South")
			core:SetWorldMarker(midpos["west"], "West")

			core:StopBar("DEFRAG")
		end
	elseif sName == "Logikessenz" then -- Essence of Logic
		core:AddUnit(unit)
	elseif sName == "Alphanumerische Raute" then -- Alphanumeric Hash
		local unitId = unit:GetId()
		if unitId then
			core:AddPixie(unitId, 2, unit, nil, "Red", 10, 20, 0)	
		end
	elseif sName == "Lebenskraft" then -- Life Force
		core:AddPixie(unit:GetId(), 2, unit, nil, "Blue", 3, 15, 0)
	end
	--Print(eventTime .. " - " .. sName)
end

function mod:OnUnitDestroyed(unit)
	local sName = unit:GetName()
	local eventTime = GameLib.GetGameTime()
	if sName == "Logikessenz" then -- Essence of Logic
		midphase = false
		core:ResetWorldMarkers()
	elseif sName == "Alphanumerische Raute" then -- Alphanumeric Hash
		local unitId = unit:GetId()
		if unitId then
			core:DropPixie(unitId)
		end
	elseif sName == "Lebenskraft" then -- Life Force
		core:DropPixie(unit:GetId())
	end
end

function mod:OnSpellCastStart(unitName, castName, unit)
	local eventTime = GameLib.GetGameTime()
	if unitName == "Viszeralus" and castName == "Blendendes Licht" then -- Visceralus, Blinding Light
		if dist2unit(unit, uPlayer) < 33 then
			core:AddMsg("BLIND", "Blinding Light", 5, "Beware")
		end
	elseif unitName == "Mnemesis" and castName == "Defragmentieren" then -- Mnemesis, Defragment
		core:StopBar("DEFRAG")
		core:AddBar("DEFRAG", "~DEFRAG CD", 40, true) -- Defrag is unreliable, but seems to take at least this long.
		core:AddBar("DEFRAG1", "Defrag Explosion", 9, true)
		core:AddMsg("DEFRAG", "DEFRAG", 5, "Beware")
	end
	--Print(eventTime .. " " .. unitName .. " Casting: " .. castName)
end

function mod:OnCombatStateChanged(unit, bInCombat)
	if unit:GetType() == "NonPlayer" and bInCombat then
		local sName = unit:GetName()
		local eventTime = GameLib.GetGameTime()

		if sName == "Viszeralus" then -- Visceralus
			core:AddUnit(unit)
			core:WatchUnit(unit)
			core:AddLine("Visc1", 2, unit, nil, 3, 25, 0, 10)
			core:AddLine("Visc2", 2, unit, nil, 1, 25, 72)
			core:AddLine("Visc3", 2, unit, nil, 1, 25, 144)
			core:AddLine("Visc4", 2, unit, nil, 1, 25, 216)
			core:AddLine("Visc5", 2, unit, nil, 1, 25, 288)
		elseif sName == "Mnemesis" then -- Mnemesis
			self:Start()
			core:WatchUnit(unit)
			uPlayer = GameLib.GetPlayerUnit()
			strMyName = uPlayer:GetName()
			midphase = false
			core:AddUnit(unit)
			core:RaidDebuff()
			core:StartScan()
			core:AddBar("DEFRAG", "~DEFRAG CD", 21, true)
			core:AddBar("ENRAGE", "ENRAGE", 480, true)

			--Print(eventTime .. " FIGHT STARTED")
		end
	end
end
