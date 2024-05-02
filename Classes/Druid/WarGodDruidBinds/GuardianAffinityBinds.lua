if UnitClass("player") ~= "Druid" then return end

setfenv(1, WarGod.Binder)

QueueSpellBind("Frenzied Regeneration", groups.noone, {prefix = "/cast [nostance:1] Bear Form\n/cast [stance:1] ", when = {[MatchesSpec]={1,2,4}, [HaveTalent]="Guardian Affinity"}})

--QueueSpellBind("Thrash", groups.noone, {prefix = "/cast [nostance:1] Bear Form\n/cast [stance:1] ", when = {[MatchesSpec]={1,2,4}, [HaveTalent]="Guardian Affinity"}})
--QueueSpellBind("Ironfur", groups.noone, {prefix = "/cast [nostance:1] Bear Form\n/cast [stance:1] ", when = {[MatchesSpec]={1,2,4}, [HaveTalent]="Guardian Affinity"}})