if UnitClass("player") ~= "Druid" then return end

setfenv(1, WarGod.Binder)

--QueueSpellBind("Rejuvenation", groups.importantFriends, {when = {[MatchesSpec]={1,2,3}, [HaveTalent]="Restoration Affinity"}})
QueueSpellBind("Rejuvenation", groups.importantFriends, {when = {[MatchesSpec]={1,2,3}, [HaveTalent]="Restoration Affinity"}})

--QueueSpellBind("Swiftmend", groups.importantFriends, {prefix = "/cast ", when = {[MatchesSpec]={1,2,3}, [HaveTalent]="Restoration Affinity"}})
QueueSpellBind("Swiftmend", groups.importantFriends, {prefix = "/cast ", when = {[MatchesSpec]={1,2,3}, [HaveTalent]="Restoration Affinity"}})

QueueSpellBind("Wild Growth", groups.player, {prefix = "/cast "})