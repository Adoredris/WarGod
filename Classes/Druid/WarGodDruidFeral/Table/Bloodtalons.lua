--
-- Created by IntelliJ IDEA.
-- User: Ikevink
-- Date: 16/12/2017
-- Time: 8:00 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods

local Rotations = WarGod.Rotation
local Class = WarGod.Class
local groups = WarGod.Unit.groups
local player = WarGod.Unit:GetPlayer()
local variable = player.variable
local talent = player.trait
local charges = player.charges
local buff = player.buff
local azerite = player.azerite
local WarGodUnit = WarGod.Unit
local WarGodControl = WarGod.Control


local upairs = upairs
local GetShapeshiftForm = GetShapeshiftForm

local print = print

---------TEMP-------------
local WGBM = WarGod.BossMods
local WarGodSpells = WarGod.Rotation.rotationFrames["Feral"]

--local Delegates = Rotations.Delegates
--------------------------

setfenv(1, Rotations)


local baseScore = 4000
do
    AddSpellFunction("Feral","Nothing", baseScore + 900,{
        -- using stacks because it avoids checking a function
        func = function(self)
            if buff.cat_form:Stacks() > 0 and talent.bloodtalons.enabled then
                --[[if WarGodSpells["Tiger's Fury"]:CDRemaining() < player.gcd then
                    return
                else]]if buff.bloodtalons.up then
                    return
                elseif player.energy > 70 or player.energy > 50 and buff.clearcasting.up then
                    return
                elseif (player.prev_gcd ~= "Rip" and player.prev_gcd ~= "Ferocious Bite" and player.prev_gcd ~= "Primal Wrath") and player:NumGeneratorsInLast4Seconds() > 0 then
                    return
                else
                    print('doing nothing cause need bloodtalons')
                    return true
                end
            end
        end,
        units = groups.noone,
        label = "Pool for Bloodtalons"
    })

    AddSpellFunction("Feral","Rake",baseScore + 800,{
        func = function(self)
            if talent.bloodtalons.enabled and Delegates:SpellWasNotCastInLast4Seconds(self.spell, WarGodUnit:GetTarget()) and buff.bloodtalons:Stacks() < 1 then
                return true
            end
        end,
        units = groups.targetable,
        label = "Rake Bloodtalons",
        andDelegates = {Delegates.IsSpellInRange, Delegates.DoT_Pandemic, Delegates.NotDotBlacklisted},
        args = {threshold = 3.6},
        quick = true,
        helpharm = "harm",
        maxRange = 10,
        IsUsable = function(self) return (GetShapeshiftForm() == 1 or GetShapeshiftForm() == 2) and player.energy >= 35 and buff.cat_form:Stacks() > 0 end,
    })

    AddSpellFunction("Feral","Brutal Slash",baseScore + 700,{
        func = function(self)
            if charges.brutal_slash.charges < 1 then return end
            if talent.bloodtalons.enabled and Delegates:SpellWasNotCastInLast4Seconds(self.spell, WarGodUnit:GetTarget(), {}) and buff.bloodtalons:Stacks() < 1 then
                local reqEnemies = 1
                if WarGodUnit.active_enemies >= 1 then
                    local numEnemies = 0
                    for guid,unit in upairs(groups.targetableOrPlates) do
                        if Delegates:IsSpellInRange("Rake", unit, {}) and (not Delegates:AoeBlacklistedWrapper(self.spell, unit, {})) then
                            numEnemies = numEnemies + 1
                        end
                        --WarGodUnit:GetTarget():DebuffRemaining("Thrash", "HARMFUL|PLAYER") < 3.6 and Delegates:IsSpellInRange("Rake", WarGodUnit:GetTarget())  and Delegates:NotDotBlacklistedWrapper(self.spell, WarGodUnit:GetTarget())
                    end
                    if (numEnemies >= reqEnemies) then
                        return true
                    end
                end
            end
        end,
        units = groups.noone,
        label = "Slash Bloodtalons",
        andDelegates = {Delegates.IsSpellInRange},
        args = {threshold = 3.6},
        quick = true,
        helpharm = "harm",
        maxRange = 11,
        IsUsable = function(self) return GetShapeshiftForm() == 2 and talent.brutal_slash.enabled and charges.brutal_slash.charges >= 1 and (buff.clearcasting.up or player.energy >= 40) end,
    })

    AddSpellFunction("Feral","Thrash",baseScore + 600,{
        func = function(self)
                if talent.bloodtalons.enabled and Delegates:SpellWasNotCastInLast4Seconds(self.spell, WarGodUnit:GetTarget(), {}) and buff.bloodtalons:Stacks() < 1 then
                    local reqEnemies = 1
                    if WarGodUnit.active_enemies >= reqEnemies then

                        local someoneNeedsThrash = false
                        local numEnemies = 0
                        for guid,unit in upairs(groups.targetableOrPlates) do
                            if Delegates:IsSpellInRange("Rake", unit, {}) and (not Delegates:AoeBlacklistedWrapper(self.spell, unit, {})) then
                                if unit:DebuffRemaining("Thrash", "HARMFUL|PLAYER") < 3.6 then
                                    someoneNeedsThrash = true
                                end
                                numEnemies = numEnemies + 1
                            end
                            --WarGodUnit:GetTarget():DebuffRemaining("Thrash", "HARMFUL|PLAYER") < 3.6 and Delegates:IsSpellInRange("Rake", WarGodUnit:GetTarget())  and Delegates:NotDotBlacklistedWrapper(self.spell, WarGodUnit:GetTarget())
                        end
                        if someoneNeedsThrash and (numEnemies >= reqEnemies) then
                            return true
                        end
                    end
                end
        end,
        units = groups.noone,
        label = "Thrash Bloodtalons",
        quick = true,
        helpharm = "harm",
        maxRange = 11,
        IsUsable = function(self) return GetShapeshiftForm() == 2 and (buff.clearcasting.up or player.energy >= 40) or GetShapeshiftForm() == 1 end,
    })

    AddSpellFunction("Feral","Swipe",baseScore + 700,{
        func = function(self)
            if talent.bloodtalons.enabled and Delegates:SpellWasNotCastInLast4Seconds(self.spell, WarGodUnit:GetTarget(), {}) and buff.bloodtalons:Stacks() < 1 then
                local reqEnemies = 2
                if WarGodUnit.active_enemies >= 2 then
                    local numEnemies = 0
                    for guid,unit in upairs(groups.targetableOrPlates) do
                        if Delegates:IsSpellInRange("Rake", unit, {}) and (not Delegates:AoeBlacklistedWrapper(self.spell, unit, {})) then
                            numEnemies = numEnemies + 1
                        end
                        --WarGodUnit:GetTarget():DebuffRemaining("Thrash", "HARMFUL|PLAYER") < 3.6 and Delegates:IsSpellInRange("Rake", WarGodUnit:GetTarget())  and Delegates:NotDotBlacklistedWrapper(self.spell, WarGodUnit:GetTarget())
                    end
                    if (numEnemies >= reqEnemies) then
                        return true
                    end
                end
            end
        end,
        units = groups.noone,
        label = "Swipe Bloodtalons",
        andDelegates = {Delegates.IsSpellInRange, Delegates.DoT_Pandemic--[[, Delegates.NotDotBlacklistedWrapper]]},
        args = {threshold = 3.6},
        quick = true,
        helpharm = "harm",
        maxRange = 11,
        IsUsable = function(self) return (GetShapeshiftForm() == 1 or GetShapeshiftForm() == 2) and (not talent.brutal_slash.enabled) and (buff.clearcasting.up or player.energy >= 35) end,
    })

    AddSpellFunction("Feral","Shred",baseScore + 500,{
        func = function(self)
            if talent.bloodtalons.enabled and Delegates:SpellWasNotCastInLast4Seconds(self.spell, WarGodUnit:GetTarget()) and buff.bloodtalons:Stacks() < 1 then
                return true
            end
        end,
        units = groups.targetable,
        label = "Shred Bloodtalons",
        andDelegates = {Delegates.IsSpellInRange},
        args = {threshold = 3.6},
        quick = true,
        helpharm = "harm",
        maxRange = 10,
        IsUsable = function(self) return GetShapeshiftForm() == 2 and (buff.clearcasting.up or player.energy >= 40) end,
    })

    AddSpellFunction("Feral","Swipe",baseScore + 400,{
        func = function(self)
            if talent.bloodtalons.enabled and Delegates:SpellWasNotCastInLast4Seconds(self.spell, WarGodUnit:GetTarget(), {}) and buff.bloodtalons:Stacks() < 1 then
                local reqEnemies = 1
                if WarGodUnit.active_enemies >= 1 then
                    local numEnemies = 0
                    for guid,unit in upairs(groups.targetableOrPlates) do
                        if Delegates:IsSpellInRange("Rake", unit, {}) and (not Delegates:AoeBlacklistedWrapper(self.spell, unit, {})) then
                            numEnemies = numEnemies + 1
                        end
                        --WarGodUnit:GetTarget():DebuffRemaining("Thrash", "HARMFUL|PLAYER") < 3.6 and Delegates:IsSpellInRange("Rake", WarGodUnit:GetTarget())  and Delegates:NotDotBlacklistedWrapper(self.spell, WarGodUnit:GetTarget())
                    end
                    if (numEnemies >= reqEnemies) then
                        return true
                    end
                end
            end
        end,
        units = groups.noone,
        label = "Swipe Bloodtalons",
        andDelegates = {Delegates.IsSpellInRange, Delegates.DoT_Pandemic--[[, Delegates.NotDotBlacklistedWrapper]]},
        args = {threshold = 3.6},
        quick = true,
        helpharm = "harm",
        maxRange = 11,
        IsUsable = function(self) return (GetShapeshiftForm() == 1 or GetShapeshiftForm() == 2) and (not talent.brutal_slash.enabled) and (buff.clearcasting.up or player.energy >= 35) end,
    })

    AddSpellFunction("Feral","Thrash",baseScore + 600,{
        func = function(self)
            if talent.bloodtalons.enabled and Delegates:SpellWasNotCastInLast4Seconds(self.spell, WarGodUnit:GetTarget(), {}) and buff.bloodtalons:Stacks() < 1 then
                local reqEnemies = 1
                if WarGodUnit.active_enemies >= 1 then

                    local someoneNeedsThrash = false
                    local numEnemies = 0
                    for guid,unit in upairs(groups.targetableOrPlates) do
                        if Delegates:IsSpellInRange("Rake", unit, {}) and (not Delegates:AoeBlacklistedWrapper(self.spell, unit, {})) then
                            return true
                        end
                        --WarGodUnit:GetTarget():DebuffRemaining("Thrash", "HARMFUL|PLAYER") < 3.6 and Delegates:IsSpellInRange("Rake", WarGodUnit:GetTarget())  and Delegates:NotDotBlacklistedWrapper(self.spell, WarGodUnit:GetTarget())
                    end
                end
            end
        end,
        units = groups.noone,
        label = "Thrash Bloodtalons (LR)",
    })
end