--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Jadefire Masters"      -- not right at all

WGBM[bossString] = {}


--WGBM[bossString].Defensive = function(spell, unit, args)
--    local unitid = unit.unitid
--    if (unit:AuraRemaining("Ravenous Blaze", "HARMFUL") > 0) then
--        return args[2] <= 60
--    end
--    --return 1337
--end
--

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
--WGBM[bossString].DPSWhitelist = function(spell, unit, args)
--    local unitid = unit.unitid
--    local name = unit.name
--    if (name ~= bossString) then
--        return true
--    end
--end
--

WGBM[bossString].DotQuick = function(spell, unit, args)
    if unit.health_percent > 0.8 then
        return true
    elseif unit.name == "Barrier" and unit.health_percent > 0.3 then
        return true
    end
end

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name

    if WarGod.Unit:GetPlayer():DebuffRemaining("Chi-Ji's Song","HARMFUL") > 0 then
        if unit:DebuffRemaining("Chi-Ji's Song","HARMFUL") == 0 then
            return true
        else
            --[[if name ~= "Living Bomb" or UnitIsUnit("target",unitid) then
                return
            end]]
        end
    else--if WarGod.Unit:GetPlayer():DebuffRemaining("Chi-Ji's Song","HARMFUL") == 0 then
        if unit:DebuffRemaining("Chi-Ji's Song","HARMFUL") > 0 then
            return true
            --[[else
                return]]
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
        --elseif UnitIsUnit("target",unitid) and WarGod.Unit:GetPlayer():DebuffRemaining("Chi-ji's Song","HARMFUL") > 0 then
        --    return
        else
            return true
        end
    end
    --[[if WarGod.Unit:GetPlayer():DebuffRemaining("Chi-ji's Song","HARMFUL") > 0 then
        if unit:DebuffRemaining("Chi-ji's Song","HARMFUL") == 0 then
            return true
        else
            return
        end
    else--if WarGod.Unit:GetPlayer():DebuffRemaining("Chi-ji's Song","HARMFUL") == 0 then
        if unit:DebuffRemaining("Chi-ji's Song","HARMFUL") > 0 then
            return true
        else
            return
        end
    end]]
    --[[if name ~= "Living Bomb" and WarGod.Unit:GetPlayer():DebuffRemaining("Chi-ji's Song","HARMFUL") > 0 and UnitName("target") == "Living Bomb" then
        return true
    end]]

end

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

WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local score = 10
    local name = unit.name
    local targetName = unit.name
    local bossCasting = UnitCastingInfo(unitid)
    if bossCasting == "Pyroblast" then
        score = 59
    elseif name == "Living Bomb" then
        if WarGod.Unit:GetPlayer():DebuffRemaining("Chi-Ji's Song","HARMFUL") > 0 then
            score = 55
        else
            score = 0
        end
    elseif name == "Ma'ra Grimfang" then
        if UnitExists(unitid) then
            score = 26
        end
    elseif name == "Anathos Firecaller" then
        score = 20
    elseif name == "Barrier" then
        score = 40
    elseif name == "Spirit of Xuen" then
        score = 30
    end
    if UnitIsUnit(unitid, "target") then
        score = score + 5
    end
    return score, bossString
end

WGBM[bossString].DamageCD = function(spell, unit, args)
    local unitId = unit.unitid
    local targetName = UnitName("target")

    if WarGod.Unit.boss1.health <= 5 then
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
end