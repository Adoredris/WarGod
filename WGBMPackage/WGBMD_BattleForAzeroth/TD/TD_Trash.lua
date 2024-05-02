local WGBM = WarGod.BossMods

local bossString = "Tol Dagor"
printTo(3,bossString)
WGBM[bossString] = {}

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    if (unit:AuraRemaining("Riot Shield", "HELPFUL") > 0) then
        printTo(3,'not dpsing with Riot Shield buff')
        return true
    elseif unit:BuffRemaining("Infested", "HELPFUL") > 0 then
        if not UnitIsUnit("target", unitid) then
            return true
        end
    elseif unit.name == "Heavy Cannon" then
        return true
    end

    return false
end

WGBM[bossString].Interrupt = function(spell, unit, args)
    local unitid = unit.unitid
    local casting = UnitCastingInfo(unitid)
    if not casting then
        casting = UnitChannelInfo(unitid)
    end
    if casting then
        if casting == "Salt Blast" then
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
        local debuffName, icon, count = UnitDebuff(unitid,i)
        if not debuffName then
            break
        end
        if debuffName == "Itchy Bite" then
            total = total + unit.health_max * 0.05 * count
        end
    end
    return total
    --local debuffName, _, _, _, _, _, _, _,_,_,_,_,_, _, _,absorbAmount = UnitDebuff("player",i)=="Immunosuppression"
    --/run for i=1,5 do if UnitDebuff("player",i)=="Immunosuppression" then print(select(16, UnitDebuff("player",i))) end end
end