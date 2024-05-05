

--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Lady Jaina Proudmoore"      -- not right at all
WGBM[bossString] = {}


--WGBM[bossString].Defensive = function(spell, unit, args)
--    local unitid = unit.unitid
--    if (unit:AuraRemaining("Ravenous Blaze", "HARMFUL") > 0) then
--        return args[2] <= 60
--    end
--    --return 1337
--end
--
WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if WarGod.Control:SafeMode() then
        if not UnitIsUnit(unitid, "target") then
            return true
        end
    end
    if name == "Unexploded Ordnance" then
        if not UnitIsUnit(unitid, "target") or unit:BuffRemaining("Refractive Ice", "HELPFUL") > 0 or unit.health_percent < 0.05 then
            return true
        end
    elseif name == bossString then
        if unit:BuffRemaining("Ice Block", "HELPFUL") > 0 then
            return true
        elseif unit:BuffRemaining("Arcane Barrage", "HELPFUL") > 0 then
            return true
        end
    end
    if UnitName("target") == "Wall of Ice" and name ~= "Wall of Ice" then
        return true
    end
    if not UnitInPhase(unitid) then
        print(name .. " not in phase")
    end
end
--
--WGBM[bossString].Mitigation = function(spell, unit, args)
--    --print('fetid mitigation')
--    local bossCasting = UnitCastingInfo("boss1")
--    --if UnitIsUnit("boss1target", "player") then
--    if bossCasting == "Terrible Thrash" then
--        local bossThreat = UnitThreatSituation("player","boss1")
--        if not bossThreat or bossThreat < 3 then
--            return true
--        end
--    end
--    --end
--    --return score, bossString
--end
--
WGBM[bossString].DPSWhitelist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if (name ~= bossString) then
        return true
    end
end
--
WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    local score = 10
    if name == "Ice Block" then
        score = 40
    elseif name == "Prismatic Image" then
        score = 36
    elseif name == "Wall of Ice" then
        score = 50
    elseif name == "Ice Blocked Nathanos" then
        score = 50
    elseif name == "Jaina's Tide Elemental" then
        score = 49
    end
    if UnitIsUnit(unitid, "target") then
        score = score + 5
    end
    return score, bossString
end

WGBM[bossString].Interrupt = function(spell, unit, args)
    local unitid = unit.unitid

    if unit.name == bossString then
        if UnitName("target") == bossString then
            return true
        elseif UnitCastingInfo(unitid) == "Arcane Barrage" then
            return
        elseif UnitChannelInfo(unitid) == "Arcane Barrage" then
            return
        end
    end
    return true
    --printTo(3,'default interrupt')
end
--
--WGBM[bossString].DamageCD = function(spell, unit, args)
--    --local unitId = unit.unitid
--    --if unitId ~= "" then
--    local targetName = UnitName("target")
--
--    if DoingMythic() then
--        local timeInCombat = WarGod.Unit:GetPlayer():TimeInCombat()
--        if args[2] <= 60 and timeInCombat < 3 then
--            return true
--        end
--        if timeInCombat < 10 then
--            return
--        end
--        if args[2] >= 60 and targetName == bossString then
--            return
--        end
--    end
--    return true
--end

WGBM[bossString].Mitigation = function(spell, unit, args)
    --print('fetid mitigation')
    local bossCasting = UnitCastingInfo("boss1")
    --if UnitIsUnit("boss1target", "player") then
    if bossCasting == "Ice Shard" then
        local bossThreat = UnitThreatSituation("player","boss1")
        if bossThreat and bossThreat >= 3 and WarGod.Rotation.Delegates:IsItemInRange(spell, unit, {itemId = 10645}) then
            return true
        end
    end
    --end
    --return score, bossString
end

