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

local eclipse = player.eclipse

---------TEMP-------------
local WarGod = WarGod
local WGBM = WarGod.BossMods
--local Delegates = Rotations.Delegates
local WarGodControl = WarGod.Control
local WarGodSpells = WarGod.Rotation.rotationFrames["Balance"]
--------------------------


WarGod.potion = false


setfenv(1, Rotations)



local baseScore = 7000
do
    -- actions+=/use_item,name=empyreal_ordnance,if=cooldown.ca_inc.remains<20&variable.convoke_desync|cooldown.convoke_the_spirits.remains<20
    --[[AddItemFunction("Balance",13,baseScore + 510,{
        func = function(self)
            local spell, unit, args = self.spell, WarGodUnit:GetTarget(), {}
            if equipped.empyreal_ordnance.slotIndex == 13
                    and Delegates:UnitIsEnemy(spell, unit, args)
                    and (not Delegates:DotBlacklistedWrapper(spell, unit,args))
                    and (not Delegates:DPSBlacklistWrapper(spell, unit,args))
                    and (Delegates:PriorityWrapper(spell, unit,args) > 0) then
                if (IsItemInRange(28767,"target")) then
                    return (WarGodSpells["Celestial Alignment"]:CDRemaining() < 20 and WarGodSpells["Convoke the Spirits"]:CDRemaining() < 20 and Delegates:BurstInWrapper(spell, unit, args) < 20 and Delegates:BurstInWrapper(spell, unit, args) == 0)
                else
                    print("You are not close enough for trinket")
                end
            end
        end,
        units = groups.noone,
        label = "Ordnance Slot 1",
        quick = true,
        IsUsable = function(self) return WarGodControl:AllowCDs() and Delegates:DamageCDWrapper(self.spell, WarGodUnit:GetTarget(), {40, 180}) and player.combat and WarGodUnit.active_enemies > 0 and (buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0) end,
    })

    AddItemFunction("Balance",14,baseScore + 500,{
        func = function(self)
            local spell, unit, args = self.spell, WarGodUnit:GetTarget(), {}
            if equipped.empyreal_ordnance.slotIndex == 14
                    and Delegates:UnitIsEnemy(spell, unit,args)
                    and ((not Delegates:DotBlacklistedWrapper(spell, unit,args)))
                    and (not Delegates:DPSBlacklistWrapper(spell, unit,args))
                    and (Delegates:PriorityWrapper(spell, unit,args) > 0) then
                if (IsItemInRange(28767,"target")) then
                    return (WarGodSpells["Celestial Alignment"]:CDRemaining() < 20 and WarGodSpells["Convoke the Spirits"]:CDRemaining() < 20 and Delegates:BurstInWrapper(spell, unit, args) < 20 or Delegates:BurstInWrapper(spell, unit, args) == 0)
                else
                    print("You are not close enough for trinket")
                end
            end
        end,
        units = groups.noone,
        label = "Ordnance Slot 2",
        quick = true,
        IsUsable = function(self) return WarGodControl:AllowCDs() and Delegates:DamageCDWrapper(self.spell, WarGodUnit:GetTarget(), {40, 180}) and player.combat and WarGodUnit.active_enemies > 0 and (buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0) end,
    })]]

    AddItemFunction("Balance",13,baseScore + 441,{
        func = function(self)
            local spell, unit, args = self.spell, WarGodUnit:GetTarget(), {}
            if Delegates:UnitIsEnemy("Wrath",unit,args)
                    --and (not (not Delegates:DotBlacklistedWrapper(spell, unit,args)))
                    and (not Delegates:DPSBlacklistWrapper(spell,unit,args))
                    and (Delegates:PriorityWrapper(spell, unit,args) > 0) then
                if equipped.spoils_of_neltharus.slotIndex == 13 or equipped.irideus_fragment.slotIndex == 13 then
                    if buff_ca_inc:Remains() > 15 or buff_ca_inc:Remains() > 9 and WarGodSpells["Celestial Alignment"]:CDRemaining() > 30 then
                        return true
                    end
                end
            end
        end,
        units = groups.noone,
        label = "Trinket Slot 1",
        quick = true,
        --IsUsable = function(self) return true end,
    })

    AddItemFunction("Balance",14,baseScore + 440,{
        func = function(self)
            local spell, unit, args = self.spell, WarGodUnit:GetTarget(), {}
            if Delegates:UnitIsEnemy("Wrath",unit,args)
                    --and (not (not Delegates:DotBlacklistedWrapper(spell, unit,args)))
                    and (not Delegates:DPSBlacklistWrapper(spell,unit,args))
                    and (Delegates:PriorityWrapper(spell, unit,args) > 0) then
                if equipped.spoils_of_neltharus.slotIndex == 14 or equipped.irideus_fragment.slotIndex == 14 then
                    if buff_ca_inc:Remains() > 15 or buff_ca_inc:Remains() > 9 and WarGodSpells["Celestial Alignment"]:CDRemaining() > 30 then
                        return true
                    end
                end
            end
        end,
        units = groups.noone,
        label = "Trinket Slot 2",
        quick = true,
        --IsUsable = function(self) return true end,
    })

    AddItemFunction("Balance","Fleeting Elemental Potion of Ultimate Power",baseScore + 401,{
        func = function(self)
            if not WarGod.potion then return end
            local spell, unit, args = self.spell, WarGodUnit:GetTarget(), {}
            if Delegates:UnitIsEnemy("Starfire", unit,args)
                    --and (not (not Delegates:DotBlacklistedWrapper(spell, unit,args)))
                    and (not Delegates:DPSBlacklistWrapper(spell, unit,args))
                    and (Delegates:PriorityWrapper(spell, unit,args) > 0)
            --and UnitExists("boss1")-- and (UnitInRaid("player")--[[ or ]])
            then
                --print('eligible potion target')
                --if covenant.venthyr then
                local incarnRemains = buff_ca_inc:Remains()
                if incarnRemains <= 0 then return end
                --if (not runeforge.sinful_hysteria.equipped) then
                if (incarnRemains > 15) then
                    return true
                end
                --end
            end
        end,
        units = groups.noone,
        label = "Pot",
        quick = true,
        IsUsable = function(self)
            if WarGod.potion and Delegates:DamageCDWrapper(self.spell, WarGodUnit:GetTarget(), {25, 300}) then
                --print('potion usable')
                --[[if DoingHeroicPlus() and GetNumGroupMembers() >= 10 then
                    return true
                elseif GetKeyLevel() >= 15 then]]
                return true
                --end
            end
        end,
    })

    AddItemFunction("Balance","Elemental Potion of Ultimate Power",baseScore + 400,{
        func = function(self)
            if not WarGod.potion then return end
            local spell, unit, args = self.spell, WarGodUnit:GetTarget(), {}
            if Delegates:UnitIsEnemy("Starfire", unit,args)
                    --and (not (not Delegates:DotBlacklistedWrapper(spell, unit,args)))
                    and (not Delegates:DPSBlacklistWrapper(spell, unit,args))
                    and (Delegates:PriorityWrapper(spell, unit,args) > 0)
                    and UnitExists("boss1")-- and (UnitInRaid("player")--[[ or ]])
                    then
                --if 1 == 1 then return true end
                --print('eligible potion target')
                local incarnRemains = buff_ca_inc:Remains()
                --print(incarnRemains)
                if incarnRemains <= 0 then return end
                --if (not runeforge.sinful_hysteria.equipped) then
                if (incarnRemains > 15) then
                    return true
                end
            end
        end,
        units = groups.noone,
        label = "Pot",
        quick = true,
        IsUsable = function(self)
            if WarGod.potion and Delegates:DamageCDWrapper(self.spell, WarGodUnit:GetTarget(), {25, 300}) then
                --
                --print('potion usable')
                --[[if DoingHeroicPlus() and GetNumGroupMembers() >= 10 then
                    return true
                elseif GetKeyLevel() >= 15 then]]
                    return true
                --end
            end
        end,
    })



    if 1==1 then return end
    AddSpellFunction("Balance","Fury of Elune",baseScore + 300,{
        func = function(self)
            local rfRemains = buff.ravenous_frenzy:Remains()
            if rfRemains > 0 then
                --if (not runeforge.sinful_hysteria.equipped) then
                if (not covenant.venthyr) then
                    return rfRemains <= 8 or buff.ravenous_frenzy.duration < 10
                else
                    return rfRemains <= 5
                end
            end
            --return true
        end,
        units = groups.targetable,
        label = "FoE RF",
        andDelegates = {Delegates.IsSpellInRange},
        IsUsable = function(self) return talent.fury_of_elune.enabled and Delegates:DamageCDWrapper(self.spell, WarGodUnit:GetTarget(), {8, 60}) and (buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0) end,
        helpharm = "harm",
        maxRange = 45,

    })

    if 1==1 then return end
    --actions+=/thorns

    --actions+=/warrior_of_elune




    --actions+=/innervate,if=azerite.lively_spirit.enabled&(cooldown.incarnation.remains<2|cooldown.celestial_alignment.remains<12)

--[[
    --actions+=/incarnation,if=dot.sunfire.remains>8&dot.moonfire.remains>12&(dot.stellar_flare.remains>6|!talent.stellar_flare.enabled)&(buff.memory_of_lucid_dreams.up|ap_check)&!buff.ca_inc.up
	AddSpellFunction("Balance","Celestial Alignment",baseScore + 410,{
        func = function(self)
			if talent.incarnation_chosen_of_elune.enabled or buff.incarnation_chosen_of_elune:Stacks() > 0 then return end
			if (player:Lunar_Power_Deficit() >= 40 or buff.memory_of_lucid_dreams.up) then-- or WarGodSpells["Celestial Alignment"]:CDRemaining() > 30) and (buff.celestial_alignment.down and buff.incarnation_chosen_of_elune.down) then
                if variable.dottedToCA or GetSpellInfo("Heart Essence") == "Guardian of Azeroth" and WarGodSpells["Guardian of Azeroth"]:CDRemaining() > 150 then
                    return true
                end

            end
			--player:Lunar_Power_Deficit() > 40 or WarGodUnit.active_enemies > 3-- or buff.time_warp:Stacks() > 0 or buff.heroism:Stacks() > 0 or buff.primal_rage:Stacks() > 0
		end,
        units = groups.noone,
        label = "Incarn",
        helpharm = "harm",
        maxRange = 40,
        IsUsable = function(self) return WarGodControl:AllowCDs () and Delegates:DamageCDWrapper(self.spell, WarGodUnit:GetTarget(), {15, 180}) and player.combat and WarGodUnit.active_enemies > 0 and buff.incarnation_chosen_of_elune:Stacks() < 1 and buff.celestial_alignment:Stacks() < 1 and (buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0) end,

    })
    --actions+=/celestial_alignment,if=!buff.ca_inc.up&(buff.memory_of_lucid_dreams.up|(ap_check&astral_power>=40))&(!azerite.lively_spirit.enabled|buff.lively_spirit.up)&(dot.sunfire.remains>2&dot.moonfire.ticking&(dot.stellar_flare.ticking|!talent.stellar_flare.enabled))
    AddSpellFunction("Balance","Celestial Alignment",baseScore + 400,{
        func = function(self)
			if (not talent.incarnation_chosen_of_elune.enabled) or buff.celestial_alignment:Stacks() > 0 then return end
            if (talent.starlord.enabled and buff.starlord.down) then return end
			if (buff.memory_of_lucid_dreams.up or AP_Check(self.spell)) then
                --local numDots
                for k,unit in upairs(groups.targetableOrPlates) do
                    if unit:DebuffRemaining("Sunfire", "HARMFUL|PLAYER") > 2 and unit:DebuffRemaining("Moonfire", "HARMFUL|PLAYER") > 0 then
						--(!azerite.lively_spirit.enabled|buff.lively_spirit.up)
                        if (not talent.stellar_flare.enabled) or unit:DebuffRemaining("Stellar Flare", "HARMFUL|PLAYER") > 0 or player.casting == "Stellar Flare" then
                            return true
                        end
                    end
                end
            end
			--return player:Lunar_Power_Deficit() > 40 or WarGodUnit.active_enemies > 3-- or buff.time_warp:Stacks() > 0 or buff.heroism:Stacks() > 0 or buff.primal_rage:Stacks() > 0
		end,
        units = groups.noone,
        label = "CA",
        helpharm = "harm",
        maxRange = 40,
        --IsUsable = function(self) return WarGodControl:AllowCDs () and Delegates:DamageCDWrapper(self.spell, WarGodUnit:GetTarget(), {15, 180}) and player.combat and WarGodUnit.active_enemies > 0 and (buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0) end,

    })
]]
    --actions+=/fury_of_elune,if=(buff.ca_inc.up|cooldown.ca_inc.remains>30)&solar_wrath.ap_check


    --actions+=/force_of_nature,if=(buff.ca_inc.up|cooldown.ca_inc.remains>30)&ap_check
    AddSpellFunction("Balance","Force of Nature",baseScore + 200,{
        func = function(self) return ((WarGodSpells["Celestial Alignment"]:CDRemaining() > 30 or (not UnitExists("boss1"))) or buff.celestial_alignment:Stacks() > 0 or buff.incarnation_chosen_of_elune:Stacks() > 0 or (not WarGodControl:AllowCDs()) or (not Delegates:DamageCDWrapper("Celestial Alignment", WarGodUnit:GetTarget(), {15, 180})))
        end,
        units = groups.cursor,
        label = "FoN",
        --andDelegates = {Delegates.UnitIsBoss},
        IsUsable = function(self) return talent.force_of_nature.enabled and WarGodControl:AllowClickies() and player.combat and WarGodUnit.active_enemies > 0 and (buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0) end,
        helpharm = "harm",
        maxRange = 45,

    })

    AddSpellFunction("Balance","Celestial Alignment",baseScore + 998,{
        func = function(self)
            return Delegates:BurstUnitWrapper(self.spell, WarGod.Unit:GetTarget(), {})
        end,
        units = groups.cursor,
        label = "CA (Burst)",
    })

    AddSpellFunction("Balance","Incarnation: Chosen of Elune",baseScore + 997,{
        func = function(self)
            return Delegates:BurstUnitWrapper(self.spell, WarGod.Unit:GetTarget(), {})
        end,
        units = groups.cursor,
        label = "Incarn (Burst)",
    })

    AddSpellFunction("Balance","Starfall",baseScore + 10,{
        func = function(self)
            --if not variable.is_aoe then return end
            local numEnemies = 0
            --local totalHealth = 0
            --local healthToStarfall = --[[UnitInRaid("player") and 0 or ]]player.health * max(1, GetNumGroupMembers())
            for k,unit in upairs(groups.targetableOrPlates) do
                if (not Delegates:AoeBlacklistedWrapper(self.spell, unit, {})) and Delegates:IsSpellInRange("Wrath", unit, {}) then
                    numEnemies = numEnemies + 1
                    if numEnemies >= 3 then return true end
                end
            end
        end,
        units = groups.noone,
        label = "Starfall (AoE Burst)"
    })

end