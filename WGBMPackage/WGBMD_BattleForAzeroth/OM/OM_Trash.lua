local WGBM = WarGod.BossMods

local bossString = "Operation: Mechagon"
printTo(3,bossString)
WGBM[bossString] = {}

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    if UnitIsUnit(unitid, "mouseover") or UnitIsUnit(unitid, "target") then
        return
    end
    local name = unit.name
    if name == "Samh'rek, Beckoner of Chaos" or name == "Ravenous Fleshfiend" or
            name == "Blood of the Corruptor" or name == "Mindrend Tentacle" or
            name == "Urg'roth, Breaker of Heroes" or name == "Malicious Growth" or
            name == "Voidweaver Mal'thir" or name == "Dummy 2" then
        return
    end
    if (unit:BuffRemaining("Smoke Cloud","HARMFUL") > 0) then
        if (WarGod.Unit:GetPlayer():BuffRemaining("Smoke Cloud","HARMFUL") == 0) then
            return true
        end

    else
        if WarGod.Unit:GetPlayer():BuffRemaining("Smoke Cloud", "HARMFUL") > 0 then
            return true
        end
    end
    local name = unit.name
    if name == "" then
        return true
    elseif name == "Walkie Shockie X1" then
        return true
    elseif name == "Shield Generator" then
        return true
    end
    return false
end

WGBM[bossString].FriendlyBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    if (unit:BuffRemaining("Smoke Cloud","HARMFUL") > 0) then
        if (WarGod.Unit:GetPlayer():BuffRemaining("Smoke Cloud","HARMFUL") == 0) then
            return true
        end

    else
        if WarGod.Unit:GetPlayer():BuffRemaining("Smoke Cloud", "HARMFUL") > 0 then
            return true
        end
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
    if unit:BuffRemaining("Unstable Hex", "HARMFUL") > 0 then
        return
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