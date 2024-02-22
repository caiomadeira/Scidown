#include "utils.lua"

frame = 0

spaceEnviromentConfig = {
    template = "sunny",
    skybox = "MOD/assets/skybox/space.dds",
    skyboxtint = {0.01, 0.01, 0.01},
    skyboxbrightness = 10,
    ambient = 100,
    ambientexponent = 500000,
    fogcolor = {0.0, 0.0, 0.0},
    fogParams = {0, 0, 0, 0},
    sunBrightness = 10,
    sunColorTint = {1.0, 1.0, 1.0},
    sunFogScale = 0.05,
    sunGlare = 0.7,
    brightness = 1,
    nightlight = false,
    fogscale = 1.0
}

testEnviromentConfig = {
    template = "sunset",
    skybox = "cloudy.dds",
}

function init() -- CALLED WHEN THE SCRIPT INITIALIZES
    DebugPrint("init main.lua")
    --getEnvironmentConfig(true)
    loadCustomEnvironment(2, true)
end

function tick()
    -- DebugPrint("Player Velocity: "..GetPlayerVelocity())
    --frame = frame + 1
    --crazyGravityEffect(frame)
end

function update(dt)
    crazyGravityEffect(dt)
end

-- Maybe should i use this like a blackhole proximity effect?
-- To make a crazy effect i need to increment frame = frame + 1 and call to tick()
function crazyGravityEffect(frame)
    SetPlayerVelocity(VecAdd(GetPlayerVelocity(), Vec(0, 10*frame, 0)))
end

function GravityJump()
    body = FindBody('body', true)



end

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
--[[
function configureEnvironment()
    SetEnvironmentDefault() -- Útil para setar um novo environment
    SetEnvironmentProperty("template", "sunny")
    SetEnvironmentProperty("skybox", "MOD/assets/skybox/space.dds")
    SetEnvironmentProperty("skyboxtint", 0.01, 0.01, 0.01)
    SetEnvironmentProperty("skyboxbrightness", 10)
    SetEnvironmentProperty("ambient", 100)
    SetEnvironmentProperty("ambientexponent", 500000)
    SetEnvironmentProperty("fogcolor", 0.0, 0.0, 0.0)
    SetEnvironmentProperty("fogParams", 0, 0, 0, 0)
    SetEnvironmentProperty("sunBrightness", 10)
    SetEnvironmentProperty("sunColorTint", 1.0, 1.0, 1.0)
    SetEnvironmentProperty("sunFogScale", 0.05)
    SetEnvironmentProperty("sunGlare", 0.7)
    SetEnvironmentProperty("brightness", 1)
    SetEnvironmentProperty("nightlight", false)

    -- THIS PROPERTY (EXPOSURE IS COUSING SOME TROUBLE DONT USE IT
    --SetEnvironmentProperty("exposure", 0.7)

    DebugPrint("Environment configured")
end
]]--

--[[ Gravity function - back another time to this
function update(dt)
    bodies = FindBodies(nil,true)
    SetPlayerVelocity(VecAdd(GetPlayerVelocity(),Vec(0,dt*10,0)))
    for i in pairs(bodies) do
        local btrans = GetBodyTransform(bodies[i])
        if IsBodyActive(bodies[i]) then
            ApplyBodyImpulse(bodies[i],TransformToParentPoint(btrans,GetBodyCenterOfMass(bodies[i])),Vec(0,GetBodyMass(bodies[i])*dt*10,0))
        end
    end
end ]]--


function logFile(content1, content2)
    local file, err = io.open("logFile.txt", 'w')
    if file then
        file:write(tostring(content1))
        file:write(tostring(content2))
        file:close()
    else
        DebugPrint("error: ", err)
    end
end