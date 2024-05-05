

--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Lihuvim, Principal Architect"      -- not right at all
WGBM[bossString] = {}

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if WarGod.Control:SafeMode() then
        if (not UnitIsUnit(unitid, "target")) then
            return true
        end
    end
    if WarGod.Rotation.Delegates:UnitIsBreakableCrowdControlled(spell, unit, args) then
        return true

    end
    if name == "Degeneration Automa" then
        if unit.health_percent > 0.99 then
            return true
        end
    end
    if DoingMythic() and name == "Acquisitions Automa" then
        return true
    end
    --[[if name == "Necrotic Ritualist" then
        if WarGod.Unit:GetUnit("boss1").health_percent < 0.45 or WarGod.Unit:GetUnit("boss2").health_percent < 0.45 or WarGod.Unit.boss3.health_percent < 0.45 or WarGod.Unit.boss4.health_percent < 0.45 then

        end
    end]]
end

WGBM[bossString].Priority = function(spell, unit, args)
    local name = unit.name
    local score = 10
    --[[if name == "Prototype of War" or name == "Prototype of Duty" or name == "Prototype of Absolution" then
        return 30 + unit.health / 10000000
    elseif name == "Prototype of Renewal" then
        return 30 + (UnitIsUnit(unit.unitid, "target") and 5 or 0) + unit.health / 10000000
    end]]
    if name == "Lihuvim" then
        score = 10
    --[[elseif name == "Necrotic Ritualist" then
        score = 40 + unit.health / 10000000]]
    end

    if name == "Defense Matrix Automa" then
        score = 40
    end
    if (UnitIsUnit(unit.unitid, "target")) then
        score = score + 5
    end
    if unit:BuffRemaining("Ephemeral Barrier","HELPFUL") > 0 then
        score = score * 0.5
    end
    return score, bossString
end

WGBM[bossString].DamageCD = function(spell, unit, args)
    if (not DoingMythic()) then return true end
    local now = GetTime()
    local targetName = UnitName("target")
    if targetName == "Guardian Automa" then
        return true
    elseif targetName == "Defense Matrix Automa" then
        return true
    elseif WarGod.Unit:GetPlayer():TimeInCombat() > 60 then
        return true
    end
end

WGBM[bossString].BurstUnit = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if name == "Guardian Automa" then
        -- should also check for some debuff?
        return true
    end

    return false
end

WGBM[bossString].Defensive = function(spell, unit, args)
    local bossCast = UnitCastingInfo("boss1")
    local bossChannel = UnitChannelInfo("boss1")
    if bossChannel == "Synthesize" then
        if args[2] <= 60 then
            return true
        end
    elseif bossCast == "Cosmic Shift" then
        if args[2] <= 60 then
            return true
        end
    end

end