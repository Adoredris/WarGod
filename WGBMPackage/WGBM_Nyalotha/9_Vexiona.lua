--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Vexiona"      -- not right at all
WGBM[bossString] = {}

--[[WGBM[bossString].Interrupt = function(spell, unit, args)
    if unit.name == "Azsh'ari Witch" then
        return true
    end
    return
end]]

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    return
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

WGBM[bossString].ExtraHealthMissing = function(spell, unit, args)
    --print('fetid mitigation')
    local amount = 0
    if UnitGroupRolesAssigned("player") == "TANK" then
        local bossThreat = UnitThreatSituation("player","boss1")
        if bossThreat and bossThreat >= 3 then
            if unit:DebuffRemaining("Despair","HARMFUL") > 0 then
                amount = amount + 0.15 * unit.health_max
            end
        end
    end
    return amount
    --return score, bossString
end

WGBM[bossString].Defensive = function(spell, unit, args)
    --print('fetid mitigation')
    if UnitGroupRolesAssigned("player") == "TANK" then
        local bossThreat = UnitThreatSituation("player","boss1")
        if bossThreat and bossThreat >= 3 then

            if WarGod.Unit:GetPlayer():DebuffRemaining("Despair","HARMFUL") > 0 then
                --print(args)
                if args and args[2] then
                    if args[2] < 60 then
                        return true, true, true
                    elseif args[2] < 120 then
                        if WarGod.Unit:GetPlayer().health_percent < 0.9 or select(2,WarGod.Unit:GetPlayer():DebuffRemaining("Despair","HARMFUL")) >= 15 then
                            return true, true, true
                        end
                    end
                end
            end
        end
    end
    --return score, bossString
end

WGBM[bossString].Mitigation = function(spell, unit, args)
    --print('fetid mitigation')

    local bossThreat = UnitThreatSituation("player","boss1")
    if bossThreat and bossThreat >= 3 then
        if WarGod.Unit:GetPlayer():DebuffRemaining("Despair","HARMFUL") > 0 then
            return true, true, true
        end
    end
    --end
    --return score, bossString
end