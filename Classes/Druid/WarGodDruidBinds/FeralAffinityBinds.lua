if UnitClass("player") ~= "Druid" then return end

setfenv(1, WarGod.Binder)

QueueSpellBind("Rake", groups.importantEnemies, {when = {[MatchesSpec]={1,3,4}, [HaveTalent]="Feral Affinity"}})
--QueueSpellBind("Swipe", groups.noone, {when = {[MatchesSpec]={1,3,4}, [HaveTalent]="Feral Affinity"}})
QueueSpellBind("Rip", groups.importantEnemies, {when = {[MatchesSpec]={1,3,4}, [HaveTalent]="Feral Affinity"}})
QueueSpellBind("Ferocious Bite", groups.importantEnemies, {when = {[MatchesSpec]={1,3,4}, [HaveTalent]="Feral Affinity"}})