setfenv(1, WarGod.Binder)
-- bind focus everyone

QueueSpellBind("focus", groups.allTheUnits, {prefix = "/"})
QueueSpellBind("target", groups.party, {prefix = "/"})

QueueSpellBind("follow", groups.party, {prefix = "/follow ", suffix = '\n/run WarGod.command = nil; WarGod.commandSource = ""'})

--QueueSpellBind("focus", groups.allFriends)
--[[if UnitClass("player") == "Druid" then
    QueueSpellBind(13, groups.noone, {prefix = "/cleartarget\n/use ", suffix = "\n/targetlasttarget"})
    QueueSpellBind(14, groups.noone, {prefix = "/cleartarget\n/use ", suffix = "\n/targetlasttarget"})
else]]
    QueueSpellBind(13, groups.noone, {prefix = "/use "--[[, suffix = "\n/targetlasttarget"]]})
    QueueSpellBind(14, groups.noone, {prefix = "/use "--[[, suffix = "\n/targetlasttarget"]]})
--end
--QueueSpellBind("Eternal Augment Rune", groups.noone, {prefix = "/use"})

QueueSpellBind("OverrideActionBarButton1", groups.noone, {prefix = "/click"})
QueueSpellBind("OverrideActionBarButton2", groups.noone, {prefix = "/click"})
QueueSpellBind("OverrideActionBarButton3", groups.noone, {prefix = "/click"})
QueueSpellBind("OverrideActionBarButton4", groups.noone, {prefix = "/click"})
QueueSpellBind("OverrideActionBarButton5", groups.noone, {prefix = "/click"})
QueueSpellBind("OverrideActionBarButton6", groups.noone, {prefix = "/click"})
QueueSpellBind("ExtraActionButton1", groups.noone, {prefix = "/click"})

--QueueSpellBind(13, groups.noone, {prefix = "/use", suffix = "/targetlasttarget"})
--QueueSpellBind(14, groups.noone, {prefix = "/use", suffix = "/targetlasttarget"})