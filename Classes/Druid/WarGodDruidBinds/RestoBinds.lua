if UnitClass("player") ~= "Druid" then return end

setfenv(1, WarGod.Binder)

QueueSpellBind("Lifebloom", groups.importantFriends, {when = {[MatchesSpec]={4}}})
QueueSpellBind("Tranquility", groups.importantFriends, {when = {[MatchesSpec]={4}}})

--QueueSpellBind("Innervate", groups.allFriends, {prefix = "/console autounshift 1\n", when = {[MatchesSpec]={4}}})
QueueSpellBind("Wild Growth", groups.importantFriends, {when = {[MatchesSpec]={4}}})

QueueSpellBind("Nature's Cure", groups.importantFriends, {when = {[MatchesSpec]={4}}})

QueueSpellBind("Rejuvenation", groups.importantFriends, {when = {[MatchesSpec]={4}}})
QueueSpellBind("Wild Growth", groups.importantFriends, {when = {[MatchesSpec]={4}}})
QueueSpellBind("Efflorescence", groups.cursor, {when = {[MatchesSpec]={4}}})
QueueSpellBind("Tranquility", groups.noone, {when = {[MatchesSpec]={4}}})