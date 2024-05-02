local WGBM = WarGod.BossMods
local bossString = "Dark Inquisitor Xanesh"
WGBM[bossString] = {}

--[[WGBM[bossString].Interrupt = function(spell, unit, args)
    if unit.name == "Azsh'ari Witch" then
        return true
    end
    return
end]]

WGBM[bossString].HealCD = function(spell, unit, args)
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

WGBM[bossString].Interrupt = function(spell, unit, args)
    if UnitIsUnit("focus", unit.unitid) or UnitClass("player") == "Druid" and GetRaidTargetIndex(unit.unitid) == 6 then
        return true
    end
end

WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local score = 10
    --print('hivemind priority')
    local name = unit.name
    if (not WarGod.Control:SafeMode()) then
        if name ~= bossString then
            score = 20
        end
    end
    if UnitIsUnit(unitid, "target") then
        score = score + 5
    end


    return score, bossString
end

WGBM[bossString].Mitigation = function(spell, unit, args)
    local bossThreat = UnitThreatSituation("player","boss1")
    if bossThreat and bossThreat >= 3 then
        if UnitCastingInfo("boss1") == "Abyssal Strike" then
            return true, nil, true
        end
    end
    --end
    --return score, bossString
end

WGBM[bossString].Defensive = function(spell, unit, args)
    local unitid = unit.unitid
    local bossThreat = UnitThreatSituation("player","boss1")
    if bossThreat and bossThreat >= 3 then
        if UnitGroupRolesAssigned("player") == "TANK" then
            if UnitCastingInfo("boss1") == "Abyssal Strike" then
                for i=1,5 do
                    local name, _, count = UnitDebuff("player", i)
                    if name == "Abyssal Strike" and args then
                        if count >= 2 and args[1] <= 90 then
                            return true
                        elseif count >= 3 and args[1] <= 180 then
                            return true
                        end
                    end
                end
            end
        end
    end
end

--[[
WGBM[bossString].NotDotBlacklisted = function(spell, unit, args)
    if spell == "Primal Wrath" then
        if WarGod.Unit.active_enemies >= 4 then
            local numEnemies = 0
            for guid,unit in upairs(groups.harmOrPlates) do
                if Delegates:HarmIn10Yards("Rake", unit, {}) then
                    numEnemies = numEnemies + 1
                end
                if numEnemies >= 4 then
                    return true
                end
            end
        end
        return
    end
    if unit.name == "Zoatroid" then
        if UnitClass("player") == "Druid" then
            if GetSpecialization() == 1 then
                if spell ~= "Sunfire" then
                    return
                elseif unit.health_percent > 0.9 or GetUnitpeed(unit.unitid) > 0 then
                    return
                elseif unit.health_percent < 0.4 and (not IsMoving()) then
                    return
                end
            elseif GetSpecialization() == 2 then
                if spell == "Rip" then
                    return
                elseif unit.health_percent > 0.9 or GetUnitpeed(unit.unitid) > 0 then
                    return
                elseif unit.health_percent < 0.4 then
                    return
                end
            end
        elseif UnitClass("player") == "Priest" then
            if WarGod.Unit:GetPlayer().talent.misery.enabled and spell == "Shadow Word: Pain" and (not IsMoving()) then
                return

            end
        end
    end
    return true
end
]]
--[[
WGBM[bossString].MoveIn = function(spell, unit, args)
    local moveIn = 1337
    if WarGod.Unit:GetPlayer():DebuffRemaining("Incubation Fluid", "HARMFUL") > 0 then
        if (CastTimeFor(spell) >= 1.5) then
            local now = GetTime()
            for msg,time in pairs(WGBM.timers) do
                local timeDiff = time - now
                if timeDiff < moveIn and timeDiff > -1 then
                    if strmatch(msg, "Arcing Current") then
                        moveIn = timeDiff
                    end
                end
            end

        end
    end
    return moveIn
end
]]
--[[
WGBM[bossString].DamageCD = function(spell, unit, args)
    for i=1,5 do
        local name = UnitBuff("boss1",i)
        if name == nil then
            return true
        elseif name == "Massive Incubator" then
            return
        end
    end
    return true
end

]]