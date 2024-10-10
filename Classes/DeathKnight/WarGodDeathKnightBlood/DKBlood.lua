if UnitClass("player") ~= "Death Knight" then C_AddOns.DisableAddOn("WarGodDeathKnightBlood"); return end

local Rotations = WarGod.Rotation
local LibStub = LibStub
local Class = WarGod.Class
local Druid = Class

local WarGod = WarGod

local player = WarGod.Unit:GetPlayer()

player.fury = UnitPower("player")
player.fury_max = UnitPowerMax("player")
player.fury_deficit = player.fury_max - player.fury

setfenv(1, Rotations)

function Delegates:DoT_Anti_Pandemic(spell, unit, args)
    --local aura = unit.aura[args and args.aura or spell]
    --return aura.remains < args.threshold
    --return unit.unitIds[1]
    return unit:AuraRemaining(args and args.aura or spell, "HARMFUL|PLAYER") > (args and args.threshold or 1.5)
end

function Delegates:IsSpellNotInRange(spell, unit, args)
    local unitId = unit.unitid
    if (args and args.spell and unitId ~= "") then
        return IsSpellInRange(args.spell, unitId) == 0
    end
end