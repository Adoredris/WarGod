if UnitClass("player") ~= "Druid" then return end

setfenv(1, WarGod.Binder)

QueueSpellBind("Incapacitating Roar", groups.noone, {when = {[MatchesSpec]={3}}})

QueueSpellBind("Maul", groups.allEnemies, {when = {[MatchesSpec]={3}}})
QueueSpellBind("Raze", groups.noone, {when = {[MatchesSpec]={3}}})

QueueSpellBind("Bristling Fur", groups.noone, {prefix = "/cast [nostance:1] Bear Form\n/cast [stance:1] ", when = {[MatchesSpec]={3}, [HaveTalent]="Bristling Fur"}})