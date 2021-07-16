--[[//////////////////////////////////////////////
File: ATIS-Caucasus.lua
Author: kleiro
Created: 8th June 2021, 09:03:33
-----
Last Modified: 9th June 2021, 13:11:11
Modified By: kleiro
//////////////////////////////////////////////////]]

--[[//////////////////////////////////////////////
        Ciribob's DCS-SimpleTextToSpeech 0.4
//////////////////////////////////////////////////]]
--[[

DCS-SimpleTextToSpeech
Version 0.4
Compatible with SRS version 1.9.6.0 +

DCS Modification Required:

You will need to edit MissionScripting.lua in DCS World/Scripts/MissionScripting.lua and remove the sanitisation.
To do this remove all the code below the comment - the line starts "local function sanitizeModule(name)"

Do this without DCS running to allow mission scripts to use os functions.

*You WILL HAVE TO REAPPLY AFTER EVERY DCS UPDATE*

USAGE:

Add this script into the mission as a DO SCRIPT or DO SCRIPT FROM FILE to initialise it

Make sure to edit the STTS.SRS_PORT and STTS.DIRECTORY to the correct values before adding to the mission.

Then its as simple as calling the correct function in LUA as a DO SCRIPT or in your own scripts

Example calls:

STTS.TextToSpeech("Hello DCS WORLD","251","AM","1.0","SRS",2)

Arguments in order are:
 - Message to say, make sure not to use a newline (\n) !
 - Frequency in MHz
 - Modulation - AM/FM
 - Volume - 1.0 max, 0.5 half
 - Name of the transmitter - ATC, RockFM etc
 - Coalition - 0 spectator, 1 red 2 blue
 - OPTIONAL - Vec3 Point i.e Unit.getByName("A UNIT"):getPoint() - needs Vec3 for Height! OR null if not needed
 - OPTIONAL - Speed -10 to +10
 - OPTIONAL - Gender male, female or neuter
 - OPTIONAL - Culture - en-US, en-GB etc
 - OPTIONAL - Voice - a specfic voice by name. Run DCS-SR-ExternalAudio.exe with --help to get the ones you can use on the command line
 - OPTIONAL - Google TTS - Switch to Google Text To Speech - Requires STTS.GOOGLE_CREDENTIALS path and Google project setup correctly

 This example will say the words "Hello DCS WORLD" on 251 MHz AM at maximum volume with a client called SRS and to the Blue coalition only

STTS.TextToSpeech("Hello DCS WORLD","251","AM","1.0","SRS",2,null,-5,"male","en-GB")

 This example will say the words "Hello DCS WORLD" on 251 MHz AM at maximum volume with a client called SRS and to the Blue coalition only centered on
 the position of the Unit called "A UNIT"

STTS.TextToSpeech("Hello DCS WORLD","251","AM","1.0","SRS",2,Unit.getByName("A UNIT"):getPoint(),-5,"male","en-GB")

Arguments in order are:
 - FULL path to the MP3 OR OGG to play
 - Frequency in MHz - to use multiple separate with a comma - Number of frequencies MUST match number of Modulations
 - Modulation - AM/FM - to use multiple
 - Volume - 1.0 max, 0.5 half
 - Name of the transmitter - ATC, RockFM etc
 - Coalition - 0 spectator, 1 red 2 blue

This will play that MP3 on 255MHz AM & 31 FM at half volume with a client called "Multiple" and to Spectators only

STTS.PlayMP3("C:\\Users\\Ciaran\\Downloads\\PR-Music.mp3","255,31","AM,FM","0.5","Multiple",0)

]]


-- STTS = {}
-- FULL Path to the FOLDER containing DCS-SR-ExternalAudio.exe - EDIT TO CORRECT FOLDER
-- STTS.DIRECTORY = "C:\\Users\\Ciaran\\Dropbox\\Dev\\DCS\\DCS-SRS\\install-build"
STTS.SRS_PORT = 5002 -- LOCAL SRS PORT - DEFAULT IS 5002
--STTS.GOOGLE_CREDENTIALS = "C:\\Users\\Ciaran\\Downloads\\googletts.json"

-- DONT CHANGE THIS UNLESS YOU KNOW WHAT YOU'RE DOING
STTS.EXECUTABLE = "DCS-SR-ExternalAudio.exe"

local random = math.random
function STTS.uuid()
    local template ='yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
end

function STTS.round(x, n)
    n = math.pow(10, n or 0)
    x = x * n
    if x >= 0 then x = math.floor(x + 0.5) else x = math.ceil(x - 0.5) end
    return x / n
end

function STTS.getSpeechTime(length,speed,isGoogle)
    -- Function returns estimated speech time in seconds

    -- Assumptions for time calc: 100 Words per min, avarage of 5 letters for english word
    -- so 5 chars * 100wpm = 500 characters per min = 8.3 chars per second
    -- so lengh of msg / 8.3 = number of seconds needed to read it. rounded down to 8 chars per sec
    -- map function:  (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min

    local maxRateRatio = 3 

    speed = speed or 1.0
    isGoogle = isGoogle or false

    local speedFactor = 1.0
    if isGoogle then
        speedFactor = speed
    else
        if speed ~= 0 then
            speedFactor = math.abs(speed) * (maxRateRatio - 1) / 10 + 1
        end
        if speed < 0 then
            speedFactor = 1/speedFactor
        end
    end

    local wpm = math.ceil(100 * speedFactor)
    local cps = math.floor((wpm * 5)/60)

    if type(length) == "string" then
        length = string.len(length)
    end

    return math.ceil(length/cps)
end

function STTS.TextToSpeech(message,freqs,modulations, volume,name, coalition,point, speed,gender,culture,voice, googleTTS )
    if os == nil or io == nil then 
        env.info("[DCS-STTS] LUA modules os or io are sanitized. skipping. ")
        return 
    end

	speed = speed or 1
	gender = gender or "female"
	culture = culture or ""
	voice = voice or ""


    message = message:gsub("\"","\\\"")
    
    local cmd = string.format("start /min \"\" /d \"%s\" /b \"%s\" -f %s -m %s -c %s -p %s -n \"%s\" -h", STTS.DIRECTORY, STTS.EXECUTABLE, freqs, modulations, coalition,STTS.SRS_PORT, name )
    
    if voice ~= "" then
    	cmd = cmd .. string.format(" -V \"%s\"",voice)
    else

    	if culture ~= "" then
    		cmd = cmd .. string.format(" -l %s",culture)
    	end

    	if gender ~= "" then
    		cmd = cmd .. string.format(" -g %s",gender)
    	end
    end

    if googleTTS == true then
        cmd = cmd .. string.format(" -G \"%s\"",STTS.GOOGLE_CREDENTIALS)
    end

    if speed ~= 1 then
        cmd = cmd .. string.format(" -s %s",speed)
    end

    if volume ~= 1.0 then
        cmd = cmd .. string.format(" -v %s",volume)
    end

    if point and type(point) == "table" and point.x then
        local lat, lon, alt = coord.LOtoLL(point)

        lat = STTS.round(lat,4)
        lon = STTS.round(lon,4)
        alt = math.floor(alt)

        cmd = cmd .. string.format(" -L %s -O %s -A %s",lat,lon,alt)        
    end

    cmd = cmd ..string.format(" -t \"%s\"",message)

    if string.len(cmd) > 255 then
        local filename = os.getenv('TMP') .. "\\DCS_STTS-" .. STTS.uuid() .. ".bat"
        local script = io.open(filename,"w+")
        script:write(cmd .. " && exit" )
        script:close()
        cmd = string.format("\"%s\"",filename)
        timer.scheduleFunction(os.remove, filename, timer.getTime() + 1) 
    end

    if string.len(cmd) > 255 then
         env.info("[DCS-STTS] - cmd string too long")
         env.info("[DCS-STTS] TextToSpeech Command :\n" .. cmd.."\n")
    end
    os.execute(cmd)

    return STTS.getSpeechTime(message,speed,googleTTS)

end

function STTS.PlayMP3(pathToMP3,freqs,modulations, volume,name, coalition,point )

    local cmd = string.format("start \"\" /d \"%s\" /b /min \"%s\" -i \"%s\" -f %s -m %s -c %s -p %s -n \"%s\" -v %s -h", STTS.DIRECTORY, STTS.EXECUTABLE, pathToMP3, freqs, modulations, coalition,STTS.SRS_PORT, name, volume )
    
    if point and type(point) == "table" and point.x then
        local lat, lon, alt = coord.LOtoLL(point)

        lat = STTS.round(lat,4)
        lon = STTS.round(lon,4)
        alt = math.floor(alt)

        cmd = cmd .. string.format(" -L %s -O %s -A %s",lat,lon,alt)        
    end

    env.info("[DCS-STTS] MP3/OGG Command :\n" .. cmd.."\n")
    os.execute(cmd)

end


--[[//////////////////////////////////////////////
                BEGIN THEATER ATIS
//////////////////////////////////////////////////]]
ATIS = {}
ATIS.airfields = {
    ["Kutaisi"] = {
        ["freq"] = 122.1,
        ["name"] = "Kuteysee"
    },
    ["Senaki-Kolkhi"] = {
        ["freq"] = 122.525,
        ["name"] = "Senahkee-Coalkhee"
    },
    ["Kobuleti"] = {
        ["freq"] = 122.3,
        ["name"] = "Kohbooletee"
    },
    ["Batumi"] = {
        ["freq"] = 122.550,
        ["name"] = "Beh-toomee"
    },
    ["Tbilisi-Lochini"] = {
        ["freq"] = 132.8,
        ["name"] = "Tiblisi-Lo-cheenee"
    },
    ["Vaziani"] = {
        ["freq"] = 122.7,
        ["name"] = "Vah-zee-ahnee"
    },
}

function roundDecimal(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
  end
  

function GetMissionWeather()

    -- Weather data from mission file.
    local weather=env.mission.weather
  
    local clouds=weather.clouds
  
    -- 0=static, 1=dynamic
    local static=weather.atmosphere_type==0
  
    -- Visibilty distance in meters.
    local visibility=weather.visibility.distance
  
    -- Ground turbulence.
    local turbulence=weather.groundTurbulence
  
    local dust=nil
    if weather.enable_dust==true then
      dust=weather.dust_density
    end
  
    local fog=nil
    if weather.enable_fog==true then
      fog=weather.fog
    end
  
    return clouds, visibility, turbulence, fog, dust, static
end

function SRATIS(_airfield)
    local _airfieldCoord = AIRBASE:FindByName(_airfield):GetCoord()
    local _height = _airfieldCoord:GetLandHeight()
    local _windDir, _windStr = _airfieldCoord:GetWind()
        _windDir = math.floor(_windDir)
        _windStr = math.ceil(UTILS.MpsToKnots(_windStr))
    local _qfe = UTILS.hPa2inHg(_airfieldCoord:GetPressure(_height))
    local _qnh = UTILS.hPa2inHg(_airfieldCoord:GetPressure(0))
    local _slp = _airfieldCoord:GetPressure(0)
        _qfe = roundDecimal(_qfe, 2)
        _qnh = roundDecimal(_qnh, 2)
        _slp = roundDecimal(_slp, 0)
    local _temperature = _airfieldCoord:GetTemperature(_height)

    local _freq = tostring(ATIS.airfields[_airfield].freq)
    
    
      -- Get mission weather info. Most of this is static.
    local clouds, visibility, turbulence, fog, dust, static = GetMissionWeather()

    -- Check that fog is actually "thick" enough to reach the airport. If an airport is in the mountains, fog might not affect it as it is measured from sea level.
    if fog and fog.thickness<_height+25 then
        fog=nil
    end

    -- Dust only up to 1500 ft = 457 m ASL.
    if dust and _height+25>UTILS.FeetToMeters(1500) then
        dust=nil
    end

      -- Get min visibility.
    local visibilitymin=visibility

    if fog then
        if fog.visibility<visibilitymin then
            visibilitymin=fog.visibility
        end
    end

    if dust then
        if dust<visibilitymin then
            visibilitymin=dust
        end
    end

    -- max reported visibility 10 NM
    local reportedviz=UTILS.Round(UTILS.MetersToNM(visibilitymin))
    if reportedviz > 10 then
        reportedviz=10
    end


    --------------
    --- Clouds ---
    --------------

    local cloudbase=clouds.base
    cloudbase = UTILS.MetersToFeet(cloudbase)
    cloudbase = 100 * math.floor((cloudbase + 50) / 100)
    local cloudceil=clouds.base+clouds.thickness
    local clouddens=clouds.density

    -- Cloud preset (DCS 2.7)  
    local cloudspreset=clouds.preset or "Nothing"
    
    -- Precepitation: 0=None, 1=Rain, 2=Thunderstorm, 3=Snow, 4=Snowstorm.
    local precepitation=0  

    if cloudspreset:find("Preset10") then
        -- Scattered 5
        clouddens = "scattered"
    elseif cloudspreset:find("Preset11") then
        -- Scattered 6
        clouddens = "scattered"
    elseif cloudspreset:find("Preset12") then
        -- Scattered 7
        clouddens = "scattered"
    elseif cloudspreset:find("Preset13") then
        -- Broken 1
        clouddens = "broken"
    elseif cloudspreset:find("Preset14") then
        -- Broken 2
        clouddens = "broken"        
    elseif cloudspreset:find("Preset15") then
        -- Broken 3
        clouddens = "broken"        
    elseif cloudspreset:find("Preset16") then
        -- Broken 4
        clouddens = "broken"        
    elseif cloudspreset:find("Preset17") then
        -- Broken 5
        clouddens = "broken"        
    elseif cloudspreset:find("Preset18") then
        -- Broken 6
        clouddens = "broken"        
    elseif cloudspreset:find("Preset19") then
        -- Broken 7
        clouddens = "broken"        
    elseif cloudspreset:find("Preset20") then
        -- Broken 8
        clouddens = "broken"        
    elseif cloudspreset:find("Preset21") then
        -- Overcast 1
        clouddens = "Overcast"        
    elseif cloudspreset:find("Preset22") then
        -- Overcast 2
        clouddens = "Overcast"        
    elseif cloudspreset:find("Preset23") then
        -- Overcast 3
        clouddens = "Overcast"        
    elseif cloudspreset:find("Preset24") then
        -- Overcast 4
        clouddens = "Overcast"        
    elseif cloudspreset:find("Preset25") then
        -- Overcast 5
        clouddens = "Overcast"        
    elseif cloudspreset:find("Preset26") then
        -- Overcast 6
        clouddens = "Overcast"        
    elseif cloudspreset:find("Preset27") then
        -- Overcast 7
        clouddens = "Overcast"                        
    elseif cloudspreset:find("Preset1") then
        -- Light Scattered 1
        clouddens = "Few"
    elseif cloudspreset:find("Preset2") then
        -- Light Scattered 2
        clouddens = "Few"
    elseif cloudspreset:find("Preset3") then
        -- High Scattered 1
        clouddens = "scattered"
    elseif cloudspreset:find("Preset4") then
        -- High Scattered 2
        clouddens = "scattered"
    elseif cloudspreset:find("Preset5") then
        -- Scattered 1
        clouddens = "scattered"
    elseif cloudspreset:find("Preset6") then
        -- Scattered 2
        clouddens = "scattered"
    elseif cloudspreset:find("Preset7") then
        -- Scattered 3
        clouddens = "scattered"
    elseif cloudspreset:find("Preset8") then
        -- High Scattered 3
        clouddens = "scattered"
    elseif cloudspreset:find("Preset9") then
        -- Scattered 4
        clouddens = "scattered"
    elseif cloudspreset:find("RainyPreset") then
        -- Overcast + Rain
        clouddens = "Overcast"
        if _temperature>5 then
            precipitation=1  -- rain
        else
            precipitation=3  -- snow
        end
    end

    local _time = timer.getAbsTime()
    -- Conversion to Zulu time.
    _time = _time - UTILS.GMTToLocalTimeDifference()*60*60
    if _time < 0 then
        _time = 24*60*60 + _time --avoid negative time around midnight
    end
    local _clock=UTILS.SecondsToClock(_time)

    --Number Formatting
    ----------------------------
    --Time
    _clock = string.gsub( _clock,":(%d%d):%d%d%+0","%1" )
    _clock = string.gsub(_clock,".", "%1 "):sub(1,-2)

    --Wind
    _windDir = string.gsub( _windDir,"%..*","")
    _windStr = string.gsub( _windStr,"%..*","")

    _windDir = string.gsub(_windDir,".", "%1 "):sub(1,-2)
    _windStr = string.gsub(_windStr,".", "%1 "):sub(1,-2)

    --Visibility
    reportedviz = string.gsub(reportedviz,".", "%1 "):sub(1,-2)

    --Temperature
    _temperature = string.gsub(_temperature,"%..*","")
    _temperature = string.gsub(_temperature,".", "%1 "):sub(1,-2)

    --Altimeter
    _qnh = string.gsub(_qnh,"%.", "")
    _qfe = string.gsub(_qfe,"%.", "")
    _slp = string.gsub(_slp,"%.", "")

    _qnh = string.gsub(_qnh,".", "%1 "):sub(1,-2)
    _qfe = string.gsub(_qfe,".", "%1 "):sub(1,-2)
    _slp = string.gsub(_slp,".", "%1 "):sub(1,-2)


    local _wxString = string.format("%s Automated Weather Observation, %s Zulu, Wihnd %s at %s, Visibility %s , Sky Condition %s %s, Temperature %s Celsius, Altimeter %s, Remarks: QFE %s, Sea Level Pressure %s", ATIS.airfields[_airfield].name, _clock, _windDir, _windStr, reportedviz, clouddens, cloudbase, _temperature, _qnh, _qfe, _slp)
    STTS.TextToSpeech(_wxString, _freq, "AM", "1.0", _airfield.."-ATIS", 2, nil, -1, "female", "en-US", "Microsoft Zira Desktop")

end

for _airfield,_data in pairs(ATIS.airfields) do

    SCHEDULER:New(nil, SRATIS,{_airfield}, 2, 30)
end