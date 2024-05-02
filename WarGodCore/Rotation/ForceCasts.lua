--[[local tContains = tContains
local tinsert = tinsert
local strsub = strsub
local strlen = strlen
local strmatch = strmatch
local GetTime = GetTime
local GetSpellInfo = GetSpellInfo
local LibStub = LibStub
local print = print
local pairs = pairs
local GetSpecializationInfo = GetSpecializationInfo
local GetSpecialization = GetSpecialization
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
local IsSpellInRange = LibStub("SpellRange-1.0").IsSpellInRange]]

local spellUnitsBindMap = WarGod.Binder.spellUnitToBinds
local Rotations = WarGod.Rotation
local player = WarGod.Unit:GetPlayer()
local ForceCasts = LibStub("AceAddon-3.0"):NewAddon("WarGodForceCasts", "AceConsole-3.0", "AceEvent-3.0")

do
    setfenv(1, Rotations)

    local possibleForceCasts = {}
    --player.possibleForceCasts = possibleForceCasts
    local queuedForceCasts = {}

    local spells = {}

    local recentCasts = {}


    function Rotations:ClearForceCasts()
        for k,v in pairs(queuedForceCasts) do
            queuedForceCasts[k] = nil
        end
    end

    function Rotations:RegisterForceCast(spell, opt_unitid)
        --print('spell = ' .. spell)
        if not possibleForceCasts[spell] then
            possibleForceCasts[spell] = {}
        end
        if not tContains(possibleForceCasts[spell], opt_unitid or "nounit") then
            tinsert(possibleForceCasts[spell], (opt_unitid or "nounit"))
        end

    end

    -- think about the best way to test for spell usability
    function Rotations:GetForceCasts()
        local now = GetTime()
        for spellUnitId,timeWasQueued in pairs(queuedForceCasts) do
            if now > timeWasQueued + 3 then
                --print('removed ' .. spellUnitId .. ' from forcecasts cause old')
                queuedForceCasts[spellUnitId] = nil
            else
                --print(spellUnitId)
                for spell,spellData in pairs(spells) do
                    --print(spell)
                    if strmatch(spellUnitId, "^"..spell) then
                        --print("found spell data for ".. spell .." to force")
                        if (spellData:IsUsable() and spellData:Ready() and spellData:Castable(spell))then
                            if (spellUnitsBindMap[spellUnitId] or spellUnitsBindMap[spell]) then
                                return spell, strsub(spellUnitId, strlen(spell) + 1)
                            end


                        end
                        break
                    end
                end

            end
        end

    end

    -- this function doesn't check the possibilities except for maybe if it's trying to find correct unitid mappings
    function ForceNextCast(spell, opt_unitid)
        queuedForceCasts[spell .. (opt_unitid or "nounit")] = GetTime()
    end


    function ForceCasts:PLAYER_SPECIALIZATION_CHANGED(event, unitid)
        if unitid == "player" then
            local spec = select(2, GetSpecializationInfo(GetSpecialization())) or "none"
            --print(spec)
            if spec ~= "none" then
                spells = Rotations.rotationFrames[spec]-- or {}

            end
        end
    end
    ForceCasts:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
    ForceCasts:PLAYER_SPECIALIZATION_CHANGED("PLAYER_SPECIALIZATION_CHANGED","player")
    --[[function Rotations:ADDON_LOADED(event,addon)
        if addon == "WarGodRotations" then
            Rotations:PLAYER_SPECIALIZATION_CHANGED("PLAYER_SPECIALIZATION_CHANGED","player")
        end
    end
    Rotations:RegisterEvent("ADDON_LOADED")]]

    function ForceCasts:UNIT_SPELLCAST_FAILED(event, unitid, lineid, spellid)
        if unitid == "player" then
            --print(event)
            local spellName = GetSpellInfo(spellid)
            if (spellName) then
                if (spellName == player.queuedSpell) then --[[print("next spell is same")]] return end
                if (queuedForceCasts[spellName]) then --[[print("already queued force")]] return end
                if recentCasts[spellName] and GetTime() - recentCasts[spellName] < 1 then --[[print("just cast that")]]return end
                -- the moon spells are always getting through here

                if (possibleForceCasts[spellName]) then
                    for index,unitid in pairs(possibleForceCasts[spellName]) do
                        if unitid == "nounit" or unitid == "cursor" or unitid == "player"--[[ or unitid == "target"]]  then
                            if not queuedForceCasts[spellName .. possibleForceCasts[spellName][index]] then
                                queuedForceCasts[spellName .. possibleForceCasts[spellName][index]] = GetTime()
                                print("queued " .. spellName .. " to be forcibly cast at " .. GetTime())
                                break

                            end
                        else
                            local inRange = IsSpellInRange(spellName, unitid)
                            if inRange ~= 0 and inRange ~= nil then
                                if not queuedForceCasts[spellName .. possibleForceCasts[spellName][index]] then
                                    queuedForceCasts[spellName .. possibleForceCasts[spellName][index]] = GetTime()
                                    print("queued " .. spellName .. " to be forcibly cast at " .. GetTime())
                                    break

                                end
                            end
                        end
                    end
                end
            end
        end
    end
    ForceCasts:RegisterEvent("UNIT_SPELLCAST_FAILED")
    function ForceCasts:COMBAT_LOG_EVENT_UNFILTERED(event, unitid, lineid, spellid)
        local timestamp, eventname, flagthatidunno, sourceGUID, sourceName, sourceflags, sourceRaidFlags, destGUID, destName, destflags, destRaidFlags, spellId, spellName, spellschool, auraType = CombatLogGetCurrentEventInfo()
        if player.guid == sourceGUID then
            --print(event)
            if (eventname == "SPELL_CAST_FAILED") then
                --print("failed " .. spellName)
                if (spellName == player.queuedSpell) then --[[print("next spell is same")]] return end
                if (queuedForceCasts[spellName]) then --[[print("already queued force")]] return end
                if recentCasts[spellName] and GetTime() - recentCasts[spellName] < 1 then --[[print("just cast that")]]return end
                -- the moon spells are always getting through here
                --print('failed ' .. spell)
                if (possibleForceCasts[spellName]) then
                    for index,unitid in pairs(possibleForceCasts[spellName]) do
                        if unitid == "nounit" or unitid == "cursor" or unitid == "player"--[[ or unitid == "target"]] then
                            if not queuedForceCasts[spellName .. possibleForceCasts[spellName][index]] then
                                queuedForceCasts[spellName .. possibleForceCasts[spellName][index]] = GetTime()
                                print("queued " .. spellName .. " to be forcibly cast at " .. GetTime())
                                break
                            end
                        else
                            local inRange = IsSpellInRange(spellName, unitid)
                            if inRange ~= 0 and inRange ~= nil then
                                if not queuedForceCasts[spellName .. possibleForceCasts[spellName][index]] then
                                    queuedForceCasts[spellName .. possibleForceCasts[spellName][index]] = GetTime()
                                    print("queued " .. spellName .. " to be forcibly cast at " .. GetTime())
                                    break
                                end
                            end
                        end
                    end
                else
                    --print("Can't force cast " .. spellName)
                end
            end
        end
    end
    ForceCasts:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED"--[["UNIT_SPELLCAST_FAILED_QUIET", ForceCasts.UNIT_SPELLCAST_FAILED]])

    function ForceCasts:UNIT_SPELLCAST_SUCCEEDED(event, unitid, lineid, spellid)
        if unitid == "player" then
            local spell = GetSpellInfo(spellid)
            if (spell) then
                recentCasts[spell] = GetTime()
                --print('succeeded ' .. spell)
                --if (spell == nextSpellTable[spell]) then return end
                --if (queuedForceCasts[spell]) then return end

                for k,v in pairs(queuedForceCasts) do
                    if strmatch(k, "^"..spell) then

                        --print('finished forcing ' .. spell .. ' @ ' .. strsub(k, strlen(spell) + 1))
                        --print(queuedForceCasts[k])
                        queuedForceCasts[k] = nil
                        --print(queuedForceCasts[k])
                    end

                end
            end
        end
    end
    ForceCasts:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    ForceCasts:RegisterEvent("UNIT_SPELLCAST_START", ForceCasts.UNIT_SPELLCAST_SUCCEEDED)

    if not player.recentCasts then player.recentCasts = recentCasts end

    player.possibleForceCasts = possibleForceCasts
end