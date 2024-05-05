

--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Radiance of Azshara"      -- not right at all
WGBM[bossString] = {}

--[[
--WGBM[bossString].Defensive = function(spell, unit, args)
--    local unitid = unit.unitid
--    if (unit:AuraRemaining("Ravenous Blaze", "HARMFUL") > 0) then
--        return args[2] <= 60
--    end
--    --return 1337
--end
--]]
WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if DoingMythic() then
        if WarGod.Unit.active_enemies > 1 then
            if unit.name == bossString and unit.health_percent > 0.3 then
                return true
            end
        end
    end
end

WGBM[bossString].DPSWhitelist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if (name ~= bossString) then
        return true
    end
end

WGBM[bossString].Mitigation = function(spell, unit, args)
    --print('fetid mitigation')
    local bossCasting = UnitCastingInfo("boss1")
    --if UnitIsUnit("boss1target", "player") then
    if bossCasting == "Tide Fist" then
        -- probably want to put active mitigation up no matter what since you're either about to taunt or about to get hit hard
        --local bossThreat = UnitThreatSituation("player","boss1")
        --if not bossThreat or bossThreat < 3 then
            return true
        --end

    end
    --end
    --return score, bossString
end
--[[
--WGBM[bossString].DPSWhitelist = function(spell, unit, args)
--    local unitid = unit.unitid
--    local name = unit.name
--    if (name ~= bossString) then
--        return true
--    end
--end
--

WGBM[bossString].Taunt = function(spell, unit, args)
    local unitid = unit.unitid
    if unit.name == bossString then
        if UnitCastingInfo(unitid) == "Bestial Smash" then
            if WarGod.Unit:GetPlayer():DebuffRemaining("Crushed", "HARMFUL") <= 0 then
                if WarGod.Unit:GetUnit("boss1target"):DebuffRemaining("Crushed", "HARMFUL") > 0 then
                    print("Should Taunt")
                    --return true

                end
            end
        end
    end
end

WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local score = 10
    local name = unit.name
    local targetName = unit.name
    if (not WarGod.Control:SafeMode()) and name ~= "Grong the Revenant" then
        if unit.health_percent > 0.5 and UnitIsUnit("target", unitid) then
            score = 20

        end
    end
    if UnitIsUnit(unitid, "target") then
        score = score + 5
    end
    local index = GetRaidTargetIndex(unitid)
    if index then
        if index == 8 then
            score = score + index
        end
    end
    return score, bossString
end

WGBM[bossString].Interrupt = function(spell, unit, args)
    local unitid = unit.unitid
    if WarGod.Rotation.Delegates:HasSpellToInterrupt_LatestPossibleInterrupt(spell, unit, args) then
        if UnitIsUnit(unitid, "target") then
            return true
        end
    end

    return
    --printTo(3,'default interrupt')
end

--
--WGBM[bossString].DamageCD = function(spell, unit, args)
--    --local unitId = unit.unitid
--    --if unitId ~= "" then
--    local targetName = UnitName("target")
--
--    if DoingMythic() then
--        local timeInCombat = WarGod.Unit:GetPlayer():TimeInCombat()
--        if args[2] <= 60 and timeInCombat < 3 then
--            return true
--        end
--        if timeInCombat < 10 then
--            return
--        end
--        if args[2] >= 60 and targetName == bossString then
--            return
--        end
--    end
--    return true
--end

]]