

--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Fatescribe Roh-Kalo"      -- not right at all
--local altName = "Mekkatorque"
WGBM[bossString] = {}
--WGBM[altName] = WGBM[bossString]

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if unit:BuffRemaining("Realign Fate", "HELPFUL") > 0 then
        return true
    end
    if name == "Fatespawn Anomaly" then
        return
    end
    if WarGod.Control:SafeMode() then
        if (UnitIsUnit("target", unitid)) then
            return
        end
        return true
    end
    if (not DoingHeroicPlus()) then
        if name == "Shade of Destiny" then
            return true
        end
    end
end

WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    local score = 10
    if WarGod.Control:SafeMode() then
        if (not UnitIsUnit("target", unitid)) then
            return 0, bossString
        end
    end
    if name == "Shade of Destiny" then
        score = 50
    --elseif name == "Fatespawn Anomaly" then
    --    score = 40
    end

    if (UnitIsUnit("target", unitid)) and score > 0 then
        score = score + 1
    end
    return score, bossString
end

WGBM[bossString].Interrupt = function(spell, unit, args)
    if DoingMythic() then
        return true
    elseif unit.name == "Fatespawn Monstrosity" then
        return true
    end
    return
end

WGBM[bossString].DotQuick = function(spell, unit, args)
    return
end

WGBM[bossString].DamageCD = function(spell, unit, args)
    --local unitId = unit.unitid
    --if unitId ~= "" then
    local targetName = UnitName("target")

    if DoingMythic() then
        --local timeInCombat = WarGod.Unit:GetPlayer():TimeInCombat()
        if args[2] == 60 then
            local bossHpPercent = WarGod.Unit.boss1.health_percent
            if bossHpPercent > 0.42 then
                return true

            elseif WarGod.Rotations:LustRemaining() > 0 then
                return true

            elseif bossHpPercent < 0.35 then
                return true
                --[[
                if bossHpPercent > 0.75 then
                    return true
                elseif bossHpPercent < 0.39 then
                    return true
                elseif WarGod.Unit.active_enemies > 3 then
                    return true
                elseif bossHpPercent < 0.69 and bossHpPercent > 0.45 then
                    return true]]
            end
        elseif args[2] == 180 then
            local timeInCombat = WarGod.Unit:GetPlayer():TimeInCombat()
            local bossHpPercent = WarGod.Unit.boss1.health_percent
            if timeInCombat <= 30 then
                return true
            elseif WarGod.Rotations:LustRemaining() > 0 then
                return true
            end
        else
            return true
        end
    else
        return true
    end
end