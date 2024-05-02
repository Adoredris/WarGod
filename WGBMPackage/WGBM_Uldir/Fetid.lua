--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Fetid Devourer"      -- not right at all
WGBM[bossString] = {}

local function DoingNormMax()
    local zone, type, diff, difficultyStr, maxSize = GetInstanceInfo()
    return diff == 14 or diff == 17
end

WGBM[bossString].Defensive = function(spell, unit, args)
    local unitid = unit.unitid
    if (unit:AuraRemaining("Ravenous Blaze", "HARMFUL") > 0) then
        return args[2] <= 60
    end
    --return 1337
end

--[[WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if DoingMythic() then
        if WarGod.Unit.active_enemies > 1 then
            if unit.name == bossString and unit.health_percent > 0.3 then
                return true
            end
        end
    end
end]]

WGBM[bossString].Mitigation = function(spell, unit, args)
    --print('fetid mitigation')
    local bossCasting = UnitCastingInfo("boss1")
    --if UnitIsUnit("boss1target", "player") then
    if bossCasting == "Terrible Thrash" then
        local bossThreat = UnitThreatSituation("player","boss1")
        if not bossThreat or bossThreat < 3 then
            return true
        end
    end
    --end
    --return score, bossString
end

WGBM[bossString].DPSWhitelist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if (name ~= bossString) then
        return true
    end
end

WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local score = 0
    local name = unit.name
    local targetName = unit.name
    if DoingMythic() then
        if name == bossString and WarGod.Unit.boss1.health_percent >= 0.4 then
            score = 0
        elseif name == "Corruption Corpuscle" then
            if targetName == name or IsMoving() or targetName == bossString or targetName == nil then
                score = 20
            else
                score = 0
            end
        elseif name == "Mutated Mass" then
            if targetName == name or IsMoving() or targetName == bossString or targetName == nil then
                score = 19
            else
                score = 0
            end
        else
            score = 16
        end
    else
        if name == bossString and unit.health_percent >= 0.4 then
            score = 10
        else
            score = 20
        end
    end
    if UnitIsUnit(unitid, "target") then
        score = score + 5
    end
    return score, bossString
end

WGBM[bossString].DamageCD = function(spell, unit, args)
    --local unitId = unit.unitid
    --if unitId ~= "" then
    local targetName = UnitName("target")

    if DoingMythic() then
        local timeInCombat = WarGod.Unit:GetPlayer():TimeInCombat()
        if args[2] <= 60 and timeInCombat < 3 then
            return true
        end
        if timeInCombat < 10 then
            return
        end
        if args[2] >= 60 and targetName == bossString then
            return
        end
    end
    return true
end