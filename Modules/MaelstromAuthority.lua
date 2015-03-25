--------------------------------------------------------------------------------
-- Module Declaration
--

local core = Apollo.GetPackage("Gemini:Addon-1.1").tPackage:GetAddon("RaidCore")

local mod = core:NewBoss("MaelstromAuthority", 52)
if not mod then return end

mod:RegisterEnableMob("Weather Control Station") -- Weather Control Station

--------------------------------------------------------------------------------
-- Locals
--

local prev = 0
local stationCount = 0
local bossPos = {}


--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	Print(("Module %s loaded"):format(mod.ModuleName))
	Apollo.RegisterEventHandler("UnitCreated", 			"OnUnitCreated", self)
	Apollo.RegisterEventHandler("UnitDestroyed", 		"OnUnitDestroyed", self)
	Apollo.RegisterEventHandler("UnitEnteredCombat", 	"OnCombatStateChanged", self)
	Apollo.RegisterEventHandler("SPELL_CAST_START", 	"OnSpellCastStart", self)
	Apollo.RegisterEventHandler("CHAT_DATACHRON", 		"OnChatDC", self)
end


--------------------------------------------------------------------------------
-- Event Handlers
--


function mod:OnUnitCreated(unit)
	local sName = unit:GetName()
	--Print(sName)
	if sName == "Avatus Hologram" then -- Avatus Hologram
		self:Start()
		core:AddBar("JUMP", "JUMP", 8.5, 1)
		bossPos = {}
	elseif sName == "Windwand" then -- Wind Wall
		core:AddPixie(unit:GetId().."_1", 2, unit, nil, "Green", 10, 20, 0)
		core:AddPixie(unit:GetId().."_2", 2, unit, nil, "Green", 10, 20, 180)
		--core:AddLine(unit:GetId().."_1", 2, unit, nil, 1, 20, 0)
		--core:AddLine(unit:GetId().."_2", 2, unit, nil, 1, 20, 180)
	elseif sName == "Wetterstation" then -- Weather Station
		-- Todo see if we can concat position to display in unit monitor.
		local stationPos = unit:GetPosition()
		--local Rover = Apollo.GetAddon("Rover")
		--Rover:AddWatch("stationPos", stationPos, 0)
		--local posStr = (stationPos.z > bossPos.z) and "S" or "N", (stationPos.x > bossPos.x) and "E" or "W"
		core:AddUnit(unit)
		local playerUnit = GameLib.GetPlayerUnit()
		core:AddPixie(unit:GetId(), 1, playerUnit, unit, "Blue", 5, 10, 10)
	end
end

function mod:OnUnitDestroyed(unit)
	local sName = unit:GetName()
	--Print(sName)
	if sName == "Windwand" then -- Wind Wall
		--core:DropLine(unit:GetId().."_1")
		--core:DropLine(unit:GetId().."_2")
		core:DropPixie(unit:GetId().."_1")
		core:DropPixie(unit:GetId().."_2")
	elseif sName == "Wetterstation" then -- Weather Station
		core:DropPixie(unit:GetId())
	end
end


function mod:OnSpellCastStart(unitName, castName, unit)
	if unitName == "Mahlstromgewalt" and castName == "Wetterzyklus aktivieren" then -- Maelstrom Authority, Activate Weather Cycle
		bossPos = unit:GetPosition()
		--local Rover = Apollo.GetAddon("Rover")
		--Rover:AddWatch("bossPoss", bossPos, 0)
		stationCount = 0
		core:AddBar("STATION", ("[%s] STATION"):format(stationCount + 1), 13)
	elseif unitName == "Mahlstromgewalt" and castName == "Eisatem" then -- Maelstrom Authority, Ice Breath
		core:AddMsg("BREATH", "ICE BREATH", 5, "RunAway")
	elseif unitName == "Mahlstromgewalt" and castName == "Kristallisieren" then -- Maelstrom Authority, Crystallize
		core:AddMsg("BREATH", "ICE BREATH", 5, "Beware")
	elseif unitName == "Mahlstromgewalt" and castName == "Taifun" then -- Maelstrom Authority, Typhoon
		core:AddMsg("BREATH", "TYPHOON", 5, "Beware")
	end
end


function mod:OnChatDC(message)
	if message:find("The platform trembles") then -- The platform trembles
		core:AddBar("JUMP", "JUMP", 7, 14)
	end
end


function mod:OnCombatStateChanged(unit, bInCombat)
	if unit:GetType() == "NonPlayer" and bInCombat then
		local sName = unit:GetName()

		if sName == "Mahlstromgewalt" then -- Maelstrom Authority
			stationCount = 0
			core:AddUnit(unit)
			core:WatchUnit(unit)
			core:StartScan()
			core:AddPixie(unit:GetId(), 2, unit, nil, "Red", 10, 15, 0)
		elseif sName == "Wetterstation" then -- Weather Station
			stationCount = stationCount + 1
			local station_name = "STATION" .. tostring(stationCount)

			local posStr = ""
			local stationPos = unit:GetPosition()
			if stationPos and bossPos then
				core:AddMsg(station_name, ("[%s] STATION : %s %s"):format(stationCount, (stationPos.z > bossPos.z) and "SOUTH" or "NORTH", (stationPos.x > bossPos.x) and "EAST" or "WEST"), 5, "Info", "Blue")
			else
				core:AddMsg(station_name, ("[%s] STATION"):format(stationCount), 5, "Info", "Blue")
			end
			core:AddBar(station_name, ("[%s] STATION"):format(stationCount + 1), 10)				
		end
	end
end
