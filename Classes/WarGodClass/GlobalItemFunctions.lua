local Rotations = WarGod.Rotation
local Class = WarGod.Class
local groups = WarGod.Unit.groups
local player = WarGod.Unit:GetPlayer()
local talent = player.trait
local buff = player.buff
local azerite = player.azerite
local variable = player.variable
local covenant = player.covenant
local equipped = player.equipped
local runeforge = player.runeforge
local buff_ca_inc = player.buff_ca_inc

local WarGodUnit = WarGod.Unit
local UnitExists = UnitExists
--local IsItemInRange = IsItemInRange
local UnitInRaid = UnitInRaid

local upairs = upairs
local print = print

local InCombatLockdown = InCombatLockdown
local GetShapeshiftForm = GetShapeshiftForm
local GetSpellInfo = C_Spell.GetSpellInfo

local DoingHeroicPlus = DoingHeroicPlus
local GetNumGroupMembers = GetNumGroupMembers
local GetKeyLevel = GetKeyLevel
local GetZoneText = GetZoneText

local GetItemCount = C_Item.GetItemCount

local eclipse = player.eclipse

---------TEMP-------------
local WarGod = WarGod
local WGBM = WarGod.BossMods
local WarGodUnit = WarGod.Unit
--local Delegates = Rotations.Delegates
local WarGodControl = WarGod.Control
--------------------------


WarGod.potion = false


setfenv(1, Rotations)

-- precombat buff trinkets
AddItemFunction(nil,13,1.135,{
    func = function(self)
        if player.combat then
            return
        end
        if equipped.mistcaller_ocarina.slotIndex == 13 then
            if buff.mistcaller_ocarina:Remains() < 300 then
                return true
            end
        end
    end,
    units = groups.noone,
    label = "Trinket Slot 1",
    quick = true,
    --IsUsable = function(self) return true end,
})

AddItemFunction(nil,14,1.134,{
    func = function(self)
        if player.combat then
            return
        end
        if equipped.mistcaller_ocarina.slotIndex == 14 then
            if buff.mistcaller_ocarina:Remains() < 300 then
                return true
            end
        end
    end,
    units = groups.noone,
    label = "Trinket Slot 2 (Ocarina)",
    quick = true,
    --IsUsable = function(self) return true end,
})