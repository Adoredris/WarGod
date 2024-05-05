

--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Painsmith Raznal"      -- not right at all
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
    if unit:BuffRemaining("Forge's Flames","HELPFUL") > 0 then
        return true
    end
    if WarGod.Control:SafeMode() then
        if not UnitIsUnit(unitid, "target") then
            return true
        else
            return
        end
    end

    if strmatch(name, "^Spiked Ball") then
        local UnitTargeting = 0
        for k,unitid in pairs(unit.unitIds) do
            if strmatch(unitid, "^raid") then
                UnitTargeting = UnitTargeting + 1
                if UnitTargeting > 2 then
                    return
                end
            end
        end
        return true
    elseif name ~= bossString then
        return
    end

end

WGBM[bossString].DotBlacklisted = function(spell, unit, args)
    if unit.name == "Shadowsteel Horror" and spell ~= "Sunfire" then
        return true
    end
end

WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    local score = 10
    if name == "Shadowsteel Horror" and unit.health_percent > 0.1 then
        score = 10 + unit.health_percent
    elseif name ~= bossString then
        if spell ~= "Fury of Elune" and unit.health_percent > 0.1 then
            score = 20

        end
    end
    if UnitIsUnit(unitid, "target") then
        score = score + 5
    end
    return score, bossString
end

WGBM[bossString].Defensive = function(spell, unit, args)
    local unitid = unit.unitid
    local now = GetTime()
    if unit:DebuffRemaining("Shadowsteel Chains", "HARMFUL") > 0 or unit.health_percent < 0.5 then
        if unit.health_percent < 0.9 then
            return args[2] <= 60
            --[[for msg,time in pairs(WGBM.timers) do
                local timeDiff = time - now
                if timeDiff < 0 and timeDiff > -15 then
                    if strmatch(msg, "Spiked Balls") then
                        if args[2] <= 60 then
                            return true
                        end
                    end
                end
                if timeDiff > -1 and timeDiff < 4 then
                    if strmatch(msg, "Cruciform Axe") or strmatch(msg, "Reverberating Hammer")then
                        if args[2] <= 60 then
                            return true
                        end
                    end
                end
            end]]
        end
    end
end

WGBM[bossString].DotQuick = function(spell, unit, args)
    if spell == "Sunfire" and unit.health_percent > 0.8 and unit.name == "Shadowsteel Horror" then
        return true
    end
end

WGBM[bossString].DamageCD = function(spell, unit, args)
    --local unitId = unit.unitid
    --if unitId ~= "" then
    local targetName = UnitName("target")

    if DoingMythic() then
        --local timeInCombat = WarGod.Unit:GetPlayer():TimeInCombat()
        if args[2] == 60 then
            local bossHpPercent = WarGod.Unit:GetUnit("boss1").health_percent
            if bossHpPercent > 0.75 then
                return true
            elseif bossHpPercent < 0.39 then
                return true
            elseif WarGod.Unit.active_enemies > 3 then
                return true
            elseif bossHpPercent < 0.69 and bossHpPercent > 0.45 then
                return true
            end
        elseif args[2] == 180 then
            local timeInCombat = WarGod.Unit:GetPlayer():TimeInCombat()
            if timeInCombat <= 30 then
                
            end
        else
            return true
        end
    end
    return true
end

WGBM[bossString].MoveIn = function(spell, unit, args)
    if unit:DebuffRemaining("Shadowsteel Chains", "HARMFUL") > 0 then
        return 1
    end
    -- add in time till balls spawn
    return 1337
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
--[[WGBM[bossString].DPSWhitelist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if (name ~= bossString) then
        return true
    end
end
--


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
end]]
--


--[[WGBM[bossString].Mitigation = function(spell, unit, args)
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
end]]

