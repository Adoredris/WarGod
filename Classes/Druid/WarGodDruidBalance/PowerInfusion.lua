local Druid = WarGod.Class
local PI = LibStub("AceAddon-3.0"):NewAddon("WarGodDruidPowerInfusion", "AceConsole-3.0", "AceEvent-3.0")
local pi = {}

local GetTime = GetTime
local UnitName = UnitName

local lastWhisperTime = 0

local WarGod = WarGod

local playerGUID = UnitGUID("player")
local UnitGroupRolesAssigned = UnitGroupRolesAssigned

local GetSpellInfo = C_Spell.GetSpellInfo

local piTable = {}

PISpam = false
PISpecific = "Sabeena"

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
    --[[elseif unitId == "player" then
        local spellName = GetSpellInfo(spellId).name
        if (spellName) then
            if spellName == "Force of Nature" then
                print("Disabling Clickies : Cast Trees Once")
                NagaStateOff("NUMPAD5")
            end
        end]]
    end
end
PI:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")


--[[
function PI:COMBAT_LOG_EVENT_UNFILTERED(event)
    local timestamp, eventname, flagthatidunno, sourceGUID, sourceName, sourceflags, sourceRaidFlags, destGUID, destName, destflags, destRaidFlags, spellId, spellName, spellschool, auraType = CombatLogGetCurrentEventInfo()
    if PISpam and playerGUID == destGUID and GetSpecialization() == 1 then
        if eventname == "SPELL_AURA_APPLIED_DOSE" then
            if GetTime() > lastWhisperTime + 30 then
                if spellName == "Ravenous Frenzy" then
                    if WarGod.Unit:GetPlayer():BuffRemaining("Ravenous Frenzy", "HELPFUL") < 20 and WarGod.Unit:GetPlayer():BuffRemaining("Ravenous Frenzy", "HELPFUL") > 10 and WarGod.Unit:GetPlayer():BuffRemaining("Power Infusion", "HELPFUL") <= 0 then
                        local groupType = UnitInRaid("player") and "raid" or "party"
                        if InCombatLockdown() then
                            if PISpecific then
                                for i=1,GetNumGroupMembers() do
                                    local groupId = groupType .. i
                                    local name = UnitNameAndServer(groupId)
                                    if name == PISpecific and UnitGroupRolesAssigned(groupId) == "HEALER" then
                                        if ((not piTable[PISpecific]) or GetTime() > 115 + piTable[PISpecific]) and IsSpellInRange("Regrowth",groupId) == 1 then
                                            print("Sending whisper to priority" .. name)
                                            lastWhisperTime = GetTime()
                                            SendChatMessage("PI me", "WHISPER", nil, name)
                                            return
                                        end
                                    end
                                end
                            end
                            for i=1,GetNumGroupMembers() do
                                local groupId = groupType .. i
                                local name = UnitNameAndServer(groupId)
                                if UnitGroupRolesAssigned(groupId) == "HEALER" then
                                    if piTable[name] then
                                        if GetTime() > 115 + piTable[name] then
                                            if IsSpellInRange("Regrowth",groupId) == 1 then
                                                print("Sending whisper to " .. name)
                                                lastWhisperTime = GetTime()
                                                SendChatMessage("PI me", "WHISPER", nil, name)
                                                return
                                            end
                                        end
                                    elseif UnitClass(groupId) == "Priest" then
                                        piTable[UnitName(groupId)] = 0
                                        if IsSpellInRange("Regrowth",groupId) == 1 then
                                            print("Sending whisper to " .. name)
                                            lastWhisperTime = GetTime()
                                            SendChatMessage("PI me", "WHISPER", nil, name)
                                            return
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        elseif eventname == "SPELL_AURA_APPLIED" then
            if spellName == "Power Infusion" then
                print(sourceName .. " cast PI on " .. destName)
            end
        end
    end
end
PI:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
]]
--[[function Balance:CHAT_MSG_WHISPER(event, text, playerName, languageName, channelName, playerName2, specialFlags, zoneChannelID, channelIndex, channelBaseName, unused, lineID, guid, bnSenderID, isMobile, isSubtitle, hideSenderInLetterbox, supressRaidIcons)
    --print(event)
    if strmatch(strlower(text), "innervate") then
        innervateCallTime = GetTime()
        innervateTarget = playerName -- comes as playername-server
    end
end
Balance:RegisterEvent("CHAT_MSG_WHISPER")]]