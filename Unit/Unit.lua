local LRC = LibStub("LibRangeCheck-2.0")

local Unit = WarGod.Unit
local frames = Unit.frames
local Auras = WarGod.Unit.Auras


local unitsByGUID = {}
Unit.unitsByGUID = unitsByGUID

setfenv(1, WarGod.Unit)

local function AuraRemaining(self, auraName, filter)
    if filter == "HARMFUL|PLAYER" then
        return self.debuff[auraName]:Remains()
    end
    if filter == "HARMFUL" then
        return self.debuffAnyone[auraName]:Remains()
    end
    if filter == "HELPFUL|PLAYER" then
        return self.buff[auraName]:Remains()
    end
    if filter == "HELPFUL" then
        return self.buffAnyone[auraName]:Remains()
    end
    printdebug('something is wrong with the AuraRemaining filter')
    return 0
end

local function AuraStacks(self, auraName, filter)
    if filter == "HARMFUL|PLAYER" then
        return self.debuff[auraName]:Stacks()
    end
    if filter == "HARMFUL" then
        return self.debuffAnyone[auraName]:Stacks()
    end
    if filter == "HELPFUL|PLAYER" then
        return self.buff[auraName]:Stacks()
    end
    if filter == "HELPFUL" then
        return self.buffAnyone[auraName]:Stacks()
    end
    printdebug('something is wrong with the aura stacks filter')
    return 0
end

setmetatable(unitsByGUID, {
    __index = function(t, guid)
        local self = {}
        --rawset(t, guid, self)
        if guid ~= 0 then
            t[guid] = self
        end


        self.BuffRemaining = AuraRemaining
        self.DebuffRemaining = AuraRemaining
        self.BuffStacks = AuraStacks
        self.BuffCount = self.BuffStacks
        self.DebuffStacks = self.BuffStacks
        self.DebuffCount = self.BuffStacks
        self.Range = UnitRange
        self.RecentDamageTaken = RecentDamageTaken
        self.PercentHealthPredictedDamage = PercentHealthPredictedDamage
        self.recentDamageTakenTable = {}
        self.guid = guid
        self.unitIds = {}

        setmetatable(self, {
            __index = function(t,key)
                key = strlower(key)
                if key == "unitid" then
                    --print(self.guid)
                    for k,v in pairs(self.unitIds) do
                        --print(v)
                        if UnitGUID(v) == self.guid then
                            return v
                        else
                            --print(frames[v])
                            frames[v]:Update(v)
                        end
                    end
                    return ""

                elseif key == "name" then
                    return UnitName(self.unitid)
                elseif key == "unit_health" then
                    return UnitHealth(self.unitid)
                end

            end
        })

        self.buff = Auras:NewTable(self, "HELPFUL|PLAYER")
        self.debuff = Auras:NewTable(self, "HARMFUL|PLAYER")
        self.buffAnyone = Auras:NewTable(self, "HELPFUL")
        self.debuffAnyone = Auras:NewTable(self, "HARMFUL")

        return self
    end
})

local unitIdToUnitsByGUID = {}
setmetatable(unitIdToUnitsByGUID, {
    __index = function(t, unitId)
        return unitsByGUID[frames[unitId].guid or 0]
    end
})

--[[setmetatable(Unit, {
    __index = function(t, unitid)
        return unitIdToUnitsByGUID[unitid]
    end
})]]

local unitIdPriority = {
    player = 1,
    target = 4,
    focus = 8,
    mouseover = 12,
}

setmetatable(unitIdPriority, {
    __index = function(t, unitid)
        local val = 20
        if strmatch(unitid, "^party") then
            return 20 + tonumber(strsub(unitid, 6, 6))-- * 2

        elseif strmatch(unitid, "^raid") then
            return 40 + tonumber(strsub(unitid,5,5))
        elseif strmatch(unitid, "^nameplate") then
            return 100 + tonumber(strsub(unitid,10,10))
        end
        return val
    end
})

local function UnitIdSorter(a, b)
    printdebug("called UnitIdSorter")
    -- target > focus > mouseover > raidXtarget > nameplate
    return unitIdPriority[a] < unitIdPriority[b]
end

function Unit:RemoveUnitMapping(guid, unitid)
    local unit = rawget(unitsByGUID,guid)
    if unit then
        for i,unitIdIter in ipairs(unit.unitIds) do
            if unitIdIter == unitid then
                printdebug("removing mapping to " .. unitid)
                tremove(unit.unitIds, i)

                Unit:RemoveUnitFromGroups(unit, unitid)
                if i > 1 or #unit.unitIds > 0 then               -- if i is more than 1, then there should be another way to reach the unit

                    return
                end

                printdebug("removed last mapping to " .. unitid)
                unitsByGUID[guid] = nil
                --Unit:RemoveUnitFromGroups(unit, unitid)
                return
            end
        end
    end
end

function Unit:AddUnitMapping(guid, unitid)
    local unit = unitsByGUID[guid]

    tinsert(unit.unitIds, unitid)
    tsort(unit.unitIds, UnitIdSorter)

    Unit:AddUnitToGroups(unit, unitid)
end

Unit:AddUnitMapping(UnitGUID("player"), "player")