--
-- Created by IntelliJ IDEA.
-- User: Flora
-- Date: 16/12/2017
-- Time: 8:00 PM
-- To change this template use File | Settings | File Templates.
--
local Rotations = WarGod.Rotation
local Class = WarGod.Class
local groups = WarGod.Unit.groups
local player = WarGod.Unit:GetPlayer()
local talent = player.trait
local buff = player.buff
local azerite = player.azerite
local variable = player.variable

local GetShapeshiftForm = GetShapeshiftForm


---------TEMP-------------
local WGBM = WarGod.BossMods
--local Delegates = Rotations.Delegates
local WarGodCore = WarGod.Control
local WarGodControl = WarGod.Control
local WarGodUnit = WarGod.Unit
--------------------------

local floor = floor
local ceil = ceil

setfenv(1, Rotations)

local baseScore = 3000



function Delegates:SunfireTargetCondition(spell, unit, args)
    if (WarGodUnit.active_enemies > 1 + (talent.twin_moons.enabled and 1 or 0)) then
        return true
    elseif (unit:DebuffRemaining("Moonfire","HARMFUL|PLAYER") > 0) then
        return true
    end
end

function Delegates:MoonfireTargetCondition(spell, unit, args)
    if (WarGodUnit.active_enemies > 1 + (talent.twin_moons.enabled and 1 or 0)) then
        return true
    elseif (unit:DebuffRemaining("Moonfire","HARMFUL|PLAYER") > 0) then
        return true
    end
end

function Delegates:IncCondition(spell, unit, args)
    if (buff.celestial_alignment.down and buff.incarnation_chosen_of_elune.down) then
        return true
    else
        local remains = unit:DebuffRemaining(spell,"HARMFUL|PLAYER")
        if (buff.celestial_alignment.remains > remains) then
            return true
        elseif (buff.incarnation_chosen_of_elune.remains > remains) then
            return true
        end
    end
end

do


    --actions.prepatch_st=moonfire,target_if=refreshable&target.time_to_die>12,if=(buff.ca_inc.remains>5|!buff.ca_inc.up|astral_power<30)&ap_check
    --actions.prepatch_st+=/sunfire,target_if=refreshable&target.time_to_die>12,if=(buff.ca_inc.remains>5|!buff.ca_inc.up|astral_power<30)&ap_check
    --actions.prepatch_st+=/stellar_flare,target_if=refreshable&target.time_to_die>16,if=(buff.ca_inc.remains>5|!buff.ca_inc.up|astral_power<30)&ap_check

    --------------------------------------------------------------------------------------------------------------------
    --actions.prepatch_st=moonfire,target_if=refreshable&target.time_to_die>12,if=(buff.ca_inc.remains>5|!buff.ca_inc.up|astral_power<30)&ap_check
    AddSpellFunction("Balance","Moonfire",baseScore + 960,{
        func = function(self) return AP_Check(self.spell) and
            ((buff.celestial_alignment:Remains() > 5 or buff.incarnation_chosen_of_elune:Remains() > 5) or
            (buff.celestial_alignment.down and buff.incarnation_chosen_of_elune.down) or
            player:Lunar_Power() < 30)
        end,
        units = groups.targetable,
        label = "Moonfire Refresh",
        ["andDelegates"] = {Delegates.IsSpellInRange, Delegates.DoT_Pandemic, Delegates.DoT_TTD_Estimate, Delegates.NotDotBlacklisted--[[, Delegates.SunfireTargetCondition, ]]},
        ["scorer"] = ScoreByInvertedDebuffTimeRemaining,
        args = {--[[aura = "sunfire", ]]threshold = 6.6, ttd = 12},
        Castable = function(self) return Delegates:EnoughTimeToCastWrapper(self.spell, player, {}) end,
        helpharm = "harm",
        maxRange = 45,
        quick = true,
        needNotFace = true,
    })

    --actions.prepatch_st+=/sunfire,target_if=refreshable&target.time_to_die>12,if=(buff.ca_inc.remains>5|!buff.ca_inc.up|astral_power<30)&ap_check
    AddSpellFunction("Balance","Sunfire",baseScore + 760,{
        func = function(self) return AP_Check(self.spell) and
                ((buff.celestial_alignment:Remains() > 5 or buff.incarnation_chosen_of_elune:Remains() > 5) or
                (buff.celestial_alignment.down and buff.incarnation_chosen_of_elune.down) or
                        player:Lunar_Power() < 30)
        end,
        units = groups.targetable,
        label = "Sunfire Refresh",
        ["andDelegates"] = {Delegates.IsSpellInRange, Delegates.DoT_Pandemic, Delegates.DoT_TTD_Estimate, Delegates.NotDotBlacklisted--[[, Delegates.SunfireTargetCondition, ]]},
        ["scorer"] = ScoreByInvertedDebuffTimeRemaining,
        args = {--[[aura = "sunfire", ]]threshold = 5.4, ttd = 12},
        Castable = function(self) return Delegates:EnoughTimeToCastWrapper(self.spell, player, {}) end,
        helpharm = "harm",
        maxRange = 45,
        quick = true,
        needNotFace = true,
    })

    --actions.prepatch_st+=/stellar_flare,target_if=refreshable&target.time_to_die>16,if=(buff.ca_inc.remains>5|!buff.ca_inc.up|astral_power<30)&ap_check
    AddSpellFunction("Balance","Stellar Flare",baseScore + 530,{
        func = function(self) return AP_Check(self.spell) and
                ((buff.celestial_alignment:Remains() > 5 or buff.incarnation_chosen_of_elune:Remains() > 5) or
                (buff.celestial_alignment.down and buff.incarnation_chosen_of_elune.down) or
                        player:Lunar_Power() < 30)
        end,
        units = groups.targetable,
        label = "Stellar Flare Refresh",
        ["andDelegates"] = {Delegates.IsSpellInRange, Delegates.DoT_Pandemic, Delegates.DoT_TTD_Estimate, Delegates.NotCastingThisAtTargetAlready, Delegates.NotDotBlacklisted},
        ["scorer"] = ScoreByInvertedDebuffTimeRemaining,
        args = {threshold = 7.2, ttd = 16},
        Castable = function(self) return (not IsMoving()) and Delegates:EnoughTimeToCastWrapper(self.spell, player, {}) end,
        IsUsable = function(self) return talent.stellar_flare.enabled and (buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0) end,
        helpharm = "harm",
        maxRange = 45,
    })


end