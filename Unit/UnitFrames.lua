--local frames = {}       -- frames to be primarily used for handling updating existence of units that don't have an event of their own
local Unit = WarGod.Unit
local frames = Unit.frames

setfenv(1, WarGod.Unit)

local function FrameUpdate(t, unitid, event)
    t.timeSinceLastUpdate = 0
    local guid = UnitGUID(t.unitid)
    if event == "NAME_PLATE_UNIT_REMOVED" then
        --print(t.guid)
        guid = nil
    else
        --print(event)
    end

    if (guid ~= t.guid) then
        if guid and t.guid then
            Unit:RemoveUnitMapping(t.guid, t.unitid)
            Unit:AddUnitMapping(guid, t.unitid)
        elseif guid ~= nil then
            printdebug(t.unitid .. " has changed to " .. UnitName(t.unitid))
            Unit:AddUnitMapping(guid, t.unitid)
        else
            printdebug(t.unitid .. " no longer exists")
            Unit:RemoveUnitMapping(t.guid, t.unitid)
        end
        t.guid = guid
    end
end


local function FrameOnUpdate(self,elapsed)
    self.timeSinceLastUpdate = self.timeSinceLastUpdate + elapsed;
    if (self.timeSinceLastUpdate > self.updateInterval) then
        self:Update(self.unitid, "OnUpdate")

        --self.timeSinceLastUpdate = 0
    end
end

local function FrameNew(t, unitid)
    --printdebug(t)
    local self = CreateFrame("Frame", "Frame" .. unitid)
    --printdebug(self)
    self.unitid = unitid
    self.guid = UnitGUID(unitid)
    self.Update = FrameUpdate
    t[unitid] = self
    return self
end

local function FrameRegister(t, unitid, updateEvents)
    local self = FrameNew(t, unitid)
    --self.unitid = unitid
    self:Update(unitid)
    if (updateEvents) then
        for k,updateEvent in pairs(updateEvents) do
            self:RegisterEvent(updateEvent)
        end
        self:SetScript("OnEvent", function(self, event, unitid)
            if unitid then
                --printdebug(event)
                if self.unitid == unitid then
                    self:Update(self.unitid, event)
                end
            else
                self:Update(self.unitid)
            end
        end)
    end

    return self
end

local function UnregisterFrame(t)
    --printdebug(t.unitid)
    t:Hide()
    printdebug("TODO - Mess with unitsByGUID")
    if (t.guid) then
        -- mapping lost cause group size shrank
        Unit:RemoveUnitMapping(t.guid, t.unitid)
        --[[for i,unitid in ipairs(guidsToUnits[t.guid].unitIds) do
            if (unitid == t.unitid) then
                tremove(guidsToUnits[t.guid].unitIds, i)
                if (#guidsToUnits[t.guid].unitIds == 0) then
                    Unit:Remove(t.guid)
                    guidsToUnits[t.guid] = nil
                end
            end
        end]]

    end
end
do
    FrameRegister(frames, "player", nil); --frames["player"]:Update("player")--tinsert(guidsToUnits[frames["player"].guid].unitIds, "player")
    FrameRegister(frames, "target", {"PLAYER_TARGET_CHANGED"})
    FrameRegister(frames, "focus", {"PLAYER_FOCUS_CHANGED"})
    printdebug("TODO - IMPLEMENT nameplates")
    for i = 1, 40 do
        FrameRegister(frames, "nameplate" .. i, {"NAME_PLATE_UNIT_ADDED", "NAME_PLATE_UNIT_REMOVED"})--; frames["nameplate" .. i]:Update()
    end
    --local mouseoverFrame = frames["mouseover"]
    FrameRegister(frames, "mouseover", {"UPDATE_MOUSEOVER_UNIT"})
    frames["mouseover"].unitid = "mouseover"
    frames["mouseover"].updateInterval = random(4,7) * 0.01
    frames["mouseover"].timeSinceLastUpdate = 0
    frames["mouseover"]:SetScript("OnUpdate", FrameOnUpdate)
end
setmetatable(frames, {
    __index = function(t, unitid)
        printdebug('creating new frame for ' .. unitid)
        self = FrameNew(t, unitid)
        self.unitid = unitid
        self.updateInterval = random(4,7) * 0.1
        self.timeSinceLastUpdate = 0
        self:Update(unitid)
        self.UnregisterFrame = UnregisterFrame
        if (not strmatch(unitid, "^nameplate")) then
            self:SetScript("OnUpdate", FrameOnUpdate)
        end
        return self
    end
})

do
    local oldGroupType = "solo"
    local oldNumGroupMembers = 0
    local function GroupUpdate(event)
        local groupType = UnitInRaid("player") and "raid" or UnitInParty("player") and "party" or "solo"
        local numGroupMembers = (GetNumGroupMembers() - (groupType == "raid" and 0 or 1))
        if (numGroupMembers > oldNumGroupMembers) then
            for i=1,numGroupMembers do
                --printdebug("show and stuff")
                --frames[groupType .. i]:Update()
                frames[groupType .. i]:Show()
                --frames[groupType .. i .. "target"]:Update()
                frames[groupType .. i .. "target"]:Show()

            end
            --oldNumGroupMembers = numGroupMembers
        end
        if (numGroupMembers < oldNumGroupMembers) then
            for unitid,frame in pairs(frames) do
                local match = strmatch(unitid, groupType .. "%d+")
                if (match) then
                    if not UnitExists(match) then
                        --printdebug('unregister not exist')
                        frame:UnregisterFrame()
                    end
                end
            end
            --oldNumGroupMembers = numGroupMembers
        end
        if (groupType ~= oldGroupType) then
            for unitid,frame in pairs(frames) do
                if (strmatch(unitid, "^" ..oldGroupType))then
                    --printdebug('unregister ' .. oldGroupType)
                    frame:UnregisterFrame()
                end
            end
        end
        oldGroupType = groupType
        oldNumGroupMembers = numGroupMembers
        printdebug(numGroupMembers)
    end
    function Unit:GROUP_ROSTER_UPDATE(event)
        GroupUpdate(event)

    end
    GroupUpdate("LOADED")
    printdebug("numGroupMembers " .. oldNumGroupMembers)
end