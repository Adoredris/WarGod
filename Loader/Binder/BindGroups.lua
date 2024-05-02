local Binder = WarGod.Binder
setfenv(1, WarGod.Binder)

groups = {}
groups.noone = {"nounit"}
groups.player = {"player"}
groups.focus = {"focus"}
groups.cursor = {"player", "cursor"}
groups.importantEnemies = {
    "target","focus","mouseover", "boss1","boss2","boss3","boss4","boss5","party1target","party2target","party3target","party4target",
    "raid1target","raid2target","raid3target","raid4target","raid5target","raid6target","raid7target","raid8target","raid9target","raid10target",
    "raid11target","raid12target","raid13target","raid14target","raid15target","raid16target","raid17target","raid18target","raid19target","raid20target",
    "raid21target","raid22target","raid23target","raid24target","raid25target","raid26target","raid27target","raid28target","raid29target","raid30target",
}
groups.allEnemies = groups.importantEnemies
groups.importantFriends = {"target","focus","mouseover","player","party1","party2","party3","party4", "party1target","party2target","party3target","party4target",}
groups.allFriends = {"target","focus","mouseover","player",
                    "party1","party2","party3","party4",
                     "raid1","raid2","raid3","raid4","raid5",
                     "raid6","raid7","raid8","raid9","raid10",
                     "raid11","raid12","raid13","raid14","raid15",
                     "raid16","raid17","raid18","raid19","raid20",
                     "raid21","raid22","raid23","raid24","raid25",}

groups.allTheUnits = {
    "party1","party2","party3","party4",--"party5",
    "raid1","raid2","raid3","raid4","raid5","raid6","raid7","raid8","raid9","raid10",
    "raid11","raid12","raid13","raid14","raid15","raid16","raid17","raid18","raid19","raid20",
    "raid21","raid22","raid23","raid24","raid25","raid26","raid27","raid28","raid29","raid30",
    "raid1target","raid2target","raid3target","raid4target","raid5target","raid6target","raid7target","raid8target","raid9target","raid10target",
    "raid11target","raid12target","raid13target","raid14target","raid15target","raid16target","raid17target","raid18target","raid19target","raid20target",
    "raid21target","raid22target","raid23target","raid24target","raid25target","raid26target","raid27target","raid28target","raid29target","raid30target",
}

groups.party = {
    "player","party1", "party2", "party3", "party4",
}