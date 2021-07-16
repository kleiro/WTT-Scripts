--[[//////////////////////////////////////////////
File: V1Sorties.lua
Author: Robert Klein
Created: 8th July 2021, 11:22:17
-----
Last Modified: 16th July 2021, 09:53:06
Modified By: Robert Klein
//////////////////////////////////////////////////]]

--[[//////////////////////////////////////////////
Sortie Functions
////////////////////////////////////////////////]]
--General Target Spawn
Sorties = {}
Sorties.Templates = {}
Sorties.Groups = {}

--Clear Sorties
Sorties.Set = SET_GROUP:New()
Sorties.Set:FilterPrefixes({"S2_", "S3_", "S4_", "S7_"})
Sorties.Set:FilterStart()

function ClearSorties()
    Sorties.Set:ForEachGroup(function(_group)
        _group:Destroy(nil)
    end)
end

--Sortie 1 Interdiciton: No function needed, 2 static objects in ME

--Sortie 2 OCA: Spawn single Tor in random radius
function StartSortieTwo()
    local _i = 1
    local _prefix = "S2_"
    while (_DATABASE.Templates.Groups[_prefix.._i]) do
        local _group = _prefix.._i

        Sorties.Templates[_group] = SPAWN:New(_group)
        Sorties.Templates[_group]:InitRandomizePosition(true, 152, 1)
        Sorties.Templates[_group]:Spawn()

        _i = _i + 1
    end
end

--Sortie 3 Precision Interdiciton: Multiple group spawns
function StartSortieThree()
    local _i = 1
    local _prefix = "S3_"
    while (_DATABASE.Templates.Groups[_prefix.._i]) do
        local _group = _prefix.._i

        Sorties.Templates[_group] = SPAWN:New(_group)
        Sorties.Templates[_group]:Spawn()

        _i = _i + 1
    end
end

--Sortie 4 SCAR: Spawn 3 groups and randomly patrol in zone
function StartSortieFour()
    local _i = 1
    local _prefix = "S4_"
    local _zoneSortieFour = ZONE:FindByName("SORTIE 4: A2G-SCAR")

    while (_DATABASE.Templates.Groups[_prefix.._i]) do
        local _group = _prefix.._i

        Sorties.Templates[_group] = SPAWN:New(_group)
        Sorties.Templates[_group]:InitRandomizePosition(true, 400, 1)
        
        Sorties.Groups[_group] = Sorties.Templates[_group]:Spawn()
        Sorties.Groups[_group]:PatrolZones({_zoneSortieFour}, 40)

        _i = _i + 1
    end
end

--Sortie 5 SOA: No function needed, runway strike

--Sortie 6 BARCAP: No function needed, BVR Range built in to mission

--Sortie 7 ASuW: Spawn single ship group
function StartSortieSeven()
    local _i = 1
    local _prefix = "S7_"
    while (_DATABASE.Templates.Groups[_prefix.._i]) do
        local _group = _prefix.._i

        Sorties.Templates[_group] = SPAWN:New(_group)
        Sorties.Templates[_group]:Spawn()

        _i = _i + 1
    end
end

--Sortie 8 QRA(I): No function needed, BFM Range built in to mission

--[[//////////////////////////////////////////////
Radio Menu
////////////////////////////////////////////////]]
Sorties.Menus = {}

Sorties.Menus.Main = MENU_COALITION:New(coalition.side.BLUE, "V1 Sorties")
Sorties.Menus.Main.S2 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "2:A2G-SEAD/DEAD", Sorties.Menus.Main, StartSortieTwo)
Sorties.Menus.Main.S3 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "3:A2G-Precision Interdiction", Sorties.Menus.Main, StartSortieThree)
Sorties.Menus.Main.S4 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "4:A2G-SCAR", Sorties.Menus.Main, StartSortieFour)
Sorties.Menus.Main.S7 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "7:A2S-ASuW", Sorties.Menus.Main, StartSortieSeven)
Sorties.Menus.Main.Clear = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Clear Sorties", Sorties.Menus.Main, ClearSorties)