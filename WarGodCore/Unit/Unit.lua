local Unit = WarGod.Unit
local frames = Unit.frames
local Auras = WarGod.Unit.Auras


local unitsByGUID = {}
Unit.unitsByGUID = unitsByGUID

setfenv(1, WarGod.Unit)

function upairs(t)
    local function stateless_iter(tbl, k)
        local v
        repeat
            --if tbl.name == "targetable" and k ~= "name" then print(k);print(v) end
            k, v = next(tbl, k)
        until ((not k) or type(v) == "table"--[[ or not tbl[k] ]])
        --if tbl.name == "targetable" then print(v) end
        if v then return k,v end
    end
    return stateless_iter, t, nil
end

local function AuraRemaining(self, auraName, filter)
    auraName = SimcraftifyString(auraName)
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
    auraName = SimcraftifyString(auraName)
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

local function RecentDamageTaken(self, howRecent)
    local damage = 0
    local now = GetTime()
    for k,v in pairs(self.recentDamageTakenTable) do
        if (GetTime() - v[1] > 60) then
            self.recentDamageTakenTable[k] = nil
        end
        if (GetTime() - v[1] > (howRecent or 5)) then
        else
            damage = damage + v[2]
        end
    end
    return damage
end

local function PercentHealthPredictedDamage(self)
    local unitId = self.unitid
    if unitId ~= "" and unitId then
        return (self.health - (WarGod.Rotation and WarGod.Rotation.Delegates:ExtraHealthMissingWrapper("", self, {}) or 0)) / self.health_max
    else
        return 1
        --print('not unitid Delegates:UnitUnderXPercentHealthPredicted')
        --print(...)
        --print(unit.name)
    end
end

local function AlwaysZero()
    return 0
end

setmetatable(unitsByGUID, {
    __index = function(t, guid)
        local self = {}
        --rawset(t, guid, self)
        if guid ~= nil and guid ~= 0 then
            t[guid] = self
            self.AuraRemaining = AuraRemaining
            self.BuffRemaining = AuraRemaining
            self.DebuffRemaining = AuraRemaining
            self.AuraStacks = AuraStacks
            self.BuffStacks = AuraStacks
            self.BuffCount = self.BuffStacks
            self.DebuffStacks = self.BuffStacks
            self.DebuffCount = self.BuffStacks
        else
            self.AuraRemaining = AlwaysZero
            self.BuffRemaining = AlwaysZero
            self.DebuffRemaining = AlwaysZero
            self.AuraStacks = AlwaysZero
            self.BuffStacks = AlwaysZero
            self.BuffCount = AlwaysZero
            self.DebuffStacks = AlwaysZero
            self.DebuffCount = AlwaysZero
        end


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
                    for k,v in pairs(self.unitIds) do
                        if UnitGUID(v) == self.guid then
                            return v
                        else
                            --print("Update forced")
                            --frames[v]:Update(v)
                        end
                    end
                    return ""
                elseif key == "level" then
                    return UnitLevel(self.unitid) or -1
                elseif key == "name" then
                    return UnitName(self.unitid) or ""
                elseif key == "health" then
                    return UnitHealth(self.unitid) or 0
                elseif key == "health_max" then
                    return UnitHealthMax(self.unitid) or 1
                elseif key == "health_percent" then
                    return self.health / self.health_max
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
    target = 2,
    focus = 4,
    mouseover = 8,
}

setmetatable(unitIdPriority, {
    __index = function(t, unitid)
        local val = 20
        if strmatch(unitid, "^boss") then
            return 10 + tonumber(strsub(unitid,5,5))

        elseif strmatch(unitid, "^party") then
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
    --printdebug("called UnitIdSorter")
    -- target > focus > mouseover > raidXtarget > nameplate
    return unitIdPriority[a] < unitIdPriority[b]
end

function Unit:RemoveUnitMapping(guid, unitid)
    local unit = rawget(unitsByGUID,guid)
    if unit then
        for i,unitIdIter in ipairs(unit.unitIds) do
            if unitIdIter == unitid then
                --printdebug("removing mapping to " .. unitid)
                tremove(unit.unitIds, i)

                Unit:RemoveUnitFromGroups(unit, unitid)
                if i > 1 or #unit.unitIds > 0 then               -- if i is more than 1, then there should be another way to reach the unit

                    return
                end

                --printdebug("removed last mapping to " .. unitid)
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