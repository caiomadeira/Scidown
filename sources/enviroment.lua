#include "sources/commons/constants.lua"

spaceEnviromentConfig = {
    template = "sunny",
    skybox = "MOD/assets/skybox/space.dds",
    skyboxtint = {0.01, 0.01, 0.01}, -- apply something like a filter
    skyboxbrightness = 10,
    ambient = 100,
    ambientexponent = 500000,
    fogcolor = {0.0, 0.0, 0.0},
    fogParams = {0, 0, 0, 0},
    sunBrightness = 10,
    sunColorTint = {1.0, 1.0, 1.0},
    sunFogScale = 0.05,
    sunGlare = 0.3, -- sun strenght and scale
    brightness = 1,
    nightlight = false,
    fogscale = 0.0
}

testEnviromentConfig = {
    template = "sunset",
    skybox = "cloudy.dds",
}

--[[ 
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    loadCustomEnvironment
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    Load a custom environment pre-set as table;

    configNumber: int - Env config number in table
    debug: boolean - Activate or not debugPrint
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
]]--

function loadCustomEnvironment(configNumber, debug)
    local enviromentsList = {
        [1] = spaceEnviromentConfig,
        [2] = testEnviromentConfig,
    }

    local config = enviromentsList[configNumber]
    if (config) then
        SetEnvironmentDefault()
        SetCustomEnvrionmentConfig(debug, config)
    else
        if debug then
            DebugPrint("[x] Error: not a valid env.")
        end
    end
    if debug then
        DebugPrint("[+] Finishing setting env.")
    end
end


--[[ 
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    SetCustomEnvrionmentConfig
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    Set and fill environment properties with the table env config;

    configNumber: int - Env config number in table;
    debug: boolean - Activate or not debugPrint;
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
]]--

function SetCustomEnvrionmentConfig(debug, enviromentConfig)
    SetEnvironmentDefault()
    -- Interating over table with pairs (key and value)
    for key, value in pairs(enviromentConfig) do
        if (type(value) == 'table') then
            SetEnvironmentProperty(key, value[1], value[2], value[3])
            if debug == true then
                DebugPrint("TABLE:" .. tostring(key) .. "=" .. tostring(value[1]) .. tostring(value[2]) .. tostring(value[3]) )
            end
        else   
            SetEnvironmentProperty(key, value)
            if debug == true then
                DebugPrint(tostring(key) .. "=" .. tostring(value))
            end
        end
    end
end