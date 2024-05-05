--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Ra-den the Despoiled"      -- not right at all
WGBM[bossString] = {}

--[[WGBM[bossString].Interrupt = function(spell, unit, args)
    if unit.name == "Azsh'ari Witch" then
        return true
    end
    return
end]]

WGBM[bossString].Taunt = function(spell, unit, args)
    local unitid = unit.unitid
    if unit.name == bossString then
        if WarGod.Unit:GetPlayer():DebuffRemaining("Nullifying Strike", "HARMFUL") <= 0 then
            if WarGod.Unit:GetUnit("boss1target"):DebuffRemaining("Nullifying Strike", "HARMFUL") > 0 then
                print("Should Taunt")
                --return true
            end
        end
        if WarGod.Unit:GetPlayer():DebuffRemaining("Decaying Wound", "HARMFUL") <= 0 then
            if WarGod.Unit:GetUnit("boss1target"):DebuffRemaining("Decaying Wound", "HARMFUL") > 0 then
                print("Should Taunt")
                --return true
            end
        end
    end
end

WGBM[bossString].DPSWhitelist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if (name ~= bossString) then
        return true
    end
end

WGBM[bossString].DotQuick = function(spell, unit, args)
    local name = unit.name
    if 1==1 then return true end
    return
end

WGBM[bossString].Defensive = function(spell, unit, args)
    --print('fetid mitigation')
    if UnitGroupRolesAssigned("player") == "TANK" then
        local bossThreat = UnitThreatSituation("player","boss1")
        if bossThreat and bossThreat >= 3 then
            local bossCasting = UnitCastingInfo("boss1")
            if bossCasting == "Nullifying Strike" then
                local nullRemains, nullStrikes = WarGod.Unit:GetPlayer():DebuffRemaining("Nullifying Strike", "HARMFUL")
                if nullStrikes > 1 or DoingMythic() then
                    if args[2] <= 90 then
                        return true
                    end
                end

            else--if bossCasting == "Decaying Strike" then
                local decayingRemains = WarGod.Unit:GetPlayer():DebuffRemaining("Decaying Wound", "HARMFUL")
                if decayingRemains > 0 then
                    if args[2] <= 90 then
                        return true
                    end
                end
            end
        end
    else
        if WarGod.Unit:GetPlayer():DebuffRemaining("Unstable Nightmare","HARMFUL") > 0 then
            if args[2] <= 90 then
                return true
            end
        end
    end
    --return score, bossString
end

WGBM[bossString].FriendlyBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    if unit:DebuffRemaining("Corrupted Existence","HARMFUL") > 0 and unit.health_percent > 0.5 then
        return true

    elseif UnitGroupRolesAssigned("player") == "TANK" then
        --[[if WarGod.Unit:GetUnit("boss1"):health_percent < 0.4 then

        end]]
    end

    return false
end

WGBM[bossString].HealCD = function(spell, unit, args)
    return WarGod.Unit:GetPlayer():TimeInCombat() > 40
end


WGBM[bossString].Priority = function(spell, unit, args)
    --print('default priority')
    local unitid = unit.unitid
    local name = unit.name
    local score = 10
    if name == bossString then

    elseif WarGod.Control:SafeMode() then
        if (not UnitIsUnit("target", unitid) and unit.name ~= bossString) then
            return 0
        end
    else
        if name == "Essence of Void" or name == "Essence of Nightmare" or name == "Essence of Nightmare" then
            if UnitIsUnit("target", unitid) or GetRaidTargetIndex(unitid) == 8 then
                score = 70
            end

        --[[elseif name == "Crackling Stalker" or name == "Night Terror" or name == "Void Hunter" then
            -- Crackling > Void > Night?
            if unit.health_percent > 0.05 then
                if UnitIsUnit("target", unitid) or GetRaidTargetIndex(unitid) == 8 then
                    score = 20
                else
                    score = 15
                end
            end]]
        elseif name == "Crackling Stalker" then
            -- Crackling > Void > Night?
            if unit.health_percent > 0.05 then
                --if UnitIsUnit("target", unitid) or GetRaidTargetIndex(unitid) == 8 then
                    score = 35
                --else
                --    score = 15
                --end
            end

        elseif name == "Void Hunter" then
            -- Crackling > Void > Night?
            if unit.health_percent > 0.05 then
                --if UnitIsUnit("target", unitid) or GetRaidTargetIndex(unitid) == 8 then
                    score = 40
                --else
                --    score = 15
                --end
            end

        elseif name == "Night Terror" then
            -- Crackling > Void > Night?
            if unit.health_percent > 0.05 then
                if UnitIsUnit("target", unitid) or GetRaidTargetIndex(unitid) == 8 then
                    score = 25
                --else
                --    score = 15
                end
            end
        end
    end



    if (UnitIsUnit("target", unitid)) and score > 0 then
        score = score + 1
    end
    return score, bossString
end

--[[
WGBM[bossString].Mitigation = function(spell, unit, args)
    local bossThreat = UnitThreatSituation("player","boss1")
    if bossThreat and bossThreat >= 3 then
        return true
    end
    --end
    --return score, bossString
end
]]
--[[
WGBM[bossString].NotDotBlacklisted = function(spell, unit, args)
    if spell == "Primal Wrath" then
        if WarGod.Unit.active_enemies >= 4 then
            local numEnemies = 0
            for guid,unit in upairs(groups.harmOrPlates) do
                if Delegates:HarmIn10Yards("Rake", unit, {}) then
                    numEnemies = numEnemies + 1
                end
                if numEnemies >= 4 then
                    return true
                end
            end
        end
        return
    end
    if unit.name == "Zoatroid" then
        if UnitClass("player") == "Druid" then
            if GetSpecialization() == 1 then
                if spell ~= "Sunfire" then
                    return
                elseif unit.health_percent > 0.9 or GetUnitpeed(unit.unitid) > 0 then
                    return
                elseif unit.health_percent < 0.4 and (not IsMoving()) then
                    return
                end
            elseif GetSpecialization() == 2 then
                if spell == "Rip" then
                    return
                elseif unit.health_percent > 0.9 or GetUnitpeed(unit.unitid) > 0 then
                    return
                elseif unit.health_percent < 0.4 then
                    return
                end
            end
        elseif UnitClass("player") == "Priest" then
            if WarGod.Unit:GetPlayer().talent.misery.enabled and spell == "Shadow Word: Pain" and (not IsMoving()) then
                return

            end
        end
    end
    return true
end
]]
--[[
WGBM[bossString].MoveIn = function(spell, unit, args)
    local moveIn = 1337
    if WarGod.Unit:GetPlayer():DebuffRemaining("Incubation Fluid", "HARMFUL") > 0 then
        if (CastTimeFor(spell) >= 1.5) then
            local now = GetTime()
            for msg,time in pairs(WGBM.timers) do
                local timeDiff = time - now
                if timeDiff < moveIn and timeDiff > -1 then
                    if strmatch(msg, "Arcing Current") then
                        moveIn = timeDiff
                    end
                end
            end

        end
    end
    return moveIn
end
]]
--[[
WGBM[bossString].DamageCD = function(spell, unit, args)
    for i=1,5 do
        local name = UnitBuff("boss1",i)
        if name == nil then
            return true
        elseif name == "Massive Incubator" then
            return
        end
    end
    return true
end

]]