

--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Stormwall Blockade"      -- not right at all
-- alt name
local altName = "Sea Priest Blockade"
WGBM[bossString] = {}
WGBM[altName] = WGBM[bossString]

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
    --print("Blockade Blacklist")
    if WarGod.Control:SafeMode() then
        if (not UnitIsUnit(unitid, "target")) then
            return true
        end
    end
end

WGBM[bossString].Cleanse = function(spell, unit, args)

end

WGBM[bossString].DotQuick = function(spell, unit, args)
    return unit:BuffRemaining("Tempting Song", "HARMFUL") > 0
end

WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local score = 10
    local name = unit.name
    if name == "Tempting Siren" then
        score = 20
    elseif name == "Energized Storm" then
        local health_percent = unit.health_percent
        if health_percent > 0.5--[[ and unit:BuffRemaining("Kelp Wrapping", "HARMFUL") > 0]] then
            score = 20
        end
    end
    if UnitIsUnit(unitid, "target") then
        score = score + 5
    end
    return score, bossString
end

WGBM[bossString].Interrupt = function(spell, unit, args)
    local unitid = unit.unitid

    if UnitCastingInfo(unitid) == "Catastrophic Tides" then
        return
    end
    if DoingMythic() then
        return
    end
    return true
    --printTo(3,'default interrupt')
end

WGBM[bossString].AllowedToInterrupt = function(spell, unit, args)
    local unitid = unit.unitid
    --print("checking interrupts on " .. unitid)
    if UnitCastingInfo(unitid) == "Catastrophic Tides" then
        print("skipping interrupts")
        return false
    end
    return true
end

WGBM[bossString].Defensive = function(spell, unit, args)
    local unitid = unit.unitid
    for i = 1, 5 do
        local debuffName = UnitDebuff(unitid,i)
        if not debuffName then
            return
        end
        if debuffName == "Sea Storm" then
            if args[2] <= 60 then
                return true
            end
        elseif debuffName == "Crackling Lightning" then
            if args[2] <= 60 and unit.health_percent < 0.7 then
                return true
            end
        --[[elseif debuffName == "Gigavolt Radiation" then
            return true
        elseif debuffName == "Buster Cannon" then
            return true
        elseif debuffName == "Sheep Shrapnel" then
            return true
        elseif debuffName == "Anti-Tampering Shock" then
            return true]]
        end
    end
end

WGBM[bossString].MoveIn = function(spell, unit, args)
    local moveIn = 1337
    if (CastTimeFor(spell) >= 1.5) then
        local now = GetTime()
        for msg,time in pairs(WGBM.timers) do
            local timeDiff = time - now
            if timeDiff < moveIn and timeDiff > -1 then
                if strmatch(msg, "Sea Swell") then
                    moveIn = timeDiff
                end
            end
        end

    end
    return moveIn
end