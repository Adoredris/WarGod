local Rotation = WarGod.Rotation
setfenv(1, Rotation)



if (1==1) then return end

function Delegates:PriorityWrapper(...)
    --print(self)
    --print(...)
    --printTo(3,...)
    local spell, unit = ...
    local unitid = unit.unitIds[1]
    if (UnitName(unitid) == "Explosives") then
        return 100, "default"
    else
        if WGBM then
            return WGBM:Priority(...)
        end
        local index = GetRaidTargetIndex(unitid)
        if not index then
            if UnitIsUnit(unitid, "target") then
                index = 2
            else
                index = 0
            end
        end
        return index + 3, "default"
    end
end

function Delegates:FriendlyPriorityWrapper(...)
    --print(self)
    --print(...)
    --printTo(3,...)
    local spell, unit = ...
    local unitid = unit.unitIds[1]
    if (UnitName(unitid) == "Explosives") then
        return 100, "default"
    else
        if WGBM then
            return WGBM:FriendlyPriority(...)
        end
        local index = GetRaidTargetIndex(unitid)
        if not index then
            if UnitIsUnit(unitid, "target") then
                index = 2
            else
                index = 0
            end
        end
        return index + 3, "default"
    end
end



function Delegates:BurstUnitWrapper(...)
    if WGBM then
        return WGBM:BurstUnit(...)
    end
end

function Delegates:BurstInWrapper(...)
    if WGBM then
        return WGBM:BurstIn(...)
    end
    return 1337
end

function Delegates:DPSWhitelistWrapper(...)
    local unitid = ...
    if (UnitName(unitid) == "Explosives") then
        return true
    else
        if WGBM then
            return WGBM:DPSWhitelist(...)
        end
    end
end

function Delegates:DPSBlacklistWrapper(...)
    local unitid = ...
    if (UnitName(unitid) == "Explosives") then
        return false
    else
        if WGBM then
            return WGBM:DPSBlacklist(...)
        end
    end
end

function Delegates:InterruptWrapper(...)
    if WGBM then
        return WGBM:Interrupt(...)
    end
end

function Delegates:TauntWrapper(...)
    if WGBM then
        return WGBM:Taunt(...)
    end
end

function Delegates:EnoughTimeToCastWrapper(...)
    if WGBM then
        return WGBM:EnoughTimeToCast(...)
    end
end

function Delegates:HealCDWrapper(...)
    if WGBM then
        return WGBM:HealCD(...)
    end
end

function Delegates:MitigationWrapper(...)
    if WGBM then
        return WGBM:Mitigation(...)
    end
end

function Delegates:DefensiveWrapper(...)
    if WGBM then
        return WGBM:Defensive(...)
    end
    return 1337
end

function Delegates:PurgeWrapper(...)
    if WGBM then
        return WGBM:Purge(...)
    end
end

function Delegates:CleanseWrapper(...)
    if WGBM then
        return WGBM:Cleanse(...)
    end
end

function Delegates:MoveInWrapper(...)
    if WGBM then
        return WGBM:MoveIn(...)
    end
    return 1337
end

function Delegates:PrehealWrapper(...)
    if WGBM then
        return WGBM:Preheal(...)
    end
end