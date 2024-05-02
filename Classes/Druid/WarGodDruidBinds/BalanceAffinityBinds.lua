if UnitClass("player") ~= "Druid" then return end

setfenv(1, WarGod.Binder)

QueueSpellBind("Moonkin Form", groups.noone, {stopmacro = "channeling:Convoke the Spirits", prefix = "/console autoUnshift 1\n/cast [nostance:4] ", when = {[MatchesSpec]={2,3,4}, [HaveTalent]="Balance Affinity"}})
QueueSpellBind("Sunfire", groups.importantEnemies, {stopmacro = "channeling:Convoke the Spirits", when = {[MatchesSpec]={2,3,4}, [HaveTalent]="Balance Affinity"}})
QueueSpellBind("Wrath", groups.importantEnemies, {stopmacro = "channeling:Convoke the Spirits", when = {[MatchesSpec]={2,3,4}, [HaveTalent]="Balance Affinity"}})
QueueSpellBind("Starfire", groups.importantEnemies, {stopmacro = "channeling:Convoke the Spirits", when = {[MatchesSpec]={2,3,4}, [HaveTalent]="Balance Affinity"}})
QueueSpellBind("Starsurge", groups.importantEnemies, {stopmacro = "channeling:Convoke the Spirits", when = {[MatchesSpec]={2,3,4}, [HaveTalent]="Balance Affinity"}})