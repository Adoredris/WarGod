local Unit = LibStub("AceAddon-3.0"):NewAddon("WarGodUnits", "AceConsole-3.0", "AceEvent-3.0")
WarGod.Unit = Unit
Unit.frames = {}
Unit.print = print
Unit.UnitName = UnitName
Unit.UnitGUID = UnitGUID
Unit.tinsert = tinsert
Unit.pairs = pairs
Unit.max = max
Unit.tonumber = tonumber


Unit.setmetatable = setmetatable
Unit.getmetatable = getmetatable

Unit.type = type
Unit.select = select

Unit.CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
Unit.strmatch = strmatch
Unit.strlower = strlower
Unit.strsub = strsub
Unit.SimcraftifyString = WarGod.SimcraftifyString
Unit.UnitHealth = UnitHealth
Unit.UnitHealthMax = UnitHealthMax
Unit.UnitGetIncomingHeals = UnitGetIncomingHeals
Unit.CreateFrame = CreateFrame
Unit.sort = sort
Unit.rawget = rawget
Unit.rawset = rawset
--Unit.originaltremove = tremove
Unit.random = random

Unit.pairs = pairs
Unit.ipairs = ipairs

Unit.UnitGUID = UnitGUID
Unit.GetNumGroupMembers = GetNumGroupMembers
Unit.UnitInRaid = UnitInRaid
Unit.UnitInParty = UnitInParty
Unit.UnitReaction = UnitReaction
Unit.UnitName = UnitName
Unit.UnitExists = UnitExists
Unit.UnitLevel = UnitLevel
Unit.UnitAura = UnitAura
Unit.UnitIsDeadOrGhost = UnitIsDeadOrGhost
Unit.UnitGroupRolesAssigned = UnitGroupRolesAssigned

Unit.GetAuraDataByAuraInstanceID = C_UnitAuras.GetAuraDataByAuraInstanceID
Unit.GetAuraDataBySlot = C_UnitAuras.GetAuraDataBySlot
Unit.GetCooldownAuraBySpellID = C_UnitAuras.GetCooldownAuraBySpellID
Unit.GetPlayerAuraBySpellID = C_UnitAuras.GetPlayerAuraBySpellID
--Unit.GetAuraDataBySlot = C_UnitAuras.IsAuraFilteredOutByInstanceID
--Unit.GetAuraDataBySlot = C_UnitAuras.WantsAlteredForm

Unit.substr = strsub
Unit.strsub = strsub
Unit.tContains = tContains
Unit.tcontains = tContains
Unit.tinsert = tinsert
Unit.tremove = tremove
Unit.tsort = table.sort
Unit.GetTime = GetTime

Unit.debug = true

--setmetatable(Units, m)



function TestUnits()
    Unit.player = WarGod.Unit.list.player
    Unit.party1 = WarGod.Unit.list.party1

    --Unit.moonkin_form = player.buff.moonkin_form
    --Unit.test = getmetatable(Sky.Units)
    --for k,v in pairs(test) do print(k) end
end
setfenv(1, WarGod.Unit)

function printdebug(msg)
    if debug then
        print(msg)
    end
end

function Unit:OnInitialize()
    -- Code that you want to run when the addon is first loaded goes here.

    --self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

    -- player stuff
    --self:RegisterEvent("ADDON_LOADED")
    self:RegisterEvent("GROUP_ROSTER_UPDATE")


    --self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

    self:RegisterEvent("UNIT_AURA")
end

function Unit:OnEnable()
    -- Called when the addon is enabled
    --printdebug('b')
end

function Unit:OnDisable()
    -- Called when the addon is disabled
end
