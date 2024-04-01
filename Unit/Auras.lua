local Auras = {}
local Unit = WarGod.Unit
WarGod.Unit.Auras = Auras

local unverified = {}
local simcName = {}

setfenv(1, WarGod.Unit)

local function UpdateAura(self)
    local filter = self.parent.filter
    local unitid = self.parent.unit.unitid
    local slots = {select(2,UnitAuraSlots(unitid, filter))}
    for _,slotNo in ipairs(slots) do
        local t = GetAuraDataBySlot(unitid, slotNo)
        if simcName[t.name] == self.simcName then
            -- auraParentTable, unitAuraInfo
            --print(t.auraInstanceID)
            Auras:UpdateUnitsAura(self.parent, t)
        end
    end
    self.upToDate = true
    --Auras:UpdateUnitsAura(unit.debuffAnyone, t)

end

local function Stacks(self)
    printdebug('test stacks')
    if not self.upToDate then
        self:UpdateAura()
    end
    if not self.auraInstanceID then return 0 end
    local unitid = self.parent.unit.unitid
    if unitid == "" then return 0 end

    return self.stacks
end

local function Remains(self)
    --printdebug('test Remains')
    if not self.upToDate then
        self:UpdateAura()
    end
    --print(self.auraInstanceID)
    if not self.auraInstanceID then return 0 end
    local unitid = self.parent.unit.unitid
    if unitid == "" then return 0 end

    return self.expirationTime - GetTime()
end

local function Duration(self)
    printdebug('test Duration')
    if not self.upToDate then
        self:UpdateAura()
    end
    if not self.auraInstanceID then return 0 end
    local unitid = self.parent.unit.unitid
    if unitid == "" then return 0 end

    return self.duration
end

local function Up(self)
    return self:Remains() > 0
end
local function Down(self, spell)
    return not(self:Up())
end

function Auras:NewTable(unit, filter)
    local self = {}
    self.filter = filter
    self.unit = unit
    setmetatable(self, {
        __index = function(parent, simcAuraName)
            local self = {}
            --print('hi')
            --self.filter = parent[filter]
            self.simcName = simcAuraName
            self.parent = parent
            self.expirationTime = 0
            self.duration = 0
            self.charges = 0
            self.maxCharges = 0
            self.points = 0
            --self.upToDate = false

            self.Up = Up
            self.Down = Down

            self.Duration = Duration
            self.Remains = Remains
            self.Stacks = Stacks
            self.Count = self.Stacks
            self.UpdateAura = UpdateAura

            parent[simcAuraName] = self
            return self
        end
    })
    return self
end

function Auras:RemoveUnitsAura(unit, auraInstanceID)
    --printdebug("implement RemoveUnitsAura")
    for k,v in pairs(unit.buffAnyone) do
        if type(v) == "table" then
            --print(v.auraInstanceID)
            if v.auraInstanceID == auraInstanceID then
                v.expirationTime = 0
                v.duration = 0
                v.charges = 0
                v.maxCharges = 0
                v.points = 0
                v.auraInstanceID = nil
                v.upToDate = true
                printdebug("removed " .. unit.name .. "'s " .. v.name .. " buff")
                --return
            end
        end
    end
    for k,v in pairs(unit.buff) do
        if type(v) == "table" then
            --print(v.auraInstanceID)
            if v.auraInstanceID == auraInstanceID then
                v.expirationTime = 0
                v.duration = 0
                v.charges = 0
                v.maxCharges = 0
                v.points = 0
                v.auraInstanceID = nil
                v.upToDate = true
                printdebug("removed " .. unit.name .. "'s " .. v.name .. " buff")
                --return
            end
        end
    end
    for k,v in pairs(unit.debuffAnyone) do
        if type(v) == "table" then
            --print(v.auraInstanceID)
            if v.auraInstanceID == auraInstanceID then
                v.expirationTime = 0
                v.duration = 0
                v.charges = 0
                v.maxCharges = 0
                v.points = 0
                v.auraInstanceID = nil
                v.upToDate = true
                printdebug("removed " .. unit.name .. "'s " .. v.name .. " debuff")
                --return
            end
        end
    end
    for k,v in pairs(unit.debuff) do
        if type(v) == "table" then
            --print(v.auraInstanceID)
            if v.auraInstanceID == auraInstanceID then
                v.expirationTime = 0
                v.duration = 0
                v.charges = 0
                v.maxCharges = 0
                v.points = 0
                v.auraInstanceID = nil
                v.upToDate = true
                printdebug("removed " .. unit.name .. "'s " .. v.name .. " debuff")
                --return
            end
        end
    end
end

function Auras:UpdateUnitsAura(auraParentTable, unitAuraInfo)
    printdebug("implement UpdateUnitsAura")
    --local name = simcName[unitAuraInfo.name]
    --print(unitAuraInfo.name)
    if not simcName[unitAuraInfo.name] then
        simcName[unitAuraInfo.name] = SimcraftifyString(unitAuraInfo.name)
    end
    local aura = auraParentTable[simcName[unitAuraInfo.name]]
    aura.name = unitAuraInfo.name
    aura.simcName = simcName[unitAuraInfo.name]
    aura.auraInstanceID = unitAuraInfo.auraInstanceID
    aura.applications = unitAuraInfo.applications
    aura.charges = unitAuraInfo.charges
    aura.maxCharges = unitAuraInfo.maxCharges
    aura.duration = unitAuraInfo.duration
    aura.expirationTime = unitAuraInfo.expirationTime
    aura.points = unitAuraInfo.points
    aura.spellId = unitAuraInfo.spellId
    aura.upToDate = true
end

function Unit:UNIT_AURA(event, unitid, updateTable)
    local unit = Unit.unitsByGUID[UnitGUID(unitid)]
    if updateTable.removedAuraInstanceIDs then
        for k, instanceId in pairs(updateTable.removedAuraInstanceIDs) do
            -- when the remove event occurs, you can't query the info
            --print('removing ' .. instanceId)
            Auras:RemoveUnitsAura(unit, instanceId)
        end
    end
    if updateTable.updatedAuraInstanceIDs then
        for k, instanceId in pairs(updateTable.updatedAuraInstanceIDs) do
            --print('updated on ' .. unitid)
            local t = GetAuraDataByAuraInstanceID(unitid, instanceId)
            if t.isHarmful then
                Auras:UpdateUnitsAura(unit.debuffAnyone, t)
                if t.sourceUnit == "player" then
                    Auras:UpdateUnitsAura(unit.debuff, t)
                end
            elseif t.isHelpful then
                Auras:UpdateUnitsAura(unit.buffAnyone, t)
                if t.sourceUnit == "player" then
                    Auras:UpdateUnitsAura(unit.buff, t)
                end
            end
            --print(GetAuraDataByAuraInstanceID(unitid, instanceId))

        end
    end
    -- added seems to be a table of a table
    if updateTable.addedAuras then
        for k, t in pairs(updateTable.addedAuras) do
            --print('added to ' .. unitid)
            if t.isHarmful then
                Auras:UpdateUnitsAura(unit.debuffAnyone, t)
                if t.sourceUnit == "player" then
                    Auras:UpdateUnitsAura(unit.debuff, t)
                end
            elseif t.isHelpful then
                Auras:UpdateUnitsAura(unit.buffAnyone, t)
                if t.sourceUnit == "player" then
                    Auras:UpdateUnitsAura(unit.buff, t)
                end
            end

        end
    end
    if updateTable.isFullUpdate then
        printdebug("Should iterate all unit auras and dump their instanceIDs")
    end
end