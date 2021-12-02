--[[//////////////////////////////////////////////
File: CarrierModule.lua
Author: Robert Klein
Created: 19th May 2021, 11:51:13
-----
Last Modified: 27th October 2021, 14:34:01
Modified By: Robert Klein
//////////////////////////////////////////////////]]
--REQUIRES global variable in Mission Editor
--Carrier_Units = {"1st Carrier Unit Name", "2nd Carrier Unit Name", ...}


--Variable Definitions
CVNGroups = {}
CVNTIG = {}
CVNTIG.PlayerCaseType = 1

--Function Definitiions
function TurnIntoWind(_navyGroup, _time)
    local _ngName = _navyGroup:GetName()
    _navyGroup.TIWData = _navyGroup:AddTurnIntoWind(nil, (_time*60), 25, false)
    MESSAGE:New(string.format("Turning %s into the wind for %i minutes", _ngName, _time)):ToCoalition(_navyGroup:GetCoalition())
    
    _navyGroup.TurnIntoWindMenu:Remove()

    _navyGroup.TIWEnd = timer.getAbsTime()+(_time*60)
    _navyGroup.TIWTimeRemainingCommand = MENU_COALITION_COMMAND:New(_navyGroup:GetCoalition(), "Time Remaining Into Wind", _navyGroup.TopMenu, TimeRemaining, _navyGroup)

    _navyGroup.EndTurnIntoWindCommand = MENU_COALITION_COMMAND:New(_navyGroup:GetCoalition(), "End Turn Into Wind", _navyGroup.TopMenu, EndTurnIntoWind, _navyGroup)
    
end

function TimeRemaining(_navyGroup)
    local _timeLeft = math.floor((_navyGroup.TIWEnd - timer.getAbsTime())/60)
    MESSAGE:New(string.format("%s | %i minutes remaining in recovery window", _navyGroup:GetName(), _timeLeft)):ToCoalition(_navyGroup:GetCoalition())
end

function EndTurnIntoWind(_navyGroup)
    _navyGroup:RemoveTurnIntoWind(_navyGroup.TIWData)
end

function AddTurninIntoWindMenu(_navyGroup)

    _navyGroup.TurnIntoWindMenu = MENU_COALITION:New(_navyGroup:GetCoalition(), "Turn Into Wind", _navyGroup.TopMenu)
        _navyGroup.TurnIntoWindCommand15 = MENU_COALITION_COMMAND:New(_navyGroup:GetCoalition(), "15 Minutes", _navyGroup.TurnIntoWindMenu, TurnIntoWind, _navyGroup, 15)
        _navyGroup.TurnIntoWindCommand30 = MENU_COALITION_COMMAND:New(_navyGroup:GetCoalition(), "30 Minutes", _navyGroup.TurnIntoWindMenu, TurnIntoWind, _navyGroup, 30)
        _navyGroup.TurnIntoWindCommand45 = MENU_COALITION_COMMAND:New(_navyGroup:GetCoalition(), "45 Minutes", _navyGroup.TurnIntoWindMenu, TurnIntoWind, _navyGroup, 45)
        _navyGroup.TurnIntoWindCommand60 = MENU_COALITION_COMMAND:New(_navyGroup:GetCoalition(), "60 Minutes", _navyGroup.TurnIntoWindMenu, TurnIntoWind, _navyGroup, 60)
        _navyGroup.TurnIntoWindCommand90 = MENU_COALITION_COMMAND:New(_navyGroup:GetCoalition(), "90 Minutes", _navyGroup.TurnIntoWindMenu, TurnIntoWind, _navyGroup, 90)
        _navyGroup.TurnIntoWindCommand120 = MENU_COALITION_COMMAND:New(_navyGroup:GetCoalition(), "120 Minutes", _navyGroup.TurnIntoWindMenu, TurnIntoWind, _navyGroup, 120)
    
end

function SetCaseType(_case, _navyGroup)
    CVNTIG.PlayerCaseType = _case
    MESSAGE:New(string.format("Grading switched to CASE %i", _case)):ToCoalition(_navyGroup:GetCoalition())
end


--Time In Groove Functions from MOOSE TIG Class
TIG = {
    ClassName      = "TIG",
    Debug          = false,
    lid            = nil,
    theatre        = nil,
    carrier        = nil,
    carriertype    = nil,
    carrierparam   =  {},
    alias          = nil,
    airbase        = nil,
    waypoints      =  {},
    currentwp      = nil,
    beacon         = nil,
    TACANon        = nil,
    TACANchannel   = nil,
    TACANmode      = nil,
    TACANmorse     = nil,
    ICLSon         = nil,
    ICLSchannel    = nil,
    ICLSmorse      = nil,
    LSORadio       = nil,
    LSOFreq        = nil,
    LSOModu        = nil,
    MarshalRadio   = nil,
    MarshalFreq    = nil,
    MarshalModu    = nil,
    TowerFreq      = nil,
    radiotimer     = nil,
    zoneCCA        = nil,
    zoneCCZ        = nil,
    players        =  {},
    menuadded      =  {},
    BreakEntry     =  {},
    BreakEarly     =  {},
    BreakLate      =  {},
    Abeam          =  {},
    Ninety         =  {},
    Wake           =  {},
    Final          =  {},
    Groove         =  {},
    Platform       =  {},
    DirtyUp        =  {},
    Bullseye       =  {},
    defaultcase    = nil,
    case           = nil,
    defaultoffset  = nil,
    holdingoffset  = nil,
    recoverytimes  =  {},
    flights        =  {},
    Qpattern       =  {},
    Qmarshal       =  {},
    Qwaiting       =  {},
    Qspinning      =  {},
    RQMarshal      =  {},
    RQLSO          =  {},
    TQMarshal      =   0,
    TQLSO          =   0,
    Nmaxpattern    = nil,
    Nmaxmarshal    = nil,
    NmaxSection    = nil,
    NmaxStack      = nil,
    handleai       = nil,
    tanker         = nil,
    Corientation   = nil,
    Corientlast    = nil,
    Cposition      = nil,
    defaultskill   = nil,
    adinfinitum    = nil,
    magvar         = nil,
    Tcollapse      = nil,
    recoverywindow = nil,
    usersoundradio = nil,
    Tqueue         = nil,
    dTqueue        = nil,
    dTstatus       = nil,
    menumarkzones  = nil,
    menusmokezones = nil,
    playerscores   = nil,
    autosave       = nil,
    autosavefile   = nil,
    autosavepath   = nil,
    marshalradius  = nil,
    TIGnice    = nil,
    staticweather  = nil,
    windowcount    =   0,
    LSOdT          = nil,
    senderac       = nil,
    radiorelayLSO  = nil,
    radiorelayMSH  = nil,
    turnintowind   = nil,
    detour         = nil,
    squadsetAI     = nil,
    excludesetAI   = nil,
    menusingle     = nil,
    collisiondist  = nil,
    holdtimestamp  = nil,
    Tmessage       = nil,
    soundfolder    = nil,
    soundfolderLSO = nil,
    soundfolderMSH = nil,
    despawnshutdown= nil,
    dTbeacon       = nil,
    Tbeacon        = nil,
    LSOCall        = nil,
    MarshalCall    = nil,
    lowfuelAI      = nil,
    emergency      = nil,
    respawnAI      = nil,
    gle            =  {},
    lue            =  {},
    trapsheet      = nil,
    trappath       = nil,
    trapprefix     = nil,
    initialmaxalt  = nil,
    welcome        = nil,
    skipperMenu    = nil,
    skipperSpeed   = nil,
    skipperTime    = nil,
    skipperOffset  = nil,
    skipperUturn   = nil,
}
TIG.CarrierType={
    ROOSEVELT="CVN_71",
    LINCOLN="CVN_72",
    WASHINGTON="CVN_73",
    TRUMAN="CVN_75",
    STENNIS="Stennis",
    VINSON="VINSON",
    TARAWA="LHA_Tarawa",
    KUZNETSOV="KUZNECOW",
}

function TIG:New(carriername)

    -- Inherit everthing from FSM class.
    local self=BASE:Inherit(self, FSM:New()) -- #TIG
  
    -- Debug.
    self:F2({carriername=carriername})
  
    -- Set carrier unit.
    self.carrier=UNIT:FindByName(carriername)
  
    -- Check if carrier unit exists.
    if self.carrier==nil then
      -- Error message.
      local text=string.format("ERROR: Carrier unit %s could not be found! Make sure this UNIT is defined in the mission editor and check the spelling of the unit name carefully.", carriername)
      MESSAGE:New(text, 120):ToAll()
      self:E(text)
      return nil
    end
  
    -- Set some string id for output to DCS.log file.
    self.lid=string.format("TIG %s | ", carriername)
  
    -- Current map.
    self.theatre=env.mission.theatre
    self:T2(self.lid..string.format("Theatre = %s.", tostring(self.theatre)))

    self:HandleEvent(EVENTS.Birth)

    self:SetCarrierControlledArea()

    self:T(self.lid.."INFO: New TIG")
  
    -- Get carrier type.
    self.carriertype=self.carrier:GetTypeName()
  
    -- Coordinates
    self.landingcoord=COORDINATE:New(0,0,0)      --Core.Point#COORDINATE
    self.sterncoord=COORDINATE:New(0, 0, 0)      --Core.Point#COORDINATE
    self.landingspotcoord=COORDINATE:New(0,0,0)  --Core.Point#COORDINATE
  
    -- Init carrier parameters.
    if self.carriertype==TIG.CarrierType.STENNIS then
        self:_InitStennis()
    elseif self.carriertype==TIG.CarrierType.ROOSEVELT then
        self:_InitNimitz()
    elseif self.carriertype==TIG.CarrierType.LINCOLN then
        self:_InitNimitz()
    elseif self.carriertype==TIG.CarrierType.WASHINGTON then
        self:_InitNimitz()
    elseif self.carriertype==TIG.CarrierType.TRUMAN then
        self:_InitNimitz()
    elseif self.carriertype==TIG.CarrierType.VINSON then
        -- TODO: Carl Vinson parameters.
        self:_InitStennis()
    elseif self.carriertype==TIG.CarrierType.TARAWA then
        -- Tarawa parameters.
        self:_InitTarawa()
    elseif self.carriertype==TIG.CarrierType.KUZNETSOV then
        -- Kusnetsov parameters - maybe...
        self:_InitStennis()
    else
        self:E(self.lid..string.format("ERROR: Unknown carrier type %s!", tostring(self.carriertype)))
        return nil
    end

    self.lue._max=_max   or  0.5
    self.lue._min=_min   or -0.5
    self.lue.Left=Left   or -1.0
    self.lue.LeftMed=LeftMed   or -2.0
    self.lue.LEFT=LEFT   or -3.0
    self.lue.Right=Right or  1.0
    self.lue.RightMed=RightMed or  2.0 
    self.lue.RIGHT=RIGHT or  3.0
  
    return self
end

function TIG:OnEventBirth(EventData)
    self:F3({eventbirth = EventData})
  
    -- Nil checks.
    if EventData==nil then
        self:E(self.lid.."ERROR: EventData=nil in event BIRTH!")
        self:E(EventData)
        return
    end
    if EventData.IniUnit==nil then
        self:E(self.lid.."ERROR: EventData.IniUnit=nil in event BIRTH!")
        self:E(EventData)
        return
    end
  
    local _unitName=EventData.IniUnitName
    local _unit, _playername=self:_GetPlayerUnitAndName(_unitName)
  
    self:T(self.lid.."BIRTH: unit   = "..tostring(EventData.IniUnitName))
    self:T(self.lid.."BIRTH: group  = "..tostring(EventData.IniGroupName))
    self:T(self.lid.."BIRTH: player = "..tostring(_playername))
  
    if _unit and _playername then
  
        local _uid=_unit:GetID()
        local _group=_unit:GetGroup()
        local _callsign=_unit:GetCallsign()
    
        -- Debug output.
        local text=string.format("Pilot %s, callsign %s entered unit %s of group %s.", _playername, _callsign, _unitName, _group:GetName())
        self:T(self.lid..text)
        MESSAGE:New(text, 5):ToAllIf(self.Debug)
    
        -- Check that coalition of the carrier and aircraft match.
        if self:GetCoalition()~=_unit:GetCoalition() then
            local text=string.format("Player entered aircraft of other coalition.")
            MESSAGE:New(text, 30):ToAllIf(self.Debug)
            self:T(self.lid..text)
            return
        end
    
        -- Delaying the new player for a second, because AI units of the flight would not be registered correctly.
        --SCHEDULER:New(nil, self._NewPlayer, {self, _unitName}, 1)
        self:ScheduleOnce(1, self._NewPlayer, self, _unitName)
    end
end

function TIG:GetCoalition()
    return self.carrier:GetCoalition()
end

function TIG:SetCarrierControlledArea(radius)

    radius=UTILS.NMToMeters(radius or 50)
  
    self.zoneCCA=ZONE_UNIT:New("Carrier Controlled Area",  self.carrier, radius)
  
    return self
end

--- Returns the unit of a player and the player name from the self.players table if it exists.
-- @param #TIG self
-- @param #string _unitName Name of the player unit.
-- @return Wrapper.Unit#UNIT Unit of player or nil.
-- @return #string Name of player or nil.
function TIG:_GetPlayerUnit(_unitName)

    for _,_player in pairs(self.players) do
  
      local player=_player --#TIG.PlayerData
  
      if player.unit and player.unit:GetName()==_unitName then
        self:T(self.lid..string.format("Found player=%s unit=%s in players table.", tostring(player.name), tostring(_unitName)))
        return player.unit, player.name
      end
  
    end
  
    return nil,nil
end

--- Returns the unit of a player and the player name. If the unit does not belong to a player, nil is returned.
-- @param #TIG self
-- @param #string _unitName Name of the player unit.
-- @return Wrapper.Unit#UNIT Unit of player or nil.
-- @return #string Name of the player or nil.
function TIG:_GetPlayerUnitAndName(_unitName)
    self:F2(_unitName)
  
    if _unitName ~= nil then
  
      -- First, let's look up all current players.
      local u,pn=self:_GetPlayerUnit(_unitName)
  
      -- Return
      if u and pn then
        return u, pn
      end
  
      -- Get DCS unit from its name.
      local DCSunit=Unit.getByName(_unitName)
  
      if DCSunit then
  
        -- Get player name if any.
        local playername=DCSunit:getPlayerName()
  
        -- Unit object.
        local unit=UNIT:Find(DCSunit)
  
        -- Debug.
        self:T2({DCSunit=DCSunit, unit=unit, playername=playername})
  
        -- Check if enverything is there.
        if DCSunit and unit and playername then
          self:T(self.lid..string.format("Found DCS unit %s with player %s.", tostring(_unitName), tostring(playername)))
          return unit, playername
        end
  
      end
  
    end
  
    -- Return nil if we could not find a player.
    return nil,nil
end

function TIG:_InitPlayer(playerData)
  
    playerData.groove={}
    playerData.debrief={}
    playerData.trapsheet={}
    playerData.warning=nil
    playerData.holding=nil
    playerData.refueling=false
    playerData.valid=false
    playerData.lig=false
    playerData.wop=false
    playerData.waveoff=false
    playerData.wofd=false
    playerData.owo=false
    playerData.boltered=false
    playerData.landed=false
    playerData.Tlso=timer.getTime()
    playerData.Tgroove=nil
    playerData.TIG0=nil
    playerData.wire=nil
    playerData.flag=-100
    playerData.debriefschedulerID=nil
  
    return playerData
end

--- Initialize player data after birth event of player unit.
-- @param #TIG self
-- @param #string unitname Name of the player unit.
-- @return #TIG.PlayerData Player data.
function TIG:_NewPlayer(unitname)

    -- Get player unit and name.
    local playerunit, playername=self:_GetPlayerUnitAndName(unitname)
  
    if playerunit and playername then
    
        -- Player data.
        local playerData = {}--#TIG.PlayerData

        -- Init stuff for this round.
        playerData=self:_InitPlayer(playerData)

        playerData.unit = playerunit

        -- Init player data.
        self.players[playername]=playerData
    
        -- Return player data table.
        return playerData
    end
  
    return nil
end


--- Init parameters for USS Stennis carrier.
-- @param #TIG self
function TIG:_InitStennis()

    -- Carrier Parameters.
    self.carrierparam.sterndist  =-153
    self.carrierparam.deckheight =  19.06
  
    -- Total size of the carrier (approx as rectangle).
    self.carrierparam.totlength=310         -- Wiki says 332.8 meters overall length.
    self.carrierparam.totwidthport=40       -- Wiki says  76.8 meters overall beam.
    self.carrierparam.totwidthstarboard=30
  
    -- Landing runway.
    self.carrierparam.rwyangle   =  -9.1359
    self.carrierparam.rwylength  = 225
    self.carrierparam.rwywidth   =  20
  
    -- Wires.
    self.carrierparam.wire1      =  46        -- Distance from stern to first wire.
    self.carrierparam.wire2      =  46+12
    self.carrierparam.wire3      =  46+24
    self.carrierparam.wire4      =  46+35     -- Last wire is strangely one meter closer.
  
  
    -- Platform at 5k. Reduce descent rate to 2000 ft/min to 1200 dirty up level flight.
    self.Platform.name="Platform 5k"
    self.Platform.Xmin=-UTILS.NMToMeters(22)  -- Not more than 22 NM behind the boat. Last check was at 21 NM.
    self.Platform.Xmax =nil
    self.Platform.Zmin=-UTILS.NMToMeters(30)  -- Not more than 30 NM port of boat.
    self.Platform.Zmax= UTILS.NMToMeters(30)  -- Not more than 30 NM starboard of boat.
    self.Platform.LimitXmin=nil               -- Limits via zone
    self.Platform.LimitXmax=nil
    self.Platform.LimitZmin=nil
    self.Platform.LimitZmax=nil
  
    -- Level out at 1200 ft and dirty up.
    self.DirtyUp.name="Dirty Up"
    self.DirtyUp.Xmin=-UTILS.NMToMeters(21)        -- Not more than 21 NM behind the boat.
    self.DirtyUp.Xmax= nil
    self.DirtyUp.Zmin=-UTILS.NMToMeters(30)        -- Not more than 30 NM port of boat.
    self.DirtyUp.Zmax= UTILS.NMToMeters(30)        -- Not more than 30 NM starboard of boat.
    self.DirtyUp.LimitXmin=nil                     -- Limits via zone
    self.DirtyUp.LimitXmax=nil
    self.DirtyUp.LimitZmin=nil
    self.DirtyUp.LimitZmax=nil
  
    -- Intercept glide slope and follow bullseye.
    self.Bullseye.name="Bullseye"
    self.Bullseye.Xmin=-UTILS.NMToMeters(11)       -- Not more than 11 NM behind the boat. Last check was at 10 NM.
    self.Bullseye.Xmax= nil
    self.Bullseye.Zmin=-UTILS.NMToMeters(30)       -- Not more than 30 NM port.
    self.Bullseye.Zmax= UTILS.NMToMeters(30)       -- Not more than 30 NM starboard.
    self.Bullseye.LimitXmin=nil                    -- Limits via zone.
    self.Bullseye.LimitXmax=nil
    self.Bullseye.LimitZmin=nil
    self.Bullseye.LimitZmax=nil
  
    -- Break entry.
    self.BreakEntry.name="Break Entry"
    self.BreakEntry.Xmin=-UTILS.NMToMeters(4)          -- Not more than 4 NM behind the boat. Check for initial is at 3 NM with a radius of 500 m and 100 m starboard.
    self.BreakEntry.Xmax= nil
    self.BreakEntry.Zmin=-UTILS.NMToMeters(0.5)        -- Not more than 0.5 NM port of boat.
    self.BreakEntry.Zmax= UTILS.NMToMeters(1.5)        -- Not more than 1.5 NM starboard.
    self.BreakEntry.LimitXmin=0                        -- Check and next step when at carrier and starboard of carrier.
    self.BreakEntry.LimitXmax=nil
    self.BreakEntry.LimitZmin=nil
    self.BreakEntry.LimitZmax=nil
  
    -- Early break.
    self.BreakEarly.name="Early Break"
    self.BreakEarly.Xmin=-UTILS.NMToMeters(1)         -- Not more than 1 NM behind the boat. Last check was at 0.
    self.BreakEarly.Xmax= UTILS.NMToMeters(5)         -- Not more than 5 NM in front of the boat. Enough for late breaks?
    self.BreakEarly.Zmin=-UTILS.NMToMeters(2)         -- Not more than 2 NM port.
    self.BreakEarly.Zmax= UTILS.NMToMeters(1)         -- Not more than 1 NM starboard.
    self.BreakEarly.LimitXmin= 0                      -- Check and next step 0.2 NM port and in front of boat.
    self.BreakEarly.LimitXmax= nil
    self.BreakEarly.LimitZmin=-UTILS.NMToMeters(0.2)  -- -370 m port
    self.BreakEarly.LimitZmax= nil
  
    -- Late break.
    self.BreakLate.name="Late Break"
    self.BreakLate.Xmin=-UTILS.NMToMeters(1)         -- Not more than 1 NM behind the boat. Last check was at 0.
    self.BreakLate.Xmax= UTILS.NMToMeters(5)         -- Not more than 5 NM in front of the boat. Enough for late breaks?
    self.BreakLate.Zmin=-UTILS.NMToMeters(2)         -- Not more than 2 NM port.
    self.BreakLate.Zmax= UTILS.NMToMeters(1)         -- Not more than 1 NM starboard.
    self.BreakLate.LimitXmin= 0                      -- Check and next step 0.8 NM port and in front of boat.
    self.BreakLate.LimitXmax= nil
    self.BreakLate.LimitZmin=-UTILS.NMToMeters(0.8)  -- -1470 m port
    self.BreakLate.LimitZmax= nil
  
    -- Abeam position.
    self.Abeam.name="Abeam Position"
    self.Abeam.Xmin=-UTILS.NMToMeters(5)            -- Not more then 5 NM astern of boat. Should be LIG call anyway.
    self.Abeam.Xmax= UTILS.NMToMeters(5)            -- Not more then 5 NM ahead of boat.
    self.Abeam.Zmin=-UTILS.NMToMeters(2)            -- Not more than 2 NM port.
    self.Abeam.Zmax= 500                            -- Not more than 500 m starboard. Must be port!
    self.Abeam.LimitXmin=-200                       -- Check and next step 200 meters behind the ship.
    self.Abeam.LimitXmax= nil
    self.Abeam.LimitZmin= nil
    self.Abeam.LimitZmax= nil
  
    -- At the Ninety.
    self.Ninety.name="Ninety"
    self.Ninety.Xmin=-UTILS.NMToMeters(4)           -- Not more than 4 NM behind the boat. LIG check anyway.
    self.Ninety.Xmax= 0                             -- Must be behind the boat.
    self.Ninety.Zmin=-UTILS.NMToMeters(2)           -- Not more than 2 NM port of boat.
    self.Ninety.Zmax= nil
    self.Ninety.LimitXmin=nil
    self.Ninety.LimitXmax=nil
    self.Ninety.LimitZmin=nil
    self.Ninety.LimitZmax=-UTILS.NMToMeters(0.6)    -- Check and next step when 0.6 NM port.
  
    -- At the Wake.
    self.Wake.name="Wake"
    self.Wake.Xmin=-UTILS.NMToMeters(4)           -- Not more than 4 NM behind the boat.
    self.Wake.Xmax= 0                             -- Must be behind the boat.
    self.Wake.Zmin=-2000                          -- Not more than 2 km port of boat.
    self.Wake.Zmax= nil
    self.Wake.LimitXmin=nil
    self.Wake.LimitXmax=nil
    self.Wake.LimitZmin=0                         -- Check and next step when directly behind the boat.
    self.Wake.LimitZmax=nil
  
    -- Turn to final.
    self.Final.name="Final"
    self.Final.Xmin=-UTILS.NMToMeters(4)           -- Not more than 4 NM behind the boat.
    self.Final.Xmax= 0                             -- Must be behind the boat.
    self.Final.Zmin=-2000                          -- Not more than 2 km port.
    self.Final.Zmax= nil
    self.Final.LimitXmin=nil                       -- No limits. Check is carried out differently.
    self.Final.LimitXmax=nil
    self.Final.LimitZmin=nil
    self.Final.LimitZmax=nil
  
    -- In the Groove.
    self.Groove.name="Groove"
    self.Groove.Xmin=-UTILS.NMToMeters(4)           -- Not more than 4 NM behind the boat.
    self.Groove.Xmax= nil
    self.Groove.Zmin=-UTILS.NMToMeters(2)           -- Not more than 2 NM port
    self.Groove.Zmax= UTILS.NMToMeters(2)           -- Not more than 2 NM starboard.
    self.Groove.LimitXmin=nil                       -- No limits. Check is carried out differently.
    self.Groove.LimitXmax=nil
    self.Groove.LimitZmin=nil
    self.Groove.LimitZmax=nil
  
end
  
  --- Init parameters for Nimitz class super carriers.
  -- @param #TIG self
function TIG:_InitNimitz()
  
    -- Init Stennis as default.
    self:_InitStennis()
  
    -- Carrier Parameters.
    self.carrierparam.sterndist  =-164
    self.carrierparam.deckheight =  20.1494  --DCS World OpenBeta\CoreMods\tech\USS_Nimitz\Database\USS_CVN_7X.lua
  
    -- Total size of the carrier (approx as rectangle).
    self.carrierparam.totlength=332.8         -- Wiki says 332.8 meters overall length.
    self.carrierparam.totwidthport=45         -- Wiki says  76.8 meters overall beam.
    self.carrierparam.totwidthstarboard=35
  
    -- Landing runway.
    self.carrierparam.rwyangle   =  -9.1359  --DCS World OpenBeta\CoreMods\tech\USS_Nimitz\scripts\USS_Nimitz_RunwaysAndRoutes.lua
    self.carrierparam.rwylength  = 250
    self.carrierparam.rwywidth   =  25
  
    -- Wires.
    self.carrierparam.wire1      =  55        -- Distance from stern to first wire.
    self.carrierparam.wire2      =  67
    self.carrierparam.wire3      =  79
    self.carrierparam.wire4      =  92
  
end
  
  --- Init parameters for LHA-1 Tarawa carrier.
  -- @param #TIG self
function TIG:_InitTarawa()
  
    -- Init Stennis as default.
    self:_InitStennis()
  
    -- Carrier Parameters.
    self.carrierparam.sterndist  =-125
    self.carrierparam.deckheight =  21  --69 ft
  
    -- Total size of the carrier (approx as rectangle).
    self.carrierparam.totlength=245
    self.carrierparam.totwidthport=10
    self.carrierparam.totwidthstarboard=25
  
    -- Landing runway.
    self.carrierparam.rwyangle  =   0
    self.carrierparam.rwylength = 225
    self.carrierparam.rwywidth  =  15
  
    -- Wires.
    self.carrierparam.wire1=nil
    self.carrierparam.wire2=nil
    self.carrierparam.wire3=nil
    self.carrierparam.wire4=nil
  
    -- Late break.
    self.BreakLate.name="Late Break"
    self.BreakLate.Xmin=-UTILS.NMToMeters(1)         -- Not more than 1 NM behind the boat. Last check was at 0.
    self.BreakLate.Xmax= UTILS.NMToMeters(5)         -- Not more than 5 NM in front of the boat. Enough for late breaks?
    self.BreakLate.Zmin=-UTILS.NMToMeters(1.6)       -- Not more than 1.6 NM port.
    self.BreakLate.Zmax= UTILS.NMToMeters(1)         -- Not more than 1 NM starboard.
    self.BreakLate.LimitXmin= 0                      -- Check and next step 0.8 NM port and in front of boat.
    self.BreakLate.LimitXmax= nil
    self.BreakLate.LimitZmin=-UTILS.NMToMeters(0.5)  -- 926 m port, closer than the stennis as abeam is 0.8-1.0 rather than 1.2
    self.BreakLate.LimitZmax= nil
  
end

--- Calculate distances between carrier and aircraft unit.
-- @param #TIG self
-- @param Wrapper.Unit#UNIT unit Aircraft unit.
-- @return #number Distance [m] in the direction of the orientation of the carrier.
-- @return #number Distance [m] perpendicular to the orientation of the carrier.
-- @return #number Distance [m] to the carrier.
-- @return #number Angle [Deg] from carrier to plane. Phi=0 if the plane is directly behind the carrier, phi=90 if the plane is starboard, phi=180 if the plane is in front of the carrier.
function TIG:_GetDistances(unit)

    -- Vector to carrier
    local a=self.carrier:GetVec3()
  
    -- Vector to player
    local b=unit:GetVec3()
  
    -- Vector from carrier to player.
    local c={x=b.x-a.x, y=0, z=b.z-a.z}
  
    -- Orientation of carrier.
    local x=self.carrier:GetOrientationX()
  
    -- Projection of player pos on x component.
    local dx=UTILS.VecDot(x,c)
  
    -- Orientation of carrier.
    local z=self.carrier:GetOrientationZ()
  
    -- Projection of player pos on z component.
    local dz=UTILS.VecDot(z,c)
  
    -- Polar coordinates.
    local rho=math.sqrt(dx*dx+dz*dz)
  
  
    -- Not exactly sure any more what I wanted to calculate here.
    local phi=math.deg(math.atan2(dz,dx))
  
    -- Correct for negative values.
    if phi<0 then
      phi=phi+360
    end
  
    return dx,dz,rho,phi
end

--- Get final bearing (FB) of carrier.
-- By default, the routine returns the magnetic FB depending on the current map (Caucasus, NTTR, Normandy, Persion Gulf etc).
-- The true bearing can be obtained by setting the *TrueNorth* parameter to true.
-- @param #TIG self
-- @param #boolean magnetic If true, magnetic FB is returned.
-- @return #number FB in degrees.
function TIG:GetFinalBearing(magnetic)

    -- First get the heading.
    local fb=self:GetHeading(magnetic)
  
    -- Final baring = BRC including angled deck.
    fb=fb+self.carrierparam.rwyangle
  
    -- Adjust negative values.
    if fb<0 then
      fb=fb+360
    end
  
    return fb
end

--- Get true (or magnetic) heading of carrier.
-- @param #TIG self
-- @param #boolean magnetic If true, calculate magnetic heading. By default true heading is returned.
-- @return #number Carrier heading in degrees.
function TIG:GetHeading(magnetic)
    self:F3({magnetic=magnetic})
  
    -- Carrier heading
    local hdg=self.carrier:GetHeading()
  
    -- Include magnetic declination.
    if magnetic then
      hdg=hdg-self.magvar
    end
  
    -- Adjust negative values.
    if hdg<0 then
      hdg=hdg+360
    end
  
    return hdg
end

-- @param #TIG self
-- @param #number case Recovery case.
-- @param #boolean magnetic If true, magnetic radial is returned. Default is true radial.
-- @param #boolean offset If true, inlcude holding offset.
-- @param #boolean inverse Return inverse, i.e. radial-180 degrees.
-- @return #number Radial in degrees.
function TIG:GetRadial(case, magnetic, offset, inverse)

    -- Case or current case.
    case=case or self.case
  
    -- Radial.
    local radial
  
    -- Select case.
    if case==1 then
  
      -- Get radial.
      radial=self:GetFinalBearing(magnetic)-180
  
    elseif case==2 then
  
      -- Radial wrt to heading of carrier.
      radial=self:GetHeading(magnetic)-180
  
      -- Holding offset angle (+-15 or 30 degrees usually)
      if offset then
        radial=radial+self.holdingoffset
      end
  
    elseif case==3 then
  
      -- Radial wrt angled runway.
      radial=self:GetFinalBearing(magnetic)-180
  
      -- Holding offset angle (+-15 or 30 degrees usually)
      if offset then
        radial=radial+self.holdingoffset
      end
  
    end
  
    -- Adjust for negative values.
    if radial<0 then
      radial=radial+360
    end
  
    -- Inverse?
    if inverse then
  
      -- Inverse radial
      radial=radial-180
  
      -- Adjust for negative values.
      if radial<0 then
        radial=radial+360
      end
  
    end
  
    return radial
end

function TIG:GetCoordinate()
    return self.carrier:GetCoord()
end

function TIG:_GetSternCoord()

    -- Heading of carrier (true).
    local hdg=self.carrier:GetHeading()

    -- Final bearing (true).
    local FB=self:GetFinalBearing()

    -- Stern coordinate (sterndist<0). Also translate 10 meters starboard wrt Final bearing.
    self.sterncoord:UpdateFromCoordinate(self:GetCoordinate())
    --local stern=self:GetCoordinate()

    -- Stern coordinate (sterndist<0).
    if self.carriertype==TIG.CarrierType.TARAWA then
        -- Tarawa: Translate 8 meters port.
        self.sterncoord:Translate(self.carrierparam.sterndist, hdg, true, true):Translate(8, FB-90, true, true)
    elseif self.carriertype==TIG.CarrierType.STENNIS then
        -- Stennis: translate 7 meters starboard wrt Final bearing.
        self.sterncoord:Translate(self.carrierparam.sterndist, hdg, true, true):Translate(7, FB+90, true, true)
    else
        -- Nimitz SC: translate 8 meters starboard wrt Final bearing.
        self.sterncoord:Translate(self.carrierparam.sterndist, hdg, true, true):Translate(9.5, FB+90, true, true)
    end

    -- Set altitude.
    self.sterncoord:SetAltitude(self.carrierparam.deckheight)

    return self.sterncoord
end


--- Get groove zone.
-- @param #TIG self
-- @param #number l Length of the groove in NM. Default 1.5 NM.
-- @param #number w Width of the groove in NM. Default 0.25 NM.
-- @param #number b Width of the beginning in NM. Default 0.10 NM.
-- @return Core.Zone#ZONE_POLYGON_BASE Groove zone.
function TIG:_GetZoneGroove(l, w, b)

    self.zoneGroove=self.zoneGroove or ZONE_POLYGON_BASE:New("Zone Groove")

    l=l or 1.50
    w=w or 0.25
    b=b or 0.10

    -- Get radial, i.e. inverse of BRC.
    local fbi=self:GetRadial(1, false, false)

    -- Stern coordinate.
    local st=self:_GetSternCoord()

    -- Zone points.
    local c1=st:Translate(self.carrierparam.totwidthstarboard, fbi-90)
    local c2=st:Translate(UTILS.NMToMeters(0.10), fbi-90):Translate(UTILS.NMToMeters(0.3), fbi)
    local c3=st:Translate(UTILS.NMToMeters(0.25), fbi-90):Translate(UTILS.NMToMeters(l),   fbi)
    local c4=st:Translate(UTILS.NMToMeters(w/2),  fbi+90):Translate(UTILS.NMToMeters(l),   fbi)
    local c5=st:Translate(UTILS.NMToMeters(b),    fbi+90):Translate(UTILS.NMToMeters(0.3), fbi)
    local c6=st:Translate(self.carrierparam.totwidthport, fbi+90)

    -- Vec2 array.
    local vec2={c1:GetVec2(), c2:GetVec2(), c3:GetVec2(), c4:GetVec2(), c5:GetVec2(), c6:GetVec2()}

    self.zoneGroove:UpdateFromVec2(vec2)

    -- Polygon zone.
    --local zone=ZONE_POLYGON_BASE:New("Zone Groove", vec2)
    --return zone

    return self.zoneGroove
end

--- Get optimal landing position of the aircraft. Usually between second and third wire. In case of Tarawa we take the abeam landing spot 120 ft abeam the 7.5 position.
-- @param #TIG self
-- @return Core.Point#COORDINATE Optimal landing coordinate.
function TIG:_GetOptLandingCoordinate()

    -- Start with stern coordiante.
    self.landingcoord:UpdateFromCoordinate(self:_GetSternCoord())
  
    -- Stern coordinate.
    --local stern=self:_GetSternCoord()
  
    -- Final bearing.
    local FB=self:GetFinalBearing(false)
  
    if self.carriertype==TIG.CarrierType.TARAWA then
  
      -- Landing 100 ft abeam, 120 ft alt.
      self.landingcoord:UpdateFromCoordinate(self:_GetLandingSpotCoordinate()):Translate(35, FB-90, true, true)
      --stern=self:_GetLandingSpotCoordinate():Translate(35, FB-90)
  
      -- Alitude 120 ft.
      self.landingcoord:SetAltitude(UTILS.FeetToMeters(120))
  
    else
  
      -- Ideally we want to land between 2nd and 3rd wire.
      if self.carrierparam.wire3 then
        -- We take the position of the 3rd wire to approximately account for the length of the aircraft.
        local w3=self.carrierparam.wire3
        self.landingcoord:Translate(w3, FB, true, true)
      end
  
      -- Add 2 meters to account for aircraft height.
      self.landingcoord.y=self.landingcoord.y+2
  
    end
  
    return self.landingcoord
end

--- Get lineup groove zone.
-- @param #TIG self
-- @return Core.Zone#ZONE_POLYGON_BASE Lineup zone.
function TIG:_GetZoneLineup()

    self.zoneLineup=self.zoneLineup or ZONE_POLYGON_BASE:New("Zone Lineup")
  
    -- Get radial, i.e. inverse of BRC.
    local fbi=self:GetRadial(1, false, false)
  
    -- Stern coordinate.
    local st=self:_GetOptLandingCoordinate()
  
    -- Zone points.
    local c1=st
    local c2=st:Translate(UTILS.NMToMeters(0.50), fbi+15)
    local c3=st:Translate(UTILS.NMToMeters(0.50), fbi+self.lue._max-0.05)
    local c4=st:Translate(UTILS.NMToMeters(0.77), fbi+self.lue._max-0.05)
    local c5=c4:Translate(UTILS.NMToMeters(0.25), fbi-90)
  
    -- Vec2 array.
    local vec2={c1:GetVec2(), c2:GetVec2(), c3:GetVec2(), c4:GetVec2(), c5:GetVec2()}
  
    self.zoneLineup:UpdateFromVec2(vec2)
  
    -- Polygon zone.
    --local zone=ZONE_POLYGON_BASE:New("Zone Lineup", vec2)
    --return zone
  
    return self.zoneLineup
end

--- Get groove data.
-- @param #TIG self
-- @param #TIG.PlayerData playerData Player data table.
-- @return #TIG.GrooveData Groove data table.
function TIG:_GetGrooveData(playerData)
    self:T(self.lid.."INFO: Getting groove data")
    -- Get distances between carrier and player unit (parallel and perpendicular to direction of movement of carrier).
    local X, Z=self:_GetDistances(playerData.unit)

    -- Stern position at the rundown.
    local stern=self:_GetSternCoord()

    -- Distance from rundown to player aircraft.
    local rho=stern:Get2DDistance(playerData.unit:GetCoordinate())

    -- Aircraft is behind the carrier.
    local astern=X<self.carrierparam.sterndist

    -- Correct sign. Negative if passed rundown.
    if astern==false then
        rho=-rho
    end

        -- Velocity vector.
    local vel=playerData.unit:GetVelocityVec3()

    -- Gather pilot data.
    local groovedata={} --#TIG.GrooveData
    groovedata.Time=timer.getTime()
    groovedata.Rho=rho
    groovedata.X=X
    groovedata.Z=Z
    groovedata.Roll=playerData.unit:GetRoll()
    groovedata.Pitch=playerData.unit:GetPitch()
    groovedata.Yaw=playerData.unit:GetYaw()
    groovedata.Height=playerData.unit:GetHeight()
    groovedata.Vel=UTILS.VecNorm(vel)
    groovedata.Vy=vel.y

    --env.info(string.format(", %.6f, %.6f, %.6f, %.6f, %.6f, %.6f, %.6f", groovedata.Time, groovedata.Rho, groovedata.X, groovedata.Alt, groovedata.GSE, groovedata.LUE, groovedata.AoA))

    return groovedata
end

--- In the groove.
-- @param #TIG self
-- @param #TIG.PlayerData playerData Player data table.
function TIG:_Groove(playerData)
    self:T(self.lid.."INFO: Running _Groove")
    -- Ranges in the groove.
    local RX2=UTILS.NMToMeters(2.500)
    local RX1=UTILS.NMToMeters(1.500)
    local RX0=UTILS.NMToMeters(1.000) -- Everything before X    1.00  = 1852 m
    local RXX=UTILS.NMToMeters(0.750) -- Start of groove.       0.75  = 1389 m
    local RIM=UTILS.NMToMeters(0.500) -- In the Middle          0.50  =  926 m (middle one third of the glideslope)
    local RIC=UTILS.NMToMeters(0.250) -- In Close               0.25  =  463 m (last one third of the glideslope)
    local RAR=UTILS.NMToMeters(0.044) -- At the Ramp.           0.03  =   55 m
  
    -- Groove data.
    local groovedata=self:_GetGrooveData(playerData)
  
    -- Coords.
    local X=groovedata.X
  
    -- Shortcuts.
    local rho=groovedata.Rho
    self:T(string.format("%s INFO: Rho-%i, Inzone-%s, Roll-%i, Vel-%i, XDist-%i", self.lid, rho, tostring(playerData.unit:IsInZone(self:_GetZoneGroove())), groovedata.Roll, groovedata.Vel, groovedata.X))
  
    if (playerData.unit:IsInZone(self:_GetZoneGroove()) and groovedata.Height<=190 and math.abs(groovedata.Roll)<=4.0 and groovedata.Vel >=40 and groovedata.Vel <= 460) and playerData.TIG0 == nil then
        self:T(self.lid.."INFO: Starting groove timer")
        -- Start time in groove
        playerData.TIG0=timer.getTime()

    elseif not (playerData.unit:IsInZone(self:_GetZoneLineup())) and groovedata.Vel<=25 and playerData.TIG0 ~= nil then
        self:T(self.lid.."INFO: Ending groove timer for trap")
        -- Trapped, end TIG
        playerData.Tgroove = timer.getTime() - playerData.TIG0
        playerData.TIG0 = nil

    -- Player infront of the carrier X>~77 m.
    elseif X>self.carrierparam.totlength+self.carrierparam.sterndist and playerData.TIG0 ~= nil then
        self:T(self.lid.."INFO: Ending groove timer for bolter/WO")
        --Boltered, end TIG
        playerData.Tgroove = timer.getTime() - playerData.TIG0
        playerData.TIG0 = nil
    end
end

--- Check current player status.
function TIG:_CheckPlayerStatus()
    -- Loop over all players.
    for _playerName,_playerData in pairs(self.players) do
        local playerData=_playerData --#TIG.PlayerData

        if playerData then
            -- Player unit.
            local unit=playerData.unit
            -- Check if unit is alive.
            if unit and unit:IsAlive() then
                -- Check if player is in carrier controlled area (zone with R=50 NM around the carrier).
                -- TODO: This might cause problems if the CCA is set to be very small!
                if unit:IsInZone(self.zoneCCA) then
                    self:_Groove(playerData)
                else
                    self:T2(self.lid.."WARNING: Player unit not inside the CCA!")
                end
            else
                -- Unit not alive.
                self:T(self.lid.."WARNING: Player unit is not alive!")
                
            end
        end
    end
end

--Main Body
for k, unitName in pairs(Carrier_Units) do
    local _carrierUnit = UNIT:FindByName(unitName)
    local _group = _carrierUnit:GetGroup()
    local groupName = _group.GroupName
    
    CVNGroups[groupName] = NAVYGROUP:New(groupName)
    CVNGroups[groupName].TopMenu = MENU_COALITION:New(CVNGroups[groupName]:GetCoalition(), string.format("%s Menu", unitName))
    AddTurninIntoWindMenu(CVNGroups[groupName])

    CVNGroups[groupName].TopMenu.CaseType = MENU_COALITION:New(CVNGroups[groupName]:GetCoalition(), "Set CASE Type", CVNGroups[groupName].TopMenu)
    MENU_COALITION_COMMAND:New(CVNGroups[groupName]:GetCoalition(), "CASE I & II", CVNGroups[groupName].TopMenu.CaseType, SetCaseType, 1, CVNGroups[groupName])
    MENU_COALITION_COMMAND:New(CVNGroups[groupName]:GetCoalition(), "CASE III", CVNGroups[groupName].TopMenu.CaseType, SetCaseType, 3, CVNGroups[groupName])
    
    local _tempNavyGroup = CVNGroups[groupName]

    function _tempNavyGroup:onafterTurnIntoWindOver(From, Event, To, IntoWindData)
        self.EndTurnIntoWindCommand:Remove()
        self.TIWTimeRemainingCommand:Remove()
        AddTurninIntoWindMenu(self)
        MESSAGE:New(string.format("%s returning to patrol route", self:GetName())):ToCoalition(self:GetCoalition())
    end

    --New TIG Object
    CVNTIG[unitName] = TIG:New(unitName)
    SCHEDULER:New(nil,function()
        CVNTIG[unitName]:_CheckPlayerStatus()
    end,{},2,0.5)

end


--DCS.log output for LsoBot
BASE:HandleEvent(EVENTS.Land)
function BASE:OnEventLand(EventData)
    if EventData.IniPlayerName then
        local _missionTime = UTILS.SecondsToClock(UTILS.SecondsOfToday(),true)

        --If a player has set case type to III, don't include TIG
        
        if CVNTIG.PlayerCaseType == 3 then

            TIMER:New(function(EventData, _missionTime)
                local _playerTIG = nil
                local _outputString = string.format("Landing_Data | UnitType:%s,Player-Name:%s,Place:%s,TIG:%i,MissionTime:%s", EventData.IniTypeName, EventData.IniPlayerName, EventData.PlaceName, _playerTIG, _missionTime)
                BASE:E(_outputString)
            end, EventData, _missionTime):Start(5)

        else

            TIMER:New(function(EventData, _missionTime)
                local _playerTIG = CVNTIG[EventData.PlaceName].players[EventData.IniPlayerName].Tgroove
                local _outputString = string.format("Landing_Data | UnitType:%s,Player-Name:%s,Place:%s,TIG:%i,MissionTime:%s", EventData.IniTypeName, EventData.IniPlayerName, EventData.PlaceName, _playerTIG, _missionTime)
                BASE:E(_outputString)
            end, EventData, _missionTime):Start(5)
            
        end
        
        

    end
end