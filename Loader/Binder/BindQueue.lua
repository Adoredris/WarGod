local Binder = WarGod.Binder
setfenv(1, Binder)



local bindUpdatesQueued = false

function HaveSpell(spell)
    if (GetSpellInfo(spell) ~= nil) then
        return true
    end
end

function MatchesSpec(specs)
    --print(specs)
    if (type(specs) ~= "table") then
        specs = {specs}
    end
    local mySpecId = GetSpecialization();
    local mySpecName = GetSpecializationInfo(mySpecId)
    for k,spec in pairs(specs) do
        if (spec == mySpecId or spec == mySpecName) then
            return true
        end

    end
end

function HaveTalent(talentNameOrID)
    print('HaveTalent needs rewriting')
    for i=1,3 do
        for j=1,7 do
            local talentID, talentName, _, _, _, _, _, _,_, haveTalent, haveFakeTalent = GetTalentInfo(j, i,1)
            if (talentNameOrID == talentID or talentNameOrID == talentName) then
                return haveTalent
            end
        end
    end
end

function NotHaveTalent(talentNameOrID)
    return not HaveTalent(talentNameOrID)
end

local bindQueue = {}
for k,group in pairs(groups) do
    bindQueue[tostring(group)] = {}
end
--groups = groups or {}



function QueueSpellBind(spell, group, t)
    for index, unitid in pairs(group) do
        BindSpellToUnit(spell, unitid, t)
    end
end

local function ConditionsAllowSpell(when)
    if not when then
        return true
    end
    if type(when) == "function" then
        when = {when}
    end
    for k,v in pairs(when) do
        --print(k)
        --print(v)
        --print(k(v))
        if (not k(v)) then
            return false
        end
    end
    return true
end

if 1==1 then return end

function Binder:PLAYER_REGEN_ENABLED(event, addonName)
   UpdateBinds(event)
end

function Binder:ADDON_LOADED(event, addonName)
    --print(addonName)
    local class = gsub(select(2, UnitClass("player")), "%s+","_")
    if (strmatch(strlower(addonName), "^WarGod" .. strlower(class) .. "binds$")) then
        UpdateBinds(event)
        self:RegisterEvent("PLAYER_ENTERING_WORLD")
        self:RegisterEvent("PLAYER_TALENT_UPDATE")
        self:RegisterEvent("GROUP_ROSTER_UPDATE")
        self:GROUP_ROSTER_UPDATE()
    end

end

function Binder:PLAYER_ENTERING_WORLD(event, addonName)
    UpdateBinds(event)

end

function Binder:PLAYER_SPECIALIZATION_CHANGED(event, unitid)
    if unitid == "player" then
        --UpdateBinds(event)
    end
end

function Binder:PLAYER_TALENT_UPDATE(event)
    UpdateBinds(event)
end

function GroupRosterIncreased(event)
    UpdateBinds(event)
end