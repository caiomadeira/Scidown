#include "sources/prefab.lua"
#include "sources/utils.lua"
#include "sources/commons/constants.lua"
#include "../settings.lua"

--[[
**************************************************************
PopulateSpace()

--------------------------------------------------------------
Populate scene with celestial bodies with random spawn
**************************************************************
]]--


function PopulateSpace()
    print("[+] PopulateSpace() Called")
    -- Generates a random number referring to the number of bodies that must be generated
    local minBodyCount = 10;
    local maxBodyCount = 20;
    --local bodyCount = math.random(minBodyCount, maxBodyCount);
    local bodyCount = 4
    local celestialBody;
    -- :::::::::::::::::::::::::
    -- :::: distanceDivider ::::
    -- :::::::::::::::::::::::::
    -- Provides a magic number wich dividers and change the proximity with player
    -- if the number is high, the proximity withc player is higher, otherwise,
    -- if the number is LOW, the object is FAR from player
    local distanceDivider = math.random(2, 8)

    --[[ implement spawn chances
    local spawnChances = {
        ["Rock"] = {min = 1, max = 5},
        ["Sand"] = {min = 4, max = 12},
        ["Glass"] = {min = 20, max = 45},
    }
    ]]--

    print("[>>>] World Celestial Body Count: ", bodyCount)

    -- Random celestial bodies prefab to spawn
    -- Will be interesting implement some logic with the property 'spawnChance' later
    -- SpawnCelestialBody(CelestialBodies.STAR, true)
    local bodiesGenerated = {  }
    local names = {  }
    local tSize = tlen(CelestialBodies)
    print("length func: ", tSize)
    for k, _ in pairs(CelestialBodies) do
        table.insert(names, CelestialBodies[k].name)
    end
    -- Run loop to execute the function
    for i=1, 5 do
        local randomCelestialBName = names[math.random(#names)]
        SpawnCelestialBody(CelestialBodies[randomCelestialBName], true, distanceDivider)
        table.insert(bodiesGenerated, CelestialBodies[randomCelestialBName].name)
    end
    print(">> BODIES GENERATED: ", dump(bodiesGenerated))
end

--[[
**************************************************************
SpawnCelestialBody(properties, allowRandomSpawn)

--------------------------------------------------------------
Create a custom celestial body with Random (or not) Properties
**************************************************************
]]--

function SpawnCelestialBody(properties, allowRandomSpawn, distance)

    print("distance divider: ", distance)

    if (properties ~= nil) then
        CreateCelestialBody(properties, allowRandomSpawn, distance)
    else
        print("[x] CreateCustomCelestialBody: OBJECT IS NIL")
    end
end