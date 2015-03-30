--------------------------------------------------------------------------------
-- Module Declaration
--

local core = Apollo.GetPackage("Gemini:Addon-1.1").tPackage:GetAddon("RaidCore")

local mod = core:NewBoss("ExperimentX89", 67)
if not mod then return end

mod:RegisterEnableMob("Expérience X-89") -- "Experiment X-89"
mod:RegisterRestrictZone("ExperimentX89", "Isolation Chamber") -- !!! "Isolation Chamber"
mod:RegisterEnableZone("ExperimentX89", "Isolation Chamber") -- !!! "Isolation Chamber"

--------------------------------------------------------------------------------
-- Locals
--

local playerName

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	Print(("Module %s loaded"):format(mod.ModuleName))
	Apollo.RegisterEventHandler("UnitEnteredCombat", 		"OnCombatStateChanged", 	self)
	Apollo.RegisterEventHandler("CHAT_DATACHRON", 		"OnChatDC", 				self)
	Apollo.RegisterEventHandler("SPELL_CAST_START", 		"OnSpellCastStart", self)
	Apollo.RegisterEventHandler("DEBUFF_APPLIED", 			"OnDebuffApplied", 			self)
end


--------------------------------------------------------------------------------
-- Event Handlers
--


function mod:OnSpellCastStart(unitName, castName, unit)
	if unitName == "Expérience X-89" and castName == "Hurlement retentissant" then -- "Experiment X-89", "Resounding Shout"
		core:AddMsg("KNOCKBACK", "KNOCKBACK !!", 5, "Alert")
		core:AddBar("KNOCKBACK", "KNOCKBACK", 23)
	elseif unitName == "Expérience X-89" and castName == "Crachat répugnant" then -- "Experiment X-89", "Repugnant Spew"
		core:AddMsg("BEAM", "BEAM !!", 5, "Alarm")
		core:AddBar("BEAM", "BEAM", 40)
	elseif unitName == "Expérience X-89" and castName == "Onde de choc dévastatrice" then -- "Experiment X-89", "Shattering Shockwave"
		core:AddBar("SHOCKWAVE", "SHOCKWAVE", 19)
	end
end

function mod:OnChatDC(message)
	-- the dash in X-89 needs to be escaped... they are magic symbols in lua
	-- can be escaped by adding a % in front of it.
	if message:find("Experiment X%-89 has placed a bomb") then -- !!! "Experiment X%-89 has placed a bomb"
		local pName = string.gsub(string.sub(message, 38), "!", "")
		if pName == playerName then
			core:AddMsg("BIGB", "BIG BOMB on YOU !!!", 5, "Destruction", "Blue")
		end
	end
end

function mod:OnDebuffApplied(unitName, splId, unit)
	if splId == 47316 then
		core:AddMsg("LITTLEB", "LITTLE BOMB on YOU !!!", 5, "RunAway", "Blue")
		core:AddBar("LITTLEB", "LITTLE BOMB", 5, 1)
	end
end


function mod:OnCombatStateChanged(unit, bInCombat)
	if unit:GetType() == "NonPlayer" and bInCombat then
		local sName = unit:GetName()
		if sName == "Expérience X-89" then -- "Experiment X-89"
			self:Start()
			playerName = GameLib.GetPlayerUnit():GetName()
			core:AddUnit(unit)
			core:UnitDebuff(GameLib.GetPlayerUnit())
			core:WatchUnit(unit)
			core:StartScan()
			core:AddBar("KNOCKBACK", "KNOCKBACK", 6)
			core:AddBar("SHOCKWAVE", "SHOCKWAVE", 17)
			core:AddBar("BEAM", "BEAM", 36)
		end
	end
end
