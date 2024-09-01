if UnitClass("player") ~= "Druid" then return end

setfenv(1, WarGod.Binder)

QueueSpellBind("Potion of Spectral Intellect", groups.noone, {prefix = "/use"})

QueueSpellBind("Celestial Alignment", groups.cursor, {suffix = "\n/cqs", prefix = "/cancelaura Starlord\n/stopmacro [channeling:Convoke the Spirits]\n/cast [talent:5/3] Ravenous Frenzy\n/cast Kindred Spirits\n/cast ", when = {[MatchesSpec]=1}})
QueueSpellBind("Incarnation: Chosen of Elune", groups.cursor, {suffix = "\n/cqs", prefix = "/cancelaura Starlord\n/stopmacro [channeling:Convoke the Spirits]\n/cast [talent:5/3] Ravenous Frenzy\n/cast Kindred Spirits\n/cast ", when = {[MatchesSpec]=1}})
--QueueSpellBind("Celestial Alignment", groups.noone, {suffix = "\n/cqs\n/use 14", prefix = "/cancelaura Starlord\n/stopmacro [channeling:Convoke the Spirits]\n/cast Berserking\n/cast ", when = {[MatchesSpec]=1}})
--QueueSpellBind("Celestial Alignment", groups.noone, {prefix = "/cast Berserking\n/use 13\n/use 14\n/cast ", when = {[MatchesSpec]=1}})

QueueSpellBind("Moonkin Form", groups.noone, {stopmacro = "channeling:Convoke the Spirits", prefix = "/cast [nostance:4] ", when = {[MatchesSpec]=1}})


QueueSpellBind("Moonfire", groups.importantEnemies, {stopmacro = "channeling:Convoke the Spirits", when = {[MatchesSpec]={1,2,3,4}}})
--if (not rModAllowed) then QueueSpellBind("Moonfire", groups.allEnemies, {when = {[MatchesSpec]={1,2,3}}}) end

QueueSpellBind("Sunfire", groups.importantEnemies, {stopmacro = "channeling:Convoke the Spirits", when = {[MatchesSpec]={1}}})
QueueSpellBind("Sunfire", groups.allEnemies, {stopmacro = "channeling:Convoke the Spirits", when = {[MatchesSpec]={1}}})



QueueSpellBind("Wrath", groups.importantEnemies, {stopmacro = "channeling:Convoke the Spirits", when = {[MatchesSpec]={1,4}}})

--QueueSpellBind("Wrath", groups.allEnemies, {when = {[MatchesSpec]={1}}})

--QueueSpellBind("Starfire", groups.allEnemies, {when = {[MatchesSpec]={1}}})
QueueSpellBind("Starfire", groups.importantEnemies, {stopmacro = "channeling:Convoke the Spirits", when = {[MatchesSpec]={1}}})


QueueSpellBind("Starsurge", groups.importantEnemies, {stopmacro = "channeling:Convoke the Spirits", when = {[MatchesSpec]={1}}})
--QueueSpellBind("Starsurge", groups.allEnemies, {when = {[MatchesSpec]={1}}})


QueueSpellBind("Starfall", groups.noone, {stopmacro = "channeling:Convoke the Spirits", prefix = "/cast [nochanneling:Convoke the Spirits] ", when = {[MatchesSpec]={1}}})

QueueSpellBind("New Moon", groups.allEnemies, {stopmacro = "channeling:Convoke the Spirits", when = {[MatchesSpec]={1}, [HaveTalent]="New Moon"}})
QueueSpellBind("Stellar Flare", groups.allEnemies, {stopmacro = "channeling:Convoke the Spirits", when = {[MatchesSpec]={1}, [HaveTalent]="Stellar Flare"}})

--QueueSpellBind("Regrowth", groups.importantFriends, {when = {[MatchesSpec]={4}}})

QueueSpellBind("Force of Nature", groups.cursor, {stopmacro = "channeling:Convoke the Spirits", prefix = "/cast [@cursor, channeling:Convoke the Spirits] ", when = {[MatchesSpec]={1}, [HaveTalent]="Force of Nature"}})

QueueSpellBind("Warrior of Elune", groups.noone, {stopmacro = "channeling:Convoke the Spirits", prefix = "/cast [nochanneling:Convoke the Spirits] ", when = {[MatchesSpec]={1}, [HaveTalent]="Warrior of Elune"}})

QueueSpellBind("Fury of Elune", groups.allEnemies, {stopmacro = "channeling:Convoke the Spirits", when = {[MatchesSpec]={1}, [HaveTalent]="Fury of Elune"}})

QueueSpellBind("Solar Beam", groups.importantEnemies, {stopmacro = "channeling:Convoke the Spirits", when = {[MatchesSpec]={1}}})


QueueSpellBind("Innervate", groups.importantFriends, {suffix = "\n/console autounshift 1\n", stopmacro = "channeling:Convoke the Spirits", when = {[MatchesSpec]={1}}})
