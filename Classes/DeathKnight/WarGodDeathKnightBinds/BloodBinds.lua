if UnitClass("player") ~= "Death Knight" then return end

setfenv(1, WarGod.Binder)

QueueSpellBind("Death's Caress", groups.importantEnemies, {prefix = "/startattack\n/petattack\n/cast Claw\n/cast ", when = {[MatchesSpec]={1}}})
QueueSpellBind("Blood Boil", groups.noone, {when = {[MatchesSpec]={1}}})
QueueSpellBind("Tombstone", groups.noone, {when = {[MatchesSpec]={1}}})
QueueSpellBind("Heart Strike", groups.importantEnemies, {prefix = "/startattack\n/petattack\n/cast Claw\n/cast ", when = {[MatchesSpec]={1}}})
QueueSpellBind("Marrowrend", groups.importantEnemies, {prefix = "/startattack\n/petattack\n/cast Claw\n/cast ", when = {[MatchesSpec]={1}}})

QueueSpellBind("Dancing Rune Weapon", groups.importantEnemies, {prefix = "/startattack\n/petattack\n/cast Claw\n/cast ", when = {[MatchesSpec]={1}}})
QueueSpellBind("Blood Tap", groups.noone, {when = {[MatchesSpec]={1}}})
QueueSpellBind("Empower Rune Weapon", groups.noone, {when = {[MatchesSpec]={1}}})