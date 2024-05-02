

--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Remnant of Ner'zhul"      -- not right at all
WGBM[bossString] = {}
--local altName = "Grong, the Revenant"
--WGBM[altName] = WGBM[bossString]

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if (WarGod.Control:SafeMode()) then
        if (not UnitIsUnit("target", unitid)) then
            return true
        end
    end
    if name == "Orb of Torment" then
        if unit:DebuffRemaining("Eternal Torment","HELPFUL") > 0 then
            --[[local sufferingIn = 1337
            local now = GetTime()
            for msg,time in pairs(WGBM.timers) do
                local timeDiff = time - now
                if timeDiff < sufferingIn and timeDiff > -5 then
                    if strmatch(msg, "Beam") and timeDiff > -2 then
                        sufferingIn = timeDiff
                        if sufferingIn < 2 then
                            return
                        end
                    end
                end
            end]]
            if UnitCastingInfo("boss1") == "Shatter" then
                return
            end
            return true
        end
    end
end

WGBM[bossString].Defensive = function(spell, unit, args)
    local unitid = unit.unitid
    local player_health_percent = WarGod.Unit:GetPlayer().health_percent
    if UnitCastingInfo("boss1") == "Shatter" then
        local bossHpPercent = WarGod.Unit.boss1.health_percent
        if bossHpPercent < 0.8 and bossHpPercent > 0.75 and player_health_percent < 0.9 or bossHpPercent < 0.6 and bossHpPercent > 0.55 or bossHpPercent < 0.3 and bossHpPercent > 0.25 then
            --print('defensive big shatter')
            return args[2] <= 60
        end
    end
    if WarGod.Unit:GetPlayer():AuraRemaining("Torment", "HARMFUL") > 0  and WarGod.Unit:GetPlayer().health_percent < 0.5 then
        --print('defensive torment')
        return args[2] <= 60
    end
    local malRemains = WarGod.Unit:GetPlayer():AuraRemaining("Malevolence", "HARMFUL")
    if malRemains > 0 and malRemains < 15 then
        --print('defensive malevolence')
        return args[2] <= 60
    end
    --return 1337
end

WGBM[bossString].AoeBlacklisted = function(spell, unit, args)
    --[[if unit.name == "Orb of Torment" and WarGod.Unit.active_enemies < 3 then
        return true
    end]]
end

WGBM[bossString].DotBlacklisted = function(spell, unit, args)
    if unit.name == "Orb of Torment" then
        if unit:DebuffRemaining("Eternal Torment","HELPFUL") > 0 then
            if UnitCastingInfo("boss1") == "Suffering" then
                return
            end
            return true
        else
            --return
        end
    end
end

WGBM[bossString].DotQuick = function(spell, unit, args)
    if unit.name == "Orb of Torment" and unit:DebuffRemaining("Eternal Torment","HELPFUL") > 0 then
        if UnitCastingInfo("boss1") == "Suffering" then
            return true
        end
        --return true
        --[[
        local sufferingIn = 1337
        local now = GetTime()
        for msg,time in pairs(WGBM.timers) do
            local timeDiff = time - now
            if timeDiff < sufferingIn and timeDiff > -5 then
                if strmatch(msg, "Beam") and timeDiff > -2 then
                    sufferingIn = timeDiff
                    if sufferingIn < 5 then
                        return true
                    end
                end
            end
        end]]
    end
end

WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local score = 10
    local name = unit.name
    local targetName = unit.name
    if (not WarGod.Control:SafeMode()) and name ~= "Remnant of Ner'zhul" then
        if unit.name == "Orb of Torment" and unit:DebuffRemaining("Eternal Torment","HELPFUL") > 0 then
            score = 1
        elseif spell ~= "Fury of Elune" then
            if unit.health_percent > 0.7--[[ and UnitIsUnit("target", unitid)]]then
                score = 20 + unit.health_percent
            end
        end
    end

    if UnitIsUnit(unitid, "target") then
        score = score + 5
    end
    return score, bossString
end

WGBM[bossString].Interrupt = function(spell, unit, args)
    return
end

WGBM[bossString].DamageCD = function(spell, unit, args)
    local now = GetTime()
    --print('boo')
    if DoingMythic() then
        if args[2] >= 300 then
            if WarGod.Rotations.LustRemaining() > 0 then
                return true
            else
                return
            end
        end
        if WarGod.Rotations.LustRemaining() > 0 then
            return true
        end
        if args[2] > 120 then
            --print("DamageCD")
            if WarGod.Unit:GetPlayer():TimeInCombat() < 20 then
                return true
            end
            if WarGod.Rotations.LustRemaining() > 0 then
                return true
            end
        else
            if WarGod.Unit.boss1.health_percent > 0.35 or WarGod.Unit.boss1.health_percent < 0.25 then
                return WarGod.Unit:GetPlayer():TimeInCombat() > 5
            end
        end
    else
        return true
    end
end