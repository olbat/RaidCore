----------------------------------------------------------------------------------------------------
-- Client Lua Script for RaidCore Addon on WildStar Game.
--
-- Copyright (C) 2015 RaidCore
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
-- Description:
--   TODO
----------------------------------------------------------------------------------------------------
local core = Apollo.GetPackage("Gemini:Addon-1.1").tPackage:GetAddon("RaidCore")
local mod = core:NewEncounter("WarmongerChuna", 52, 98, 110)
if not mod then return end

----------------------------------------------------------------------------------------------------
-- Registering combat.
----------------------------------------------------------------------------------------------------
mod:RegisterTrigMob("ANY", { "Warmonger Chuna" })
mod:RegisterEnglishLocale({
    -- Unit names.
    ["Warmonger Chuna"] = "Warmonger Chuna",
    ["Conjured Fire Bomb"] = "Conjured Fire Bomb",
    ["Conjured Fire Totem"] = "Conjured Fire Totem",
    -- Cast.
    ["Conjure Fire Elementals"] = "Conjure Fire Elementals",
    ["Fire Room"] = "[DS] Fire Room - Osun (F) - Bubble Block (Target Selection)",
    -- Bar and messages.
    ["Safe Bubble"] = "Safe Bubble",
    ["Bombs"] = "Bombs",
    ["ELEMENTALS SOON"] = "ELEMENTALS SOON",
    ["FIRE ELEMENTALS"] = "FIRE ELEMENTALS",
})
mod:RegisterFrenchLocale({
    -- Unit names.
    ["Warmonger Chuna"] = "Guerroyeuse Chuna",
    ["Conjured Fire Bomb"] = "Bombe incendiaire invoquée",
    ["Conjured Fire Totem"] = "Totem de feu invoqué",
    -- Cast.
    ["Conjure Fire Elementals"] = "Invocation d'Élémentaires de feu",
    ["Fire Room"] = "[DS] Fire Room - Osun (F) - Bubble Block (Target Selection)",
    -- Bar and messages.
    ["Safe Bubble"] = "Bulle Sûre",
    ["Bombs"] = "Bombes",
    ["ELEMENTALS SOON"] = "ÉLÉMENTAIRES BIENTÔT",
    ["FIRE ELEMENTALS"] = "ÉLÉMENTAIRES DE FEU",
})
mod:RegisterGermanLocale({
    -- Unit names.
    ["Warmonger Chuna"] = "Kriegstreiberin Chuna",
    ["Conjured Fire Bomb"] = "Beschworene Feuerbombe",
    -- Cast.
    ["Conjure Fire Elementals"] = "Feuerelementare beschwören",
    -- Bar and messages.
})
-- Timers default configs.
mod:RegisterDefaultTimerBarConfigs({
    ["BOMBS"] = { sColor = "xkcdLightRed" },
    ["TOTEM"] = { sColor = "xkcdBloodOrange" },
    ["BUBBLE"] = { sColor = "xkcdBabyBlue" },
})

----------------------------------------------------------------------------------------------------
-- Constants.
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
-- Locals.
----------------------------------------------------------------------------------------------------
local GetGameTime = GameLib.GetGameTime
local nPreviousBombPopDate, nPreviousTotemPopDate
local bIsFirstFireRoom

----------------------------------------------------------------------------------------------------
-- Encounter description.
----------------------------------------------------------------------------------------------------
function mod:OnBossEnable()
    Apollo.RegisterEventHandler("RC_UnitCreated", "OnUnitCreated", self)
    Apollo.RegisterEventHandler("UNIT_HEALTH", "OnHealthChanged", self)
    Apollo.RegisterEventHandler("SPELL_CAST_START", "OnSpellCastStart", self)
    Apollo.RegisterEventHandler("SPELL_CAST_END", "OnSpellCastEnd", self)

    nPreviousBombPopDate, nPreviousTotemPopDate  = 0, 0
    bIsFirstFireRoom = true
end

function mod:OnUnitCreated(tUnit, sUnitName)
    local nCurrentTime = GetGameTime()

    if self.L["Warmonger Chuna"] == sUnitName then
        core:AddUnit(tUnit)
        core:WatchUnit(tUnit)
    elseif self.L["Conjured Fire Bomb"] == sUnitName then
        if nPreviousBombPopDate + 8 < nCurrentTime then
            mod:AddTimerBar("BOMBS", "Bombs", 22.5)
            nPreviousBombPopDate = nCurrentTime
        end
    elseif self.L["Conjured Fire Totem"] == sUnitName then
        if nPreviousTotemPopDate + 8 < nCurrentTime then
            mod:AddTimerBar("TOTEM", "Conjured Fire Totem", 26)
            nPreviousTotemPopDate = nCurrentTime
        end
    end
end

function mod:OnHealthChanged(sUnitName, nHealth)
    if self.L["Warmonger Chuna"] == sUnitName then
        if nHealth == 67 or nHealth == 34 then
            core:AddMsg("ELEMENTALS", self.L["ELEMENTALS SOON"], 5)
        end
    end
end

function mod:OnSpellCastStart(sUnitName, sCastName, tUnit)
    if self.L["Warmonger Chuna"] == sUnitName then
        if self.L["Conjure Fire Elementals"] == sCastName then
            core:AddMsg("ELEMENTALS", self.L["FIRE ELEMENTALS"], 5)
        elseif self.L["Fire Room"] == sCastName then
            if bIsFirstFireRoom == false then
                core:PlaySound("Long")
            end
            bIsFirstFireRoom = false
        end
    end
end

function mod:OnSpellCastEnd(sUnitName, sCastName, tUnit)
    if self.L["Warmonger Chuna"] == sUnitName then
        if self.L["Fire Room"] == sCastName then
            mod:AddTimerBar("BUBBLE", "Safe Bubble", 50, true)
        end
    end
end
