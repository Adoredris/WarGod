local control = {}

local frame = CreateFrame("Frame")


WarGod.Control = control

local function printTo(index, ...)
    --print(index)
    local frame = _G["ChatFrame" .. (index > 2 and index + 1 or index)]
    if (frame) then
        local printResult = ""
        for i,v in ipairs({...}) do
            printResult = printResult .. tostring(v) .. " "
        end
        --printResult = printResult .. "\n"
        --if lastMessages[index] ~= printResult then
            --lastMessages[index] = printResult
            frame:AddMessage(printResult)

        --end

    end
end

local NagaStrings = {}
--NagaStrings.NUMPAD1 = "NUMPAD1"
NagaStrings.NUMPAD2 = "NUMPAD2"
NagaStrings.NUMPAD3 = "NUMPAD3"
NagaStrings.NUMPAD4 = "NUMPAD4"
NagaStrings.NUMPAD5 = "NUMPAD5"
NagaStrings.NUMPAD6 = "NUMPAD6"
NagaStrings.NUMPAD7 = "NUMPAD7"
NagaStrings.NUMPAD8 = "NUMPAD8"
NagaStrings.NUMPAD9 = "NUMPAD9"
NagaStrings.NUMPAD10 = "NUMPAD0"
NagaStrings.NUMPADMINUS = "NUMPADMINUS"
NagaStrings.NUMPADPLUS = "NUMPADPLUS"
control.NagaStrings = NagaStrings

local NagaDelegates = {}
control.NagaDelegates = NagaDelegates

local NagaStates = {}
control.NagaStates = NagaStates

local NagaButtons = {}
control.NagaButtons = NagaButtons

local NagaLabels = {}
control.NagaLabels = NagaLabels

local nagaDelegates = control.NagaDelegates
local nagaStates = control.NagaStates
local nagaStrings = control.NagaStrings
local nagaLabels = control.NagaLabels
local coreStrings = {}

coreStrings.bossbutton = "ExtraActionButton1"
coreStrings.nounit = "nounit"
coreStrings.null = "null"
coreStrings.dd = "DD"
coreStrings.aoe = "AOE"
coreStrings.off = "OFF"
coreStrings.cast = "cast"
coreStrings.legendary = "Legendary"
coreStrings.heal = "HEAL"
coreStrings.cc = "CC"
control.coreStrings = coreStrings

function ToggleNagaState (keybind)
    nagaDelegates[keybind](keybind);
end

function NagaStateOff (keybind)
    nagaStates[keybind] = false
end

local function BoringDefaultnagaToggle (keybind)
    if(nagaStates[keybind] == nil)then
        nagaStates[keybind] = false
    end
    nagaStates[keybind] = (not nagaStates[keybind])
    printTo(1, "Toggling " .. nagaLabels[keybind] .. " : " .. (nagaStates[keybind] and "Enabled" or "Disabled"))
end

local function nagaDDAOEOffDelegate (keybind)
    local mode = coreStrings.null
    if(keybind == nagaStrings.NUMPAD7)then
        mode = coreStrings.dd
    elseif(keybind == nagaStrings.NUMPAD8)then
        mode = coreStrings.aoe
    elseif(keybind == nagaStrings.NUMPAD9)then
        mode = coreStrings.off
    end

    nagaStates[nagaStrings.NUMPAD7] = mode
    nagaStates[nagaStrings.NUMPAD8] = mode
    nagaStates[nagaStrings.NUMPAD9] = mode
    printTo(1, "Mode: " .. mode)
    if control.ClearForceCasts then control:ClearForceCasts() end
    UIErrorsFrame:Show()
end



local function BindMacro (MacroText, Keybind, optIcon)
    NagaButtons[Keybind] = CreateFrame("Button", Keybind, UIParent, "SecureActionButtonTemplate");
    NagaButtons[Keybind]:SetAttribute("type","macro");
    SetOverrideBindingClick(NagaButtons[Keybind], true, Keybind, Keybind);
    --MacroText = MacroText .. "\n/run WarGod.Rotations:RefreshRotation()"
    NagaButtons[Keybind]:SetAttribute("macrotext",MacroText);
end

--LegBinds:BindMacro ("say test",keybind)
for i, keybind in pairs (nagaStrings) do
    --nagaButtons[keybind] =
    BindMacro ("/run ToggleNagaState('" .. keybind .. "')", keybind)
    nagaDelegates[keybind] = BoringDefaultnagaToggle;
    nagaLabels[keybind] = keybind
    nagaStates[keybind] = false
end

--override default behaviour for the standard on/aoe/off buttons and a few other things
nagaDelegates[nagaStrings.NUMPAD7] = nagaDDAOEOffDelegate
nagaDelegates[nagaStrings.NUMPAD8] = nagaDDAOEOffDelegate
nagaDelegates[nagaStrings.NUMPAD9] = nagaDDAOEOffDelegate
BindMacro ("/click ExtraActionButton1\n/run print('Hit boss button')", "NUMPAD1")--nagaStrings.NUMPAD1)

function LegendaryNagaMode ()
    return nagaStates[nagaStrings.NUMPAD7]
end

--naga labels
nagaLabels[nagaStrings.NUMPAD2] = "FFire"
nagaStates[nagaStrings.NUMPAD2] = false
function control:AOEDotEnabled ()
    return (not nagaStates[nagaStrings.NUMPAD2])
end
function control:FocusFire ()
    return nagaStates[nagaStrings.NUMPAD2] and not control:AOEMode()
end

NagaLabels[NagaStrings.NUMPAD3] = "Conserve"
NagaStates[NagaStrings.NUMPAD3] = true
function control:HighSustain ()
    return NagaStates[NagaStrings.NUMPAD3]
end

nagaLabels[nagaStrings.NUMPAD4] = "CDs"
nagaStates[nagaStrings.NUMPAD4] = false
function control:AllowCDs ()
    return nagaStates[nagaStrings.NUMPAD4]
end

NagaLabels[NagaStrings.NUMPAD5] = "Clickies"
NagaStates[NagaStrings.NUMPAD5] = false
function control:AllowClickies ()
    return NagaStates[NagaStrings.NUMPAD5]
end

NagaLabels[NagaStrings.NUMPAD6] = "Cleave"
NagaStates[NagaStrings.NUMPAD6] = true
function control:CleaveMode()
    return NagaStates[NagaStrings.NUMPAD6]
end

nagaLabels[nagaStrings.NUMPADMINUS] = "Utility"
nagaStates[nagaStrings.NUMPADMINUS] = true
function control:AutoKick()
    return nagaStates[nagaStrings.NUMPADMINUS]
end
function control:AutoPurge()        -- I think soothe is coming back
    return nagaStates[nagaStrings.NUMPADMINUS]
end
function control:AutoCleanse()        -- I think soothe is coming back
    return nagaStates[nagaStrings.NUMPADMINUS]
end
function control:AutoUtility()
    return nagaStates[nagaStrings.NUMPADMINUS]
end
function control:AutoTaunt()
    return nagaStates[nagaStrings.NUMPADMINUS]
end


nagaLabels[nagaStrings.NUMPADPLUS] = "Weaving"
nagaStates[nagaStrings.NUMPADPLUS] = true
function control:AutoWeave()
    return nagaStates[nagaStrings.NUMPADPLUS]
end




-- pcast style simple rotation toggle causes legendary to travel a different path
nagaLabels[nagaStrings.NUMPAD10] = "SafeMode"
nagaStates[nagaStrings.NUMPAD10] = false
function control:SafeMode()
    return nagaStates[nagaStrings.NUMPAD10]
end

function control:AOEMode() return LegendaryNagaMode()==coreStrings.aoe end

function control:Off()
    --print(nagaStates[nagaStrings.NUMPAD9])
    return nagaStates[nagaStrings.NUMPAD9] == "OFF"

end

--printTo(3,"IO6_nagaToggles.lua")

frame:SetScript("OnEvent", function(self, event, ...)
    if nagaStates[nagaStrings.NUMPAD10] == true then
        nagaStates[nagaStrings.NUMPAD10] = false
        print('Toggling SafeMode : Disabled (Left Combat)')
    end
    --if UnitClass("player") == "Druid" and GetSpecialization() == 1 then
        local inInstance, instanceType = IsInInstance()
        if inInstance and instanceType == "party" then
            if select(4,GetInstanceInfo()) == "Mythic Keystone" then
                if UnitClass("player") == "Druid" and GetSpecialization() == 1 or UnitClass("player") == "Priest" and GetSpecialization() == 3 or UnitClass("player") == "Warrior" then
                    if nagaStates[nagaStrings.NUMPAD5] == true then
                        nagaStates[nagaStrings.NUMPAD5] = false
                        print("Disabling Clickies : Left combat")
                    end
                else
                    --[[if nagaStates[nagaStrings.NUMPAD5] == false then
                        nagaStates[nagaStrings.NUMPAD5] = true
                        print("Enabling Clickies : Left combat")
                    end]]
                end

            end
        end

    --end
    if nagaStates[nagaStrings.NUMPAD4] == true and IsInInstance() then
        --[[if UnitClass("player") == "Druid" and WarGod.Unit.player.covenant.venthyr then
            nagaStates[nagaStrings.NUMPAD4] = false
            print("Disabling Cooldowns : Left combat")
        end]]
    end
    if nagaStates[nagaStrings.NUMPADMINUS] == false then
        nagaStates[nagaStrings.NUMPADMINUS] = true
        print("Enabling Interrupts : Left combat")
    end
    if nagaStates[nagaStrings.NUMPAD6] == false then
        nagaStates[nagaStrings.NUMPAD6] = true
        print("Enabling Cleave : Left combat")
    end
end)
frame:RegisterEvent("PLAYER_REGEN_ENABLED")