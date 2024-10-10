if UnitClass("player") ~= "Hunter" then C_AddOns.DisableAddOn("WarGodHunterBinds"); return end

-- only stuff that lots of specs have for lots of

setfenv(1, WarGod.Binder)

QueueSpellBind("Ravenous Frenzy", groups.noone, {prefix = "/cast ", when = {[HaveSpell] = "Ravenous Frenzy"}})
QueueSpellBind("Kindred Spirits", groups.noone, {--[[]prefix = "/cast Berserking\n/use 13\n/use 14\n/cast ", ]]when = {[HaveSpell] = "Kindred Spirits"}})
QueueSpellBind("Convoke the Spirits", groups.noone, {prefix = "/cqs\n/cast ", when = {[HaveSpell] = "Convoke the Spirits"}})

QueueSpellBind("Bear Form", groups.noone, {prefix = "/cancelaura Atomically Recalibrated\n/cast [nostance:1]"})
QueueSpellBind("Cat Form", groups.noone, {prefix = "/cancelaura Atomically Recalibrated\n/cast [nochanneling:Convoke the Spirits,nostance:2]"})
QueueSpellBind("Travel Form", groups.noone, {prefix = "/cancelaura Atomically Recalibrated\n/cast [noform][form:1/2/3] "})
QueueSpellBind("Mount Form", groups.noone, {prefix = "/cancelaura Atomically Recalibrated\n/cast [noform][form:1/2/3] "})

QueueSpellBind("Prowl", groups.noone, {prefix = "/cancelaura Atomically Recalibrated\n/cast [nostealth] "})

QueueSpellBind("Barkskin", groups.noone, {prefix = "/cast [nochanneling:Convoke the Spirits] "})
QueueSpellBind("Stampeding Roar", groups.noone, {prefix = "/cast [nochanneling:Convoke the Spirits] ", when =      {[MatchesSpec]={2, 3}}})
QueueSpellBind("Survival Instincts", groups.noone, {when = {[MatchesSpec]={2, 3}}})

QueueSpellBind("Renewal", groups.noone, {prefix = "/cast [nochanneling:Convoke the Spirits] ", when = {[HaveTalent] = "Renewal"}})

QueueSpellBind("Ursol's Vortex", groups.cursor, {stopmacro = "channeling:Convoke the Spirits", when = {[MatchesSpec]={3, 4}}})

QueueSpellBind("Soothe", groups.allEnemies, {stopmacro = "channeling:Convoke the Spirits"})

QueueSpellBind("Wild Charge", groups.noone, {when = {[HaveTalent]="Wild Charge"}})

QueueSpellBind("Nature's Vigil", groups.noone, {when = {[HaveTalent]="Nature's Vigil"}})


QueueSpellBind("Typhoon", groups.noone, {prefix = "/cast [nochanneling:Convoke the Spirits] "})
QueueSpellBind("Mighty Bash", groups.importantEnemies, {stopmacro = "channeling:Convoke the Spirits", when = {[HaveTalent]="Mighty Bash"}})
QueueSpellBind("Mass Entanglement", groups.importantEnemies, {stopmacro = "channeling:Convoke the Spirits", when = {[HaveTalent]="Mass Entanglement"}})

QueueSpellBind("Dash", groups.noone, {prefix = "/castsequence"--[[, prefix = "/cast [nochanneling:Convoke the Spirits] "]]})

QueueSpellBind("Regrowth", groups.importantFriends, {prefix = "/console autounshift 0\n/cast ", stopmacro = "channeling:Convoke the Spirits"})

QueueSpellBind("Shred", groups.importantEnemies--[[, {when = {[MatchesSpec]={1,3,4}, [HaveTalent]="Feral Affinity"}}]])

QueueSpellBind("Skull Bash", groups.allEnemies, {stopmacro = "channeling:Convoke the Spirits", when =      {[MatchesSpec]={2, 3}}})

QueueSpellBind("Adaptive Swarm", groups.importantEnemies--[[, {when = {[MatchesSpec]={1,3,4}, [HaveTalent]="Feral Affinity"}}]])

------------ noone things are a bit funny with the 'when' stuff
QueueSpellBind("Thrash", groups.noone, {stopmacro = "channeling:Convoke the Spirits", prefix = "/cancelaura Atomically Recalibrated\n/castsequence [stance:1/2] ", --[[when = {[MatchesSpec]={1,2,4}, [HaveTalent]="Guardian Affinity"}]]})
--QueueSpellBind("Ironfur", groups.noone, {prefix = "/castsequence reset=1 " , suffix = ", Donothing", when = {[MatchesSpec]={1,2,4}, [HaveTalent]="Guardian Affinity"}})
QueueSpellBind("Ironfur", groups.noone, {prefix = "/cancelaura Atomically Recalibrated\n/cast "})
QueueSpellBind("Swipe", groups.noone,                 {prefix = "/cancelaura Atomically Recalibrated\n/cast ",--[[stopmacro = "channeling:Convoke the Spirits", ]]when = {[NotHaveTalent]="Brutal Slash"}})
QueueSpellBind("Brutal Slash", groups.noone,                 {prefix = "/cancelaura Atomically Recalibrated\n/cast ", --[[stopmacro = "channeling:Convoke the Spirits",]] when = {[HaveTalent]="Brutal Slash"}})
QueueSpellBind("Frenzied Regeneration", groups.noone, { stopmacro = "channeling:Convoke the Spirits", when =      {[MatchesSpec]={2}}})

QueueSpellBind("Remove Corruption", groups.importantFriends, {stopmacro = "channeling:Convoke the Spirits", when = {[MatchesSpec]={1,2,3}}})

QueueSpellBind("Mark of the Wild", groups.player)