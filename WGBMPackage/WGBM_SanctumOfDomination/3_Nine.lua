--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "The Nine"      -- not right at all

WGBM[bossString] = {}

--[[WGBM[bossString].DotQuick = function(spell, unit, args)
    if unit.health_percent > 0.8 then
        return true
    elseif unit.name == "Barrier" and unit.health_percent > 0.3 then
        return true
    end
end]]

--[[WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name

    if WarGod.Unit:GetPlayer():DebuffRemaining("Chi-Ji's Song","HARMFUL") > 0 then
        if unit:DebuffRemaining("Chi-Ji's Song","HARMFUL") == 0 then
            return true
        else
        end
    else--if WarGod.Unit:GetPlayer():DebuffRemaining("Chi-Ji's Song","HARMFUL") == 0 then
        if unit:DebuffRemaining("Chi-Ji's Song","HARMFUL") > 0 then
            return true
        end
    end

    if name == "Anathos Firecaller" then
        local cast = UnitChannelInfo(unitid)
        if cast == "Phoenix Strike" then
            return true
        elseif cast == "Flash of Phoenixes" then
            return true
        elseif unit.health < 5 then
            return true
        end
    elseif name == "Ma'ra Grimfang" then
        if UnitChannelInfo(unitid) == "Ring of Hostility" then
            return true
        elseif unit.health < 5 then
            return true
        end
    elseif name == "Living Bomb" then
        if IsItemInRange(32321, unitid) == false then
            return
        else
            return true
        end
    end

end]]

WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local score = 10
    local name = unit.name
    local targetName = unit.name
    local bossCasting = UnitCastingInfo(unitid)
    if name == "Formless Mass" then
        if unit.health_percent > 0.05 or UnitIsUnit(unitid, "target") then
            score = 50
        end
    elseif name == "Signe" or name == "Kyra" then
        score = 30 + unit.health / 10000000
    else
        score = 20
    end
    --[[if UnitIsUnit(unitid, "target") then
        score = score + 5
    end]]
    return score, bossString
end

WGBM[bossString].Defensive = function(spell, unit, args)
    local unitid = unit.unitid
    for i = 1, 5 do
        local debuffName = UnitDebuff(unitid,i)
        if not debuffName then
            return
        end
        if debuffName == "Fragments of Destiny" then
            if args[2] <= 150 then
                return unit.health_percent < 0.7
            end
        end
        if debuffName == "Daschla's Mighty Impact" then
            if args[2] <= 150 then
                return true
            end
        end
    end
end

WGBM[bossString].Interrupt = function(spell, unit, args)
    if unit.name == "Formless Mass" or UnitChannelInfo(unit.unitid) ~= nil then
        return true
    end
end

WGBM[bossString].Mitigation = function(spell, unit, args)
    local unit = unit or WarGod.Unit:GetPlayer()
    local boss1Threat = UnitThreatSituation("player","boss1")
    local boss2Threat = UnitThreatSituation("player","boss2")
    local boss3Threat = UnitThreatSituation("player","boss3")
    if boss1Threat and boss1Threat >= 3 then
        local boss1Casting = UnitCastingInfo("boss1")
        if boss1Casting == "Unending Strike" then
            return true
        elseif boss1Casting == "Pierce Soul" then
            return true
        end
    end
    if boss2Threat and boss2Threat >= 3 then
        local boss2Casting = UnitCastingInfo("boss2")
        if boss2Casting == "Unending Strike" then
            return true
        elseif boss2Casting == "Pierce Soul" then
            return true
        end
    end
    if boss3Threat and boss3Threat >= 3 then
        local boss3Casting = UnitCastingInfo("boss3")
        if boss3Casting == "Unending Strike" then
            return true
        elseif boss3Casting == "Pierce Soul" then
            return true
        end
    end
    --end
    --return score, bossString
end

--[[
WGBM[bossString].FriendlyBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name

    if WarGod.Unit:GetPlayer():DebuffRemaining("Chi-Ji's Song","HARMFUL") > 0 then
        if unit:DebuffRemaining("Chi-Ji's Song","HARMFUL") == 0 then
            return true
        end
    else--if WarGod.Unit:GetPlayer():DebuffRemaining("Chi-Ji's Song","HARMFUL") > 0 then
        if unit:DebuffRemaining("Chi-Ji's Song","HARMFUL") > 0 then
            return true
        end
    end

end
]]

--[[
WGBM[bossString].DamageCD = function(spell, unit, args)
    local unitId = unit.unitid
    local targetName = UnitName("target")

    if WarGod.Unit:GetUnit("boss1").health <= 5 then
        return true
    elseif DoingMythic() then
        local damageBuffRemains, damageBuffStacks = WarGod.Unit:GetPlayer():DebuffRemaining("Successful Defense", "HARMFUL")
        if damageBuffStacks >= 5 or damageBuffRemains > 0 and damageBuffRemains < 25 then
            return true
        else
            return
        end
    end
    return true
end]]