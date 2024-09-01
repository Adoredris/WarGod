local Druid = WarGod.Class
local KS = LibStub("AceAddon-3.0"):NewAddon("WarGodDruidKindredSpirits", "AceConsole-3.0", "AceEvent-3.0")
--local pi = {}

local GetTime = GetTime
local UnitName = UnitName
local GetSpellInfo = C_Spell.GetSpellInfo
local UnitBuff = UnitBuff

local lastWhisperTime = 0

local WarGod = WarGod

local playerGUID = UnitGUID("player")
local UnitGroupRolesAssigned = UnitGroupRolesAssigned

--local ksPartner =

function GetKSPartnerUnitId()
    if GetSpellInfo("Kindred Spirits").name == "Empower Bond" then
        for i=1,40 do
            local playerName, playerIcon, _, _, _, _, playerSourceUnitId, _, _, playerSpellId = UnitBuff("player",i)
            if playerSpellId == nil then
                return
            end
            if playerSpellId == 326434 then
                return playerSourceUnitId
            end
        end
    end
end

function KSPartnerHasCDUp()
    if GetSpellInfo("Kindred Spirits").name == "Empower Bond" then
        for i=1,40 do
            local playerName, playerIcon, _, _, _, _, playerSourceUnitId, _, _, playerSpellId = UnitBuff("player",i)
            if playerSpellId == nil then
                return
            end
            if GetSpecialization() == 3 then
                return true
            end
            if playerSpellId == 326434 then
                for j=1,40 do
                    local name, playerIcon, _, _, _, _, _, _, _, playerSpellId = UnitBuff(playerSourceUnitId,j)
                    if name == "Empower Rune Weapon" or name == "Army of the Dead" then
                        return true
                    elseif name == "Metamorphosis" then
                        return true
                    elseif name == "Celestial Alignement" or name == "Berserk" or strmatch(name, "^Incarnation") then
                        return true
                    elseif name == "Bestial Wrath" or name == "Aspect of the Wild" or name == "Trueshot" or name == "Coordinated Assault" then
                        return true
                    elseif name == "Icy Veins" or name == "Combustion" or name == "Arcane Power" then
                        return true
                    elseif name == "Storm, Earth, and Fire" then
                        return true
                    elseif name == "Avenging Wrath" then
                        return true
                    elseif name == "Power Infusion" or name == "Voidform" then
                        return true
                    elseif name == "Adrenaline Rush" or name == "Shadow Dance" or name == "Vendetta" then     -- no idea if vendetta is actually a buff on you
                        return true
                    elseif name == "Ascendence" then
                        return true
                    elseif name == "Recklessness" then
                        return true
                    elseif strmatch(name, "^Dark Soul") or name == "Demonic Power" then
                        return true
                    end
                end
            end
        end
    end
end

--[[
local function UnitNameAndServer(unitid)
    local name, server = UnitName(unitid)
    if server ~= nil then
        name = name .. "-" .. server
    end
    return name
end

function PI:UNIT_SPELLCAST_SUCCEEDED(event, unitId, lineId, spellId)
    if spellId == 10060 then
        piTable[UnitNameAndServer(unitId)] = GetTime()
        --print(UnitNameAndServer(unitId) .. " cast PI")
    elseif unitId == "player" then
        local spellName = GetSpellInfo(spellId)
        if (spellName) then
            if spellName == "Force of Nature" then
                print("Disabling Clickies : Cast Trees Once")
                NagaStateOff("NUMPAD5")
            end
        end
    end
end
PI:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")]]