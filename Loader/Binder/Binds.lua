--local MyAddon = LibStub("AceAddon-3.0"):NewAddon("WarGod", "AceConsole-3.0", "AceEvent-3.0")

--local SetOverrideBindingClick = SetOverrideBindingClick

setfenv(1, WarGod.Binder)

local requestsTable = {}

local buttons = {}
spellUnitToBinds = {}

--[[local function IsReserved(bind)
    if reservedBinds[bind] then
        return true
    end
end]]

--/run LegBinds:GenerateKeybinds()
do
    --local function GenerateKeybinds()

    local BindableKeys = {}
    BindableKeys["F1"]=112
    BindableKeys["F2"]=113
    BindableKeys["F3"]=114
    --[[,{"F4"]=115}]]
    BindableKeys["F5"]=116
    BindableKeys["F6"]=117
    BindableKeys["F7"]=118
    BindableKeys["F8"]=119
    BindableKeys["F9"]=120
    BindableKeys["F10"]=121
    BindableKeys["F11"]=122
    BindableKeys["F12"]=123
    BindableKeys["0"]=48
    BindableKeys["1"]=49
    BindableKeys["2"]=50
    BindableKeys["3"]=51
    BindableKeys["4"]=52
    BindableKeys["5"]=53
    BindableKeys["6"]=54
    BindableKeys["7"]=55
    BindableKeys["8"]=56
    BindableKeys["9"]=57
    --[[,{"A"]=65}]]
    BindableKeys["B"]=66
    BindableKeys["C"]=67
    --[[,{"D"]=68}]]
    BindableKeys["E"]=69
    BindableKeys["F"]=70
    BindableKeys["G"]=71
    BindableKeys["H"]=72
    BindableKeys["I"]=73
    BindableKeys["J"]=74
    BindableKeys["K"]=75
    BindableKeys["L"]=76
    BindableKeys["M"]=77
    BindableKeys["N"]=78
    BindableKeys["O"]=79
    BindableKeys["P"]=80
    BindableKeys["Q"]=81
    BindableKeys["R"]=82
    --[[,{"S"]=83}]]
    BindableKeys["T"]=84
    BindableKeys["U"]=85
    BindableKeys["V"]=86
    --[[,{"W"]=87}]]
    BindableKeys["X"]=88
    BindableKeys["Y"]=89
    BindableKeys["Z"]=90
    BindableKeys["`"]=192
    BindableKeys["["]=219
    BindableKeys["]"]=221
    BindableKeys["'"]=222
    BindableKeys[","]=188
    BindableKeys["."]=190
    BindableKeys["/"]=191
    BindableKeys["="]=187
    BindableKeys["\\"]=220
    BindableKeys["-"]=189
    BindableKeys[";"]=186

    --these are done "array[int]=string" to avoid sorting issues when we generate the mod-strings later on. String arrays aren't stable, int arrays are.
    local BlueModifiers = {} --[[VKEY values: {"LCTRL"]=162,BindableKeys["RCTRL"]=163,BindableKeys["LSHIFT"]=160,BindableKeys["RSHIFT"]=161,BindableKeys["LALT"]=164,BindableKeys["RALT"]=165}]]
    BlueModifiers[1] = "LALT-"
    BlueModifiers[2] = "RALT-"
    BlueModifiers[4] = "LCTRL-"
    BlueModifiers[8] = "RCTRL-"
    BlueModifiers[16] = "LSHIFT-"
    BlueModifiers[32] = "RSHIFT-"



    local RedModifiers = {} --[[VKEY values: {"LCTRL"]=162,BindableKeys["RCTRL"]=163,BindableKeys["LSHIFT"]=160,BindableKeys["RSHIFT"]=161,BindableKeys["LALT"]=164,BindableKeys["RALT"]=165}]]
    RedModifiers["LCTRL-"] = 0
    RedModifiers["RCTRL-"] = 64
    RedModifiers["LSHIFT-"] = 0
    RedModifiers["RSHIFT-"] = 128
    RedModifiers["LALT-"] = 0
    RedModifiers["RALT-"] = 0

    local RedCapableModifiers = {} --[[VKEY values: {"LCTRL"]=162,BindableKeys["RCTRL"]=163,BindableKeys["LSHIFT"]=160,BindableKeys["RSHIFT"]=161,BindableKeys["LALT"]=164,BindableKeys["RALT"]=165}]]
    RedCapableModifiers["LCTRL-"] = -9000
    RedCapableModifiers["RCTRL-"] = 0
    RedCapableModifiers["LSHIFT-"] = -9000
    RedCapableModifiers["RSHIFT-"] = 0
    RedCapableModifiers["LALT-"] = -9000
    RedCapableModifiers["RALT-"] = 1

    local BlueModifierCombos,RedModifierCombos,RedCapableCombos = {},{},{}
    BlueModifierCombos[""] = 0;
    RedModifierCombos[""] = 0;
    RedCapableCombos[""] = 0;

    --/run printTo(3,RedCapableCombos["RCTRL-"]..":"..RedModifierCombos["RCTRL-"])
    --/run printTo(3,RedCapableCombos["RSHIFT-"]..":"..RedModifierCombos["RSHIFT-"])
    --/run printTo(3,RedCapableModifiersCombos["RALT-"]..":"..RedModifierCombos["RALT-"])
    for v, k in pairs (BlueModifiers) do -- note, blue modifiers are stored "array[int] = string" to avoid the sorting issue with lua
        local CurrentPassCombos = {} -- temp table
        local ExclusionString = strsub(k,2) or "This is not the modifier you are looking for"
        for kT, vT in pairs (BlueModifierCombos) do -- calc combos for current k
            if(strfind(kT, ExclusionString)==nil)then
                CurrentPassCombos[kT .. k] = vT + v
                RedModifierCombos[kT .. k] = (RedModifierCombos[kT] or 0)+RedModifiers[k]
                RedCapableCombos[kT .. k] = (RedCapableCombos[kT] or 0)+RedCapableModifiers[k]
            end
        end
        for kT, vT in pairs (CurrentPassCombos) do -- copy temp table into perm table
            BlueModifierCombos[kT] = vT
        end
    end
    RedCapableCombos[""] = -9000; -- needs to be zero while we are evaluating combos to make the maths work, but shouldn't be considered 'red capable'

    --    --[[Test all the modifier combos were generated correctly]]
    --    for kCombo, vCombo in pairs (BlueModifierCombos) do
    --        printTo(3,kCombo.." Red:"..RedModifierCombos[kCombo].." Blue:"..BlueModifierCombos[kCombo])
    --    --    if(RedCapableCombos[kCombo]>0)then
    --    --        printTo(3,kCombo.." Red:"..RedModifierCombos[kCombo].." Blue:"..BlueModifierCombos[kCombo])
    --    --    end
    --    end


    --generate all the binds
    --Keystroke, BlueModifier, RedModifier, RedCapable, KeybindUsed = {}, {}, {}, {},{}
    for kMod, vMod in pairs (BlueModifierCombos) do --printTo(3,kMod.."("..vMod..")")
        --print(kMod)
        for kKey, vKey in pairs (BindableKeys) do --printTo(3,kMod..kKey)
            --Keystroke[kMod .. kKey] = vKey
            --BlueModifier[kMod .. kKey] = BlueModifierCombos[kMod]
            --RedModifier[kMod .. kKey] = RedModifierCombos[kMod]
            --RedCapable[kMod .. kKey] = RedCapableCombos[kMod] == 1 and 1 or 0
            --KeybindUsed[kMod .. kKey] = _unbound

            local bind = kMod..kKey
            if not IsReserved(bind) then
                buttons[bind] = CreateFrame("Button", bind, UIParent, "SecureActionButtonTemplate")


                buttons[kMod .. kKey]:SetAttribute("type", "macro")
                SetOverrideBindingClick(buttons[bind], true, bind, bind);
                buttons[bind]:SetAttribute("macrotext", "/run print('unused bind: " .. bind .. "' )")
                buttons[bind]:RegisterForClicks("AnyDown","AnyUp")
                buttons[bind].key = vKey
                buttons[bind].mod = BlueModifierCombos[kMod]

            end
        end
    end

    --make sure the _null bind turns all the shit off
    --Keystroke[_null] = 0; BlueModifier[_null] = 0; RedModifier[_null] = 0; RedCapable[_null] = 1; KeybindUsed[_null] = _unbound;
    --for k,v in pairs(Keystroke) do
    --    printTo(3,k..":"..v..(RedCapable[k] == 1 and " :-) " or " >.< ").." + redmod: "..RedModifier[k].." + bluemod: "..BlueModifier[k])
    --end
    --public:PrintBindStatus()


end

local function GetUnallocatedButton(avoid)
    for k,v in pairs(buttons) do
        if (k ~= avoid and not v.used) then
            return k
        end
    end
end
local _nounit = "nounit"
function BindSpellToUnit(spell, unitid, t)
    if (t ~= nil and type(t) ~= "table") then print(spell .. "@" .. unitid .. " invalid args to bind") end
    if (t==nil) then t = {} end
    local SpellUnit = spell .. (unitid~=_nounit and unitid or "")


    if spellUnitToBinds[SpellUnit] ~= nil and not t.forceBind then --[[print("already bound " .. SpellUnit);]] return end

    --local SpellUnitClean = "" -- get the name of the spellunit without any banned chars, like : -- use this for buttons
    local Keybind = t.forceBind or GetUnallocatedButton(t.avoidBind)

    local MacroText = ""
    --[[if(1==0)then
    elseif(optFlag_FakeCastSequence~=nil)then
        MacroText= "/castsequence "..(Unit~=_nounit and "[@"..Unit.."] reset=1 " or " reset=1 ")..Spell..", Languages\n/run PlayerSpellBlock_ApplyBlock('"..Spell.."')"
    elseif(optFlag_SpellIsAnItem~=nil)then
        MacroText= "/use "..(Unit~=_nounit and "[@"..Unit.."] " or "")..Spell
    elseif(optFlag_SpellIsAnAction==nil)then
        MacroText= "/cast "..(Unit~=_nounit and "[@"..Unit.."] " or "")..Spell
    else
        MacroText= "/"..Spell.." "..(Unit~=_nounit and Unit or "")
    end]]
    if (t.prefix == nil) then t.prefix = "/cast" end
    if (t.prefix == "/castsequence") then
        MacroText = t.prefix .. (unitid~=_nounit and " [@"..unitid.."] reset=2 " or " reset=2 ") .. spell..", Arcane Intellect"--[[\n/run PlayerSpellBlock_ApplyBlock('"..Spell.."')"]]
    elseif(t.prefix == "/") then

        MacroText = t.prefix .. spell .. (unitid~=_nounit and " [@"..unitid.."] " or " ")
        --printTo(3,MacroText)
    elseif(t.prefix == "/cast !") then

        MacroText = t.prefix .. spell
        --printTo(3,MacroText)
    elseif(t.prefix == "/click") then
        MacroText = t.prefix .. " " ..  spell
        --print(MacroText)
    elseif(spell == "follow") then
        MacroText = "/run FollowUnit(\"" .. unitid.."\")\n/console autointeract " .. (unitid == "player" and "0" or  "1")
    else
        MacroText = t.prefix .. (unitid~=_nounit and " [@"..unitid.."] " or " ") .. spell
        --if t.prefix == "/use" then print(MacroText) end
    end

    if (t.suffix ~= nil) then
        MacroText = MacroText .. t.suffix
    end
    if (t.autoattack ~= nil) then
        MacroText = MacroText.. "\n/startattack" .. (unitid~=_nounit and " [@"..unitid.."] " or " ")
    end
    if (t.petattack ~= nil) then
        MacroText = MacroText.."\n/petattack" .. (unitid~=_nounit and " [@"..unitid.."] " or " ")
    end
    MacroText = gsub(MacroText, "@unit", "@" .. unitid .."")

    if t.stopmacro then
        MacroText = "/stopmacro [" .. t.stopmacro .. "]\n" .. MacroText
    end

    if spell == "follow" then print(MacroText) end

    --printTo(3,"Binding "..Spell.." to "..Unit.. " via " .. Keybind.. " with macro " .. MacroText.." as "..SpellUnit)

    --print("Keybind found "..Keybind.." for " .. SpellUnit)
    spellUnitToBinds[SpellUnit] = Keybind;

    if (t.forceBind) then
        if (not buttons[Keybind]) then
            buttons[Keybind] = CreateFrame("Button", Keybind, UIParent, "SecureActionButtonTemplate")
            buttons[Keybind]:SetAttribute("type", "macro")
            SetOverrideBindingClick(buttons[Keybind], true, Keybind, Keybind);
            buttons[Keybind]:SetAttribute("macrotext", "/run print('unused bind: " .. Keybind .. "' )")

            --buttons[Keybind].key = (not strmatch(Keybind, "-") and )
        end
        if (buttons[Keybind].used) then
            -- hopefully such code isn't invoked too much cause it's a bit messy
            BindSpellToUnit(buttons[Keybind].spell, buttons[Keybind].unitid, {avoidBind = Keybind})
        end
    end
    if (Keybind == nil) then
        print('RAN OUT OF BINDS - RELOADUI SHOULD FIX YOUR CURRENT SPEC')
    else
        --MacroText = MacroText .. "\n/run print(\"".. MacroText.."\")"
        buttons[Keybind]:SetAttribute("macrotext", MacroText)
        buttons[Keybind].spell = spell
        buttons[Keybind].unitid = unitid
        buttons[Keybind].used = true

        if t.always then             -- these ones don't get unbound when respecing
            buttons[Keybind].always = true
        end
        --print(SpellUnit .. " bound to " .. Keybind )
        --BoundSpellUnit_Icon[SpellUnit] = select(3,GetSpellInfo(t.spellNameForIcon or Spell) or "Some\\Path\\To\\Some\\Icon")
        --BoundSpellUnit_Button[string.gsub(Spell, ":", "") .. Unit] = CreateFrame("Button", string.gsub(Spell, ":", "") .. Unit, UIParent, "SecureActionButtonTemplate");
        --BoundSpellUnit_Button[string.gsub(Spell, ":", "") .. Unit]:SetAttribute("type","macro");

    end
end

--[[local function GetValuesForBind(k)
    if (Keystroke[k]==nil)then
        print("Nope, "..k.." doesn't exist")
    else
        --printTo(3,Keystroke[k], BlueModifier[k], RedModifier[k], RedCapable[k], KeybindUsed[k])
        return Keystroke[k], BlueModifier[k], 0, 0, 0, "boo"
    end
end]]

function GetValuesForSpellUnit(spell, unitid)
    if unitid == "nounit" then unitid = nil end
    local SpellUnit = tostring(unitid and spell .. unitid or spell)
    --print(SpellUnit)
    if(spellUnitToBinds[SpellUnit]~=nil)then
        local k = spellUnitToBinds[SpellUnit]
        return buttons[k].key,buttons[k].mod,0,0,true,"boo"

    end
    if unitid then
        SpellUnit = spell .. "focus"
        if(spellUnitToBinds[SpellUnit]~=nil)then
            if UnitIsUnit("focus", unitid) then
                local k = spellUnitToBinds[SpellUnit]
                return buttons[k].key,buttons[k].mod,0,0,true,"boo"
            end
            SpellUnit = "focus" .. unitid
            if(spellUnitToBinds[SpellUnit]~=nil)then
                local k = spellUnitToBinds[SpellUnit]
                return buttons[k].key,buttons[k].mod,0,0,true,"boo"
            end

        end
    end
    return 0,0,0,0,0,"null"
end