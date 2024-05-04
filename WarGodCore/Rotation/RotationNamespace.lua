local Rotation = LibStub("AceAddon-3.0"):NewAddon("WarGodRotation", "AceConsole-3.0", "AceEvent-3.0")
WarGod.Rotation = Rotation
EnableAddOn("WarGodBossMods")
LoadAddOn("WarGodBossMods")
WarGod.Rotation.WGBM = WarGod.BossMods
Rotation.printTo = WarGod.printTo

Rotation.CreateFrame = CreateFrame
Rotation.ChatFrame4 = ChatFrame4

Rotation.print = print
Rotation.LRC = LibStub("LibRangeCheck-2.0")
--Rotation.WarGod = WarGod
Rotation.WarGodUnit = WarGod.Unit
Rotation.WarGodBM = WarGod.BossMods
Rotation.setmetatable = setmetatable
Rotation.tContains = tContains
Rotation.tinsert = tinsert
Rotation.rawset = rawset
Rotation.rawget = rawget
Rotation.IsMounted = IsMounted
Rotation.GetUnitSpeed = GetUnitSpeed
Rotation.IsFalling = IsFalling
Rotation.CreateFrame = CreateFrame
Rotation.select = select
Rotation.pairs = pairs
Rotation.random = random
Rotation.max = max
Rotation.GetTime = GetTime

--Rotation.pixel = WarGod.Pixel
Rotation.GetSpellCooldown = GetSpellCooldown
Rotation.GetInventoryItemCooldown = GetInventoryItemCooldown
Rotation.GetItemCooldown = GetItemCooldown
Rotation.GetItemCount = GetItemCount
Rotation.UnitCastingInfo = UnitCastingInfo
Rotation.UnitChannelInfo = UnitChannelInfo
Rotation.GetNetStats = GetNetStats
Rotation.type = type
Rotation.print = print
Rotation.strmatch = strmatch
Rotation.strsub = strsub
Rotation.strfind = strfind
Rotation.strlen = strlen
Rotation.tostring = tostring
Rotation.setmetatable = setmetatable
Rotation.random = random
Rotation.tonumber = tonumber
Rotation.UnitGUID = UnitGUID

Rotation.GetSpecialization = GetSpecialization
Rotation.GetSpecializationInfo = GetSpecializationInfo
Rotation.UnitClass = UnitClass
Rotation.GetCurrentKeyBoardFocus = GetCurrentKeyBoardFocus
Rotation.UnitInVehicle = UnitInVehicle
Rotation.HasOverrideActionBar = HasOverrideActionBar
Rotation.UnitHasVehicleUI = UnitHasVehicleUI
Rotation.UnitIsDeadOrGhost = UnitIsDeadOrGhost
Rotation.UnitHealth = UnitHealth
Rotation.UnitHealthMax = UnitHealthMax
Rotation.UnitIsPlayer = UnitIsPlayer
Rotation.UnitName = UnitName
Rotation.UnitExists = UnitExists
Rotation.CheckInteractDistance = CheckInteractDistance
Rotation.UnitGetIncomingHeals = UnitGetIncomingHeals

--Rotation.IsItemInRange = IsItemInRange
Rotation.IsSpellInRange = LibStub("SpellRange-1.0").IsSpellInRange
Rotation.IsInInstance = IsInInstance
Rotation.GetInstanceInfo = GetInstanceInfo
Rotation.GetDifficultyInfo = GetDifficultyInfo
Rotation.GetDungeonDifficultyID = GetDungeonDifficultyID
Rotation.GetNumGroupMembers = GetNumGroupMembers
Rotation.UnitAffectingCombat = UnitAffectingCombat
Rotation.GetSpellInfo = GetSpellInfo
Rotation.CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
Rotation.GetQuestObjectiveInfo = GetQuestObjectiveInfo

Rotation.UnitDebuff = UnitDebuff
Rotation.UnitBuff = UnitBuff

Rotation.GetShapeshiftForm = GetShapeshiftForm
Rotation.GetShapeshiftFormInfo = GetShapeshiftFormInfo
Rotation.GetZoneText = GetZoneText
Rotation.upairs = WarGod.Unit.upairs
Rotation.SimcraftifyString = WarGod.SimcraftifyString
Rotation.UnitThreatSituation = UnitThreatSituation
Rotation.UnitVehicleSeatCount = UnitVehicleSeatCount

Rotation.groups = WarGod.Unit.groups

Rotation.player = WarGod.Unit:GetPlayer()

Rotation.printdebug = WarGod.printdebug

setfenv(1, Rotation)
rotationFrames = {}
setmetatable(rotationFrames, {__index = function(parent, name)
    local self = {}
    parent[name] = self
    setmetatable(self, {
        __index = function (parent, spell)

            local self = CreateFrame("Frame", spell .. "Frame")
            rawset(parent, spell, self)

            self.name = spell
            self.maxScore = 0


            return self
        end
    })
    return self
end})