local Class = LibStub("AceAddon-3.0"):NewAddon("WarGodClass", "AceConsole-3.0", "AceEvent-3.0")
Class.random = random
Class.CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
Class.UnitClass = UnitClass
Class.UnitInRaid = UnitInRaid
Class.UnitGroupRolesAssigned = UnitGroupRolesAssigned
Class.GetSpecialization = GetSpecialization
Class.strmatch = strmatch
Class.GetTime = GetTime
Class.UnitPower = UnitPower
Class.UnitPowerMax = UnitPowerMax
Class.UnitExists = UnitExists
Class.DoEmote = DoEmote
Class.CreateFrame = CreateFrame
Class.ActivateSoulbind = C_Soulbinds.ActivateSoulbind
Class.GetActiveCovenantID = C_Covenants.GetActiveCovenantID
Class.GetActiveSoulbindID = C_Soulbinds.GetActiveSoulbindID
Class.strlower = strlower


local player = WarGod.Unit:GetPlayer()


local upairs = WarGod.Unit.upairs
WarGod.Class = Class
WarGod[UnitClass("player")] = Class
local WarGodRotation = WarGod.Rotation
local WarGodUnit = WarGod.Unit
WarGodUnit.active_enemies = 1
local WarGodControl = WarGod.Control
local Delegates = WarGod.Rotation.Delegates

local class = gsub(UnitClass("player"), " ", "")
C_AddOns.LoadAddOn("WarGod" .. class)

local IsInInstance = IsInInstance
local UnitAffectingCombat = UnitAffectingCombat
local IsResting = IsResting

function Class:OnInitialize()
    -- Code that you want to run when the addon is first loaded goes here.
    --self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
end

function Class:OnEnable()
    -- Called when the addon is enabled
    --print('boo')
end

function Class:OnDisable()
    -- Called when the addon is disabled
end



function Class:PLAYER_SPECIALIZATION_CHANGED(event, unitid)
    --if not unitid then print(event);print("Class:PLAYER_SPECIALIZATION_CHANGED") end
    if unitid == "player" then
        print("spec changed")
        local specIndex = GetSpecialization()

        if specIndex then
            local spec = select(2, GetSpecializationInfo(specIndex))
            if spec then
                spec = gsub(spec, " ", "")
                player.specIndex = specIndex
                player.spec = spec
                --print(spec)
                C_AddOns.EnableAddOn("WarGod"..class..spec)
                C_AddOns.LoadAddOn("WarGod" .. class .. spec)

            end

        end
    end
end
Class:PLAYER_SPECIALIZATION_CHANGED("PLAYER_SPECIALIZATION_CHANGED", "player")
Class:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")

--[[function Class:ADDON_LOADED(event, addon)
    --if not unitid then print(event);print("Class:PLAYER_SPECIALIZATION_CHANGED") end
    if addon == "WarGod" .. class then
        Class:PLAYER_SPECIALIZATION_CHANGED(event, "player")
    end
end
Class:RegisterEvent("ADDON_LOADED")]]

do
    local frame = CreateFrame("Frame")
    frame.updateDelay = 0.05
    frame.timeSinceLastUpdate = 0
    frame.harm = true       -- for passing into IsValid Enemy
    frame:SetScript("OnUpdate", function(self, elapsed)
        self.timeSinceLastUpdate = self.timeSinceLastUpdate + elapsed;
        if(self.timeSinceLastUpdate > self.updateDelay )then
            --print('boo')
            local focusFire = (not WarGodControl:CleaveMode()) and (not WarGodControl:AOEMode())
            local active_enemies = 0
            for k,unit in upairs(WarGodUnit.groups.targetableOrPlates) do
                if (WarGodRotation.IsValidEnemy(self,unit, {})) and Delegates:PriorityWrapper("", unit, {}) > 0 and (not Delegates:AoeBlacklistedWrapper("", unit, {})) then
                    --print('checking and stuff')
                    if (IsInInstance() or UnitAffectingCombat(unit.unitid)) or IsResting() then
                        active_enemies = active_enemies + 1
                    end
                    if focusFire then break end
                end
            end
            WarGodUnit.active_enemies = active_enemies
            --print(active_enemies)
            self.timeSinceLastUpdate = 0
        end
    end)
end

function IsMoving()
    return GetUnitSpeed("player") > 0 or IsFalling()
end

setfenv(1, WarGod.Class)


