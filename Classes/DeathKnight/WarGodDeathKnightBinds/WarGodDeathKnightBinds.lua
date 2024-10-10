if UnitClass("player") ~= "Death Knight" then C_AddOns.DisableAddOn("WarGodDeathKnightBinds"); return end

-- only stuff that lots of specs have for lots of

setfenv(1, WarGod.Binder)

QueueSpellBind("Raise Dead", groups.noone)
QueueSpellBind("Army of the Dead", groups.noone)
QueueSpellBind("Mind Freeze", groups.allEnemies)
QueueSpellBind("Death and Decay", groups.cursor, {when = {[MatchesSpec]={1,3}}})
QueueSpellBind("Icebound Fortitude", groups.noone)
QueueSpellBind("Anti-Magic Shell", groups.noone)
QueueSpellBind("Death Grip", groups.importantEnemies)
QueueSpellBind("Death Strike", groups.importantEnemies,{prefix = "/startattack\n/petattack\n/cast Claw\n/cast ", })
QueueSpellBind("Soul Reaper", groups.importantEnemies, {when = {[HaveTalent]="Soul Reaper"}})