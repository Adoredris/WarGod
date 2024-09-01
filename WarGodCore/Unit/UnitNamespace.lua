local Unit = LibStub("AceAddon-3.0"):NewAddon("WarGodUnit", "AceConsole-3.0", "AceEvent-3.0")
WarGod.Unit = Unit
Unit.WarGod = WarGod
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
Unit.GetSpecialization = GetSpecialization
Unit.GetSpecializationInfo = GetSpecializationInfo
Unit.strmatch = strmatch
Unit.strlower = strlower
Unit.strupper = strupper
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

Unit.IsUsable = IsUsable
Unit.UnitPowerType = UnitPowerType
Unit.UnitPowerMax = UnitPowerMax
Unit.UnitPower = UnitPower
Unit.UnitChannelInfo = UnitChannelInfo
Unit.InCombatLockdown = InCombatLockdown

Unit.UnitGUID = UnitGUID
Unit.GetNumGroupMembers = GetNumGroupMembers
Unit.UnitInRaid = UnitInRaid
Unit.UnitInParty = UnitInParty
Unit.UnitReaction = UnitReaction
Unit.UnitName = UnitName
Unit.UnitClass = UnitClass
Unit.UnitExists = UnitExists
Unit.UnitLevel = UnitLevel
--Unit.UnitAura = UnitAura
Unit.UnitAuraSlots = C_UnitAuras.GetAuraSlots
Unit.GetAuraSlots = C_UnitAuras.UnitAuraSlots
Unit.EnumPowerType = Enum.PowerType
Unit.GetAuraDataByAuraInstanceID = C_UnitAuras.GetAuraDataByAuraInstanceID
Unit.GetAuraDataBySlot = C_UnitAuras.GetAuraDataBySlot
Unit.GetCooldownAuraBySpellID = C_UnitAuras.GetCooldownAuraBySpellID
Unit.GetPlayerAuraBySpellID = C_UnitAuras.GetPlayerAuraBySpellID
Unit.UnitIsDeadOrGhost = UnitIsDeadOrGhost
Unit.UnitGroupRolesAssigned = UnitGroupRolesAssigned
Unit.UnitSpellHaste = UnitSpellHaste
Unit.GetMastery = GetMastery
Unit.LibStub = LibStub
Unit.C_Covenants = C_Covenants
Unit.C_Item = C_Item
Unit.GetSpellCooldown = C_Spell.GetSpellCooldown

Unit.GetSpellInfo = C_Spell.GetSpellInfo
Unit.ItemLocation = ItemLocation
Unit.C_AzeriteEmpoweredItem = C_AzeriteEmpoweredItem
Unit.C_LegendaryCrafting = C_LegendaryCrafting

Unit.GetActiveConfigID = C_ClassTalents.GetActiveConfigID
Unit.GetConfigInfo = C_Traits.GetConfigInfo
Unit.GetTreeNodes = C_Traits.GetTreeNodes
Unit.GetNodeInfo = C_Traits.GetNodeInfo
Unit.GetEntryInfo = C_Traits.GetEntryInfo
Unit.GetDefinitionInfo = C_Traits.GetDefinitionInfo
Unit.GetSpellBookItemName = GetSpellBookItemName
Unit.GetSpellCharges = GetSpellCharges

--Unit.GetAuraDataBySlot = C_UnitAuras.IsAuraFilteredOutByInstanceID
--Unit.GetAuraDataBySlot = C_UnitAuras.WantsAlteredForm

Unit.substr = strsub
Unit.strsub = strsub
Unit.gsub = gsub
Unit.tContains = tContains
Unit.tcontains = tContains
Unit.tinsert = tinsert
Unit.tremove = tremove
Unit.tsort = table.sort
Unit.GetTime = GetTime
Unit.next = next

Unit.printdebug = WarGod.printdebug

--setmetatable(Units, m)



function TestUnits()
    Unit.player = WarGod.Unit.list.player
    Unit.party1 = WarGod.Unit.list.party1

    --Unit.moonkin_form = player.buff.moonkin_form
    --Unit.test = getmetatable(WarGod.Unit)
    --for k,v in pairs(test) do print(k) end
end
setfenv(1, WarGod.Unit)

function GetTarget()
    local guid = UnitGUID("target")
    if guid then
        return unitsByGUID[guid]
    end
end

function GetUnit(self, unitid)
    --print(unitid)
    local guid = UnitGUID(unitid)
    if guid then
        return unitsByGUID[guid]
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
