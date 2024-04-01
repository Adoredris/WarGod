local groups = {}
local Unit = WarGod.Unit
Unit.groups = groups


local frames = Unit.frames
local Auras = WarGod.Unit.Auras

groups.player = {}

groups.targetable = {}            -- @unit possible
groups.targetableOrPlates = {}    -- every single hostile unit
groups.targetableAndPlates = {}   -- theoretically somewhat in front of you under normal conditions
groups.plates = {}

groups.target = {}
groups.focus = {}
groups.mouseover = {}

setfenv(1, WarGod.Unit)

function Unit:AddUnitToGroups(unit, newUnitId)
    local newIdAbrv = substr(newUnitId, 1, 1)
    if newUnitId == "player" then
        groups.player[unit.guid] = unit
    elseif newIdAbrv == "n" then
        if groups.targetable[unit.guid] then
            groups.targetableAndPlates[unit.guid] = unit
        end
        groups.plates[unit.guid] = unit
        groups.targetableOrPlates[unit.guid] = unit
    else
        if newIdAbrv == "t" then
            groups.target[unit.guid] = unit
        elseif newIdAbrv == "f" then
            groups.focus[unit.guid] = unit
        elseif newIdAbrv == "m" then
            groups.mouseover[unit.guid] = unit
        end
        if groups.plates[unit.guid] then
            groups.targetableAndPlates[unit.guid] = unit
        end
        groups.targetableOrPlates[unit.guid] = unit
        groups.targetable[unit.guid] = unit
    end
end

function Unit:RemoveUnitFromGroups(unit, oldUnitId)
    local oldIdAbrv = substr(oldUnitId, 1, 1)
    if oldUnitId == "player" then
        return
    elseif oldIdAbrv == "n" then
        if not groups.targetable[unit.guid] then
            groups.targetableOrPlates[unit.guid] = nil
        end
        groups.plates[unit.guid] = nil
        groups.targetableAndPlates[unit.guid] = nil
    else
        if oldIdAbrv == "t" then
            groups.target[unit.guid] = nil
        elseif oldIdAbrv == "f" then
            groups.focus[unit.guid] = nil
        elseif oldIdAbrv == "m" then
            groups.mouseover[unit.guid] = nil
        end
        if not groups.plates[unit.guid] then
            -- this should get destroyed if necessary by the calling function which should clean it up here?
            groups.targetable[unit.guid] = nil
            groups.targetableOrPlates[unit.guid] = nil
        else
            local firstChar = substr(unit.unitIds[1], 1, 1)
            if firstChar == "n" then
                groups.targetableAndPlates[unit.guid] = nil
                groups.targetable[unit.guid] = nil
            elseif groups.targetable[unit.guid].unitid == "" then
                groups.targetableOrPlates[unit.guid] = nil
                groups.targetable[unit.guid] = nil
            end
            --elseif groups.targetable[unit.guid].unitid == "" then
            --    groups.targetable[unit.guid] = nil
            --    groups.targetableOrPlates[unit.guid] = nil
            --end
        end
    end
end