local WGBM = WarGod.BossMods
--local Delegates = WarGod.Rotation.Delegates
local bossString = "Shrine of the Storm"
printTo(3,bossString)
WGBM[bossString] = {}

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    if unit:BuffRemaining("Infested", "HELPFUL") > 0 then
        if not UnitIsUnit("target", unitid) then
            return true
        end

    end

    return false
end


WGBM[bossString].Interrupt = function(spell, unit, args)
    local unitid = unit.unitid
    if WarGod.Rotation.Delegates:HasSpellToInterrupt_LatestPossibleInterrupt(spell, unit, args) then
        return true
    end
    if UnitCastingInfo(unitid) == "Consume Essence" then
        return
    end
    return true
    --printTo(3,'default interrupt')
end

WGBM[bossString].ExtraHealthMissing = function(spell, unit, args)
    local total = 0
    local unitid = unit.unitid
    for i = 1, 5 do
        local debuffName = UnitDebuff(unitid,i)
        if not debuffName then
            break
        end
        if debuffName == "Decaying Mind" then
            local amount = select(16, UnitDebuff(unitid, i))
            --print(amount)
            total = total + unit.health_max * 0.2
        elseif debuffName == "Carve Flesh" then
            local amount = select(16, UnitDebuff(unitid, i))
            --print(amount)
            total = total + unit.health_max * 0.2
        end
    end
    for i = 1, 30 do
        local buffName = UnitBuff(unitid,i)
        if not buffName then
            break
        end
        if buffName == "Minor Reinforcing Ward" then
            --local amount = select(16, UnitBuff(unitid, i))
            --print(amount)
            total = total * 0.25
        end
    end
    return total
    --local debuffName, _, _, _, _, _, _, _,_,_,_,_,_, _, _,absorbAmount = UnitDebuff("player",i)=="Immunosuppression"
    --/run for i=1,5 do if UnitDebuff("player",i)=="Immunosuppression" then print(select(16, UnitDebuff("player",i))) end end
end