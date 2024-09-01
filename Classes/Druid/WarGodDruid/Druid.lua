if UnitClass("player") ~= "Druid" then C_AddOns.DisableAddOn("WarGodDruid"); return end

local LibStub = LibStub
local Class = WarGod.Class
local Druid = Class

local WarGod = WarGod

local player = WarGod.Unit:GetPlayer()
player.maxHelpRangeSpell = "Regrowth"
player.maxHarmRangeSpell = "Moonfire"
--local WarGodSpells = WarGod.Rotation.rotationFrames[select(2,GetSpecializationInfo(GetSpecialization()))]
local Rotation = WarGod.Rotation
local Delegates = Rotation.Delegates

local print = print

player.channels["Convoke the Spirits"] = 4

local innervateCallTime = 0
local innervateTarget = ""

setfenv(1, Class)

player.mana_cost = 0
player.Mana_Percent = function(self)
    return (self.mana - self.mana_cost) / self.mana_max
end
player.Mana = function(self)
    return (self.mana - self.mana_cost)
end

function Delegates:NoInnervate(spell, unit, args)
    if unit:BuffRemaining("Innervate", "HELPFUL") <= 0 then
        return true
    end
end

function Delegates:InnervateRaid(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    local class = UnitClass(unitid)
    --[[if WarGod.Unit:GetPlayer():TimeInCombat() < 10 then
        return
    end]]
    if (unit:BuffRemaining(spell, "HELPFUL") > 0 or UnitGroupRolesAssigned(unitid) ~= "HEALER")then
        return
    end
    if innervateCallTime + 10 > GetTime() and strmatch(innervateTarget, name)
            and GetTime() > innervateCallTime + 1   -- this one
    then
        return true
    end
    local threshold = 0.9

    local manapercent = UnitPower(unitid) / UnitPowerMax(unitid);--always 300k mana
    --if (UnitClass(unitid) == "Paladin" and not UnitIsUnit(unitid, "focus")) then return end   -- rude not innervating pallies, lol
    --[[if (UnitClass(unitid) == "Druid") then
        threshold = threshold - 0.3

    end]]

    if name ~= "Synergies" and name ~= "Priimo" then return end

    --[[if name ~= "Synergies" then return end

    local class = UnitClass(unitid)
    if class == "Druid" then
        local castingSpell = UnitCastingInfo(unitid)
        if castingSpell == "Wild Growth" or castingSpell == "Regrowth" then
            return true
        end
    end
    return manapercent < threshold]]
    --end
    return true
end

function Delegates:InnervateParty(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    local class = UnitClass(unitid)
    --[[if WarGod.Unit:GetPlayer():TimeInCombat() < 10 then
        return
    end]]
    if (unit:BuffRemaining(spell, "HELPFUL") > 0 or unit:BuffRemaining("Food & Drink","HELPFUL") > 0 or unit:BuffRemaining("Drink","HELPFUL") > 0 or UnitGroupRolesAssigned(unitid) ~= "HEALER")then
        return
    end
    if innervateCallTime + 10 > GetTime() and strmatch(innervateTarget, name)
            and GetTime() > innervateCallTime + 1   -- this one
    then
        return true
    end
    local threshold = 0.8
    local manapercent = UnitPower(unitid) / UnitPowerMax(unitid);--always 300k mana
    if player:TimeInCombat() > 10 or manapercent > 0.8 then return end

    if UnitInRaid("player") then return end

    return manapercent < threshold
end

--[[function Class:CHAT_MSG_WHISPER(event, text, playerName, languageName, channelName, playerName2, specialFlags, zoneChannelID, channelIndex, channelBaseName, unused, lineID, guid, bnSenderID, isMobile, isSubtitle, hideSenderInLetterbox, supressRaidIcons)
    --print(event)
    --print(playerName)
    if strmatch(strlower(text), "innervate") and strlen(text) < 25 then
        innervateCallTime = GetTime()
        innervateTarget = playerName -- comes as playername-server
        --print(playername)
        if UnitIsDeadOrGhost("player") then
            SendChatMessage("I'm dead", "WHISPER", nil, playerName)
        elseif IsSpellInRange("Innervate", strsplit("-", playerName)) ~= 1 then
            SendChatMessage("You are out of range for innervate", "WHISPER", nil, playerName)
        else
            local cdRemains = WarGodSpells["Innervate"]:CDRemaining()
            if cdRemains > 1.5 then
                cdRemains = floor(cdRemains)
                SendChatMessage("Innervate on cooldown for " .. cdRemains .. " seconds", "WHISPER", nil, playerName)
            end
        end
    end
    --local start, cd = GetSpellCooldown("Innervate")

end
Class:RegisterEvent("CHAT_MSG_WHISPER")]]

function Delegates:UnitHasHot(spell, unit, args)
    --print(spell)
    if unit:BuffRemaining("Rejuvenation","HELPFUL|PLAYER") > 0 or unit:BuffRemaining("Wild Growth","HELPFUL|PLAYER") > 0 or unit:BuffRemaining("Regrowth","HELPFUL|PLAYER") > 0 then
        return true
    end
end

function Class:UNIT_SPELLCAST_START(event, unitId, lineId, spellId)
    if (unitId == "player") then
        --print("boo")
        if (spellId == 8936) then           -- regrowth
            player.mana_cost = 0.2184 * player.mana_max
        elseif (spellId == 48438) then      -- wild growth
            player.mana_cost = 0.3 * player.mana_max
        elseif (spellId == 2637) then       -- hibernate
            player.mana_cost = 0.15 * player.mana_max
        elseif (spellId == 339) then       -- entangling roots
            player.mana_cost = 0.18 * player.mana_max
            -----------------------------------------------------------
        elseif (spellId == 190984) then     -- Wrath
            --print("wrath")
            if player.talent.soul_of_the_forest.enabled and player.eclipse and player.eclipse:In_Solar() then
                player.lunar_gen = 16
            else
                player.lunar_gen = 10
            end
        elseif (spellId == 194153) then     -- Starfire
            if player.talent.soul_of_the_forest.enabled and player.eclipse and player.eclipse:In_Lunar() then
                player.lunar_gen = 13
            else
                player.lunar_gen = 12
            end
        elseif (spellId == 202347) then     -- stellar flare
            player.lunar_gen = 8
        end
    end
end

function Class:UNIT_SPELLCAST_STOP(event, unitId, lineId, spellId)
    if (unitId == "player") then
        player.mana_cost = 0
        player.lunar_gen = 0
    end
end
Class:RegisterEvent("UNIT_SPELLCAST_START")
Class:RegisterEvent("UNIT_SPELLCAST_STOP")

--[[function Class:UNIT_SPELLCAST_SUCCEEDED(event, unitId, lineId, spellId)
    if (unitId == "player") then
        local spellName = GetSpellInfo(spellId)
        if spellName == "Celestial Alignment" or strmatch(spellName, "^Incarnation") then
            if UnitInRaid("player") then
                DoEmote("train")
            end
        end

    end
end
Class:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")]]

--local spamTrain = true

function Class:COMBAT_LOG_EVENT_UNFILTERED(event)
    --if spamTrain then
        local timestamp, eventname, flagthatidunno, sourceGUID, sourceName, sourceflags, sourceRaidFlags, destGUID, destName, destflags, destRaidFlags, spellId, spellName, spellschool, auraType = CombatLogGetCurrentEventInfo()
        if player.guid == sourceGUID and player.guid == destGUID then
            if eventname == "SPELL_AURA_APPLIED" then
                if spellName == "Celestial Alignment" or strmatch(spellName, "^Incarnation") or spellName == "Berserk" then
                    if UnitInRaid("player") then
                        if UnitExists("boss1") then
                            DoEmote("train")

                        end
                    end
                end
            end
        end
    --end
end
Class:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

function Class:PLAYER_REGEN_DISABLED(event)
    spamTrain = random(0,3) == 0
    --if spamTrain then print("spamming") else print("not spamming") end
end
Class:RegisterEvent("PLAYER_REGEN_DISABLED")

function Class:PLAYER_REGEN_DISABLED(event)
    spamTrain = random(0,3) == 0
    --if spamTrain then print("spamming") else print("not spamming") end
end
Class:RegisterEvent("PLAYER_REGEN_DISABLED")

do
    local SoulbindFixer = LibStub("AceAddon-3.0"):NewAddon("WarGodDruidSoulbindFixer", "AceConsole-3.0", "AceEvent-3.0")
    function SoulbindFixer:COVENANT_CHOSEN(event, id)
        if id == 1 then
            -- kyrian
            --[[if GetSpecialization() == 1 then
                ActivateSoulbind(9)
            elseif GetSpecialization() == 3 then
                ActivateSoulbind(3)
            end]]
            if GetActiveSoulbindID() ~= 18 then
                ActivateSoulbind(18)
            end
        elseif id == 2 then
            --covenant.venthyr = true
            if GetSpecialization() == 1 then
                ActivateSoulbind(9)
            elseif GetSpecialization() == 3 then
                ActivateSoulbind(3)
            end
        elseif id == 3 then
            --covenant.night_fae = true
        elseif id == 4 then
            --covenant.necrolord = true
        end
    end
    SoulbindFixer:RegisterEvent("COVENANT_CHOSEN")

    function SoulbindFixer:PLAYER_SPECIALIZATION_CHANGED(event, unitid)
        if unitid == "player" then
            local specId = GetSpecialization()
            if specId == 1 then
                if GetActiveCovenantID() == 2 then
                    if GetActiveSoulbindID() ~= 9 then
                        ActivateSoulbind(9)
                    end
                elseif GetActiveCovenantID() == 1 then
                    if GetActiveSoulbindID() ~= 18 then
                        ActivateSoulbind(18)
                    end
                end

            elseif specId == 3 then
                if GetActiveCovenantID() == 2 then
                    if GetActiveSoulbindID() ~= 3 then
                        ActivateSoulbind(3)
                    end
                elseif GetActiveCovenantID() == 1 then
                    if GetActiveSoulbindID() ~= 18 then
                        ActivateSoulbind(18)
                    end
                end
            end
        end
    end
    SoulbindFixer:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
end

--player.maxHarmRangeSpell = "Moonfire"
player.maxHelpRangeSpell = "Regrowth"

Rotation:RegisterForceCast("Typhoon")
Rotation:RegisterForceCast("Barkskin")

Rotation:RegisterForceCast("Mount Form")
Rotation:RegisterForceCast("Ursol's Vortex", "cursor")

Rotation:RegisterForceCast("Swiftmend", "player")
--Rotation:RegisterForceCast("Rebirth", "mouseover")
Rotation:RegisterForceCast("Soothe", "target")
Rotation:RegisterForceCast("Travel Form")
Rotation:RegisterForceCast("Cat Form")
Rotation:RegisterForceCast("Bear Form")
Rotation:RegisterForceCast("Wild Charge")
Rotation:RegisterForceCast("Dash")