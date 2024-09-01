local Rotations = WarGod.Rotation
local Class = WarGod.Class
local groups = WarGod.Unit.groups
local player = WarGod.Unit:GetPlayer()
local buff = player.buff
local covenant = player.covenant
local talent = player.trait

---------TEMP-------------
local WGBM = WarGod.BossMods
--local Delegates = Rotations.Delegates
local WarGodControl = WarGod.Control
local WarGodUnit = WarGod.Unit
--------------------------


setfenv(1, Rotations)

function Delegates:Moonfire_Refresh(spell, unit)
    return unit:DebuffRemaining(spell, "HARMFUL|PLAYER") < 4.8
end

do
    AddSpellFunction("Guardian","Bear Form",7000,{
        func = function(self) return buff.bear_form:Stacks() == 0 and
                buff.cat_form:Stacks() == 0 and buff.moonkin_form:Stacks() == 0
        end,
        units = groups.noone,
        label = "Bear"
    })

    AddSpellFunction("Guardian","Maul",6895,{
        func = function(self)
            local threat = UnitThreatSituation("player")
            if not talent.raze.enabled then return end
            local reqTargets = 3 - buff.tooth_and_claw:Stacks()
            if buff.tooth_and_claw:Up() and buff.vicious_cycle:Stacks() >= 3 then
                local targets = 0
                for k,unit in upairs(groups.targetableOrPlates) do
                    if Delegates:IsSpellInRange("Mangle", unit, {}) and unit:DebuffRemaining("Tooth and Claw","HARMFUL|PLAYER") < 1 then
                        targets = targets + 1
                        if targets > reqTargets then
                            return true
                        end
                    end
                end
            end
        end,
        units = groups.noone,
        label = "Maul",
        --andDelegates = {Delegates.IsSpellInRange},
    })

    AddSpellFunction("Guardian","Thrash",6890, {
        func = function(self)
            local reqEnemies = 3
            --if WarGodUnit.active_enemies >= reqEnemies then
            local immoTargets = 0
            for k,unit in upairs(groups.targetableOrPlates) do
                if Delegates:IsSpellInRange("Mangle", unit, {})
                        and (not Delegates:DotBlacklistedWrapper("Mangle", unit, {}))
                        and (Delegates:DoT_Pandemic("Thrash", unit, {threshold = 1.5}) or Delegates:StacksLT("Thrash", unit, {stacks = 3})--[[ or runeforge.ursocs_fury_remembered.equipped]]) then
                    immoTargets = immoTargets + 1
                    --return true
                    if immoTargets >= reqEnemies then
                        return true
                    end
                end
            end
            return immoTargets >= reqEnemies
            --end
        end,
        units = groups.noone,--groups.targetableOrPlates,
        label = "Thrash Stacks (Many AoE)",
        --["andDelegates"] = {Delegates:UnitInCombat, Delegates:NotHaveThrash}, -- hopefully the combat check removes units that can't be cleaved
        --["scorer"] = WarGodUnit.DebuffRemaining,
        helpharm = "harm",
        maxRange = 10,
        IsUsable = function(self) return buff.bear_form:Stacks() > 0 end,
    })

    AddSpellFunction("Guardian","Raze",6885,{
        func = function(self)
            local threat = UnitThreatSituation("player")
            if not talent.raze.enabled then return end
            local reqTargets = 3 - buff.tooth_and_claw:Stacks()
            if buff.tooth_and_claw:Up() and buff.vicious_cycle:Stacks() >= 1 then
                local targets = 0
                for k,unit in upairs(groups.targetableOrPlates) do
                    if Delegates:IsSpellInRange("Mangle", unit, {}) and unit:DebuffRemaining("Tooth and Claw","HARMFUL|PLAYER") < 1 then
                        --print('hello')
                        targets = targets + 1
                        if targets > reqTargets then
                            return true
                        end
                    end
                end
            end
        end,
        units = groups.noone,
        label = "Raze (Vicious Tooth)",
        --andDelegates = {Delegates.IsSpellInRange},
    })

    AddSpellFunction("Guardian","Moonfire",6860,{
        func = function(self) return WarGodUnit.active_enemies < 3 and buff.incarnation_guardian_of_ursoc.up end,
        units = groups.targetable,
        label = "Refresh Low Targets Moonfire",
        andDelegates = {Delegates.IsSpellInRange, Delegates.DoT_Pandemic},
        args = {threshold = 4.8},
        helpharm = "harm",
        maxRange = 40,
    })

    AddSpellFunction("Guardian","Raze",6855,{
        func = function(self)
            local threat = UnitThreatSituation("player")
            if not talent.raze.enabled then return end
            local reqTargets = 1
            if buff.vicious_cycle:Stacks() >= 3 then
                local targets = 0
                for k,unit in upairs(groups.targetableOrPlates) do
                    if Delegates:IsSpellInRange("Mangle", unit, {}) then
                        --print('hello')
                        targets = targets + 1
                        if targets > reqTargets then
                            return true
                        end
                    end
                end
            end
        end,
        units = groups.noone,
        label = "Maul (Vicious Tooth)",
        --andDelegates = {Delegates.IsSpellInRange},
    })

    AddSpellFunction("Guardian","Thrash",6850, {
        func = function(self)
            local reqEnemies = 1
            --if WarGodUnit.active_enemies >= reqEnemies then
            local immoTargets = 0
            if buff.incarnation_guardian_of_ursoc.up then
                for k,unit in upairs(groups.targetableOrPlates) do
                    if Delegates:IsSpellInRange("Mangle", unit, {})
                            and (not Delegates:DotBlacklistedWrapper("Mangle", unit, {}))
                            and (Delegates:DoT_Pandemic("Thrash", unit, {threshold = 1.5}) or Delegates:StacksLT("Thrash", unit, {stacks = 3})--[[ or runeforge.ursocs_fury_remembered.equipped]]) then
                        immoTargets = immoTargets + 1
                        --return true
                        if immoTargets >= reqEnemies then
                            return true
                        end
                    end
                end
            end
            return immoTargets >= reqEnemies
            --end
        end,
        units = groups.noone,--groups.targetableOrPlates,
        label = "Thrash Stacks (Incarn)",
        --["andDelegates"] = {Delegates:UnitInCombat, Delegates:NotHaveThrash}, -- hopefully the combat check removes units that can't be cleaved
        --["scorer"] = WarGodUnit.DebuffRemaining,
        helpharm = "harm",
        maxRange = 10,
        IsUsable = function(self) return buff.bear_form:Stacks() > 0 end,
    })


    AddSpellFunction("Guardian","Mangle",6800,{
        func = function(self) return (buff.incarnation_guardian_of_ursoc.up or buff.berserk.up) and WarGodUnit.active_enemies < 3 end,
        units = groups.targetable,
        label = "Incarn Mangle No AOE",
        andDelegates = {Delegates.IsSpellInRange},
        helpharm = "harm",
        maxRange = 8,
        IsUsable = function(self) return buff.bear_form:Stacks() > 0 end,
    })

    AddSpellFunction("Guardian","Thrash",6700, {
        func = function(self)
            local reqEnemies = 2
            --if WarGodUnit.active_enemies >= reqEnemies then
                local immoTargets = 0
                for k,unit in upairs(groups.targetableOrPlates) do
                    if Delegates:IsSpellInRange("Mangle", unit, {})
                            and (not Delegates:DotBlacklistedWrapper("Mangle", unit, {})) then
                        immoTargets = immoTargets + 1
                        return true
                    end
                end
                return immoTargets >= reqEnemies
            --end
        end,
        units = groups.noone,--groups.targetableOrPlates,
        label = "Thrash Spam",
        --["andDelegates"] = {Delegates:UnitInCombat, Delegates:NotHaveThrash}, -- hopefully the combat check removes units that can't be cleaved
        --["scorer"] = WarGodUnit.DebuffRemaining,
        helpharm = "harm",
        maxRange = 10,
    })

    -- this one was for when
    --[[AddSpellFunction("Guardian","Mangle",6650,{
        func = function(self) return (buff.incarnation_guardian_of_ursoc.up or buff.berserk.up) end,
        units = groups.targetable,
        label = "Incarn Mangle",
        andDelegates = {Delegates.IsSpellInRange},
        helpharm = "harm",
        maxRange = 8,
    })]]

        AddSpellFunction("Guardian","Moonfire",6600,{
            func = function(self) return buff.galactic_guardian:Remains() < 2 and buff.galactic_guardian:Up() end,
            units = groups.targetable,
            label = "ST GG Moonfire",
            helpharm = "harm",
            maxRange = 30,
            andDelegates = {Delegates.IsSpellInRange},
        })


    AddSpellFunction("Guardian","Mangle",6500,{
        --func = function(self) return true end,
        units = groups.targetable,
        label = "ST Mangle",
        andDelegates = {Delegates.IsSpellInRange},
        helpharm = "harm",
        maxRange = 8,
    })

    AddSpellFunction("Guardian","Moonfire",6400,{
        func = function(self) return WarGodUnit.active_enemies < 3 end,
        units = groups.targetable,
        label = "Refresh Low Targets Moonfire",
        andDelegates = {Delegates.IsSpellInRange, Delegates.DoT_Pandemic},
        args = {threshold = 4.8},
        helpharm = "harm",
        maxRange = 40,
    })

    --[[AddSpellFunction("Guardian","Moonfire",6200,{
        func = function(self) return buff.galactic_guardian:Up() end,
        units = groups.targetable,
        label = "ST GG Moonfire"
    })]]

    AddSpellFunction("Guardian","Pulverize",6200, {
        func = function(self) return player.combat and buff.pulverize:Remains() < 3.5 end,
        units = groups.targetable,
        label = "Pulverize",
        andDelegates = {Delegates.Pulverizable, Delegates.IsSpellInRange},
        --["scorer"] = MostStacksThrash,

        --["scorer"] = WarGodUnit.DebuffRemaining,
        helpharm = "harm",
        maxRange = 8,
        IsUsable = function(self) return buff.bear_form:Stacks() > 0 and talent.pulverize.enabled end,
    })

    AddSpellFunction("Guardian","Raze",1905,{
        func = function(self)
            local threat = UnitThreatSituation("player")
            if (threat == nil or threat < 3) and player.rage_deficit <= 15 or buff.tooth_and_claw:Up() then
                local targets = 0
                for k,unit in upairs(groups.targetableOrPlates) do
                    if Delegates:IsSpellInRange("Mangle", unit, {}) then
                        targets = targets + 1
                        if targets > 1 then
                            return true
                        end
                    end
                end
                if (targets < 2) then
                    return
                end
            end
        end,
        units = groups.targetable,
        label = "noone",
        andDelegates = {Delegates.IsSpellInRange},
        IsUsable = function(self) return buff.bear_form:Stacks() > 0 and (player.rage >= 40 or buff.tooth_and_claw:Up())  end,
        helpharm = "harm",
        maxRange = 8,
    })

    AddSpellFunction("Guardian","Maul",1900,{
        func = function(self)
            local threat = UnitThreatSituation("player")
            if (threat == nil or threat < 3) and player.rage_deficit <= 15 or buff.tooth_and_claw:Up() then
                local targets = 0
                for k,unit in upairs(groups.targetableOrPlates) do
                    if Delegates:IsSpellInRange("Mangle", unit, {}) then
                        targets = targets + 1
                        if targets > 2 then
                            return player.rage_deficit <= 5
                        end
                    end
                end
                if (targets <= 2) then
                    return true
                end
            end
        end,
        units = groups.targetable,
        label = "Maul",
        andDelegates = {Delegates.IsSpellInRange},
        IsUsable = function(self) return buff.bear_form:Stacks() > 0 and (player.rage >= 40 or buff.tooth_and_claw:Up())  end,
        helpharm = "harm",
        maxRange = 8,
    })

    --[[AddSpellFunction("Guardian","Maul",1900,{
        func = function(self)
            local threat = UnitThreatSituation("player");
            if (threat == nil or threat <= 1) and player.rage_deficit <= 5 then
                return true
            end
        end,
        units = groups.targetable,
        label = "Maul",
        ["andDelegates"] = {Delegates.IsSpellInRange},
        IsUsable = function(self) return player.rage >= 45 end,
        helpharm = "harm",
        maxRange = 8,
    })]]

    AddSpellFunction("Guardian","Moonfire",1100,{
        func = function(self) return WarGodUnit.active_enemies < 4 end,
        units = groups.targetable,
        label = "Refresh Low Targets Moonfire",
        andDelegates = {Delegates.IsSpellInRange, Delegates.DoT_Pandemic},
        args = {threshold = 4.8},
    })

    AddSpellFunction("Guardian","Swipe",1000, {
        func = function(self)
            local reqEnemies = 2
            --if WarGodUnit.active_enemies >= reqEnemies then
            local immoTargets = 0
            for k,unit in upairs(groups.targetableOrPlates) do
                if Delegates:IsSpellInRange("Mangle", unit, {})
                        and Delegates:UnitInCombat(self.spell, unit, {})
                        and (not Delegates:DotBlacklistedWrapper("Mangle", unit, {})) then
                    immoTargets = immoTargets + 1
                    return true
                end
            end
            return immoTargets >= reqEnemies
            --end
        end,
        units = groups.noone,
        label = "Swipe",
        andDelegates = {Delegates.UnitInCombat},
        IsUsable = function(self) return buff.bear_form:Stacks() > 0 end,
    })


    AddSpellFunction("Guardian","Moonfire",900,{
        --func = function(self) return buff.galactic_guardian:Up() end,
        units = groups.targetable,
        label = "Refresh AOE Moonfire",
        andDelegates = {Delegates.IsSpellInRange, Delegates.DoT_Pandemic},
        args = {threshold = 4.8},
        Castable = function(self) return Delegates:EnoughTimeToCastWrapper(self.spell, player, {}) end,
        IsUsable = function(self) return buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0 or buff.bear_form:Stacks() > 0 and player.spec == "Guardian" or buff.cat_form:Stacks() > 0 and talent.lunar_inspiration.enabled and player.energy >= 30 end,
    })

    AddSpellFunction("Guardian","Kindred Spirits",1050,{
        func = function(self)
            if (not runeforge.kindred_affinity.equipped) or GetSpellInfo(self.spell).name == "Lone Empowerment" then
                return true
            else
                return true
                --[[if buff_ca_inc:Up() then
                    return true
                elseif WarGodSpells["Celestial Alignment"]:CDRemaining() < 20 or buff.primordial_arcanic_pulsar:Value() >= 250 then
                    return
                else
                    --local ksPartner = GetKSPartnerUnitId()
                    --if ksPartner == nil then return end
                    return KSPartnerHasCDUp()
                end]]
            end
        end,
        units = groups.noone,
        label = "Kindred",
        Castable = function(self) return Delegates:IsKindredSpiritsInRange() end,
        IsUsable = function(self)
            if covenant.kyrian then
                return Delegates:DamageCDWrapper(self.spell, WarGodUnit:GetTarget(), {10, 60}) and player.combat and WarGodUnit.active_enemies > 0 or GetNumGroupMembers() < 2 and GetSpellInfo(self.spell).name == "Kindred Spirits" and player.casting ~= "Kindred Spirits"
            end
        end,
    })
end
