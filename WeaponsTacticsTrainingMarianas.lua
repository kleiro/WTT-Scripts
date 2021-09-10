--[[//////////////////////////////////////////////
File: WeaponsTacticsTraining.lua
Author: Robert Klein
Created: 8th August 2020, 11:50:09
-----
Last Modified: 10th September 2021, 09:19:08
Modified By: kleiro
//////////////////////////////////////////////////]]

WTT = {}

--[[//////////////////////////////////////////////
PVE Aircraft
////////////////////////////////////////////////]]

--BFM Aircraft Spawn Functions
WTT.BFMSpawns = SET_GROUP:New()
WTT.BFMSpawns:FilterPrefixes("PVE_Red_BFM_")
WTT.BFMSpawns:FilterStart()

function SpawnBFMAircraft(_acType, _spawnCount)
    local _clientInZone = 0
    local _spawnZone = ZONE:FindByName("BFM Range")
    WTT.clients:ForEachClientInZone(_spawnZone,
        function()
            _clientInZone = _clientInZone + 1
        end
    )

    if _clientInZone > 0 then 
        MESSAGE:New("Spawning ".._spawnCount.." BFM ".._acType):ToAll()
        SPAWN:New("PVE_Red_BFM_".._acType)
            :InitGrouping(_spawnCount)
            :Spawn()
    else
        MESSAGE:New("***No players inside the BFM Range. Spawn canceled.***"):ToAll()
    end
end

function ClearBFMAircraft()
    WTT.BFMSpawns:ForEachGroup(function(_group)
        _group:Destroy(nil)
    end)
end

--BVR Aircraft Spawn Functions
WTT.BVRSpawns = SET_GROUP:New()
WTT.BVRSpawns:FilterPrefixes("PVE_Red_BVR_")
WTT.BVRSpawns:FilterStart()

function SpawnBVRAircraft(_acType, _spawnCount)
    local _clientInZone = 0
    local _spawnZone = ZONE:FindByName("BVR Range")
    WTT.clients:ForEachClientInZone(_spawnZone,
        function()
            _clientInZone = _clientInZone + 1
        end
    )

    if _clientInZone > 0 then 
        MESSAGE:New("Spawning ".._spawnCount.." BVR ".._acType):ToAll()
        SPAWN:New("PVE_Red_BVR_".._acType)
            :InitGrouping(_spawnCount)
            :Spawn()
    else
        MESSAGE:New("***No players inside the BVR Range. Spawn canceled.***"):ToAll()
    end
end

function ClearBVRAircraft()
    WTT.BVRSpawns:ForEachGroup(function(_group)
        _group:Destroy(nil)
    end)
end

WTT.clients = SET_CLIENT:New():FilterActive(true):FilterStart()

--WTT Menu
WTT.pveAC = {"F14", "F15", "F16", "F18", "F5", "MiG21", "MiG23", "MiG29", "MiG31", "Su27", "TU95"}

WTT.menus = {}
WTT.menus.main = MENU_COALITION:New(coalition.side.BLUE, "Spawn PVE Aircraft")

WTT.menus.main.BVR = MENU_COALITION:New(coalition.side.BLUE, "BVR", WTT.menus.main)
WTT.menus.main.ClearBVR = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Clear BVR Spawns", WTT.menus.main, ClearBVRAircraft)

WTT.menus.main.BFM = MENU_COALITION:New(coalition.side.BLUE, "BFM", WTT.menus.main)
WTT.menus.main.ClearBFM = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Clear BFM Spawns", WTT.menus.main, ClearBFMAircraft)

WTT.menus.main.BVR.AC = {}
WTT.menus.main.BFM.AC = {}

for _k,_v in pairs(WTT.pveAC) do 
    WTT.menus.main.BVR.AC[_v] = MENU_COALITION:New(coalition.side.BLUE, _v, WTT.menus.main.BVR)
    WTT.menus.main.BFM.AC[_v] = MENU_COALITION:New(coalition.side.BLUE, _v, WTT.menus.main.BFM)
    for _i=1,4 do
        MENU_COALITION_COMMAND:New(coalition.side.BLUE, tostring(_i), WTT.menus.main.BVR.AC[_v], SpawnBVRAircraft, _v, _i)
        MENU_COALITION_COMMAND:New(coalition.side.BLUE, tostring(_i), WTT.menus.main.BFM.AC[_v], SpawnBFMAircraft, _v, _i)
    end
end


--[[//////////////////////////////////////////////
Surface Target Respawn
////////////////////////////////////////////////]]

WTT.templates = {}

function SpawnSurfaceTargets(_group)
    WTT.templates[_group] = SPAWN:New(_group)
    WTT.templates[_group]:InitLimit(#_DATABASE.Templates.Groups[_group].Template.units, 999)
    WTT.templates[_group]:InitRandomizePosition(true, 100, 5)
    WTT.templates[_group]:SpawnScheduled(15,0)
end

local _i = 1
while (_DATABASE.Templates.Groups["RedST_".._i]) do
    SpawnSurfaceTargets("RedST_".._i)
    _i = _i + 1
end

BASE:E("Spawned ".._i.." Surface Targets")


--[[//////////////////////////////////////////////
Armed Convoy Respawn
////////////////////////////////////////////////]]
--WTT.armedConvoy = SPAWN:New("RedConvoy")
--WTT.armedConvoy:InitLimit(5, 999)
--WTT.armedConvoy:SpawnScheduled(120, 0):InitRandomizeTemplatePrefixes("RedConvoy_")


--[[//////////////////////////////////////////////
Tanker Respawn
////////////////////////////////////////////////]]
WTT.tankers = {}

WTT.tankers.Shell = SPAWN:New("Shell")
WTT.tankers.Shell:InitKeepUnitNames()
WTT.tankers.Shell:InitLimit(1, 999)
WTT.tankers.Shell:InitRepeatOnLanding()
WTT.tankers.Shell:SpawnScheduled(15, 0)

WTT.tankers.Texaco = SPAWN:New("Texaco")
WTT.tankers.Texaco:InitKeepUnitNames()
WTT.tankers.Texaco:InitLimit(1, 999)
WTT.tankers.Texaco:InitRepeatOnLanding()
WTT.tankers.Texaco:SpawnScheduled(15, 0)

--[[//////////////////////////////////////////////
AWACS
////////////////////////////////////////////////]]
WTT.awacs = {}
WTT.awacs.Darkstar = SPAWN:New("Darkstar")
WTT.awacs.Darkstar:InitKeepUnitNames()
WTT.awacs.Darkstar:InitLimit(1, 999)
WTT.awacs.Darkstar:InitRepeatOnLanding()
WTT.awacs.Darkstar:InitDelayOn()
WTT.awacs.Darkstar:SpawnScheduled(20, 0)
WTT.awacs.Darkstar:SpawnScheduleStop()

function EnableAWACS()
    WTT.awacs.Darkstar:SpawnScheduleStart()
    
    WTT.menus.awacs.on:Remove()
    WTT.menus.awacs.off = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Disable AWACS", WTT.menus.awacs, DisableAWACS)
end

function DisableAWACS()
    WTT.awacs.Darkstar:SpawnScheduleStop()
    WTT.awacs.Darkstar:GetLastAliveGroup():Destroy(nil)
    
    WTT.menus.awacs.off:Remove()
    WTT.menus.awacs.on = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Enable AWACS", WTT.menus.awacs, EnableAWACS)
end

WTT.menus.awacs = MENU_COALITION:New(coalition.side.BLUE, "AWACS")
WTT.menus.awacs.on = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Enable AWACS", WTT.menus.awacs, EnableAWACS)


--[[//////////////////////////////////////////////
MOOSE CVN Airboss & Recovery Tanker
////////////////////////////////////////////////]]

--WTT.airboss = AIRBOSS:New("CVN-71","CVN Roosevelt")
--WTT.airboss:SetAutoSave([[C:\Users\DCAF\Google Drive (dcafoc@gmail.com)\DCAF\2_Establishment\Carrier Grades]])
--WTT.airboss:Load([[C:\Users\DCAF\Google Drive (dcafoc@gmail.com)\DCAF\2_Establishment\Carrier Grades]])
--WTT.airboss:SetTrapSheet()
--WTT.airboss:SetGlideslopeErrorThresholds(0.5, -0.4, 0.9, 1.6, -0.6, -0.9)
--WTT.airboss:SetLineupErrorThresholds(0.75, -0.75, -1.75, -3.0, 1.75, 3.0)
--WTT.airboss:SetSoundfilesFolder("Airboss Soundfiles/")
--WTT.airboss:SetVoiceOversLSOByRaynor()
--WTT.airboss:SetVoiceOversMarshalByGabriella()
--WTT.airboss:SetRadioRelayLSO("LSOVO")
--WTT.airboss:SetRadioRelayMarshal("MSHLVO")
--WTT.airboss:SetDefaultPlayerSkill("Naval Aviator")
--WTT.airboss:SetMaxLandingPattern(6)
--WTT.airboss:Start()
--WTT.airboss:SetTACAN(71, "X", "CVN")
--WTT.airboss:SetICLS(1, "ICV")
--WTT.airboss:SetMarshalRadio(305.00, "AM")
--WTT.airboss:SetLSORadio(305.10, "AM")
--WTT.airboss:SetCollisionDistance(15)
--WTT.airboss:SetMenuRecovery(60, 27, true, 0)
--WTT.airboss:CarrierTurnIntoWind(21600, UTILS.KnotsToMps(30))

WTT.recoveryTanker = RECOVERYTANKER:New(UNIT:FindByName("CVN-71"), "Arco")
WTT.recoveryTanker:SetTakeoffAir()
WTT.recoveryTanker:SetRespawnInAir()
WTT.recoveryTanker:SetTACAN(39,"ARC")
WTT.recoveryTanker:SetRadio(290, "AM")
WTT.recoveryTanker:Start()

WTT.rescueHelo = RESCUEHELO:New(UNIT:FindByName("CVN-71"), "Lifeguard")
WTT.rescueHelo:SetTakeoffAir()
WTT.rescueHelo:SetRespawnInAir()
WTT.rescueHelo:SetRespawnOn()
WTT.rescueHelo:Start()

--[[//////////////////////////////////////////////
MOOSE LHA Airboss
////////////////////////////////////////////////]]
--WTT.airbossLHA = AIRBOSS:New("LHA-1","LHA Tarawa")
--WTT.airbossLHA:SetAutoSave([[C:\Users\DCAF\Google Drive (dcafoc@gmail.com)\DCAF\2_Establishment\Carrier Grades]])
--WTT.airbossLHA:Load([[C:\Users\DCAF\Google Drive (dcafoc@gmail.com)\DCAF\2_Establishment\Carrier Grades]])
--[[WTT.airbossLHA:SetTrapSheet()
WTT.airbossLHA:SetGlideslopeErrorThresholds(0.5, -0.4, 0.9, 1.6, -0.7, -1.0)
WTT.airbossLHA:SetLineupErrorThresholds(0.75, -0.75, -1.75, -3.0, 1.75, 3.0)
WTT.airbossLHA:SetSoundfilesFolder("Airboss Soundfiles/")
WTT.airbossLHA:SetVoiceOversLSOByRaynor()
WTT.airbossLHA:SetVoiceOversMarshalByGabriella()
WTT.airbossLHA:SetRadioRelayLSO("LSOVOLHA")
WTT.airbossLHA:SetRadioRelayMarshal("MSHLVOLHA")
WTT.airbossLHA:SetDefaultPlayerSkill("Naval Aviator")
WTT.airbossLHA:SetMaxLandingPattern(6)
WTT.airbossLHA:Start()
WTT.airbossLHA:SetTACAN(73, "X", "LHA")
WTT.airbossLHA:SetICLS(3, "ILH")
WTT.airbossLHA:SetMarshalRadio(305.10, "AM")
WTT.airbossLHA:SetLSORadio(305.20, "AM")
WTT.airbossLHA:SetCollisionDistance(15)
WTT.airbossLHA:SetMenuRecovery(60, 27, true, 0)]]