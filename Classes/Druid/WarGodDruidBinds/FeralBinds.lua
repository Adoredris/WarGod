if UnitClass("player") ~= "Druid" then return end

setfenv(1, WarGod.Binder)

QueueSpellBind("Fleeting Elemental Potion of Power", groups.noone, {stopmacro = "channeling", prefix = "/use Fleeting Elemental Potion of Ultimate Power\n/use", suffix = "\n/use Elemental Potion of Ultimate Power\n/use Elemental Potion of Power"})
QueueSpellBind("Fleeting Elemental Potion of Ultimate Power", groups.noone, {stopmacro = "channeling", prefix = "/use", suffix = "\n/use Elemental Potion of Ultimate Power\n/use Elemental Potion of Power"})
QueueSpellBind("Elemental Potion of Power", groups.noone, {stopmacro = "channeling", prefix = "/use Fleeting Elemental Potion of Ultimate Power\n/use", suffix = "\n/use Elemental Potion of Ultimate Power\n/use Elemental Potion of Power"})
QueueSpellBind("Elemental Potion of Ultimate Power", groups.noone, {stopmacro = "channeling", prefix = "/use", suffix = "\n/use Elemental Potion of Ultimate Power\n/use Elemental Potion of Power"})

QueueSpellBind("Primal Wrath", groups.noone, {stopmacro = "channeling", when = {[MatchesSpec]={2},[HaveTalent]="Primal Wrath"}})
QueueSpellBind("Maim", groups.allEnemies, {stopmacro = "channeling", prefix = "/startattack\n/cast ", when =      {[MatchesSpec]={2}}})
QueueSpellBind("Mangle", groups.allEnemies, {stopmacro = "channeling", prefix = "/startattack\n/cast ", when =      {[MatchesSpec]={2, 3}}})
QueueSpellBind("Rake", groups.allEnemies, {stopmacro = "channeling", prefix = "/startattack\n/cast ", when =      {[MatchesSpec]={2}}})
QueueSpellBind("Rip", groups.allEnemies, {stopmacro = "channeling", prefix = "/startattack\n/cast ", when =      {[MatchesSpec]={2}}})
QueueSpellBind("Shred", groups.allEnemies, {stopmacro = "channeling", prefix = "/startattack\n/cast ", when =      {[MatchesSpec]={2}}})
QueueSpellBind("Ferocious Bite", groups.allEnemies, {stopmacro = "channeling", prefix = "/startattack\n/cast ", when =      {[MatchesSpec]={2}}})
QueueSpellBind("Feral Frenzy", groups.allEnemies, {stopmacro = "channeling", prefix = "/startattack\n/cast ", when =      {[MatchesSpec]={2}}})

QueueSpellBind("Berserk", groups.noone, {stopmacro = "channeling", prefix = "/cast ", when =      {[MatchesSpec]={2}}})
--QueueSpellBind("Thrash", groups.noone, { when =      {[MatchesSpec]={2}}})
--QueueSpellBind("Swipe", groups.noone, { when =      {[MatchesSpec]={2}}})
QueueSpellBind("Tiger's Fury", groups.noone, {stopmacro = "channeling", prefix = "/cast ", when =      {[MatchesSpec]={2}}})

print('FeralBinds.lua')