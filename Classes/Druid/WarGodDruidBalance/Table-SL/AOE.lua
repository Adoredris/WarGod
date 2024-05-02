--
-- Created by IntelliJ IDEA.
-- User: Ikevink
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
local buffNotMine = player.buffNotMine
local azerite = player.azerite
local conduit = player.conduit
local variable = player.variable
local eclipse = player.eclipse
local buff_ca_inc = player.buff_ca_inc
local covenant = player.covenant
local runeforge = player.runeforge
local equipped = player.equipped


local GetShapeshiftForm = GetShapeshiftForm
local GetNumGroupMembers = GetNumGroupMembers
local GetSpellInfo = GetSpellInfo

local GetSpellCount = GetSpellCount
local GetInventoryItemCooldown = GetInventoryItemCooldown
local UnitInRaid = UnitInRaid




local floor = floor
local ceil = ceil
local max = max

local upairs = upairs
local KSPartnerHasCDUp = KSPartnerHasCDUp

---------TEMP-------------
local WGBM = WarGod.BossMods
local WarGodUnit = WarGod.Unit
local WarGodControl = WarGod.Control
local WarGodSpells = WarGod.Rotation.rotationFrames["Balance"]
--------------------------

setfenv(1, Rotations)

local baseScore = 5000
do
    AddSpellFunction("Balance","Sunfire",baseScore + 950,{
        func = function(self)
            if not variable.is_aoe then return end
            return AP_Check(self.spell)
        end,
        units = groups.targetable,
        label = "Sunfire AoE",
        andDelegates = {Delegates.IsSpellInRange, Delegates.DoT_Pandemic, Delegates.DoT_TTD_Estimate, Delegates.NotDotBlacklisted, Delegates.UnitNotMoving},
        scorer = ScoreByInvertedDebuffTimeRemaining,
        args = {--[[aura = "sunfire", ]]threshold = 5.4, ttd = 8},
    })

    --actions.aoe+=/adaptive_swarm,target_if=!ticking&!action.adaptive_swarm_damage.in_flight|dot.adaptive_swarm_damage.stack<3&dot.adaptive_swarm_damage.remains<3

    --actions.aoe+=/moonfire,target_if=refreshable&target.time_to_die>(14+(spell_targets.starfire*1.5))%spell_targets+remains,if=(cooldown.ca_inc.ready|spell_targets.starfire<3|(eclipse.in_solar|eclipse.in_both|eclipse.in_lunar&!talent.soul_of_the_forest.enabled|buff.primordial_arcanic_pulsar.value>=250)&(spell_targets.starfire<10*(1+talent.twin_moons.enabled))&astral_power>50-buff.starfall.remains*6)&!buff.kindred_empowerment_energize.up&ap_check
    AddSpellFunction("Balance","Moonfire",baseScore + 925,{
        func = function(self)
            if not variable.is_aoe then return end
            return AP_Check(self.spell)
        end,
        units = groups.targetable,
        label = "Moonfire AoE",
        andDelegates = {Delegates.IsSpellInRange, Delegates.DoT_Pandemic, Delegates.DoT_TTD_Estimate, Delegates.NotDotBlacklisted--[[, Delegates.SunfireTargetCondition, ]]},
        scorer = ScoreByInvertedDebuffTimeRemaining,
        args = {--[[aura = "sunfire", ]]threshold = 6.6, ttd = 8},
    })

    AddSpellFunction("Balance","Starfall",baseScore + 900,{
        func = function(self)
            if not variable.is_aoe then return end
            if player:Lunar_Power() > 70 or buff.starwearvers_warp:Up() then
                local numEnemies = 0
                local totalHealth = 0
                local healthToStarfall = --[[UnitInRaid("player") and 0 or ]]player.health * max(1, GetNumGroupMembers())
                for k,unit in upairs(groups.targetableOrPlates) do
                    if (not Delegates:AoeBlacklistedWrapper(self.spell, unit, {})) and Delegates:IsSpellInRange("Wrath", unit, {}) then
                        numEnemies = numEnemies + 1
                        totalHealth = totalHealth + unit.health
                        if numEnemies >= variable.sf_targets and totalHealth >= healthToStarfall then return true end
                    end
                end
            end
        end,
        units = groups.noone,
        label = "Starfall (AoE)",
        --IsUsable = function() return (player:Lunar_Power() >= 50 * (talent.rattle_the_stars.enabled and buff.rattled_stars:Stacks() * 0.95 or 1) - (talent.elunes_guidance.enabled and buff.incarnation_chosen_of_elune:Up()  and 8 or 0) or talent.starweaver.enabled and buff.starweavers_warp:Up()) and --[[WarGodControl:AllowClickies() and ]]player.combat and (buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0) end,
    })

    AddSpellFunction("Balance","Celestial Alignment",baseScore + 890,{
        func = function(self)
            if not variable.is_aoe then return end
            --if WarGodControl:AOEMode() then return end
            --local lustRemains = LustRemaining()
            if buff_ca_inc:Up() then return end
            local totalHealth = 0
            local healthToCD = --[[UnitInRaid("player") and 0 or ]]player.health * max(1, GetNumGroupMembers())
            for k,unit in upairs(groups.targetableOrPlates) do
                if (not Delegates:AoeBlacklistedWrapper(self.spell, unit, {})) and Delegates:IsSpellInRange("Wrath", unit, {}) then
                    totalHealth = totalHealth + unit.health
                    if totalHealth >= healthToCD then return true end
                end
            end
            return true
        end,
        units = groups.noone,
        label = "Incarn (AoE)",
    })

    AddSpellFunction("Balance","Warrior of Elune",baseScore + 825,{
        --func = function(self) return talent.warrior_of_elune.enabled and  end,
        units = groups.noone,
        label = "WoE (AoE)",
    })

    AddSpellFunction("Balance","Starfire",baseScore + 750,{
        func = function(self)
            if not variable.is_aoe then return end
            if (eclipse:In_Any()) then return end
            if WarGodUnit.active_enemies > 2 then return end
            if eclipse:Any_Next() and (GetSpellCount("Starfire") > 1 or player.casting ~= "Starfire") then
                return true
            end
        end,
        units = groups.targetable,
        label = "Starfire (Enter Eclipse AoE)",
    })

    AddSpellFunction("Balance","Wrath",baseScore + 700,{
        func = function(self)
            if not variable.is_aoe then return end
            if (eclipse:In_Any()) then return end
            if WarGodUnit.active_enemies < 3 then return end
            if eclipse:Any_Next() and (GetSpellCount("Wrath") > 1 or player.casting ~= "Wrath") then
                return true
            end
        end,
        units = groups.targetable,
        label = "Wrath (Enter Eclipse AoE)",
    })

    AddSpellFunction("Balance","Fury of Elune",baseScore + 650,{
        func = function(self)
            if not variable.is_aoe then return end
            -- experimental replacement
            --[[if (WarGodSpells["Celestial Alignment"]:CDRemaining() > 40 or (not Delegates:DamageCDWrapper(self.spell, WarGodUnit:GetTarget(), {30, 180}))) and (buff_ca_inc:Down() or buff.ravenous_frenzy:Down()) and eclipse:In_Any() then
                return true
            end]]
            return eclipse:In_Any()
        end,
        units = groups.targetable,
        label = "FoE (AoE)",
        andDelegates = {Delegates.IsSpellInRange},
        IsUsable = function(self) return talent.fury_of_elune.enabled and Delegates:DamageCDWrapper(self.spell, WarGodUnit:GetTarget(), {8, 60}) and (buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0) end,
        helpharm = "harm",
        maxRange = 45,

    })

    AddSpellFunction("Balance","Starfall",baseScore + 600,{
        func = function(self)
            if not variable.is_aoe then return end
            if (talent.starweaver.enabled and buff.starweavers_warp:Down()) or (talent.starlord.enabled and buff.starlord:Stacks() < 3) then
            --if player:Lunar_Power() > 80 then
                local numEnemies = 0
                local totalHealth = 0
                local healthToStarfall = --[[UnitInRaid("player") and 0 or ]]player.health * max(1, GetNumGroupMembers())
                for k,unit in upairs(groups.targetableOrPlates) do
                    if (not Delegates:AoeBlacklistedWrapper(self.spell, unit, {})) and Delegates:IsSpellInRange("Wrath", unit, {}) then
                        numEnemies = numEnemies + 1
                        totalHealth = totalHealth + unit.health
                        if numEnemies >= variable.sf_targets and totalHealth >= healthToStarfall then return true end
                    end
                end
            end
        end,
        units = groups.noone,
        label = "Starfall (AoE Starlord)",
        IsUsable = function()
            if --[[player.combat and ]](buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0) then
                local starfallCost = 50 - (talent.rattle_the_stars.enabled and buff.rattled_stars:Stacks() * 2.5 or 0) - (talent.elunes_guidance.enabled and buff.incarnation_chosen_of_elune:Up() and 8 or 0)
                --print(starfallCost)
                if player:Lunar_Power() >= starfallCost then
                    return true
                elseif talent.starweaver.enabled and buff.starweavers_warp:Up() then
                    return true
                end
            end
        end,
    })

    AddSpellFunction("Balance","Starsurge",baseScore + 550,{
        func = function(self)
            if not variable.is_aoe then return end
            if WarGodUnit.active_enemies < 3 then return end
            if buff.starweavers_weft:Down() then return end
            return true
        end,
        units = groups.targetable,
        label = "Starsurge (Weft AoE)",
        andDelegates = {Delegates.IsSpellInRange},
    })

    -- Stellar Flare


    AddSpellFunction("Balance","Astral Communion",baseScore + 520,{
        func = function(self)
            if not variable.is_aoe then return end
            return player:Lunar_Power_Deficit() > 65
        end,
        units = groups.noone,
        label = "AC",
    })

    -- Convoke

    -- Moons

    AddSpellFunction("Balance","Starsurge",baseScore + 450,{
        func = function(self)
            if not variable.is_aoe then return end
            if buff.starweavers_weft:Down() then return end
            return true
        end,
        units = groups.targetable,
        label = "Starsurge (Weft AoE)",
        andDelegates = {Delegates.IsSpellInRange},
    })

    AddSpellFunction("Balance","Starfall",baseScore + 400,{
        func = function(self)
            if not variable.is_aoe then return end
            local numEnemies = 0
            local totalHealth = 0
            local healthToStarfall = --[[UnitInRaid("player") and 0 or ]]player.health * max(1, GetNumGroupMembers())
            for k,unit in upairs(groups.targetableOrPlates) do
                if (not Delegates:AoeBlacklistedWrapper(self.spell, unit, {})) and Delegates:IsSpellInRange("Wrath", unit, {}) then
                    numEnemies = numEnemies + 1
                    totalHealth = totalHealth + unit.health
                    if numEnemies >= variable.sf_targets and totalHealth >= healthToStarfall then return true end
                end
            end
        end,
        units = groups.noone,
        label = "Starfall (AoE)"
    })


    --actions.aoe+=/variable,name=starfire_in_solar,value=spell_targets.starfire>4+floor(mastery_value%20)+floor(buff.starsurge_empowerment_solar.stack%4)
    AddSpellFunction("Balance","Starfire",baseScore + 390,{
        func = function(self)
            if not variable.is_aoe then return end
            if eclipse:In_Lunar() and (not eclipse:In_Solar()) then
                return true
            end
            if WarGodUnit.active_enemies >= 4 and buff_ca_inc:Remains() > CastTimeFor(self.spell) then
                return true
            end
        end,
        units = groups.targetable,
        label = "Starfire (AoE Filler)",
        andDelegates = {Delegates.IsSpellInRange},
    })


    --actions.aoe+=/wrath,if=eclipse.lunar_next|eclipse.any_next&variable.is_cleave|buff.eclipse_solar.remains<action.starfire.execute_time&buff.eclipse_solar.up|eclipse.in_solar&!variable.starfire_in_solar|buff.ca_inc.remains<action.starfire.execute_time&!variable.is_cleave&buff.ca_inc.remains<execute_time&buff.ca_inc.up|buff.ravenous_frenzy.up&spell_haste>0.6&(spell_targets<=3|!talent.soul_of_the_forest.enabled)|!variable.is_cleave&buff.ca_inc.remains>execute_time
    AddSpellFunction("Balance","Wrath",baseScore + 360,{
        func = function(self)
            if not variable.is_aoe then return end
            if eclipse:In_Solar() and (not eclipse:In_Lunar()) then
                return true
            end
            if WarGodUnit.active_enemies < 4 and buff_ca_inc:Remains() > CastTimeFor("Starfire") then
                return true
            end
        end,
        units = groups.targetable,
        label = "Wrath AOE",
        andDelegates = {Delegates.IsSpellInRange},
    })
    --actions.aoe+=/starfire

    AddSpellFunction("Balance","Starfire",baseScore + 330,{
        func = function(self)
                return variable.is_aoe and eclipse:SolarRemains() > CastTimeFor("Wrath") and WarGodUnit.active_enemies > 9
        end,
        units = groups.targetable,
        label = "Starfire Override AOE",
        andDelegates = {Delegates.IsSpellInRange},
    })

    AddSpellFunction("Balance","Wrath",baseScore + 320,{
        func = function(self)
            if variable.is_aoe then
                if eclipse:In_Solar() then
                    return true
                elseif eclipse:Lunar_Next() then
                    if player.casting == "Wrath" and GetSpellCount("Wrath") == 1 then
                        return
                    end
                    return true
                end
            end
        end,
        units = groups.targetable,
        label = "Wrath Filler AOE",
        andDelegates = {Delegates.IsSpellInRange},
    })

    AddSpellFunction("Balance","Starfire",baseScore + 310,{
        func = function(self)
            return variable.is_aoe
        end,
        units = groups.targetable,
        label = "Starfire Filler AOE",
        andDelegates = {Delegates.IsSpellInRange},
    })

    AddSpellFunction("Balance","Wrath",baseScore + 300,{
        func = function(self)
            return variable.is_aoe
        end,
        units = groups.targetable,
        label = "Wrath Filler AOE",
        andDelegates = {Delegates.IsSpellInRange},
    })




    ----------------------------- Fallthru --------------------------------------
    AddSpellFunction("Balance","Sunfire",baseScore + 155,{
        func = function(self)
            if variable.is_aoe then
                return true--AP_Check(self.spell)
            end
        end,
        units = groups.targetable,
        label = "Sunfire AoE",
        andDelegates = {Delegates.IsSpellInRange, Delegates.DoT_Pandemic, Delegates.NotDotBlacklisted},
        scorer = ScoreByInvertedDebuffTimeRemaining,
        args = {--[[aura = "sunfire", ]]threshold = 5.4, ttd = 8},
    })

    --actions.aoe+=/moonfire,target_if=refreshable&target.time_to_die>(14+(spell_targets.starfire*1.5))%spell_targets+remains,if=(cooldown.ca_inc.ready|spell_targets.starfire<3|(eclipse.in_solar|eclipse.in_both|eclipse.in_lunar&!talent.soul_of_the_forest.enabled|buff.primordial_arcanic_pulsar.value>=250)&(spell_targets.starfire<10*(1+talent.twin_moons.enabled))&astral_power>50-buff.starfall.remains*6)&!buff.kindred_empowerment_energize.up&ap_check
    AddSpellFunction("Balance","Moonfire",baseScore + 150,{
        func = function(self)
            if variable.is_aoe and buff.balance_of_all_things:Down() then
                return true--AP_Check(self.spell)
            end
        end,
        units = groups.targetable,
        label = "Moonfire AoE",
        andDelegates = {Delegates.IsSpellInRange, Delegates.DoT_Pandemic, Delegates.NotDotBlacklisted},
        scorer = ScoreByInvertedDebuffTimeRemaining,
        args = {--[[aura = "sunfire", ]]threshold = 6.6, ttd = 8},
    })

    --actions.fallthru=starsurge,if=!runeforge.balance_of_all_things.equipped
    AddSpellFunction("Balance","Starsurge",baseScore + 100,{
        func = function(self)
            --if runeforge.balance_of_all_things.equipped then return end
            if variable.is_aoe then
                return player:Lunar_Power() >= 90
            end
        end,
        units = groups.targetable,
        label = "Starsurge Filler AOE",
        andDelegates = {Delegates.IsSpellInRange},
    })
    --actions.fallthru+=/sunfire,target_if=dot.moonfire.remains>remains
    AddSpellFunction("Balance","Sunfire",baseScore + 90,{
        func = function(self)
            if variable.is_aoe then
                return true
            end
        end,
        units = groups.targetable,
        label = "Sunfire MF > SF AOE",
        andDelegates = {Delegates.IsSpellInRange, Delegates.MoonfireRemainsGTSunfireRemains},
    })

    --actions.fallthru+=/moonfire
    AddSpellFunction("Balance","Moonfire",baseScore + 60,{
        func = function(self)
            if variable.is_aoe then
                return true
            end
        end,
        units = groups.targetable,
        label = "Moonfire Filler AOE",
        andDelegates = {Delegates.IsSpellInRange},
    })

    AddSpellFunction("Balance","Sunfire",baseScore + 30,{
        func = function(self)
            if variable.is_aoe then
                return true
            end
        end,
        units = groups.targetable,
        label = "Sunfire Filler AOE",
        andDelegates = {Delegates.IsSpellInRange},
    })

end