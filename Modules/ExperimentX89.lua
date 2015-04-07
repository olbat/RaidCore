--------------------------------------------------------------------------------
-- Module Declaration
--

local core = Apollo.GetPackage("Gemini:Addon-1.1").tPackage:GetAddon("RaidCore")

local mod = core:NewBoss("ExperimentX89", 67)
if not mod then return end

mod:RegisterEnableMob("Experiment X-89")
mod:RegisterRestrictZone("ExperimentX89", "Isolation Chamber")
mod:RegisterEnableZone("ExperimentX89", "Isolation Chamber")
mod:RegisterEnglishLocale({
	-- Unit names.
	["Experiment X-89"] = "Experiment X-89",
	-- Datachron messages.
	---- This entry is used with string.match, so the dash in X-89 needs to be escaped.
	["Experiment X-89 has placed a bomb"] = "Experiment X%-89 has placed a bomb on (.*)!",
	-- Cast.
	["Shattering Shockwave"] = "Shattering Shockwave",
	["Repugnant Spew"] = "Repugnant Spew",
	["Resounding Shout"] = "Resounding Shout",
	-- Bar and messages.
	["KNOCKBACK !!"] = "KNOCKBACK !!",
	["KNOCKBACK"] = "KNOCKBACK",
	["BEAM !!"] = "BEAM !!",
	["BEAM"] = "BEAM",
	["SHOCKWAVE"] = "SHOCKWAVE",
	["BIG BOMB on YOU !!!"] = "BIG BOMB on YOU !!!",
	["LITTLE BOMB on YOU !!!"] = "LITTLE BOMB on YOU !!!",
	["LITTLE BOMB"] = "LITTLE BOMB",
})
mod:RegisterFrenchLocale({
	-- Unit names.
	["Experiment X-89"] = "Expérience X-89",
	-- Datachron messages.
	---- This entry is used with string.match, so the dash in X-89 needs to be escaped.
--	["Experiment X-89 has placed a bomb"] = "Experiment X%-89 has placed a bomb on (.*)!",	-- TODO: translation missing !!!!
	-- Cast.
	["Shattering Shockwave"] = "Onde de choc dévastatrice",
	["Repugnant Spew"] = "Crachat répugnant",
	["Resounding Shout"] = "Hurlement retentissant",
	-- Bar and messages.
--	["KNOCKBACK !!"] = "KNOCKBACK !!",	-- TODO: translation missing !!!!
--	["KNOCKBACK"] = "KNOCKBACK",	-- TODO: translation missing !!!!
--	["BEAM !!"] = "BEAM !!",	-- TODO: translation missing !!!!
--	["BEAM"] = "BEAM",	-- TODO: translation missing !!!!
--	["SHOCKWAVE"] = "SHOCKWAVE",	-- TODO: translation missing !!!!
--	["BIG BOMB on YOU !!!"] = "BIG BOMB on YOU !!!",	-- TODO: translation missing !!!!
--	["LITTLE BOMB on YOU !!!"] = "LITTLE BOMB on YOU !!!",	-- TODO: translation missing !!!!
--	["LITTLE BOMB"] = "LITTLE BOMB",	-- TODO: translation missing !!!!
})
mod:RegisterGermanLocale({
	-- Unit names.
	["Experiment X-89"] = "Experiment X-89",
	-- Datachron messages.
	---- This entry is used with string.match, so the dash in X-89 needs to be escaped.
--	["Experiment X-89 has placed a bomb"] = "Experiment X%-89 has placed a bomb on (.*)!",	-- TODO: translation missing !!!!
	-- Cast.
	["Shattering Shockwave"] = "Zerschmetternde Schockwelle",
	["Repugnant Spew"] = "Widerliches Erbrochenes",
	["Resounding Shout"] = "Widerhallender Schrei",
	-- Bar and messages.
--	["KNOCKBACK !!"] = "KNOCKBACK !!",	-- TODO: translation missing !!!!
--	["KNOCKBACK"] = "KNOCKBACK",	-- TODO: translation missing !!!!
--	["BEAM !!"] = "BEAM !!",	-- TODO: translation missing !!!!
--	["BEAM"] = "BEAM",	-- TODO: translation missing !!!!
--	["SHOCKWAVE"] = "SHOCKWAVE",	-- TODO: translation missing !!!!
--	["BIG BOMB on YOU !!!"] = "BIG BOMB on YOU !!!",	-- TODO: translation missing !!!!
--	["LITTLE BOMB on YOU !!!"] = "LITTLE BOMB on YOU !!!",	-- TODO: translation missing !!!!
--	["LITTLE BOMB"] = "LITTLE BOMB",	-- TODO: translation missing !!!!
})

--------------------------------------------------------------------------------
-- Locals
--

local playerName

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	Print(("Module %s loaded"):format(mod.ModuleName))
	Apollo.RegisterEventHandler("RC_UnitStateChanged", "OnUnitStateChanged", self)
	Apollo.RegisterEventHandler("CHAT_DATACHRON", "OnChatDC", self)
	Apollo.RegisterEventHandler("SPELL_CAST_START", "OnSpellCastStart", self)
	Apollo.RegisterEventHandler("DEBUFF_APPLIED", "OnDebuffApplied", self)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:OnSpellCastStart(unitName, castName, unit)
	if unitName == self.L["Experiment X-89"] then
		if castName == self.L["Resounding Shout"] then
			core:AddMsg("KNOCKBACK", self.L["KNOCKBACK !!"], 5, "Alert")
			core:AddBar("KNOCKBACK", self.L["KNOCKBACK"], 23)
		elseif castName == self.L["Repugnant Spew"] then
			core:AddMsg("BEAM", self.L["BEAM !!"], 5, "Alarm")
			core:AddBar("BEAM", self.L["BEAM"], 40)
		elseif castName == self.L["Shattering Shockwave"] then
			core:AddBar("SHOCKWAVE", self.L["SHOCKWAVE"], 19)
		end
	end
end

function mod:OnChatDC(message)
	-- The dash in X-89 needs to be escaped, by adding a % in front of it.
	-- The value returned is the player name targeted by the boss.
	local pName = message:match(self.L["Experiment X-89 has placed a bomb"])
	if pName and pName == playerName then
		core:AddMsg("BIGB", self.L["BIG BOMB on YOU !!!"], 5, "Destruction", "Blue")
	end
end

function mod:OnDebuffApplied(unitName, splId, unit)
	if splId == 47316 then
		core:AddMsg("LITTLEB", self.L["LITTLE BOMB on YOU !!!"], 5, "RunAway", "Blue")
		core:AddBar("LITTLEB", self.L["LITTLE BOMB"], 5, 1)
	end
end

function mod:OnUnitStateChanged(unit, bInCombat, sName)
	if unit:GetType() == "NonPlayer" and bInCombat then
		if sName == self.L["Experiment X-89"] then
			self:Start()
			local playerUnit = GameLib.GetPlayerUnit()
			playerName = playerUnit:GetName()
			core:AddUnit(unit)
			core:UnitDebuff(playerUnit)
			core:WatchUnit(unit)
			core:StartScan()
			core:AddBar("KNOCKBACK", self.L["KNOCKBACK"], 6)
			core:AddBar("SHOCKWAVE", self.L["SHOCKWAVE"], 17)
			core:AddBar("BEAM", self.L["BEAM"], 36)
		end
	end
end
