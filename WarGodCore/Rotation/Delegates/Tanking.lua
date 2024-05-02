local Rotation = WarGod.Rotation

setfenv(1, Rotation)

function Delegates:IAmNotTankingUnit(spell, unit, args)
    local unitid = unit.unitid
    if unitid ~= "" then
        local threat = UnitThreatSituation("player", unitid)
        if (threat == nil or threat < 2) then
            return true
        end
    end
end

function Delegates:IAmTankingUnit(spell, unit, args)
    local unitId = unit.unitid
    if unitId ~= "" then
        --printTo(3,unitid)
        return UnitDetailedThreatSituation("player", unitId)
    end
end