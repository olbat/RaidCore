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
local mod = core:NewEncounter("EpLogicWater", 52, 98, 118)
if not mod then return end

----------------------------------------------------------------------------------------------------
-- Registering combat.
----------------------------------------------------------------------------------------------------
mod:RegisterTrigMob("ALL", { "Hydroflux", "Mnemesis" })
mod:RegisterEnglishLocale({
    -- Unit names.
    ["Mnemesis"] = "Mnemesis",
    ["Hydroflux"] = "Hydroflux",
    ["Alphanumeric Hash"] = "Alphanumeric Hash",
    ["Hydro Disrupter - DNT"] = "Hydro Disrupter - DNT",
    -- Cast.
    ["Circuit Breaker"] = "Circuit Breaker",
    ["Imprison"] = "Imprison",
    ["Defragment"] = "Defragment",
    ["Watery Grave"] = "Watery Grave",
    ["Tsunami"] = "Tsunami",
    -- Bar and messages.
    ["Middle Phase"] = "Middle Phase",
    ["SPREAD"] = "SPREAD",
    ["~Defrag"] = "~Defrag",
    ["~Imprison"] = "~Imprison",
    ["ORB"] = "ORB",
})
mod:RegisterFrenchLocale({
    -- Unit names.
    ["Mnemesis"] = "Mnémésis",
    ["Hydroflux"] = "Hydroflux",
    ["Alphanumeric Hash"] = "Alphanumeric Hash",
    ["Hydro Disrupter - DNT"] = "Hydro-disrupteur - DNT",
    -- Cast.
    ["Circuit Breaker"] = "Coupe-circuit",
    ["Imprison"] = "Emprisonner",
    ["Defragment"] = "Défragmentation",
    ["Watery Grave"] = "Tombe aqueuse",
    ["Tsunami"] = "Tsunami",
    -- Bar and messages.
    ["Middle Phase"] = "Phase du Milieu",
    ["SPREAD"] = "SEPAREZ-VOUS",
    ["~Defrag"] = "~Defrag",
    ["~Imprison"] = "~Emprisonner",
    ["ORB"] = "ORB",
})
mod:RegisterGermanLocale({
    -- Unit names.
    ["Mnemesis"] = "Mnemesis",
    ["Hydroflux"] = "Hydroflux",
    ["Alphanumeric Hash"] = "Alphanumerische Raute",
    --["Hydro Disrupter - DNT"] = "Hydro Disrupter - DNT", -- TODO: German translation missing !!!!
    -- Cast.
    ["Circuit Breaker"] = "Schaltkreiszerstörer",
    ["Imprison"] = "Einsperren",
    ["Defragment"] = "Defragmentieren",
    ["Watery Grave"] = "Seemannsgrab",
    -- Bar and messages.
    --["Middle Phase"] = "Middle Phase", -- TODO: German translation missing !!!!
    --["SPREAD"] = "SPREAD", -- TODO: German translation missing !!!!
    --["~Defrag"] = "~Defrag", -- TODO: German translation missing !!!!
    ["~Imprison"] = "~Einsperren",
    --["ORB"] = "ORB", -- TODO: German translation missing !!!!
})
-- Default settings.
mod:RegisterDefaultSetting("SoundDefrag")
mod:RegisterDefaultSetting("SoundDataDisruptorDebuff")
mod:RegisterDefaultSetting("SoundMidphaseCountDown")
mod:RegisterDefaultSetting("OtherWateryGraveTimer")
mod:RegisterDefaultSetting("OtherOrbMarkers")
mod:RegisterDefaultSetting("LineTetrisBlocks")
mod:RegisterDefaultSetting("LineOrbs")
mod:RegisterDefaultSetting("LineCleaveHydroflux")
-- Timers default configs.
mod:RegisterDefaultTimerBarConfigs({
    ["MIDPHASE"] = { sColor = "xkcdAlgaeGreen" },
    ["PRISON"] = { sColor = "xkcdBluegreen" },
    ["GRAVE"] = { sColor = "xkcdBloodRed" },
    ["DEFRAG"] = { sColor = "xkcdBarneyPurple" },
})

----------------------------------------------------------------------------------------------------
-- Constants.
----------------------------------------------------------------------------------------------------
local DEBUFFID_DATA_DISRUPTOR = 78407

----------------------------------------------------------------------------------------------------
-- Locals.
----------------------------------------------------------------------------------------------------
local GetPlayerUnit = GameLib.GetPlayerUnit
local GetGameTime = GameLib.GetGameTime
local nMnemesisId
local midphase = false

----------------------------------------------------------------------------------------------------
-- Encounter description.
----------------------------------------------------------------------------------------------------
function mod:OnBossEnable()
    Apollo.RegisterEventHandler("RC_UnitCreated", "OnUnitCreated", self)
    Apollo.RegisterEventHandler("RC_UnitDestroyed", "OnUnitDestroyed", self)
    Apollo.RegisterEventHandler("SPELL_CAST_START", "OnSpellCastStart", self)
    Apollo.RegisterEventHandler("SPELL_CAST_END", "OnSpellCastEnd", self)
    Apollo.RegisterEventHandler("DEBUFF_APPLIED", "OnDebuffApplied", self)
    Apollo.RegisterEventHandler("DEBUFF_REMOVED", "OnDebuffRemoved", self)

    midphase = false
    nMnemesisId = nil
    mod:AddTimerBar("MIDPHASE", "Middle Phase", 75, mod:GetSetting("SoundMidphaseCountDown"))
    mod:AddTimerBar("PRISON", "Imprison", 33)
    mod:AddTimerBar("DEFRAG", "~Defrag", 16, mod:GetSetting("SoundDefrag"))
    if mod:GetSetting("OtherWateryGraveTimer") then
        mod:AddTimerBar("GRAVE", "Watery Grave", 10)
    end
end

function mod:OnSpellCastStart(unitName, castName, unit)
    if unitName == self.L["Mnemesis"] then
        if castName == self.L["Circuit Breaker"] then
            midphase = true
            mod:RemoveTimerBar("PRISON")
            mod:RemoveTimerBar("DEFRAG")
            mod:AddTimerBar("MIDPHASE", "Circuit Breaker", 25, mod:GetSetting("SoundMidphaseCountDown"))
        elseif castName == self.L["Imprison"] then
            mod:RemoveTimerBar("PRISON")
        elseif castName == self.L["Defragment"] then
            core:AddMsg("DEFRAG", self.L["SPREAD"], 5, mod:GetSetting("SoundDefrag") and "Beware")
            mod:AddTimerBar("DEFRAG", "~Defrag", 36, mod:GetSetting("SoundDefrag"))
        end
    elseif unitName == self.L["Hydroflux"] then
        if castName == self.L["Watery Grave"] then
            if mod:GetSetting("OtherWateryGraveTimer") then
                mod:AddTimerBar("GRAVE", "Watery Grave", 10)
            end
        elseif self.L["Tsunami"] == castName then
            mod:RemoveTimerBar("GRAVE")
        end
    end
end

function mod:OnSpellCastEnd(unitName, castName)
    if unitName == self.L["Mnemesis"] then
        if castName == self.L["Circuit Breaker"] then
            midphase = false
            mod:AddTimerBar("MIDPHASE", "Middle Phase", 90, mod:GetSetting("SoundMidphaseCountDown"))
            mod:AddTimerBar("PRISON", "Imprison", 25)
        end
    end
end

function mod:OnDebuffApplied(unitName, splId, unit)
    if splId == DEBUFFID_DATA_DISRUPTOR then
        if unit == GetPlayerUnit() then
            if mod:GetSetting("SoundDataDisruptorDebuff") then
               core:PlaySound("Beware")
           end
        end
        if mod:GetSetting("OtherOrbMarkers") then
            core:MarkUnit(unit, nil, self.L["ORB"])
        end
    end
end

function mod:OnDebuffRemoved(unitName, splId, unit)
    if splId == DEBUFFID_DATA_DISRUPTOR then
        local unitId = unit:GetId()
        if unitId then
            core:DropMark(unit:GetId())
        end
    end
end

function mod:OnUnitCreated(unit, sName)
    local nUnitId = unit:GetId()

    if sName == self.L["Alphanumeric Hash"] then
        if nUnitId and mod:GetSetting("LineTetrisBlocks") then
            core:AddPixie(nUnitId, 2, unit, nil, "Red", 10, 20, 0)
        end
    elseif sName == self.L["Hydro Disrupter - DNT"] then
        if nUnitId and not midphase and mod:GetSetting("LineOrbs") then
            core:AddPixie(nUnitId, 1, unit, GetPlayerUnit(), "Blue", 5, 10, 10)
        end
    elseif sName == self.L["Hydroflux"] then
        core:AddUnit(unit)
        core:WatchUnit(unit)
        if mod:GetSetting("LineCleaveHydroflux") then
            core:AddPixie("Hydro_1", 2, unit, nil, "Yellow", 3, 7, 0)
            core:AddPixie("Hydro_2", 2, unit, nil, "Yellow", 3, 7, 180)
        end
    elseif sName == self.L["Mnemesis"] then
        if nUnitId and (nMnemesisId == nil or nMnemesisId == nUnitId) then
            -- A filter is needed, because there is many unit called Mnemesis.
            -- Only the first is the good.
            nMnemesisId = nUnitId
            core:AddUnit(unit)
            core:WatchUnit(unit)
        end
    end
end

function mod:OnUnitDestroyed(unit, sName)
    local nUnitId = unit:GetId()
    if sName == self.L["Alphanumeric Hash"] then
        if nUnitId then
            core:DropPixie(nUnitId)
        end
    elseif sName == self.L["Hydro Disrupter - DNT"] then
        if nUnitId then
            core:DropPixie(nUnitId)
        end
    end
end
