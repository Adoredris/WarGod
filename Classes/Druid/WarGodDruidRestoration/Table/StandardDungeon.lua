local Rotations = WarGod.Rotation

local Class = WarGod.Class
local groups = WarGod.Unit.groups
local player = WarGod.Unit:GetPlayer()
local talent = player.trait
local buff = player.buff
local azerite = player.azerite


local UnitThreatSituation = UnitThreatSituation
local UnitGroupRolesAssigned = UnitGroupRolesAssigned


---------TEMP-------------
local WGBM = WarGod.BossMods
local WarGodUnit = WarGod.Unit
local WarGodControl = WarGod.Control
--------------------------

setfenv(1, Rotations)

do
    local function LifebloomScorer(self, spell, unit, args)
        local unitid = unit.unitid
        local threat = UnitThreatSituation(unitid)
        local roleScore = 0.8
        local role = UnitGroupRolesAssigned(unitid)
        roleScore = (role == "TANK" and 1 or unitid == "player" and 0.9 or role == "HEALER" and 0.6 or 0.8)
        --print(unit.name .. ": " .. roleScore)
        if (threat and threat >= 2) then
            return roleScore
        else
            return (0.51 - (unit.health_percent / 2)) * roleScore
        end
    end

    --[[AddSpellFunction("Restoration","Efflorescence",8050, {
        func = function(self) return
            player.combat and not GetTotemInfo(1)
        end,
        ["units"] = groups.player,
        label = "Mushroom RESTO",
        ["andDelegates"] = {Delegates.EnoughEfflorescenceTargets},
        ["args"] = {percent = 0.99, targets = 2, andDelegates = {Delegates.UnitNotMoving, Delegates.UnitUnderXPercentHealth, Delegates.NotMovingSoon}, move = 10},
    })

    AddSpellFunction("Restoration","Efflorescence",8000, {
        func = function(self) return
            player.combat and
            not GetTotemInfo(1)

        end,
        ["units"] = groups.player,
        label = "Mushroom RESTO",
        ["andDelegates"] = {Delegates.EnoughEfflorescenceTargets},
        ["args"] = {percent = 0.95, targets = 4, andDelegates = {Delegates.UnitNotMoving, Delegates.NotMovingSoon}, move = 10},
    })]]


    AddSpellFunction("Restoration","Wild Growth",5900, {
        func = function(self) return --[[player.mode == "dungeon" and ]]player:Mana_Percent() > 0.2 end,
        ["units"] = groups.targetable,
        label = "Wild Growth Damaged",
        ["andDelegates"] = {Delegates.UnitMustBeTopped},
        ["args"] = {andDelegates = {Delegates.UnitUnderXPercentHealth}, targets = 4, percent = 0.99},
        helpharm = "help",
        maxRange = 40,
    })

    AddSpellFunction("Restoration","Rejuvenation",5800, {
        func = function(self) return --[[player.mode == "dungeon" and ]]player:Mana_Percent() > 0.2 end,
        ["units"] = groups.targetable,
        label = "Rejuvenation Damaged",
        ["andDelegates"] = {Delegates.UnitMustBeTopped, Delegates.HoT_Missing, Delegates.UnitUnderXPercentHealthPredictedDamage},
        ["args"] = {andDelegates = {Delegates.UnitUnderXPercentHealth},percent = 0.99},
        helpharm = "help",
        maxRange = 40,
    })

    AddSpellFunction("Restoration","Rejuvenation",5700, {
        --func = function(self) return player.mode == "dungeon" end,
        ["units"] = groups.targetable,
        label = "Rejuv Germ RESTO",
        ["andDelegates"] = {Delegates.UnitMustBeTopped, Delegates.HoT_Missing, Delegates.UnitUnderXPercentHealthPredictedDamage},
        --["scorer"] = ScoreByInvertedBuffTimeRemaining,
        ["args"] = {aura = "Rejuvenation (Germination)", percent = 0.99}
    })


    AddSpellFunction("Restoration","Regrowth",5600, {
        --func = function(self) return player.mode == "dungeon" end,
        ["units"] = groups.targetable,
        label = "Regrowth RESTO",
        ["andDelegates"] = {Delegates.UnitMustBeTopped, Delegates.UnitUnderXPercentHealthPredicted},
        --["scorer"] = ScoreByInvertedBuffTimeRemaining,
        ["args"] = {percent = 0.7},
        helpharm = "help",
        maxRange = 40,
    })

    AddSpellFunction("Restoration","Swiftmend",5500, {
        --func = function(self) return player.mode == "dungeon" end,
        ["units"] = groups.targetable,
        label = "Regrowth RESTO",
        ["andDelegates"] = {Delegates.UnitMustBeTopped, Delegates.UnitUnderXPercentHealth},
        --["scorer"] = ScoreByInvertedBuffTimeRemaining,
        ["args"] = {percent = 0.8},
        helpharm = "help",
        maxRange = 40,
    })

    AddSpellFunction("Restoration","Wild Growth",2900, {
        func = function(self) return --[[player.mode == "dungeon" and ]]player:Mana_Percent() > 0.5 end,
        ["units"] = groups.targetable,
        label = "Wild Growth RESTO",
        andDelegates = {Delegates.EnoughWildGrowthTargets},
        ["args"] = {andDelegates = {Delegates.UnitUnderXPercentHealthPredictedDamage}, targets = 4, percent = 0.9},
        IsUsable = function(self) return true end,
        Castable = function(self) return ((not IsMoving()) or CastTimeFor(self.spell) == 0) and Delegates:EnoughTimeToCastWrapper(self.spell, player, {}) end,
    })

    AddSpellFunction("Restoration","Swiftmend",2800, {
        func = function(self) return --[[player.mode == "dungeon" and ]]player:Mana_Percent() > 0.05 and (IsMoving() or buff.clearcasting:Remains() < CastTimeFor("Regrowth")) end,
        ["units"] = groups.targetable,
        label = "Swiftmend RESTO",
        ["andDelegates"] = {Delegates.UnitUnderXPercentHealth},
        --["scorer"] = ScoreByInvertedBuffTimeReFmaining,
        ["args"] = {percent = 0.3}
    })

    AddSpellFunction("Restoration","Lifebloom",2600, {
        func = function(self) return --[[player.mode == "dungeon" and ]]not player:IsLifebloomActive() end,
        ["units"] = groups.targetable,
        label = "Lifebloom RESTO",
        --["andDelegates"] = {Delegates.UnitUnderXPercentHealth},
        --["args"] = {percent = 0.7},
        ["scorer"] = LifebloomScorer,
        helpharm = "help",
        maxRange = 40,
    })

    AddSpellFunction("Restoration","Regrowth",2550, {
        func = function(self) return --[[player.mode == "dungeon" and ]]player:Mana_Percent() > 0.3 end,
        ["units"] = groups.targetable,
        label = "Regrowth RESTO",
        ["andDelegates"] = {Delegates.UnitUnderXPercentHealthPredicted},
        ["args"] = {percent = 0.4},
        helpharm = "help",
        maxRange = 40,
    })

    AddSpellFunction("Restoration","Regrowth",2500, {
        func = function(self) return --[[player.mode == "dungeon"
                and]] ((buff.clearcasting:Stacks() > 1 or buff.clearcasting:Remains() > CastTimeFor("Regrowth") and player.casting ~= "Regrowth")
                or player:BuffRemaining("Innervate","HELPFUL") > CastTimeFor("Regrowth"))
        end,
        ["units"] = groups.targetable,
        label = "Regrowth RESTO",
        ["andDelegates"] = {Delegates.UnitUnderXPercentHealthPredicted},
        Castable = function(self) return ((not IsMoving()) or CastTimeFor(self.spell) == 0) and Delegates:EnoughTimeToCastWrapper(self.spell, player, {}) end,
        ["args"] = {percent = 0.8},
    })

    AddSpellFunction("Restoration","Rejuvenation",2450, {
        --func = function(self) return player.mode == "dungeon" end,
        ["units"] = groups.targetable,
        label = "Rejuv RESTO",
        ["andDelegates"] = {Delegates.PrehealWrapper, Delegates.HoT_Missing},
        ["args"] = {aura = "Rejuvenation", percent = 0.8}
    })

    AddSpellFunction("Restoration","Rejuvenation",2400, {
        --func = function(self) return player.mode == "dungeon" end,
        ["units"] = groups.targetable,
        label = "Rejuv Germ RESTO",
        ["andDelegates"] = {Delegates.PrehealWrapper, Delegates.HoT_Missing, Delegates.UnitUnderXPercentHealthPredictedDamage},
        --["scorer"] = ScoreByInvertedBuffTimeRemaining,
        ["args"] = {aura = "Rejuvenation (Germination)", percent = 0.8}
    })

    AddSpellFunction("Restoration","Rejuvenation",2050, {
        --func = function(self) return player.mode == "dungeon" end,
        ["units"] = groups.targetable,
        label = "Rejuv RESTO",
        ["andDelegates"] = {Delegates.HoT_Pandemic, Delegates.UnitUnderXPercentHealthPredictedDamage},
        ["scorer"] = ScoreByInvertedBuffTimeRemaining,
        ["args"] = {aura = "Rejuvenation", percent = 0.9},
    })

    AddSpellFunction("Restoration","Rejuvenation",2000, {
        --func = function(self) return player.mode == "dungeon" end,
        ["units"] = groups.targetable,
        label = "Rejuv Germ RESTO",
        ["andDelegates"] = {Delegates.HoT_Pandemic, Delegates.UnitUnderXPercentHealthPredictedDamage},
        ["scorer"] = ScoreByInvertedBuffTimeRemaining,
        ["args"] = {aura = "Rejuvenation (Germination)", percent = 0.7}
    })
end
