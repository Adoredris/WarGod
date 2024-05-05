local WGBM = WarGod.BossMods
local groups = WarGod.Unit.groups

local bossString = "Sporecaller Zancha"
printTo(3,bossString)
WGBM[bossString] = {}

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    --print('boo')
    local unitid = unit.unitid
    --if UnitAffectingCombat(unitid) then return end  -- hoping this lets through the things that are fighting at the entrance
    local name = unit.unitid
    if WarGod.Control:SafeMode() then
        if UnitIsUnit(unitid, "mouseover") or UnitIsUnit(unitid, "target") then
            return
        end
        return true
    end


    if name == "Incorporeal Being" then return true end
    if WarGod.Rotation.Delegates:UnitIsBreakableCrowdControlled(spell, unit, args) then return true end
    return
end

WGBM[bossString].ExtraHealthMissing = function(spell, unit, args)
    local unitid = unit.unitid
    local total = 0
    for i = 1, 5 do
        local debuffName = UnitDebuff(unitid,i)
        if not debuffName then
            break
        end
        if debuffName == "Serrated Fangs" then
            local amount = select(16, UnitDebuff(unitid, i))
            print(amount)
        end
    end
    return total
    --local debuffName, _, _, _, _, _, _, _,_,_,_,_,_, _, _,absorbAmount = UnitDebuff("player",i)=="Immunosuppression"
    --/run for i=1,5 do if UnitDebuff("player",i)=="Immunosuppression" then print(select(16, UnitDebuff("player",i))) end end
end

WGBM[bossString].AoeIn = function(spell, unit, args)
    return 1337
end