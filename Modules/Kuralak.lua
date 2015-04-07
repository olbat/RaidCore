--------------------------------------------------------------------------------
-- Module Declaration
--

local core = Apollo.GetPackage("Gemini:Addon-1.1").tPackage:GetAddon("RaidCore")

local mod = core:NewBoss("Kuralak", 67)
if not mod then return end

mod:RegisterEnableMob("Kuralak the Defiler")
mod:RegisterRestrictZone("Kuralak", "Archive Access Core")
mod:RegisterEnableZone("Kuralak", "Archive Access Core")
mod:RegisterEnglishLocale({
	-- Unit names.
	["Kuralak the Defiler"] = "Kuralak the Defiler",
	-- Datachron messages.
	["Kuralak the Defiler returns to the Archive Core"] = "Kuralak the Defiler returns to the Archive Core",
	["Kuralak the Defiler causes a violent outbreak of corruption"] = "Kuralak the Defiler causes a violent outbreak of corruption",
	["The corruption begins to fester"] = "The corruption begins to fester",
	["has been anesthetized"] = "has been anesthetized",
	-- NPCSay messages.
	["Through the Strain you will be transformed"] = "Through the Strain you will be transformed",
	["Your form is flawed, but I will make you beautiful"] = "Your form is flawed, but I will make you beautiful",
	["Let the Strain perfect you"] = "Let the Strain perfect you",
	["The Experiment has failed"] = "The Experiment has failed",
	["Join us... become one with the Strain"] = "Join us... become one with the Strain",
	["One of us... you will become one of us"] = "One of us... you will become one of us",
	-- Cast.
	["Vanish into Darkness"] = "Vanish into Darkness",
	-- Bar and messages.
	["P2 SOON !"] = "P2 SOON !",
	["PHASE 2 !"] = "PHASE 2 !",
	["VANISH"] = "VANISH",
	["Vanish"] = "Vanish",
	["OUTBREAK"] = "OUTBREAK",
	["Outbreak (%s)"] = "Outbreak (%s)",
	["EGGS (%s)"] = "EGGS (%s)",
	["Eggs (%s)"] = "Eggs (%s)",
	["BERSERK !!"] = "BERSERK !!",
	["SWITCH TANK"] = "SWITCH TANK",
	["Switch Tank (%s)"] = "Switch Tank (%s)",
	["MARKER north"] = "N",
	["MARKER south"] = "S",
	["MARKER east"] = "E",
	["MARKER west"] = "W",
})
mod:RegisterFrenchLocale({
	-- Unit names.
	["Kuralak the Defiler"] = "Kuralak la Profanatrice",
	-- Datachron messages.
--	["Kuralak the Defiler returns to the Archive Core"] = "Kuralak the Defiler returns to the Archive Core",	-- TODO: translation missing !!!!
--	["Kuralak the Defiler causes a violent outbreak of corruption"] = "Kuralak the Defiler causes a violent outbreak of corruption",	-- TODO: translation missing !!!!
--	["The corruption begins to fester"] = "The corruption begins to fester",	-- TODO: translation missing !!!!
--	["has been anesthetized"] = "has been anesthetized",	-- TODO: translation missing !!!!
	-- NPCSay messages.
--	["Through the Strain you will be transformed"] = "Through the Strain you will be transformed",	-- TODO: translation missing !!!!
--	["Your form is flawed, but I will make you beautiful"] = "Your form is flawed, but I will make you beautiful",	-- TODO: translation missing !!!!
--	["Let the Strain perfect you"] = "Let the Strain perfect you",	-- TODO: translation missing !!!!
--	["The Experiment has failed"] = "The Experiment has failed",	-- TODO: translation missing !!!!
--	["Join us... become one with the Strain"] = "Join us... become one with the Strain",	-- TODO: translation missing !!!!
--	["One of us... you will become one of us"] = "One of us... you will become one of us",	-- TODO: translation missing !!!!
	-- Cast.
	["Vanish into Darkness"] = "Disparaître dans les ténèbres",
	-- Bar and messages.
--	["P2 SOON !"] = "P2 SOON !",	-- TODO: translation missing !!!!
--	["PHASE 2 !"] = "PHASE 2 !",	-- TODO: translation missing !!!!
--	["VANISH"] = "VANISH",	-- TODO: translation missing !!!!
	["Vanish"] = "Disparition",
--	["OUTBREAK"] = "OUTBREAK",	-- TODO: translation missing !!!!
--	["Outbreak (%s)"] = "Outbreak (%s)",	-- TODO: translation missing !!!!
--	["EGGS (%s)"] = "EGGS (%s)",	-- TODO: translation missing !!!!
--	["Eggs (%s)"] = "Eggs (%s)",	-- TODO: translation missing !!!!
--	["BERSERK !!"] = "BERSERK !!",	-- TODO: translation missing !!!!
--	["SWITCH TANK"] = "SWITCH TANK",	-- TODO: translation missing !!!!
--	["Switch Tank (%s)"] = "Switch Tank (%s)",	-- TODO: translation missing !!!!
--	["MARKER north"] = "N",	-- TODO: translation missing !!!!
--	["MARKER south"] = "S",	-- TODO: translation missing !!!!
--	["MARKER east"] = "E",	-- TODO: translation missing !!!!
--	["MARKER west"] = "W",	-- TODO: translation missing !!!!
})
mod:RegisterGermanLocale({
	-- Unit names.
	["Kuralak the Defiler"] = "Kuralak die Schänderin",
	-- Datachron messages.
--	["Kuralak the Defiler returns to the Archive Core"] = "Kuralak the Defiler returns to the Archive Core",	-- TODO: translation missing !!!!
--	["Kuralak the Defiler causes a violent outbreak of corruption"] = "Kuralak the Defiler causes a violent outbreak of corruption",	-- TODO: translation missing !!!!
--	["The corruption begins to fester"] = "The corruption begins to fester",	-- TODO: translation missing !!!!
--	["has been anesthetized"] = "has been anesthetized",	-- TODO: translation missing !!!!
	-- NPCSay messages.
--	["Through the Strain you will be transformed"] = "Through the Strain you will be transformed",	-- TODO: translation missing !!!!
--	["Your form is flawed, but I will make you beautiful"] = "Your form is flawed, but I will make you beautiful",	-- TODO: translation missing !!!!
--	["Let the Strain perfect you"] = "Let the Strain perfect you",	-- TODO: translation missing !!!!
--	["The Experiment has failed"] = "The Experiment has failed",	-- TODO: translation missing !!!!
--	["Join us... become one with the Strain"] = "Join us... become one with the Strain",	-- TODO: translation missing !!!!
--	["One of us... you will become one of us"] = "One of us... you will become one of us",	-- TODO: translation missing !!!!
	-- Cast.
	["Vanish into Darkness"] = "In der Dunkelheit verschwinden",
	-- Bar and messages.
--	["P2 SOON !"] = "P2 SOON !",	-- TODO: translation missing !!!!
--	["PHASE 2 !"] = "PHASE 2 !",	-- TODO: translation missing !!!!
--	["VANISH"] = "VANISH",	-- TODO: translation missing !!!!
	["Vanish"] = "Verschwinden",
--	["OUTBREAK"] = "OUTBREAK",	-- TODO: translation missing !!!!
--	["Outbreak (%s)"] = "Outbreak (%s)",	-- TODO: translation missing !!!!
--	["EGGS (%s)"] = "EGGS (%s)",	-- TODO: translation missing !!!!
--	["Eggs (%s)"] = "Eggs (%s)",	-- TODO: translation missing !!!!
--	["BERSERK !!"] = "BERSERK !!",	-- TODO: translation missing !!!!
--	["SWITCH TANK"] = "SWITCH TANK",	-- TODO: translation missing !!!!
--	["Switch Tank (%s)"] = "Switch Tank (%s)",	-- TODO: translation missing !!!!
--	["MARKER north"] = "N",	-- TODO: translation missing !!!!
--	["MARKER south"] = "S",	-- TODO: translation missing !!!!
--	["MARKER east"] = "E",	-- TODO: translation missing !!!!
--	["MARKER west"] = "W",	-- TODO: translation missing !!!!
})

--------------------------------------------------------------------------------
-- Locals
--

local eggsCount, siphonCount, outbreakCount = 0, 0, 0

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	Print(("Module %s loaded"):format(mod.ModuleName))
	Apollo.RegisterEventHandler("RC_UnitStateChanged", "OnUnitStateChanged", self)
	Apollo.RegisterEventHandler("UNIT_HEALTH", "OnHealthChanged", self)
	Apollo.RegisterEventHandler("CHAT_DATACHRON", "OnChatDC", self)
	Apollo.RegisterEventHandler("CHAT_NPCSAY", "OnChatNPCSay", self)
	Apollo.RegisterEventHandler("DEBUFF_APPLIED", "OnDebuffApplied", self)
	Apollo.RegisterEventHandler("RC_UnitCreated", "OnUnitCreated", self)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:OnUnitCreated(unit, sName)
	if sName == self.L["Kuralak the Defiler"] then
		core:AddUnit(unit)
	end
end

function mod:OnHealthChanged(unitName, health)
	if health == 74 and unitName == self.L["Kuralak the Defiler"] then
		core:AddMsg("P2", self.L["P2 SOON !"], 5, "Info")
	end
end

function mod:OnChatDC(message)
	if message:find(self.L["Kuralak the Defiler returns to the Archive Core"]) then
		core:AddMsg("VANISH", self.L["VANISH"], 5, "Alert")
		core:AddBar("VANISH", self.L["Vanish"], 47, 1)
	elseif message:find(self.L["Kuralak the Defiler causes a violent outbreak of corruption"]) then
		core:AddMsg("OUTBREAK", self.L["OUTBREAK"], 5, "RunAway")
		outbreakCount = outbreakCount + 1
		if outbreakCount <= 5 then
			core:AddBar("OUTBREAK", (self.L["Outbreak (%s)"]):format(outbreakCount + 1), 45)
		end
		if outbreakCount == 4 then
			core:StopScan()
		end
	elseif message:find(self.L["The corruption begins to fester"]) then
		if eggsCount < 2 then eggsCount = 2 end
		core:AddMsg("EGGS", (self.L["EGGS (%s)"]):format(math.pow(2, eggsCount-1)), 5, "Alert")
		eggsCount = eggsCount + 1
		if eggsCount == 5 then
			core:AddBar("EGGS", self.L["BERSERK !!"], 66)
			eggsCount = 2
		else
			core:AddBar("EGGS", (self.L["Eggs (%s)"]):format(math.pow(2, eggsCount-1)), 66)
		end
	elseif message:find(self.L["has been anesthetized"]) then
		if siphonCount == 0 then siphonCount = 1 end
		siphonCount = siphonCount + 1
		if self:Tank() then
			core:AddMsg("SIPHON", self.L["SWITCH TANK"], 5, "Alarm")
			if siphonCount < 4 then
				core:AddBar("SIPHON", (self.L["Switch Tank (%s)"]):format(siphonCount), 88)
			end
		end
	end
end

function mod:OnChatNPCSay(message)
		if message:find(self.L["Through the Strain you will be transformed"])
		or message:find(self.L["Your form is flawed, but I will make you beautiful"])
		or message:find(self.L["Let the Strain perfect you"])
		or message:find(self.L["The Experiment has failed"])
		or message:find(self.L["Join us... become one with the Strain"])
		or message:find(self.L["One of us... you will become one of us"]) then
			eggsCount, siphonCount, outbreakCount = 2, 1, 0
			core:StopBar(self.L["VANISH"])
			core:AddMsg("KP2", self.L["PHASE 2 !"], 5, "Alert")
			core:AddBar("OUTBREAK", (self.L["Outbreak (%s)"]):format(outbreakCount + 1), 15)
			core:AddBar("EGGS", (self.L["Eggs (%s)"]):format(eggsCount), 73)
			if self:Tank() then
				core:AddBar("SIPHON", (self.L["Switch Tank (%s)"]):format(siphonCount), 37)
			end
			local estpos = { x = 194.44, y = -110.80034637451, z = -483.20 }
			core:SetWorldMarker(estpos, self.L["MARKER east"])
			local sudpos = { x = 165.79222106934, y = -110.80034637451, z = -464.8489074707 }
			core:SetWorldMarker(sudpos, self.L["MARKER south"])
			local ouestpos = { x = 144.20, y = -110.80034637451, z = -494.38 }
			core:SetWorldMarker(ouestpos, self.L["MARKER west"])
			local nordpos = { x = 175.00, y = -110.80034637451, z = -513.31 }
			core:SetWorldMarker(nordpos, self.L["MARKER north"])
			core:RaidDebuff()
			core:StartScan()
		end
end

function mod:OnDebuffApplied(unitName, splId, unit)
	if splId == 56652 then
		core:MarkUnit(unit)
		core:AddUnit(unit)
	end
end

function mod:OnUnitStateChanged(unit, bInCombat, sName)
	if unit:GetType() == "NonPlayer" and bInCombat then
		if sName == self.L["Kuralak the Defiler"] then
			self:Start()
			core:AddUnit(unit)
			eggsCount, siphonCount, outbreakCount = 2, 1, 0
		end
	end
end
