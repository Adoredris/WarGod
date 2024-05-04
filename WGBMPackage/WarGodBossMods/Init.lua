local WGBM = LibStub("AceAddon-3.0"):NewAddon("WarGodBossMods", "AceConsole-3.0", "AceEvent-3.0")
local WarGod = WarGod and WarGod or {}
WarGod.BossMods = WGBM
WarGod.BossMods.default = {}
---------------------------------
--  General (local) functions  --
---------------------------------
--local bossName = ""
local printTo = WarGod.printTo

function PrintBossName()
    printTo(3,bossName)
end

WarGodBigNumber = 13333333337

local bw = {}

-- checks if a given value is in an array
-- returns true if it finds the value, false otherwise
local function checkEntry(t, val)
    for i, v in ipairs(t) do
        if v == val then
            return true
        end
    end
    return false
end

function WGBM:Debug(message)
    printTo(3,message)
end

function GetAffixes()
    local affixes = C_MythicPlus.GetCurrentAffixes()
    local activeAffixStrings = {}
    for _,t in pairs(affixes) do
         activeAffixStrings[strlower(C_ChallengeMode.GetAffixInfo(t.id))] = true
    end

    return activeAffixStrings
end

function GetKeyLevel()
    local _, level = C_ChallengeMode.GetCompletionInfo()
    return level or 0
end


local plugin = {}--BigWigs:NewPlugin("WGBM")

WGBM.timers = {}

--local PandeityBigwigsEventCallbacks = {}

-- this probably should check for zone wide ones to reset to rather than going straight to default
--[[local ]]function WGBM:ResetToDefaults()

    local zoneText = GetZoneText()
    WarGod.bossName = zoneText
    if (WGBM[zoneText] ~= nil) then
        WarGod.bossName = zoneText
        for text,v in pairs(WGBM["default"]) do
            if (WGBM[zoneText][text]) then
                WGBM[text] = WGBM[zoneText][text]
            else
                WGBM[text] = WGBM["default"][text]
            end

        end
    else
        WarGod.bossName = zoneText
        for text,v in pairs(WGBM["default"]) do
            WGBM[text] = WGBM["default"][text]
        end
    end
end

function WGBM:ADDON_LOADED(event, name)
    if (string.match(name, "^BigWigs"))then
        -- previous expac shit gets merged into its own addon (fix this to match bw)
        if (string.match(name, "WarlordsOfDraenor")) then
            if (not IsAddOnLoaded("WGBM_WarlordsOfDraenor")) then
                LoadAddOn("WGBM_WarlordsOfDraenor")
            end
        --[[elseif(string.match(name, "Nightmare"))then
            if (not IsAddOnLoaded("WGBM_Nightmare")) then
                LoadAddOn("WGBM_Nightmare")
            end
        elseif(string.match(name, "TrialOfValor"))then
            if (not IsAddOnLoaded("WGBM_TrialOfValor")) then
                LoadAddOn("WGBM_TrialOfValor")
            end
        elseif(string.match(name, "Nighthold"))then
            if (not IsAddOnLoaded("WGBM_Nighthold")) then
                LoadAddOn("WGBM_Nighthold")
            end

        elseif(string.match(name, "TombOfSargeras"))then
            if (not IsAddOnLoaded("WGBM_TombOfSargeras")) then
                LoadAddOn("WGBM_TombOfSargeras")
            end

        elseif(string.match(name, "Antorus"))then
            if (not IsAddOnLoaded("WGBM_Antorus")) then
                LoadAddOn("WGBM_Antorus")
            end
        elseif(string.match(name, "Uldir"))then
            if (not IsAddOnLoaded("WGBM_Uldir")) then
                LoadAddOn("WGBM_Uldir")
            end
        elseif(string.match(name, "BattleOfDazaralor"))then
            if (not IsAddOnLoaded("WGBM_BattleOfDazaralor")) then
                LoadAddOn("WGBM_BattleOfDazaralor")
            end
        elseif(string.match(name, "CrucibleOfStorms"))then
            if (not IsAddOnLoaded("WGBM_CrucibleOfStorms")) then
                LoadAddOn("WGBM_CrucibleOfStorms")
            end
        elseif(string.match(name, "EternalPalace"))then
            if (not IsAddOnLoaded("WGBM_EternalPalace")) then
                LoadAddOn("WGBM_EternalPalace")
            end
        elseif(string.match(name, "Nyalotha"))then
            if (not IsAddOnLoaded("WGBM_Nyalotha")) then
                LoadAddOn("WGBM_Nyalotha")
            end
        elseif(string.match(name, "CastleNathria"))then
            if (not IsAddOnLoaded("WGBM_CastleNathria")) then
                LoadAddOn("WGBM_CastleNathria")
            end
        elseif(string.match(name, "SanctumOfDomination"))then
            if (not IsAddOnLoaded("WGBM_SanctumOfDomination")) then
                LoadAddOn("WGBM_SanctumOfDomination")
            end
        elseif(string.match(name, "SepulcherOfTheFirstOnes"))then
            if (not IsAddOnLoaded("WGBM_SepulcherOfTheFirstOnes")) then
                LoadAddOn("WGBM_SepulcherOfTheFirstOnes")
            end]]

        elseif(string.match(name, "VaultOfTheIncarnates"))then
            if (not IsAddOnLoaded("WGBM_VaultOfTheIncarnates")) then
                LoadAddOn("WGBM_VaultOfTheIncarnates")
            end
        elseif(string.match(name, "Aberrus"))then
            if (not IsAddOnLoaded("WGBM_Aberrus")) then
                LoadAddOn("WGBM_Aberrus")
            end

        end
    elseif(name == "LittleWigs") then
        if (not IsAddOnLoaded("WGBMD_Dragonflight")) then
            LoadAddOn("WGBMD_Dragonflight")
        end
    elseif(string.match(name,"^LittleWigs"))then
        if(string.match(name, "Classic"))then
            if (not IsAddOnLoaded("WGBMD_Classic")) then
                LoadAddOn("WGBMD_Classic")
            end
        elseif(string.match(name, "BurningCrusade"))then
            if (not IsAddOnLoaded("WGBMD_BurningCrusade")) then
                LoadAddOn("WGBMD_BurningCrusade")
            end
        elseif(string.match(name, "WrathOfTheLichKing"))then
            if (not IsAddOnLoaded("WGBMD_WrathOfTheLichKing")) then
                LoadAddOn("WGBMD_WrathOfTheLichKing")
            end
        elseif(string.match(name, "MistsOfPandaria"))then
            if (not IsAddOnLoaded("WGBMD_MistsOfPandaria")) then
                LoadAddOn("WGBMD_MistsOfPandaria")
            end
        elseif(string.match(name, "Cataclysm"))then
            if (not IsAddOnLoaded("WGBMD_Cataclysm")) then
                LoadAddOn("WGBMD_Cataclysm")
            end
        elseif(string.match(name, "WarlordsOfDraenor"))then
            if (not IsAddOnLoaded("WGBMD_WarlordsOfDraenor")) then
                LoadAddOn("WGBMD_WarlordsOfDraenor")
            end
        elseif(string.match(name, "Legion"))then
            if (not IsAddOnLoaded("WGBMD_Legion")) then
                LoadAddOn("WGBMD_Legion")
            end
        elseif(string.match(name, "BattleForAzeroth"))then
            if (not IsAddOnLoaded("WGBMD_BattleForAzeroth")) then
                LoadAddOn("WGBMD_BattleForAzeroth")
            end
        elseif(string.match(name, "Shadowlands"))then
            if (not IsAddOnLoaded("WGBMD_Shadowlands")) then
                LoadAddOn("WGBMD_Shadowlands")
            end
        end
    elseif string.match(name, "WGBM") then
        WGBM:ResetToDefaults()
    end
end
WGBM:RegisterEvent("ADDON_LOADED")
for i=1,GetNumAddOns() do
    if IsAddOnLoaded(i) then
        WGBM:ADDON_LOADED("ADDON_LOADED", GetAddOnInfo(i))   -- in case bigwigs module was already loaded
    end

end

function WGBM:PLAYER_REGEN_DISABLED(event)
    if (not UnitExists("boss1")) then
        WGBM:ResetToDefaults()
    end
end
WGBM:RegisterEvent("PLAYER_REGEN_DISABLED")

function WGBM:CHALLENGE_MODE_START(event)
    print("resetting cause starting a key")
    WGBM:ResetToDefaults()
end
WGBM:RegisterEvent("CHALLENGE_MODE_START")


--[[local function --PandeityPerformBigwigsCallbacks(event, ...)
    if(PandeityBigwigsEventCallbacks[event]~=nil)then
        for k,callback in pairs(PandeityBigwigsEventCallbacks[event]) do
            callback(event,...)
        end
    end
end]]



local function RemoveOld()
    local now = GetTime()
    for msg,occuranceTime in pairs(WGBM.timers) do
        if occuranceTime - now < -15 then
            WGBM.timers[msg] = nil
        end

    end
end

function bw:BigWigs_StartBar(--[[event, ]]...)
    local --[[event, ]]boss, spellid, msg, length, iconIndex = ...
    --if type(boss) == "table" then ChatFrame6:AddMessage(boss.displayName) else printTo(3,type(boss)); printTo(3,...) end
    if (WarGod.bossName == "" and boss.displayName ~= nil or WarGod.bossName == GetZoneText()) then
        printTo(3,'faking boss engage')
        bw:BigWigs_OnBossEngage(boss)
    end
    --printTo(3,boss)
    --printTo(3,boss.displayName)

    RemoveOld()

    WGBM.timers[msg] = GetTime() + length
    --print(...)
    --printTo(6,...)
    --printTo(7,...)
end
BigWigsLoader.RegisterMessage(plugin, "BigWigs_StartBar", bw.BigWigs_StartBar)

-- args of the rest of the "events" aren't tested
function bw:BigWigs_StopBar(--[[event,]] ...)
    local --[[event, ]]boss, msg = ...
    --printTo(3,...)
    --print(...)
    WGBM.timers[msg] = nil
    --PandeityPerformBigwigsCallbacks("BigWigs_StopBar", ...)
end
BigWigsLoader.RegisterMessage(plugin, "BigWigs_StopBar", bw.BigWigs_StopBar)

-- boss reset
function bw:BigWigs_OnBossReboot(...)
    printTo(3,...)
    for k,v in pairs(WGBM.timers) do
        WGBM.timers[k] = nil
    end
    WGBM:ResetToDefaults()
    ----PandeityPerformBigwigsCallbacks("BigWigs_OnBossReboot", ...)
end
BigWigsLoader.RegisterMessage(plugin, "BigWigs_OnBossReboot", bw.BigWigs_OnBossReboot)

function bw:BigWigs_OnBossWipe(...)
    printTo(3,...)
    for k,v in pairs(WGBM.timers) do
        WGBM.timers[k] = nil
    end
    WGBM:ResetToDefaults()
    ----PandeityPerformBigwigsCallbacks("BigWigs_OnBossWipe", ...)
end
BigWigsLoader.RegisterMessage(plugin, "BigWigs_OnBossWipe", bw.BigWigs_OnBossWipe)

function bw:BigWigs_OnBossEngage(boss, difficulty)
    --ChatFrame6:AddMessage("Boss was engaged")
    --ChatFrame6:AddMessage(...)
    --local --[[event,]] boss, difficulty = ...
    --printTo(3,boss == "BigWigs_Bosses_Archimonde")
    --printTo(3,type(boss))
    --for k,v in pairs(boss) do if strmatch(k, "ame") then printTo(3,k); printTo(3,v) end end
    --print('A')
    --print(...)
    --print('Z')
    if boss.displayName == "Trash" or boss.displayName == "Bars" then
        WGBM:ResetToDefaults()
    else
        WarGod.bossName = boss.displayName or GetZoneText() or ""
        local bossName = WarGod.bossName
        printTo(3,"bossName: "..bossName)
        if (WGBM[bossName] ~= nil) then
            printTo(3,"swapping WGBM funcs")
            for text,v in pairs(WGBM["default"]) do
                if (WGBM[bossName][text]) then
                    WGBM[text] = WGBM[bossName][text]
                else
                    WGBM[text] = WGBM["default"][text]
                end

            end

        else
            --[[if bossName ~= "" then
                printTo(3,"Engaged in unhandled fight " .. bossName)
                WGBM:ResetToDefaults()
            else
                printTo(3,'oogady boogady boo')
            end]]

        end

    end
    ----PandeityPerformBigwigsCallbacks("BigWigs_OnBossEngage", ...)
end
BigWigsLoader.RegisterMessage(plugin, "BigWigs_OnBossEngage", bw.BigWigs_OnBossEngage)

function bw:BigWigs_OnBossWin(...)
    for k,v in pairs(WGBM.timers) do
        WGBM.timers[k] = nil
    end
    WGBM:ResetToDefaults()
    ----PandeityPerformBigwigsCallbacks("BigWigs_OnBossWin", ...)
end
BigWigsLoader.RegisterMessage(plugin, "BigWigs_OnBossWin", bw.BigWigs_OnBossWin)

--[[function PandeityBigWigsAddCallback(event,callback, opt_callbackUniqueName)
    if(PandeityBigwigsEventCallbacks[event]==nil)then
        PandeityBigwigsEventCallbacks[event] = {}
    end

    if(opt_callbackUniqueName==nil)then
        table.insert(PandeityBigwigsEventCallbacks[event],callback)
    else
        PandeityBigwigsEventCallbacks[event][opt_callbackUniqueName] = callback
    end
end

function PandeityBigWigsRemoveCallback(event,callbackUniqueName)
    if(PandeityBigwigsEventCallbacks[event]==nil)then--you silly goose
        printTo(3,"Event has nothing registered to it, noob")
    else
        PandeityBigwigsEventCallbacks[event][callbackUniqueName] = nil
    end


end]]

function DoingMythic()
    local zone, type, diff, difficultyStr, maxSize = GetInstanceInfo()
    return diff == 16
end
function DoingHeroicPlus()
    local zone, type, diff, difficultyStr, maxSize = GetInstanceInfo()
    return diff >= 15
end

function CastTimeRemaining(unitid, spell)
    if (not WarGod.Control:AutoWeave()) then return 0 end
    local castingSpell, displayName, icon, WasStartedAt, ShouldEndAt, isTradeSkill, castID, notInterruptible = UnitCastingInfo(unitid)
    if (not spell) and castingSpell or castingSpell == spell then
        return ShouldEndAt and ShouldEndAt / 1000 - GetTime() or 0
    end
    return 0
end

function GetPing()
    local _,_,ping,ping2 = GetNetStats()
    return ping
end

function ChannelTimeRemaining(unitid, spell)
    local castingSpell, displayName, icon, WasStartedAt, ShouldEndAt, isTradeSkill, castID, notInterruptible = UnitChannelInfo(unitid)
    if (not spell) and castingSpell or castingSpell == spell then
        return ShouldEndAt and ShouldEndAt / 1000 - GetTime() or 0
    end
    return 0
end
--printTo(3,'bigwigs stuff')