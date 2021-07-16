--[[Automated script to issue mission restart messages
based on missionHours variable set in ME, switch the flag 9999 to 10
]]

local _missionLength = missionHours*60

--60 Minute Warning
SCHEDULER:New(nil, function()
    MESSAGE:New("*** 60 minutes until mission end ***", 15, "", true):ToAll()
end, {}, (_missionLength-60)*60)

--30 Minute Warning
SCHEDULER:New(nil, function()
    MESSAGE:New("*** 30 minutes until mission end ***", 15, "", true):ToAll()
end, {}, (_missionLength-30)*60)

--15 Minute Warning
SCHEDULER:New(nil, function()
    MESSAGE:New("*** 15 minutes until mission end ***", 15, "", true):ToAll()
end, {}, (_missionLength-15)*60)

--5 Minute Warning
SCHEDULER:New(nil, function()
    MESSAGE:New("*** 5 minutes until mission end ***", 15, "", true):ToAll()
end, {}, (_missionLength-5)*60)

--1 Minute Warning
SCHEDULER:New(nil, function()
    MESSAGE:New("*** 1 minute until mission end ***", 15, "", true):ToAll()
end, {}, (_missionLength-1)*60)

--Flag Switch
SCHEDULER:New(nil, function()
    USERFLAG:New("9999"):Set(10)
end, {}, _missionLength*60)