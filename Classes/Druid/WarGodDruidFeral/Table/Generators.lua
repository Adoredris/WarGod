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


---------TEMP-------------
local WGBM = WarGod.BossMods
local WarGodSpells = WarGod.Rotation.rotationFrames["Feral"]

--local Delegates = Rotations.Delegates
--------------------------

setfenv(1, Rotations)


local baseScore = 2000
do
    --[[]]

    AddSpellFunction("Feral","Thrash",baseScore + 990,{
        func = function(self)
            if buff.incarnation_avatar_of_ashamane:Up() then return end
            if buff.clearcasting:Down() then return end
            --if buff.clearcasting:Up() then
                local reqEnemies = 1
                if WarGodUnit.active_enemies >= reqEnemies then

                    local numEnemies = 0
                    for guid,unit in upairs(groups.targetableOrPlates) do
                        if Delegates:IsSpellInRange("Rake", unit, {}) and (not Delegates:AoeBlacklistedWrapper(self.spell, unit, {})) and (not Delegates:DPSBlacklistWrapper(self.spell, unit, {})) then
                            if unit:DebuffRemaining("Thrash", "HARMFUL|PLAYER") < 3.6 and (not Delegates:DotBlacklistedWrapper(self.spell, unit, {})) then
                                numEnemies = numEnemies + 1
                                if (numEnemies >= reqEnemies) then
                                    return true
                                end
                            end

                        end
                        --WarGodUnit:GetTarget():DebuffRemaining("Thrash", "HARMFUL|PLAYER") < 3.6 and Delegates:IsSpellInRange("Rake", WarGodUnit:GetTarget())  and Delegates:NotDotBlacklistedWrapper(self.spell, WarGodUnit:GetTarget())
                    end
                    if (numEnemies >= reqEnemies) then
                        return true
                    end
                end
            --end
        end,
        units = groups.noone,
        label = "Thrash (Gen CC)",
        --IsUsable = function(self) return GetShapeshiftForm() == 2 and (buff.clearcasting.up or player.energy >= 40) or GetShapeshiftForm() == 1 end,
    })

    AddSpellFunction("Feral","Brutal Slash",baseScore + 960,{
        func = function(self)

            if (not WarGodControl:CleaveMode()) and (not WarGodControl:AOEMode()) then
                return
            end
            if charges.brutal_slash.charges < 1 then return end
            local reqEnemies = 3
            if WarGodUnit.active_enemies >= reqEnemies then
                local numEnemies = 0
                for guid,unit in upairs(groups.targetableOrPlates) do
                    if Delegates:IsSpellInRange("Rake", unit, {}) and (not Delegates:AoeBlacklistedWrapper(self.spell, unit, {})) and (not Delegates:DPSBlacklistWrapper(self.spell, unit, {})) then
                        numEnemies = numEnemies + 1
                    end
                    --WarGodUnit:GetTarget():DebuffRemaining("Thrash", "HARMFUL|PLAYER") < 3.6 and Delegates:IsSpellInRange("Rake", WarGodUnit:GetTarget())  and Delegates:NotDotBlacklistedWrapper(self.spell, WarGodUnit:GetTarget())
                end
                if (numEnemies >= reqEnemies) then
                    return true
                end
            end

        end,

        units = groups.noone,
        label = "Slash (Gen CC)",
        andDelegates = {Delegates.IsSpellInRange--[[, Delegates.NotDotBlacklistedWrapper]]},
        args = {threshold = 3.6},
    })

    AddSpellFunction("Feral","Shred",baseScore + 930,{
        func = function(self)
            if buff.incarnation_avatar_of_ashamane:Up() then return end
            if buff.clearcasting:Down() then return end
            return true
        end,
        units = groups.targetable,
        label = "Shred (Gen CC)",
        andDelegates = {Delegates.IsSpellInRange},
    })

    AddSpellFunction("Feral","Rake",baseScore + 800,{
        func = function(self)
            if buff.incarnation_avatar_of_ashamane:Up() then return end
            --if player.combopoints >= 5 and buff.bloodtalons:Up() and (WarGodUnit.active_enemies <= 1 or buff.clearcasting:Up()) then return end
            --if player.combopoints >= 5 and buff.bloodtalons:Up() or (WarGodUnit.active_enemies <= 1 and buff.clearcasting:Up()) then return end
            --if talent.bloodtalons.enabled and Delegates:SpellWasNotCastInLast4Seconds(self.spell, WarGodUnit:GetTarget()) and buff.bloodtalons:Stacks() < 1 then
                return true
            --end
        end,
        units = groups.targetable,
        label = "Rake",
        andDelegates = {Delegates.IsSpellInRange, Delegates.DoT_Pandemic, Delegates.NotDotBlacklisted},
        args = {threshold = 3.6},
    })



    AddSpellFunction("Feral","Moonfire",baseScore + 700,{
        func = function(self)
            if buff.incarnation_avatar_of_ashamane:Up() then return end
            if talent.lunar_inspiration.enabled and GetShapeshiftForm() == 2 then
                return true
            end
        end,
        units = groups.targetable,
        label = "Moonfire (Gen)",
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

    ----------------------------------------------

    AddSpellFunction("Feral","Thrash",baseScore + 600,{
        func = function(self)
            if buff.incarnation_avatar_of_ashamane:Up() then return end
            local reqEnemies = 1
            if WarGodUnit.active_enemies >= reqEnemies then

                local numEnemies = 0
                for guid,unit in upairs(groups.targetableOrPlates) do
                    if Delegates:IsSpellInRange("Rake", unit, {}) and (not Delegates:AoeBlacklistedWrapper(self.spell, unit, {})) and (not Delegates:DPSBlacklistWrapper(self.spell, unit, {})) then
                        if unit:DebuffRemaining("Thrash", "HARMFUL|PLAYER") < 3.6 and (not Delegates:DotBlacklistedWrapper(self.spell, unit, {})) then
                            numEnemies = numEnemies + 1
                            if (numEnemies >= reqEnemies) then
                                return true
                            end
                        end

                    end
                    --WarGodUnit:GetTarget():DebuffRemaining("Thrash", "HARMFUL|PLAYER") < 3.6 and Delegates:IsSpellInRange("Rake", WarGodUnit:GetTarget())  and Delegates:NotDotBlacklistedWrapper(self.spell, WarGodUnit:GetTarget())
                end
                if (numEnemies >= reqEnemies) then
                    return true
                end
            end
        end,
        units = groups.noone,
        label = "Thrash (Gen)",
        --IsUsable = function(self) return GetShapeshiftForm() == 2 and (buff.clearcasting.up or player.energy >= 40) or GetShapeshiftForm() == 1 end,
    })

    AddSpellFunction("Feral","Brutal Slash",baseScore + 550,{
        func = function(self)
            if buff.incarnation_avatar_of_ashamane:Up() then return end
            if charges.brutal_slash.charges < 1 then return end
            local reqEnemies = 1
            if WarGodUnit.active_enemies >= 1 then
                local numEnemies = 0
                for guid,unit in upairs(groups.targetableOrPlates) do
                    if Delegates:IsSpellInRange("Rake", unit, {}) and (not Delegates:AoeBlacklistedWrapper(self.spell, unit, {})) and (not Delegates:DPSBlacklistWrapper(self.spell, unit, {})) then
                        numEnemies = numEnemies + 1
                        if (numEnemies >= reqEnemies) then
                            return true
                        end
                    end
                    --WarGodUnit:GetTarget():DebuffRemaining("Thrash", "HARMFUL|PLAYER") < 3.6 and Delegates:IsSpellInRange("Rake", WarGodUnit:GetTarget())  and Delegates:NotDotBlacklistedWrapper(self.spell, WarGodUnit:GetTarget())
                end
                if (numEnemies >= reqEnemies) then
                    return true
                end
            end
        end,
        units = groups.noone,
        label = "Slash (Gen)",
        andDelegates = {Delegates.IsSpellInRange--[[, Delegates.NotDotBlacklistedWrapper]]},
        args = {threshold = 3.6},
    })

    AddSpellFunction("Feral","Swipe",baseScore + 500,{
        func = function(self)
            if buff.incarnation_avatar_of_ashamane:Up() then return end
            local reqEnemies = 2
            if WarGodUnit.active_enemies > 1 then
                local numEnemies = 0
                for guid,unit in upairs(groups.targetableOrPlates) do
                    if Delegates:IsSpellInRange("Rake", unit, {}) and (not Delegates:AoeBlacklistedWrapper(self.spell, unit, {})) and (not Delegates:DPSBlacklistWrapper(self.spell, unit, {})) then
                        numEnemies = numEnemies + 1
                    end
                    --WarGodUnit:GetTarget():DebuffRemaining("Thrash", "HARMFUL|PLAYER") < 3.6 and Delegates:IsSpellInRange("Rake", WarGodUnit:GetTarget())  and Delegates:NotDotBlacklistedWrapper(self.spell, WarGodUnit:GetTarget())
                end
                if (numEnemies >= reqEnemies) then
                    return true
                end
            end
        end,
        units = groups.noone,
        label = "Swipe (Gen))",
        andDelegates = {Delegates.IsSpellInRange, Delegates.DoT_Pandemic--[[, Delegates.NotDotBlacklistedWrapper]]},
        args = {threshold = 3.6},
        quick = true,
        helpharm = "harm",
        maxRange = 11,
        IsUsable = function(self) return (not talent.brutal_slash.enabled) and (buff.clearcasting.up or player.energy >= 35) end,
    })

    AddSpellFunction("Feral","Shred",baseScore + 400,{
        func = function(self)
            if buff.incarnation_avatar_of_ashamane:Up() then return end
            return true
        end,
        units = groups.targetable,
        label = "Shred (Gen)",
        andDelegates = {Delegates.IsSpellInRange},
    })

end