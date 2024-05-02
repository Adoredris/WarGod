--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Zek'voz, Herald of N'zoth"      -- not right at all
WGBM[bossString] = {}

local player = WarGod and WarGod.Unit and WarGod.Unit:GetPlayer() or false
local buff = player.buff

WGBM[bossString].Defensive = function(spell, unit, args)
    local unitid = unit.unitid
    if (WarGod.Unit:GetPlayer():AuraRemaining("Dark Stride","HARMFUL") > 0) then
        return args[2] <= 120
    end
end

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if (name == "Nerubian Voidweaver" and not UnitIsUnit(unitid, "target") and UnitDebuff(unitid, 10) == nil) then
        return true
    --[[elseif name == "Ember of Taeshalach" then
        if not DoingNormMax() then
            if DoingMythic() then
                if WarGodCore:AOEMode() then
                    return false
                end
            else
                return true
            end
        end]]
    end
end

WGBM[bossString].DPSWhitelist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if (name ~= "Zek'voz") then
        return true
    end
end

WGBM[bossString].Mitigation = function(spell, unit, args)
    --print('zekvoz mitigation')
    local bossThreat = UnitThreatSituation("player","boss1")
    if bossThreat and bossThreat >= 3 then
        local bossCasting = UnitCastingInfo("boss1")

        if bossCasting == "Shatter" or bossCasting == "Void Lash" then
            return true
        end
    end
    --return score, bossString
end

WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local score = 0
    local name = unit.name
    if name == "Zek'voz" then
        score = 10
    else
        score = 20
    end

    if UnitIsUnit(unitid, "target") then
        score = score + 5
    end
    return score, bossString
end

WGBM[bossString].DamageCD = function(spell, unit, args)
    if DoingMythic() then
        if args[2] > 120 then
            if WarGod.Unit.active_enemies > 4 then
                return true
            elseif player:BuffRemaining("Time Warp", "HELPFUL") > 0 or player:BuffRemaining("Heroism", "HELPFUL") > 0 or player:BuffRemaining("Primal Rage", "HELPFUL") > 0 or player:BuffRemaining("Bloodlust", "HELPFUL") > 0 then
                return true
            elseif player:BuffRemaining("Corruptor's Pact", "HARMFUL") > 0--[[buff.corruptors_pact.stacks > 0]] then
                return true
            elseif player:TimeInCombat() < 15 then
                return true
            else
                return
            end


        end
    end
    return true

    --if buff.time_warp

end