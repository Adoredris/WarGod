

--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "The Queen's Court"      -- not right at all
-- alt name
WGBM[bossString] = {}

--WGBM[bossString].Defensive = function(spell, unit, args)
--    local unitid = unit.unitid
--    if (unit:AuraRemaining("Ravenous Blaze", "HARMFUL") > 0) then
--        return args[2] <= 60
--    end
--    --return 1337
--end
--
--[[WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    --print("Blockade Blacklist")
    if name == "Potent Spark" then
        if (not UnitIsUnit(unitid, "target")) then
            return true
        end
    end
end]]

WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local score = 10

    if UnitIsUnit(unitid, "target") then
        score = score + 5
    end
    if spell == "Mind Sear" then
        if unit.name == "Silivaz the Zealous" or unit.name == "Pashmar the Fanatical" then
            return 0, bossString
        end
    end
    if WarGod.Unit:GetPlayer():BuffRemaining("Repeat Performance", "HARMFUL") > 0 then
        if WarGod.Unit:GetPlayer().prev_gcd == spell then
            return 0, bossString
        end
        if spell == "Void Eruption" and WarGod.Unit:GetPlayer().prev_gcd == "Void Bolt" then
            return 0, bossString
        end
    end
    if unit.name == "Potent Spark" then
        if spell == "Vampiric Touch" or spell == "Shadow Word: Pain" then
            if (unit.health_percent < 0.5 or WarGod.Unit:GetPlayer().buff.twist_of_fate.remains > 6.5) and WarGod.Unit:GetUnit("boss2").health_percent < 0.35 then
                score = 0
            end
        else
            if (not UnitIsUnit(unitid, "target")) then
                score = 0
            end
        end
    else
        --[[if spell == "Void Eruption" then
            if WarGod.Control:FocusFire() and UnitIsUnit("target", unitid) then
                score = 100
            else
                score = 50 - max(unit:DebuffRemaining("Shadow Word: Pain", "HARMFUL|PLAYER"), unit:DebuffRemaining("Vampiric Touch", "HARMFUL|PLAYER"))
                if UnitIsUnit("boss1", unitid) then
                    if unit.health_percent < 0.35 and WarGod.Unit:GetUnit("boss2").health_percent > 0.45 then
                        score = 1
                    end
                elseif UnitIsUnit("boss2", unitid) then
                    if unit.health_percent < 0.35 and WarGod.Unit:GetUnit("boss1").health_percent > 0.45 then
                        score = 1
                    end
                end
            end
        end]]
    end
    return score, bossString
end

WGBM[bossString].EnoughTimeToCast = function(spell, unit, args)
    if WarGod.Unit:GetPlayer():BuffRemaining("Repeat Performance", "HARMFUL") > 0 then
        if WarGod.Unit:GetPlayer().prev_gcd == spell then
            return
        end
        if spell == "Void Eruption" and WarGod.Unit:GetPlayer().prev_gcd == "Void Bolt" then
            return
        end
    end
    return true
end

WGBM[bossString].DPSWhitelist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if (name ~= bossString) then
        return true
    end
end
--[[
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
        if health_percent > 0.5 then
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
]]