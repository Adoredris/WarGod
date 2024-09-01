local WGBM = WarGod.BossMods

local Rotation = WarGod.Rotation
local Class = WarGod.Class
local groups = WarGod.Unit.groups
local player = WarGod.Unit:GetPlayer()
local talent = player.trait
local buff = player.buff
local azerite = player.azerite
local variable = player.variable
local eclipse = player.eclipse
local covenant = player.covenant
local charges = player.charges
local buff_ca_inc = player.buff_ca_inc
local buff_kindred_empowerment_energize = player.buff_kindred_empowerment_energize
local runeforge = player.runeforge
local equipped = player.equipped

local WarGodUnit = WarGod.Unit
local WarGodControl = WarGod.Control

local GetShapeshiftForm = GetShapeshiftForm
local GetSpellInfo = C_Spell.GetSpellInfo
local GetNumGroupMembers = GetNumGroupMembers
local GetSpecialization = GetSpecialization
local UnitInRaid = UnitInRaid
local IsUsableSpell = IsUsableSpell



local upairs = upairs
local ceil = ceil
local max = max
local UnitClass = UnitClass
local GetKSPartnerUnitId = GetKSPartnerUnitId
local KSPartnerHasCDUp = KSPartnerHasCDUp

local print = print
local strmatch = strmatch

---------TEMP-------------
local WGBM = WarGod.BossMods

local WarGodSpells = WarGod.Rotation.rotationFrames["Balance"]

--local Delegates = Rotations.Delegates
--------------------------

setfenv(1, Rotation)


local baseScore = 2000
do



--

    AddSpellFunction("Balance","Moonkin Form",11000,{
        -- using stacks because it avoids checking a function
        func = function(self) return buff.moonkin_form:Stacks() == 0
                --and (buff.cat_form:Stacks() == 1 and not IsMoving() and buff.prowl:Stacks() == 0 or buff.cat_form:Stacks() == 0)
                --and buff.bear_form:Stacks() == 0
                and buff.cat_form:Stacks() == 0
                and buff.bear_form:Stacks() == 0
                and (WarGodUnit.active_enemies > 0 or (not player.combat) and player.health_percent > 0.8 or player.health_percent > 0.9)
        end,
        units = groups.noone,
        label = "Moonkin",
        IsUsable = function() return GetShapeshiftForm() == 0 end,
    })

    AddSpellFunction("Balance","Celestial Alignment",baseScore + 999,{
        func = function(self)
            if variable.is_aoe then return end
            return ((LustRemaining() > 0 and LustRemaining() < 32) or player:BuffRemaining("Power Infusion","HELPFUL") > 0) and talent.incarnation_chosen_of_elune.enabled
        end,
        units = groups.cursor,
        label = "Incarn Fast",
        helpharm = "harm",
        maxRange = 40,
        quick = true,
        offgcd = true,

    })
    AddSpellFunction("Balance","Incarnation: Chosen of Elune",baseScore + 998,{
        func = function(self)
            if variable.is_aoe then return end
            return ((LustRemaining() > 0 and LustRemaining() < 32) or player:BuffRemaining("Power Infusion","HELPFUL") > 0) and talent.incarnation_chosen_of_elune.enabled
        end,
        units = groups.cursor,
        label = "Incarn Fast",
        helpharm = "harm",
        maxRange = 40,
        quick = true,
        offgcd = true,

    })

--actions.st=adaptive_swarm,target_if=!dot.adaptive_swarm_damage.ticking&!action.adaptive_swarm_damage.in_flight&(!dot.adaptive_swarm_heal.ticking|dot.adaptive_swarm_heal.remains>5)|dot.adaptive_swarm_damage.stack<3&dot.adaptive_swarm_damage.remains<3&dot.adaptive_swarm_damage.ticking
--actions.st+=/convoke_the_spirits,if=(variable.convoke_desync&!cooldown.ca_inc.ready|buff.ca_inc.up)&astral_power<40&(buff.eclipse_lunar.remains>10|buff.eclipse_solar.remains>10)|fight_remains<10


    AddSpellFunction("Balance","Moonfire",baseScore + 965,{
        func = function(self)
            if variable.is_aoe then return end
            return buff.eclipse_solar:Up() or buff.eclipse_lunar:Up()
        end,
        units = groups.targetable,
        label = "Moonfire Refresh (C)",
        ["andDelegates"] = {Delegates.UnitIsEnemy, Delegates.IsSpellInRange, Delegates.DoT_Pandemic, Delegates.DoT_TTD_Estimate, Delegates.NotDotBlacklisted--[[, Delegates.SunfireTargetCondition, ]]},
        ["scorer"] = ScoreByInvertedDebuffTimeRemaining,
        args = {--[[aura = "sunfire", ]]threshold = 4.95, ttd = 12},
        Castable = function(self) return Delegates:EnoughTimeToCastWrapper(self.spell, player, {}) end,
        IsUsable = function(self) return buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0 or buff.bear_form:Stacks() > 0 and player.spec == "Guardian" or buff.cat_form:Stacks() > 0 and talent.lunar_inspiration.enabled and player.energy >= 30 end,
        helpharm = "harm",
        maxRange = 45,
        quick = true,
        needNotFace = true,
    })

    --actions.prepatch_st+=/sunfire,target_if=refreshable&target.time_to_die>12,if=(buff.ca_inc.remains>5|!buff.ca_inc.up|astral_power<30)&ap_check
    AddSpellFunction("Balance","Sunfire",baseScore + 961,{
        func = function(self)
            if variable.is_aoe then return end
            return buff.eclipse_solar:Up() or buff.eclipse_lunar:Up()
        end,
        units = groups.targetable,
        label = "Sunfire Refresh",
        andDelegates = {Delegates.UnitIsEnemy, Delegates.IsSpellInRange, Delegates.DoT_Pandemic, Delegates.DoT_TTD_Estimate, Delegates.NotDotBlacklisted--[[, Delegates.SunfireTargetCondition, ]]},
        ["scorer"] = ScoreByInvertedDebuffTimeRemaining,
        args = {--[[aura = "sunfire", ]]threshold = 4.05, ttd = 12},
        Castable = function(self) return Delegates:EnoughTimeToCastWrapper(self.spell, player, {}) end,
        IsUsable = function(self) return buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0 end,
        helpharm = "harm",
        maxRange = 45,
        quick = true,
        needNotFace = true,
    })

    AddSpellFunction("Balance","Stellar Flare",baseScore + 950,{
        func = function(self)
            if variable.is_aoe then return end
            return buff.eclipse_solar:Up() or buff.eclipse_lunar:Up()
        end,
        units = groups.targetable,
        label = "SFlare Refresh",
        ["andDelegates"] = {Delegates.IsSpellInRange, Delegates.DoT_Pandemic, Delegates.DoT_TTD_Estimate, Delegates.NotCastingThisAtTargetAlready, Delegates.NotDotBlacklisted},
        ["scorer"] = ScoreByInvertedDebuffTimeRemaining,
        args = {threshold = 7.2, ttd = 16},
        Castable = function(self) return (not IsMoving()) and Delegates:EnoughTimeToCastWrapper(self.spell, player, {}) end,
        IsUsable = function(self) return talent.stellar_flare.enabled and (buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0) end,
        helpharm = "harm",
        maxRange = 45,
        andDelegates = {Delegates.UnitIsEnemy},
        quick = true,
    })

    AddSpellFunction("Balance","Wrath",baseScore + 850,{
        func = function(self)
            if variable.is_aoe then return end
            if eclipse:In_Any() then return end
            if GetSpellCount("Starfire") == 1 and player.casting == "Starfire" then return end      -- this should count as "In_Any" but anyway
            if (eclipse:Lunar_Next() and (not eclipse:Any_Next())) and (GetSpellCount("Wrath") > 1 or GetSpellCount("Wrath") == 1 and player.casting ~= "Wrath") then
                return true
            elseif (eclipse:Any_Next() and (buff.primordial_arcanic_pulsar:Value() >= 520 or WarGodSpells["Celestial Alignment"]:CDRemaining() < 5)) then
                return true
            end
        end,
        units = groups.targetable,
        andDelegates = {Delegates.UnitIsEnemy},
        label = "Wrath (Enter Lunar)",
    })

    AddSpellFunction("Balance","Warrior of Elune",baseScore + 825,{
        --func = function(self) return buff.eclipse_sol end,
        units = groups.noone,
        label = "WoE (ST)",
        quick = true,
        --Castable = function(self) return talent.warrior_of_elune and buff.warrior_of_elune:Stacks() < 1 and (buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0)end
        IsUsable = function(self)
            if not player.combat then return end
            return talent.warrior_of_elune and buff.warrior_of_elune:Stacks() < 1 and (buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0)
        end
    })

    AddSpellFunction("Balance","Starfire",baseScore + 800,{
        func = function(self)
            if variable.is_aoe then return end
            if eclipse:In_Any() then return end
            if GetSpellCount("Wrath") == 1 and player.casting == "Wrath" then return end
            if (eclipse:Solar_Next() or eclipse:Any_Next()) and (GetSpellCount("Starfire") > 1 or GetSpellCount("Starfire") == 1 and player.casting ~= "Starfire") then
                return true
            end
        end,
        units = groups.targetable,
        andDelegates = {Delegates.UnitIsEnemy},
        label = "Starfire (Enter Solar)",
    })

    AddSpellFunction("Balance","Starfall",baseScore + 790,{
        func = function(self)
            if variable.is_aoe then return end
            if not talent.primordial_arcanic_pulsar.enabled then return end
            if (not talent.starweaver.enabled) or buff.starweavers_warp:Down() then return end
            --if WarGodControl:AOEMode() then return end
            if (buff_ca_inc:Up()) then return end
            if buff.primordial_arcanic_pulsar:Value() < 550 then return end
            if WarGodUnit.active_enemies >= 1 then
                local totalHealth = 0
                local healthToStarfall = --[[UnitInRaid("player") and UnitExists("boss1") and 0 or ]]player.health * max(1, GetNumGroupMembers())
                for k,unit in upairs(groups.targetableOrPlates) do
                    if (not Delegates:AoeBlacklistedWrapper(self.spell, unit, {})) and Delegates:IsSpellInRange("Wrath", unit, {}) then
                        totalHealth = totalHealth + unit.health
                        if totalHealth >= healthToStarfall then return true end
                    end
                end
            end
        end,
        units = groups.noone,
        label = "Starfall (PAP Starweave)",
        --andDelegates = {Delegates.IsSpellInRange},
        helpharm = "harm",
        maxRange = 45,
    })

    AddSpellFunction("Balance","Celestial Alignment",baseScore + 781,{
        func = function(self)
            if variable.is_aoe then return end
            --if WarGodControl:AOEMode() then return end
            --local lustRemains = LustRemaining()
            if buff_ca_inc:Up() then return end
            return eclipse:In_Any()
        end,
        units = groups.cursor,
        label = "CA",
        helpharm = "harm",
        maxRange = 40,
        quick = true,
        offgcd = true,
        IsUsable = function(self)
            if not talent.celestial_alignment.enabled then --[[print("don't have CA") ]]return end
            if talent.incarnation_chosen_of_elune.enabled then return end

            if WarGodControl:AllowCDs() or LustRemaining() > 0 and (LustRemaining() < 32 or eclipse:In_Any())  or player:BuffRemaining("Power Infusion", "HELPFUL") > 0 then
                --print('2/3 usable')
                if Delegates:DamageCDWrapper(self.spell, WarGodUnit:GetTarget(), {15, 180}) and player.combat and WarGodUnit.active_enemies > 0 and buff_ca_inc:Down() and (buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0) then
                    --print('usable')
                    return true
                end
            end
        end,
    })

    AddSpellFunction("Balance","Incarnation: Chosen of Elune",baseScore + 780,{
        func = function(self)
            if variable.is_aoe then return end
            --if WarGodControl:AOEMode() then return end
            --local lustRemains = LustRemaining()
            if buff_ca_inc:Up() then return end
            return eclipse:In_Any()
        end,
        units = groups.cursor,
        label = "Incarn",
        helpharm = "harm",
        maxRange = 40,
        quick = true,
        offgcd = true,
        IsUsable = function(self)
            if not talent.incarnation_chosen_of_elune.enabled then return end

            if WarGodControl:AllowCDs() or LustRemaining() > 0 and (LustRemaining() < 32 or eclipse:In_Any())  or player:BuffRemaining("Power Infusion", "HELPFUL") > 0 then
                --print('2/3 usable')
                if Delegates:DamageCDWrapper(self.spell, WarGodUnit:GetTarget(), {15, 180}) and player.combat and WarGodUnit.active_enemies > 0 and buff_ca_inc:Down() and (buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0) then
                    --print('usable')
                    return true
                end
            end
        end,
    })

    -- FIX
    AddSpellFunction("Balance","Convoke the Spirits",baseScore + 760,{
        func = function(self)
            if variable.is_aoe then return end
            return --(buff_ca_inc:Up() or WarGodSpells["Celestial Alignment"]:CDRemaining() > 30) and player:Lunar_Power() < 40
            --(variable.convoke_desync and WarGodSpells["Celestial Alignment"]:CDRemaining() > player.gcd or buff_ca_inc:Up()) and player:Lunar_Power() < 40 and (eclipse:LunarRemains() > 8 or eclipse:SolarRemains() > 8)--|fight_remains<10
            buff_ca_inc:Remains() > 4.5 and (player:Lunar_Power() < 40 or buff_ca_inc:Remains() < 6)
        end,
        units = groups.noone,
        label = "Convoke",
        helpharm = "harm",
        maxRange = 40,
        IsUsable = function(self) return (talent.convoke_the_spirits.enabled) and WarGodControl:AllowCDs () and Delegates:DamageCDWrapper(self.spell, WarGodUnit:GetTarget(), {4, 60}) and player.combat and WarGodUnit.active_enemies > 0 and (GetSpecialization() ~= 1 or buff.moonkin_form:Stacks() > 0) end,
    })

    AddSpellFunction("Balance","Astral Communion",baseScore + 730,{
        func = function(self)
            if variable.is_aoe then return end
            return player:Lunar_Power_Deficit() > 65
        end,
        units = groups.noone,
        label = "AC",
        helpharm = "harm",
        maxRange = 40,
        IsUsable = function(self) return (talent.astral_communion.enabled) and --[[WarGodControl:AllowCDs () and ]]Delegates:DamageCDWrapper(self.spell, WarGodUnit:GetTarget(), {4, 60}) and player.combat and WarGodUnit.active_enemies > 0 and (GetSpecialization() ~= 1 or buff.moonkin_form:Stacks() > 0) end,
    })

    AddSpellFunction("Balance","Fury of Elune",baseScore + 700,{
        func = function(self)
            if variable.is_aoe then return end
            -- experimental replacement
            --[[if ((WarGodSpells["Celestial Alignment"]:CDRemaining() > 40 or talent.celestial_alignment.enabled and WarGodSpells["Celestial Alignment"]:CDRemaining() > 20) or (not Delegates:DamageCDWrapper(self.spell, WarGodUnit:GetTarget(), {30, 180}))) and (buff_ca_inc:Down() or buff.ravenous_frenzy:Down()) and eclipse:In_Any() then
                return true
            end]]
            return eclipse:In_Any()
        end,
        units = groups.targetable,
        label = "FoE (ST))",
        andDelegates = {Delegates.IsSpellInRange},
        IsUsable = function(self) return talent.fury_of_elune.enabled and Delegates:DamageCDWrapper(self.spell, WarGodUnit:GetTarget(), {8, 60}) and (buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0) end,
        helpharm = "harm",
        maxRange = 45,

    })

    AddSpellFunction("Balance","Starfall",baseScore + 680,{
        func = function(self)
            if variable.is_aoe then return end
            if (not talent.starweaver.enabled) or buff.starweavers_warp:Down() then return end
            if WarGodUnit.active_enemies >= 1 then
                local totalHealth = 0
                local healthToStarfall = --[[UnitInRaid("player") and UnitExists("boss1") and 0 or ]]player.health * max(1, GetNumGroupMembers())
                for k,unit in upairs(groups.targetableOrPlates) do
                    if (not Delegates:AoeBlacklistedWrapper(self.spell, unit, {})) and Delegates:IsSpellInRange("Wrath", unit, {}) then
                        totalHealth = totalHealth + unit.health
                        if totalHealth >= healthToStarfall then return true end
                    end
                end
            end
        end,
        units = groups.noone,
        label = "Starfall (Starweave)",
        --andDelegates = {Delegates.IsSpellInRange},
        helpharm = "harm",
        maxRange = 45,
    })

    AddSpellFunction("Balance","Starsurge",baseScore + 650,{
        func = function(self)
            if variable.is_aoe then return end
            if not talent.starlord.enabled then return end
            if not talent.rattle_the_stars.enabled then return end
            local starlordStacks = buff.starlord:Stacks()
            if starlordStacks > 0 and starlordStacks < 3 and buff.rattle_the_stars:Remains() < 2 then return true end
        end,
        units = groups.targetable,
        label = "Starsurge (Starlord Rattle)",
        andDelegates = {Delegates.IsSpellInRange},
        helpharm = "harm",
        IsUsable = function(self) return (player:Lunar_Power() >= 40 - (talent.rattle_the_stars.enabled and buff.rattled_stars:Stacks() * 2 or 0) - (talent.elunes_guidance.enabled and buff.incarnation_chosen_of_elune:Up()  and 5 or 0) or talent.starweaver.enabled and buff.starweavers_weft:Up()) and (buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0) end,
        maxRange = 45,
    })


    AddSpellFunction("Balance","New Moon",baseScore + 625,{
        func = function(self)
            --if variable.is_aoe then return end
            --if WarGodControl:AOEMode() then return end
            local execute_time = 0.1
            if AP_Check(self.spell) then
                if player.casting == nil or (not strmatch(player.casting, "Moon$")) then
                    local moonName = GetSpellInfo("New Moon").name
                    if moonName == "New Moon" then
                        return true
                    else
                        return eclipse:SolarRemains() > CastTimeFor("New Moon") or eclipse:LunarRemains() > CastTimeFor("New Moon")
                    end
                end

            end

        end,
        units = groups.targetable,
        label = "Moon (High Charges)",
        andDelegates = {Delegates.IsSpellInRange},
        helpharm = "harm",
        Castable = function(self)
            local castTime = CastTimeFor(self.spell)
            return castTime == 0 and Delegates:EnoughTimeToCastWrapper(self.spell, player, {}) or
                    (not IsMoving() and Delegates:EnoughTimeToCastWrapper(self.spell, player, {}) and Delegates:MoveInWrapper(self.spell, player, {}) > CastTimeFor(self.spell)) end,
        IsUsable = function(self) return talent.new_moon.enabled and (charges.new_moon:Fractional() >= 2 or charges.new_moon:Fractional() >= 1 and (player.casting == nil or (not strmatch(player.casting,"Moon$")))) and (buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0) end,
        maxRange = 45,
    })


    AddSpellFunction("Balance","Starsurge",baseScore + 600,{
        func = function(self)
            if variable.is_aoe then return end
            if buff.starweavers_weft:Up() then return true end
            --if player:Lunar_Power() >= 60 then
                local eclipseRemains = max(buff.eclipse_solar:Remains(), buff.eclipse_lunar:Remains())
                if eclipseRemains > 0 and eclipseRemains < 4 then
                    return true
                end
                if player:Lunar_Power() > 85 then
                    return true
                end
            if eclipseRemains > 0 and eclipseRemains < 4 then
                return true
            end
            if talent.balance_of_all_things.enabled and buff.balance_of_all_things:Up() then
                return true
            end
            if talent.balance_of_all_things.enabled and (GetSpellCount("Starfire") == 1 and player.casting == "Starfire" or GetSpellCount("Wrath") == 1 and player.casting == "Wrath") then
                return true
            end

        end,
        units = groups.targetable,
        label = "Starsurge",
        andDelegates = {Delegates.IsSpellInRange},
        helpharm = "harm",
        IsUsable = function(self) return (player:Lunar_Power() >= 40 - (talent.rattle_the_stars.enabled and buff.rattled_stars:Stacks() * 2 or 0) - (talent.elunes_guidance.enabled and buff.incarnation_chosen_of_elune:Up()  and 5 or 0) or talent.starweaver.enabled and buff.starweavers_weft:Up()) and (buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0) end,
        maxRange = 45,
    })



    AddSpellFunction("Balance","Starfire",baseScore + 595,{
        func = function(self)
            if variable.is_aoe then return end
            if not talent.warrior_of_elune.enabled then return end
            return buff_ca_inc:Up() and buff.warrior_of_elune:Stacks() == 1
        end,
        units = groups.targetable,
        label = "Starfire",
        Castable = function(self)
            local castTime = CastTimeFor(self.spell)
            return castTime == 0 and Delegates:EnoughTimeToCastWrapper(self.spell, player, {}) or
                    (not IsMoving() and Delegates:EnoughTimeToCastWrapper(self.spell, player, {}) and Delegates:MoveInWrapper(self.spell, player, {}) > CastTimeFor(self.spell)) end,
        IsUsable = function(self) return buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0 end,
        Interrupt = function(other) return other.spell == "Solar Beam" end,
        andDelegates = {Delegates.UnitIsEnemy, Delegates.IsSpellInRange},
        helpharm = "harm",
        maxRange = 45,
        quick = true,
    })

    AddSpellFunction("Balance","New Moon",baseScore + 315,{
        func = function(self)
            if variable.is_aoe then return end
            --if WarGodControl:AOEMode() then return end
            local execute_time = 0.1
            if AP_Check(self.spell) then
                if buff_ca_inc:Up() or charges.new_moon:Fractional() > 2.5 and buff.primordial_arcanic_pulsar:Value() <= 520 and WarGodSpells["Celestial Alignment"]:CDRemaining() > 10 then
                    if player.casting == "Full Moon" or player.casting ~= "New Moon" and GetSpellInfo("New Moon").name == "New Moon" then
                        return buff_ca_inc:Up() or charges.new_moon:Fractional() > 2.5 and buff.primordial_arcanic_pulsar:Value() <= 520 and WarGodSpells["Celestial Alignment"]:CDRemaining() > 10
                    else
                        if player.casting == "New Moon" or player.casting ~= "Half Moon" and GetSpellInfo("New Moon").name == "Half Moon" then
                            return buff.eclipse_solar:Remains() > 2 / (player.spell_haste / 100 + 1) or buff.eclipse_lunar:Remains() > 2 / (player.spell_haste / 100 + 1)
                        else
                            return buff.eclipse_solar:Remains() > 3 / (player.spell_haste / 100 + 1) or buff.eclipse_lunar:Remains() > 3 / (player.spell_haste / 100 + 1)
                        end
                    end
                end

            end

        end,
        units = groups.targetable,
        label = "Moon (AOE)",
        andDelegates = {Delegates.IsSpellInRange},
    })

    AddSpellFunction("Balance","Wrath",baseScore + 590,{
        func = function(self)
            if variable.is_aoe then return end
            return eclipse:In_Solar() and buff_ca_inc:Down() or buff_ca_inc:Remains() > CastTimeFor(self.spell) + 0.5
        end,
        units = groups.targetable,
        label = "Wrath",
        Castable = function(self)
            local castTime = CastTimeFor(self.spell)
            return castTime == 0 and Delegates:EnoughTimeToCastWrapper(self.spell, player, {}) or
                    (not IsMoving() and Delegates:EnoughTimeToCastWrapper(self.spell, player, {}) and Delegates:MoveInWrapper(self.spell, player, {}) > CastTimeFor(self.spell))
        end,
        IsUsable = function(self) return buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0 end,
        Interrupt = function(other) return other.spell == "Solar Beam" end,
        andDelegates = {Delegates.UnitIsEnemy, Delegates.IsSpellInRange},
        helpharm = "harm",
        maxRange = 45,
        quick = true,
    })

    --actions.prepatch_st+=/starfire,if=(azerite.streaking_stars.rank&buff.ca_inc.remains>execute_time&variable.prev_wrath)|(!azerite.streaking_stars.rank|buff.ca_inc.remains<execute_time|!variable.prev_starfire)&(eclipse.in_lunar|eclipse.solar_next|eclipse.any_next|buff.warrior_of_elune.up&buff.eclipse_lunar.up|(buff.ca_inc.remains<action.wrath.execute_time&buff.ca_inc.up))|(azerite.dawning_sun.rank>2&buff.eclipse_solar.remains>5&!buff.dawning_sun.remains>action.wrath.execute_time)
    AddSpellFunction("Balance","Starfire",baseScore + 585,{
        func = function(self)
            if variable.is_aoe then return end
            return eclipse:In_Lunar() or buff_ca_inc:Up()
        end,
        units = groups.targetable,
        andDelegates = {Delegates.UnitIsEnemy},
        label = "Starfire",
    })

    ----------------------------- Fallthru --------------------------------------

    --[[AddSpellFunction("Balance","Starfall",baseScore + 400,{
        func = function(self)
            if runeforge.balance_of_all_things.equipped or variable.is_aoe then return end
            if talent.stellar_drift.enabled then
                if WarGodUnit.active_enemies >= 1 then
                    local totalHealth = 0
                    local healthToStarfall = player.health * max(1, GetNumGroupMembers())
                    for k,unit in upairs(groups.targetableOrPlates) do
                        if (not Delegates:AoeBlacklistedWrapper(self.spell, unit, {})) and Delegates:IsSpellInRange("Wrath", unit, {}) then
                            totalHealth = totalHealth + unit.health
                            if totalHealth >= healthToStarfall then return true end
                        end
                    end
                end
            end
        end,
        units = groups.noone,
        label = "Starfall Fallthrough",
        andDelegates = {Delegates.IsSpellInRange},
    })]]

    --actions.fallthru=starsurge,if=!runeforge.balance_of_all_things.equipped
    AddSpellFunction("Balance","Starsurge",baseScore + 300,{
        func = function(self)
            if variable.is_aoe then return end
            return player:Lunar_Power() >= 80
        end,
        units = groups.targetable,
        label = "Starsurge Filler",
        andDelegates = {Delegates.IsSpellInRange},
    })

    --actions.fallthru+=/sunfire,target_if=dot.moonfire.remains>remains
    AddSpellFunction("Balance","Sunfire",baseScore + 290,{
        func = function(self)
            if variable.is_aoe then return end
            return true
        end,
        units = groups.targetable,
        label = "Sunfire MF > SF",
        andDelegates = {Delegates.IsSpellInRange, Delegates.MoonfireRemainsGTSunfireRemains},
    })

    --actions.fallthru+=/moonfire
    AddSpellFunction("Balance","Moonfire",baseScore + 260,{
        func = function(self)
            if variable.is_aoe then return end
            return true
        end,
        units = groups.targetable,
        label = "Moonfire Filler",
        andDelegates = {Delegates.IsSpellInRange},
    })

    AddSpellFunction("Balance","Sunfire",baseScore + 230,{
        func = function(self)
            if variable.is_aoe then return end
            return true
        end,
        units = groups.targetable,
        label = "Sunfire Filler",
        andDelegates = {Delegates.IsSpellInRange},
    })

end