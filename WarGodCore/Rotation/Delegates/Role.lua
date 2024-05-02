local Rotation = WarGod.Rotation
setfenv(1, Rotation)

function Delegates:UnitIsTank(spell, unit, args)
    return unit.role == "TANK"
end