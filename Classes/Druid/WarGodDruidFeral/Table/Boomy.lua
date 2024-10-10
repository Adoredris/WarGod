--
-- Created by IntelliJ IDEA.
-- User: Flora
-- Date: 16/12/2017
-- Time: 8:00 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods

local Rotations = WarGod.Rotation
local Class = WarGod.Class
local groups = WarGod.Unit.groups
local player = WarGod.Unit:GetPlayer()
local talent = player.trait
local charges = player.charges
local buff = player.buff
local azerite = player.azerite
local variable = player.variable
local buff_bs_inc = player.bs_inc

local WarGodUnit = WarGod.Unit
local WarGodControl = WarGod.Control


local upairs = upairs

local GetShapeshiftForm = GetShapeshiftForm
local GetSpecialization = GetSpecialization

local print = print

---------TEMP-------------
local WGBM = WarGod.BossMods
local WarGodSpells = WarGod.Rotation.rotationFrames["Feral"]

--local Delegates = Rotations.Delegates
--------------------------

setfenv(1, Rotations)


local baseScore = 8000
do
    AddSpellFunction("Feral","Moonkin Form",baseScore + 999,{
        func = function(self)
            --[[if player.combat and WarGodUnit.active_enemies >= 1 and WarGodControl:AutoWeave() then
                if variable.numEnemiesInMelee == 0 and variable.numBoomyDotsNeeded > 0 then
                    return true
                elseif player.energy < 20 then
                    if buff.tigers_fury:Down() and buff_bs_inc:Down() then
                        if variable.sunfireNeeded and WarGodUnit.active_enemies > 1 then
                            return true
                        elseif variable.numBoomyDotsNeeded > 1 then
                            return true
                        end
                    end
                end
            end]]
            if player:DebuffRemaining("Icy Shroud","HARMFUL") ~= 0 and player.health_percent < 0.7 or player:DebuffRemaining("Frozen Shroud","HARMFUL") ~= 0 then
                return true
            end
        end,
        units = groups.noone,
        label = "Owlweave",
        --andDelegates = {Delegates.IsSpellInRange, Delegates.DoT_Pandemic--[[, Delegates.NotDotBlacklistedWrapper]]},
        args = {threshold = 3.6},
        --[[quick = true,
        helpharm = "harm",
        maxRange = 10,]]
        IsUsable = function(self) return talent.moonkin_form.enabled and buff.moonkin_form:Stacks() == 0 and (GetSpecialization() == 1 or WarGodControl:AutoWeave()) end,
    })

    AddSpellFunction("Feral","Sunfire",baseScore + 700,{
        func = function(self)
            --[[if player.energy < 80 then
                return true
            end
            if variable.numEnemiesInMelee == 0 then]]
                return true
            --end
        end,
        units = groups.targetable,
        label = "Sunfire Owl",
        ["andDelegates"] = {Delegates.IsSpellInRange, Delegates.DoT_Pandemic, Delegates.NotDotBlacklisted--[[, Delegates.SunfireTargetCondition, ]]},
        ["scorer"] = ScoreByInvertedDebuffTimeRemaining,
        args = {--[[aura = "sunfire", ]]threshold = 5.4, ttd = 12},
        Castable = function(self) return Delegates:EnoughTimeToCastWrapper(self.spell, player, {}) end,
        IsUsable = function(self) return buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0 and GetSpecialization() == 1 or buff.bear_form:Stacks() > 0 and player.spec == "Guardian" end,
        helpharm = "harm",
        maxRange = 45,
        quick = true,
        needNotFace = true,
    })

    AddSpellFunction("Feral","Moonfire",baseScore + 500,{
        func = function(self)
            if buff.prowl:Remains() ~= 0 then return end
            if WarGodUnit.active_enemies < 3 then return true end
            if variable.numEnemiesInMelee == 0 then
                return true
            end
        end,
        units = groups.targetable,
        label = "Moonfire Owl (doh)",
        ["andDelegates"] = {Delegates.IsSpellInRange, Delegates.DoT_Pandemic, Delegates.NotDotBlacklisted},
        ["scorer"] = ScoreByInvertedDebuffTimeRemaining,
        args = {threshold = 6.6, ttd = 12},
        Castable = function(self) return Delegates:EnoughTimeToCastWrapper(self.spell, player, {}) end,
        IsUsable = function(self) return buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0 or buff.bear_form:Stacks() > 0 and player.spec == "Guardian" or buff.cat_form:Stacks() > 0 and talent.lunar_inspiration.enabled and player.energy >= 30 end,
        helpharm = "harm",
        maxRange = 45,
        quick = true,
        needNotFace = true,
    })

end