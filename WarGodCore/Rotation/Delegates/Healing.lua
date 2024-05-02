local Rotation = WarGod.Rotation
setfenv(1, Rotation)

function Delegates:IsTankingSomething(spell, unit, args)
    local unitid = unit.unitid
    if unitid ~= "" then
        local threat = UnitThreatSituation(unitid)
        if threat then
            return threat >= 2
        end
    end
end

function Delegates:UnitMustBeTopped(spell, unit, args)
    local name = unit.name
    local unitid = unit.unitid
    --[[if strfind(name, "^Damaged") then
        return true
    end]]
    --[[if name == "Kael'thas Sunstrider" then
        return true
    else]]if name == "Training Dummy" then
        return true
    end
end