local Rotation = WarGod.Rotation
setfenv(1, Rotation)
local delegates = {}
Delegates = delegates

--[[function Delegates:DPSBlacklistWrapper(...)
    --print(self)
    --print(...)
    --printTo(3,...)
    local spell, unit, args = ...
    local unitid = unit.unitid
    local name = unit.name
    if name == "Thing From Beyond" then
        if (not UnitIsUnit(unitid, "mouseover")) and (not UnitIsUnit(unitid, "target")) then
            return true
        end
    else
        if not WGBM then
            WGBM = WarGod.BossMods
        end
        return WGBM.DPSBlacklist(spell, unit, args)
    end
end]]

function Delegates:PriorityWrapper(...)
    --print(self)
    --print(...)
    --printTo(3,...)
    local spell, unit, args = ...
    local unitid = unit.unitid
    local name = unit.name
    --[[if (name == "Explosives") then
        --print('default killing explosives first')
        return 10000, "default"

    elseif name == "Thing From Beyond" then
        local class = UnitClass("player")
        if class == "Druid" then
            if spell == "Entangling Roots" or spell == "Mass Entanglement" or spell == "Mighty Bash" then
                return 100, "default in wrapper"
            else
                return 0, "default in wrapper"
            end
        else
            return 0, "Not Druid"   -- should come up with non-druid stuff
        end
    else]]
    if not WGBM then
        WGBM = WarGod.BossMods
    end
    return WGBM.Priority(spell, unit, args)
    --end
end

function Delegates:AoeBlacklistedWrapper(spell, unit, args)
    if select(2,GetInstanceInfo()) == "party" then
        if unit.name == "Explosives" then
            return true
        elseif unit.name == "Spiteful Shade" then
            return true
        end
    end

    return WGBM.AoeBlacklisted(spell, unit, args)--Delegates:NotAoeBlacklisted(spell, unit, args)
end

function Delegates:DotBlacklistedWrapper(...)
    local spell, unit, args = ...
    if unit.name == "Explosives" then
        return true

    end
    return WGBM.DotBlacklisted(...)
end

function Delegates:NotFriendlyBlacklistWrapper(...)
    return not Delegates:FriendlyBlacklistWrapper(...)
end

function Delegates:ExtraHealthMissingWrapper(spell, unit, args)
    if not WGBM then
        WGBM = WarGod.BossMods
    end

    local total = WGBM.default.ExtraHealthMissing(spell, unit, args)
    if WGBM.ExtraHealthMissing == WGBM.default.ExtraHealthMissing then
        local unitid = unit.unitid
        local threat = UnitThreatSituation(unitid)
        if threat then
            if threat >= 2 then
                total = total + 0.05 * unit.health_max
            end
        end
        --total = total + WGBM.ExtraHealthMissing(...)
    else
        total = total + WGBM.ExtraHealthMissing(spell, unit, args)
    end



    return total
end

local function DummyDelegate() return 1 end
setmetatable(delegates, {
    __index = function(t, name)
        local index = strfind(name, "Wrapper$")
        if index then
            print(name)
            local subName = strsub(name, 1, index-1)
            if WGBM and WGBM[subName] then
                delegates[name] = function(self, ...)       -- self there to stop self going through to WGBM functions
                    --print('calling WGBM func')
                    return WGBM[subName](...)
                end
                return delegates[name]
            end
        end
        print("Delegates." .. name .. " using DummyDelegate")
        delegates[name] = DummyDelegate
        return DummyDelegate
    end,
    __newindex = function(t, name, v)
        if rawget(t, name) then print("Delegate:" .. name .. " being replaced") end
        rawset(t, name, v)
    end,
})