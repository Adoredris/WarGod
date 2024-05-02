local Rotations = WarGod.Rotation

local Class = WarGod.Class
local groups = WarGod.Unit.groups
local player = WarGod.Unit:GetPlayer()
local talent = player.trait
local buff = player.buff
local azerite = player.azerite



---------TEMP-------------
local WGBM = WarGod.BossMods
local WarGodUnit = WarGod.Unit
local WarGodControl = WarGod.Control
--------------------------

setfenv(1, Rotations)

local buff = player.buff
local talent = player.trait




--[[function LegUnits:UnitHealthPredictedPercent(unitid)
    return math.min( ((UnitHealth(unitid) or 0) + (UnitGetIncomingHeals(unitid) or 0)) / (UnitHealthMax(unitid) or 1), 1)
end]]



do


    --[[AddSpellFunction("Restoration","Efflorescence",8050, {
        func = function(self) return
            player.combat and not GetTotemInfo(1)
        end,
        ["units"] = groups.player,
        label = "Mushroom RESTO",
        ["andDelegates"] = {LegDelegates.EnoughEfflorescenceTargets},
        ["args"] = {percent = 0.99, targets = 2, andDelegates = {LegDelegates.UnitNotMoving, LegDelegates.UnitUnderXPercentHealth, LegDelegates.NotMovingSoon}, move = 10},
    })

    AddSpellFunction("Restoration","Efflorescence",8000, {
        func = function(self) return
            player.combat and
            not GetTotemInfo(1)

        end,
        ["units"] = groups.player,
        label = "Mushroom RESTO",
        ["andDelegates"] = {LegDelegates.EnoughEfflorescenceTargets},
        ["args"] = {percent = 0.95, targets = 4, andDelegates = {LegDelegates.UnitNotMoving, LegDelegates.NotMovingSoon}, move = 10},
    })]]

    AddSpellFunction("Restoration","Wild Growth",3900, {
        func = function(self) return player.mode == "raid" and not LegCore:HighSustain() end,
        ["units"] = groups.player,
        label = "Wild Growth RESTO",
        ["andDelegates"] = {LegDelegates.EnoughWildGrowthTargets},
        ["args"] = {andDelegates = {LegDelegates.UnitUnderXPercentHealth}, targets = 4, percent = 0.9},
    })

    AddSpellFunction("Restoration","Lifebloom",3600, {
        func = function(self) return player.mode == "raid" and not IsLifebloomActive() end,
        ["units"] = groups.targetable,
        label = "Lifebloom RESTO",
        --["andDelegates"] = {LegDelegates.UnitUnderXPercentHealth},
        --["args"] = {percent = 0.7},
        ["scorer"] = LifebloomScorer,
    })

    AddSpellFunction("Restoration","Regrowth",3500, {
        func = function(self) return player.mode == "raid"
                and ((buff.clearcasting:Stacks() > 1 or buff.clearcasting:Remains() > CastTimeFor("Regrowth") and player.casting ~= "Regrowth")
                or LegUnits:BuffRemaining("Innervate", "player", nil, true) > CastTimeFor("Regrowth"))
        end,
        ["units"] = groups.targetable,
        label = "Regrowth RESTO",
        ["andDelegates"] = {LegDelegates.UnitUnderXPercentHealth},
        ["args"] = {percent = 0.8},
    })

    AddSpellFunction("Restoration","Rejuvenation",3490, {
        func = function(self) return player.mode == "raid" and not LegCore:HighSustain() end,
        ["units"] = groups.targetable,
        label = "Rejuv RESTO",
        ["andDelegates"] = {LegDelegates.PrehealWrapper, LegUnits.HoT_Missing},
        --["scorer"] = ScoreByInvertedBuffTimeRemaining,
    })

    AddSpellFunction("Restoration","Rejuvenation",3460, {
        func = function(self) return player.mode == "raid" and not LegCore:HighSustain() end,
        ["units"] = groups.targetable,
        label = "Rejuv Germ RESTO",
        ["andDelegates"] = {LegDelegates.PrehealWrapper, LegUnits.HoT_Missing, LegDelegates.UnitUnderXPercentHealth},
        --["scorer"] = ScoreByInvertedBuffTimeRemaining,
        ["args"] = {aura = "Rejuvenation (Germination)", percent = 0.8}
    })

    AddSpellFunction("Restoration","Rejuvenation",3030, {
        func = function(self) return player.mode == "raid" and not LegCore:HighSustain() end,
        ["units"] = groups.targetable,
        label = "Rejuv RESTO",
        ["andDelegates"] = {LegUnits.HoT_Pandemic, LegDelegates.UnitUnderXPercentHealth},
        ["scorer"] = ScoreByInvertedBuffTimeRemaining,
        ["args"] = {percent = 0.7},
    })

    AddSpellFunction("Restoration","Rejuvenation",3000, {
        func = function(self) return player.mode == "raid" and not LegCore:HighSustain() end,
        ["units"] = groups.targetable,
        label = "Rejuv Germ RESTO",
        ["andDelegates"] = {LegUnits.HoT_Pandemic, LegDelegates.UnitUnderXPercentHealth},
        ["scorer"] = ScoreByInvertedBuffTimeRemaining,
        ["args"] = {aura = "Rejuvenation (Germination)", percent = 0.5}
    })
end
