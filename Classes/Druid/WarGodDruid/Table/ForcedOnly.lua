--
-- Created by IntelliJ IDEA.
-- User: Flora
-- Date: 30/06/2017
-- Time: 6:22 PM
-- To change this template use File | Settings | File Templates.
--
local Rotations = WarGod.Rotation
local Class = WarGod.Class
local groups = WarGod.Unit.groups
local player = WarGod.Unit:GetPlayer()
local talent = player.trait
local buff = player.buff
local azerite = player.azerite

local WarGodControl = WarGod.Control

local UnitInRaid = UnitInRaid
local InCombatLockdown = InCombatLockdown
local GetShapeshiftForm = GetShapeshiftForm
local GetShapeshiftFormInfo = GetShapeshiftFormInfo
local IsSpellInRange = LibStub("SpellRange-1.0").IsSpellInRange
local IsOutdoors = IsOutdoors
local UnitIsPlayer = UnitIsPlayer

local GetSpecialization = GetSpecialization


--local upairs = upairs

---------TEMP-------------
local WGBM = WarGod.BossMods
--local Delegates = Rotations.Delegates
local WarGodCore = WarGod.Control
--------------------------



local GetNumGroupMembers = GetNumGroupMembers


setfenv(1, Rotations)

do
    AddSpellFunction(nil, "Wild Charge",0,{
        func = function(self)  end,       -- dummy func, don't do it
        units = groups.noone,
        label = "Wild Charge",
        --["andDelegates"] = {Delegates.HasSpellToInterrupt_LatestPossibleInterrupt, Delegates.InterruptWrapper, Delegates.IsSpellInRange},
        --isCC = true,
        helpharm = "help",
        --maxRange = 10,
        IsUsable = function(self) return talent.wild_charge.enabled and
                (GetShapeshiftForm() == 0 and IsSpellInRange(self.spell,"target") == 1
                        or buff.moonkin_form:Stacks() > 0
                        or (buff.cat_form:Stacks() > 0 or buff.bear_form:Stacks() > 0) and IsSpellInRange(self.spell, "target") == 1)
        end
    })

    AddSpellFunction(nil, "Typhoon",0,{
        func = function(self)  end,       -- dummy func, don't do it
        units = groups.noone,
        label = "Typhoon",
        --["andDelegates"] = {Delegates.HasSpellToInterrupt_LatestPossibleInterrupt, Delegates.InterruptWrapper, Delegates.IsSpellInRange},
        --isCC = true,
        helpharm = "harm",
        maxRange = 10,
        IsUsable = function(self) return GetSpecialization() == 1 or talent.balance_afinity.enabled end
    })

    AddSpellFunction(nil, "Bear Form",0,{
        func = function(self)  end,       -- dummy func, don't do it
        units = groups.noone,
        label = "Typhoon",
        --["andDelegates"] = {Delegates.HasSpellToInterrupt_LatestPossibleInterrupt, Delegates.InterruptWrapper, Delegates.IsSpellInRange},
        --isCC = true,
        --helpharm = "harm",
        --maxRange = 10,
        --IsUsable = function(self) return talent.typhoon.enabled end
    })

    AddSpellFunction(nil, "Cat Form",0,{
        func = function(self)  end,       -- dummy func, don't do it
        units = groups.noone,
        label = "Typhoon",
        --["andDelegates"] = {Delegates.HasSpellToInterrupt_LatestPossibleInterrupt, Delegates.InterruptWrapper, Delegates.IsSpellInRange},
        --isCC = true,
        --helpharm = "harm",
        --maxRange = 10,
        --IsUsable = function(self) return talent.typhoon.enabled end
    })

    AddSpellFunction(nil, "Travel Form",0,{
        func = function(self)  end,       -- dummy func, don't do it
        units = groups.noone,
        label = "Travel Form",
        --["andDelegates"] = {Delegates.HasSpellToInterrupt_LatestPossibleInterrupt, Delegates.InterruptWrapper, Delegates.IsSpellInRange},
        --isCC = true,
        --helpharm = "harm",
        --maxRange = 10,
        IsUsable = function(self)
            if IsOutdoors() then
                local form = GetShapeshiftForm()
                if not form then
                    return true
                elseif form == 3 then
                    return
                elseif form >= 4 and GetShapeshiftFormInfo(form) == 210053 then
                    return
                end
                return true
            end
        end
    })

    AddSpellFunction(nil, "Mount Form",0,{
        func = function(self)  end,       -- dummy func, don't do it
        units = groups.noone,
        label = "Mount Form",
        --["andDelegates"] = {Delegates.HasSpellToInterrupt_LatestPossibleInterrupt, Delegates.InterruptWrapper, Delegates.IsSpellInRange},
        --isCC = true,
        --helpharm = "harm",
        --maxRange = 10,
        IsUsable = function(self)
            if IsOutdoors() then
                local form = GetShapeshiftForm()
                if not form then
                    return true
                elseif form == 3 then
                    return
                elseif form >= 4 and GetShapeshiftFormInfo(form) == 210053 then
                    return
                end
                return true
            end
        end
    })

    --[[AddSpellFunction(nil,"Soothe",19980,{
        func = function(self) return (not player.channel) end,
        units = groups.targetable,
        label = "Druid Purge",
        ["andDelegates"] = {Delegates.PurgeWrapper, Delegates.HasEnrageEffect},
        --scorer = Delegates.PurgePriorityWrapper,
        helpharm = "harm",
        maxRange = 40,
        isCC = true,
        IsUsable = function(self)
            if player:Mana_Percent() > 0.2 and WarGodControl:AutoPurge() then
                local formIndex = GetShapeshiftForm()
                local specIndex = GetSpecialization()

                if formIndex == 0 then
                    return true
                elseif formIndex == 1 then
                    if specIndex == 3 then
                        return true
                    end
                elseif formIndex == 2 then
                    if specIndex == 2 then
                        return true
                    end
                else
                    return true
                end
            end
        end,
    })]]

    AddSpellFunction(nil,"Mark of the Wild",5,{
        func = function(self)
            --return true
            for guid,unit in upairs(groups.targetable) do
                if UnitIsPlayer(unit.unitid) and unit:BuffRemaining("Mark of the Wild","HELPFUL") < 60 and Delegates:IsSpellInRange("Mark of the Wild", unit, {}) then
                    return true
                end
            end
        end,
        units = groups.player,
        label = "MotW",
        IsUsable = function(self)
            return player.prev_gcd ~= "Mark of the Wild" and player.mana >= 10000--(player.combat) and player:BuffRemaining("Mark of the Wild", "HELPFUL") < 60 or (not player.combat) and player:BuffRemaining("Mark of the Wild", "HELPFUL") < 1200
        end,
    })

    AddSpellFunction(nil, "Incapacitating Roar",0,{
        func = function(self)  end,       -- dummy func, don't do it
        units = groups.noone,
        label = "Disorient",
        --["andDelegates"] = {Delegates.HasSpellToInterrupt_LatestPossibleInterrupt, Delegates.InterruptWrapper, Delegates.IsSpellInRange},
        --isCC = true,
        helpharm = "help",
        maxRange = 15,
        IsUsable = function(self) return player.spec == "Guardian" or talent.guardian_affinity.enabled end
    })

    AddSpellFunction(nil, "Ursol's Vortex",0,{
        func = function(self)  end,       -- dummy func, don't do it
        units = groups.cursor,
        label = "Vortex",
        --["andDelegates"] = {Delegates.HasSpellToInterrupt_LatestPossibleInterrupt, Delegates.InterruptWrapper, Delegates.IsSpellInRange},
        --isCC = true,
        helpharm = "harm",
        maxRange = 30,
        IsUsable = function(self) return talent.restoration_affinity.enabled or GetSpecialization() == 4 end
    })

    AddSpellFunction(nil, "Mighty Bash",0,{
        func = function(self)  end,       -- dummy func, don't do it
        units = groups.target,
        label = "Bash",
        --["andDelegates"] = {Delegates.HasSpellToInterrupt_LatestPossibleInterrupt, Delegates.InterruptWrapper, Delegates.IsSpellInRange},
        --isCC = true,
        helpharm = "harm",
        maxRange = 30,
        IsUsable = function(self) return talent.mighty_bash.enabled end
    })

    AddSpellFunction(nil, "Mass Entanglement",0,{
        func = function(self)  end,       -- dummy func, don't do it
        units = groups.target,
        label = "Mass Entanglement",
        --["andDelegates"] = {Delegates.HasSpellToInterrupt_LatestPossibleInterrupt, Delegates.InterruptWrapper, Delegates.IsSpellInRange},
        --isCC = true,
        helpharm = "harm",
        maxRange = 30,
        IsUsable = function(self) return talent.mass_entanglement.enabled end
    })

end
