#include "sources/commons/constants.lua"
#include "sources/prefab.lua"

Environment = {
    space1 = {
        type = 'environment',
        name='space1',
        tags='space1',
        template = "sunset", -- not working aftyer 1.5.4 api updater
        skybox = CONSTANTS.SKYBOX.SPACE,
        skyboxtint = '0.01 0.01 0.01', -- need to comment beacause this work with template
        skyboxbrightness = '10',
        ambient = '50',
        ambientexponent = '500000',
        fogcolor = '0.0 0.0 0.0',
        fogParams = '0 0 0 0',
        sunBrightness = '10',
        sunColorTint = '1.0 1.0 1.0',
        sunFogScale = '0.05',
        sunGlare = '0.3', -- sun strenght and scale
        brightness = '1',
        nightlight = 'false',
        fogscale = '0.0'
    }
}

--[[ 
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    LoadCustomEnvironment
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    Load a custom environment pre-set as table;

    configNumber: int - Env config number in table
    debug: boolean - Activate or not debugPrint
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
]]--

function CreateEnvironmentDirectly(environment)
    -- SetEnvironmentProperty("template", "sunset")
    local avoid = { 'type', 'template'} -- keys to avoid due the update 1.5.4 of API
    if (environment) then
        SetEnvironmentDefault()
        for key, value in pairs(environment) do
            print(key, value)
            if avoid[1] ~= 'type' or avoid[2] ~= 'template' then
                SetEnvironmentProperty(key, value)
                print("Environment: ".. tostring(key) .. "=" .. tostring(value)) 
            end
        end
    else
        print("[x] Error: not a valid env.")
    end
    print("[+] Finishing setting env.")
end

function CreateEnvironmentByPrefab(prefabProperties)
    -- SetEnvironmentProperty("template", "sunset")
    local avoid = { 'type', 'template'} -- keys to avoid due the update 1.5.4 of API
    if (prefabProperties) then
        CreateXMLPrefab(prefabProperties, nil)
        print("[+] Finishing prefab env.")
    else
        print("[x] Error: not a valid env.")
    end
end