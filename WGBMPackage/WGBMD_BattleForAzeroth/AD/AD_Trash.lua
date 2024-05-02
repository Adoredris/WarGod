local WGBM = WarGod.BossMods

local bossString = "Atal'Dazar"
printTo(3,bossString)
WGBM[bossString] = {}

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    if (unit:BuffRemaining("Bad Voodoo","HELPFUL") > 0) then
        printTo(3,'not dpsing cause healing fast')
        return true

    elseif unit:BuffRemaining("Infested", "HELPFUL") > 0 then
        if not UnitIsUnit("target", unitid) then
            return true
        end
    elseif UnitCastingInfo(unitid) == "Teleport: The Eternal Palace" then
        return true

    end

    return false
end

--[[WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    --if (addSoon and WarGodU)
    local score = 10
    if name ~= bossString then
        score = 20
    end
    if UnitIsUnit(unitid, "target") then
        score = score + 5
    end
    return score, bossString
    --return WGBM.default.Priority(spell, unitid, args)
end]]

WGBM[bossString].Cleanse = function(spell, unit, args)
    local unitid = unit.unitid
    --if UnitClass("player") == "Druid" or UnitClass("player") == "Mage" then return end
    if unit:BuffRemaining("Unstable Hex", "HARMFUL") > 0 then
        return
    end
    if UnitGroupRolesAssigned("player") == "HEALER" then
        if unit:BuffRemaining("Cascading Terror", "HARMFUL") > 0 then
            return
        end
    end
    return true
end

WGBM[bossString].Interrupt = function(spell, unit, args)
    local unitid = unit.unitid
    local casting = UnitCastingInfo(unitid)
    if casting then
        if casting == "Venom Blast" then
            return
        end
    elseif unit.name == "Void-Touched Emissary" or unit.name == "Void" then
        return
    end
    return true
    --printTo(3,'default interrupt')
end

WGBM[bossString].ExtraHealthMissing = function(spell, unit, args)
    local total = 0
    local unitid = unit.unitid
    for i = 1, 5 do
        local debuffName, id, stacks = UnitDebuff(unitid,i)
        if not debuffName then
            break
        end
        if debuffName == "Rending Maul" then
            total = total + unit.health_max * 0.05 * stacks
        end
    end
    return total
    --local debuffName, _, _, _, _, _, _, _,_,_,_,_,_, _, _,absorbAmount = UnitDebuff("player",i)=="Immunosuppression"
    --/run for i=1,5 do if UnitDebuff("player",i)=="Immunosuppression" then print(select(16, UnitDebuff("player",i))) end end
end