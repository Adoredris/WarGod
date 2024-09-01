local Binder = LibStub("AceAddon-3.0"):NewAddon("WarGodBinder", "AceConsole-3.0", "AceEvent-3.0")
WarGod.Binder = Binder

Binder.SetOverrideBinding = SetOverrideBinding
Binder.SetOverrideBindingClick = SetOverrideBindingClick
Binder.print = print
Binder.pairs = pairs
Binder.CreateFrame = CreateFrame
Binder.strmatch = strmatch
Binder.string = string
Binder.strrev = strrev
Binder.type = type
Binder.GetSpecializationInfo = GetSpecializationInfo
Binder.GetSpecialization = GetSpecialization
Binder.GetTalentInfo = GetTalentInfo
Binder.GetSpellInfo = C_Spell.GetSpellInfo
Binder.GetNumGroupMembers = GetNumGroupMembers
Binder.UnitInRaid = UnitInRaid
Binder.tinsert = tinsert
Binder.UnitClass = UnitClass
Binder.select = select
Binder.gsub = gsub
Binder.strlower = strlower
Binder.tostring = tostring
Binder.pairs = pairs
Binder.InCombatLockdown = InCombatLockdown
Binder.type = type
Binder.strsub = strsub
Binder.strmatch = strmatch
Binder.strrev = strrev
Binder.strfind = strfind
Binder.strlen = strlen
Binder.ChatFrame3 = ChatFrame3
Binder.UnitIsUnit = UnitIsUnit
--Binder.Auras = LibStub("AceAddon-3.0"):NewAddon("WarGodAuras", "AceConsole-3.0", "AceEvent-3.0")
--WarGod.Auras = Auras

setfenv(1, WarGod.Binder)



--Binder.Binder = WarGod.Binder
--setfenv(1, WarGod.Binder)

function Binder:OnInitialize()
    -- Code that you want to run when the addon is first loaded goes here.
    --Binder:RegisterEvent("ADDON_LOADED")

    --Binder:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")

    --self:RegisterEvent("GROUP_ROSTER_UPDATE")
end

function Binder:OnEnable()
    -- Called when the addon is enabled

end

function Binder:OnDisable()
    -- Called when the addon is disabled
end