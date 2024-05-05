--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Carapace of N'Zoth"      -- not right at all
local altBossString = "Fury of N'Zoth"
WGBM[bossString] = {}

WGBM[bossString].Interrupt = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if name == "Gaze of Madness" then
        local theTime = GetTime()
        local spell, displayName, icon, startTime, endTime, isTradeSkill, notInterruptible = UnitChannelInfo (unitid)
        if (spell == "Breed Madness") then-- and spellsThatCantOrShouldntBeInterrupted[spell] == nil
            local castTime = (endTime - startTime) / 1000
            local castRemaining = (endTime / 1000) - theTime
            local castCompletion = (1 - (castRemaining / castTime))
            if castCompletion < 0.1 then
                return true
            end
        end
    end
end

WGBM[bossString].DPSWhitelist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if (name ~= altBossString) then
        return true
    end
end

WGBM[bossString].DotQuick = function(spell, unit, args)
    local name = unit.name
    if unit.health_percent > 0.8 then
        return true
    end
    return
end

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    --print("Blockade Blacklist")
    if WarGod.Control:SafeMode() then
        if (not UnitIsUnit(unitid, "target")) then
            return true
        end
    else
        if UnitIsUnit(unitid, "target") or UnitIsUnit(unitid, "mouseover") then
            return
        elseif name == "Fury of N'Zoth" then
            if WarGod.Unit:GetUnit("boss1"):DebuffRemaining("Synthesis","HELPFUL") > 0 or unit.health_percent > 0.5 then
                return true
            end
        elseif name == "Mycelial Cyst" then
            if UnitIsUnit(unitid, "target") then
                return
            end
            return true
        else
            local bossHpPercent = (UnitHealth("boss1") or 0) / (UnitHealthMax("boss1") or 1)
            if unit.name == "Nightmare Antigen" then
                if not DoingMythic() then
                    if bossHpPercent < 0.5 then
                        return

                    else
                        if CheckInteractDistance(unitid, 2) then
                            return
                        end
                    end
                end
                return true
            end
            return true
        end
    end
end

WGBM[bossString].HealCD = function(spell, unit, args)
    local unitid = unit.unitid
    --[[if UnitChannelInfo(unitid) == "Obsidian Shatter" then  -- innervate in p2
        return true
    end]]
end

--
WGBM[bossString].Priority = function(spell, unit, args)
    --print('default priority')
    local unitid = unit.unitid
    local name = unit.name
    local score = 10
    if WarGod.Control:SafeMode() then
        if (not UnitIsUnit("target", unitid) and unit.name ~= altBossString) then
            return 0
        end
    end
    if spell == "Stellar Flare" and unit.health_percent < 0.2 and name ~= altBossString then
        score = 0
    end

    if (UnitIsUnit("target", unitid)) and score > 0 then
        score = score + 1
    end
    return score, bossString
end


WGBM[bossString].Mitigation = function(spell, unit, args)
    local bossThreat = UnitThreatSituation("player","boss1")
    if bossThreat and bossThreat >= 3 then
        local bossCasting = UnitCastingInfo("boss1")
        if bossCasting == "Mandible Slam" then
            return true, nil, true
        end
    end
    --end
    --return score, bossString
end

WGBM[bossString].DamageCD = function(spell, unit, args)
    local targetName = WarGod.Unit:GetTarget().name
    -- den of transfusion
    -- locus of infinite truths
    if args[2] <= 120 then
        return true
    elseif (not DoingMythic()) or targetName == "Gaze of Madness" or GetMinimapZoneText() ~= "N'Zoth" or targetName == "Synthesis Growth" and (not IsMoving()) then
        for i=1,5 do
            local name = UnitDebuff("player",i)
            if name == nil then
                return true
            elseif name == "Madness Bomb" then
                return
            end
        end

    end
    return
end

