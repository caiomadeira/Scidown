#include "sources/prefab.lua"
#include "sources/utils.lua"
#include "sources/commons/constants.lua"
#include "../settings.lua"

CelestialBodies = {
    STAR = { -- DEFAULT CONFIGURATION
        name = 'STAR',
        type = 'RED_GIANT'; 
        emitsLight = true, 
        gravitStrength = 30,
        allowRotation = false, -- After spawn / For Animation
        spawnChance = 70,  -- Calls before Spawn
        hasParticles = true,
        prefab = Prefabs.star
    },

    PLANET = {
        name = 'PLANET',
        moonCount = 0,
        type = 'GASEOUS_PLANET', -- GASEOUS_PLANET, ROCKY OR OCEAN
        gravitStrength = 30,
        allowRotation = true,
        allowMovement = true, -- allow translation movement
        spawnChance = 100,
        prefab = Prefabs.planet -- can be a solid prefab or particle
    },

    ASTEROID = {
        name = 'ASTEROID',
        type = 'RANDOM',
        allowRotation = true,
        allowMovement = true,
        hasParticles = true,
        velocity = 50,
        spawnChance = 100,
        prefab = Prefabs.asteroid
    },

    NATURAL_SATELLITE = {
        name = 'NATURAL_SATELLITE',
        type = 'NATURAL_SATELLITE_DEFAULT',
        gravitStrength = 30,
        allowRotation = true,
        spawnChance = 100,
        velocity = 50,
        prefab = Prefabs.naturalSatellite
    },

    BLACK_HOLE = {
        name = 'BLACK_HOLE',
        type = 'MASSIVE',
        gravitStrength = 100,
        allowRotation = true,
        spawnChance = 5,
        prefab = Prefabs.blackHole
    },

    --[[
    ***************************



    ***************************

    NEBULOSA = {
        name = 'NEBULOSA',
        type = 'NEBULOSA_DEFAULT',
        spawnChance = 10,
        prefab = Prefabs.Particles.nebulosa
    },

    GIANT_STAR = {
        name = 'STAR',
        type = 'GIANT_STAR_DEFAULT',
        spawnChance = 10,
        prefab = Prefabs.Particles.giantStar
    }

    ]]--
}

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
        SpawnCelestialBody(CelestialBodies[randomCelestialBName], true)
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
    -- :::::::::::::::::::::::::
    -- :::: distanceDivider ::::
    -- :::::::::::::::::::::::::
    -- Provides a magic number wich dividers and change the proximity with player
    -- if the number is high, the proximity withc player is higher, otherwise,
    -- if the number is LOW, the object is FAR from player
    local distanceDivider = math.random(2, 8)
    print("distance divider: ", distanceDivider)

    if (properties ~= nil) then
        CreateCelestialBody(properties, allowRandomSpawn, distanceDivider)
    else
        print("[x] CreateCustomCelestialBody: OBJECT IS NIL")
    end
end

function CreateCelestialBody(properties, allowRandomSpawn, distanceDivider) 
    print("[+] function() CreateCelestialBody() | properties @param: ", dump(properties))

    -- Table values
    -- This values are special beacause they need to be converted to a table
    local prefabProperties = properties.prefab; -- Separete prefab properties
    local randomSpawnPos;
    -- The object (prefab) position, rotiation, color and size as STRING
    local prefabPositionStr, prefabRotationStr;
    -- local  prefabColorStr, prefabSizeStr; 
    local prefabPositionTable, prefabRotationTable;
    -- local prefabColorTable, prefabSizeTable;
        print("[+] function() CreateCelestialBody() | prefab: ", dump(prefabProperties))
        print("[+] function() CreateCelestialBody() | prefab.properfties pos: ", prefabProperties.pos)

    if allowRandomSpawn == true then
        randomSpawnPos = ConvertTableToStr(RandomizeObjectPosition(prefabProperties.pos, distanceDivider))
        print("[+] function() CreateCelestialBody() | prebProperties.pos: spawn RANDOM" .. dump(randomSpawnPos))
    else 
        print("[+] function() CreateCelestialBody() | Prefab Default spawn - Not randomized prefabProperties.pos.")
        -- Its important to have disponible this values as vector or integer
        -- because we gone use later in this function to pass in Spawn
        -- prefabPositionTable = ConvertStrToTable(prefabProperties.pos)
        -- prefabRotationTable = ConvertStrToTable(prefabProperties.rot)
        -- prefabColorTable = GetTableValuesFromProperties(prefabProperties, 'color')
        -- prefabSizeTable = GetTableValuesFromProperties(prefabProperties, 'size')
    end

        -- We dont need to convert str to str its unnecessary
        --prefabPositionStr = ConvertTableToStr(prefabPositionTable)
        --print("pos str: ", prefabPositionStr)

        --prefabRotationStr = ConvertTableToStr(prefabRotationTable)
        --print("pos rot: ", prefabRotationStr)
        --print("pass pos rot")

    -- prefabColorStr = ConvertTableToStr(colorValues)  -- not used yet
    -- prefabSizeStr = ConvertTableToStr(sizeValues) -- not used yet

    -- Configure object properties if a type is given (objects properties are optionals)
    -- Check if the prefab name matches with property name
    if (prefabProperties.name == string.lower(properties.name)) then 
        if (prefabProperties.name == string.lower('STAR')) then --
            print(">>>>>>>> Star config")
            _StarConfiguration(prefabProperties, properties)

        elseif (prefabProperties.name == string.lower('ASTEROID')) then
            print(">>>>>>> Asteroid config")
            _AsteroidConfiguration(prefabProperties, properties)
        elseif (prefabProperties.name == string.lower('PLANET')) then
            print(">>>>>>> Planet config")
            _PlanetConfiguration(prefabProperties, properties)
            --_StarConfiguration(prefabProperties, properties)
            -- TODO: Need to check the moonCount to spawn in planets orbits
            --if (properties.moonCount > 0) then
                --_NaturalSatelliteConfiguration(prefabProperties, properties)
            --end
        else    
            print("[!] No prefab confiuration function. Setting as default prefab table config.")
        end
    end

    ------- OBJECT XML SCENE CREATION -----------------------
    -- TODO: Move to a function
    -- For now its only voxbox
    local prefabXml = CreateXMLPrefab(prefabProperties, randomSpawnPos)
    --------- SPAWN RULES -----------------------
    -- THE SPAWN TRANSFORM IS ANOTHER PARAM AND I DON'T KNOW WHY I NEED THIS beacause
    -- THE PREFAB ALREADY HAS.
    --local spawnTransform = Transform(Vec(pos[1], pos[2], pos[3]))
    local spawnTransform;
    if allowRandomSpawn == true then
        -- true = table setted based RANDOMIZED spawn
        print("random spawn")
        spawnTransform = Transform(randomSpawnPos)
    else
        -- false = prefab table setted spawn - DEFAULT
        print("default spawn")
        spawnTransform = Transform(ConvertStrToTable(prefabProperties.pos))
    end
    Spawn(prefabXml, spawnTransform, true)
    ---------------------------------------------
    -- BODY AND SHAPE RULES
    ---------------------------------------------
    -- CREATE A BODY FOR SHAPE AND CHECK IF IS IsBodyActive
    -- For performance reasons, bodies that don't move are taken out of the simulation. 
    --local handleShape = CreateBodyForShape(prefabProperties)
    local handleShape = FindShape(prefabProperties.tags, true)
    HasShapeCreated(handleShape, prefabProperties, prefabXml)

    ------------------------------------------------------
    -- ADDITIONAL CONFIGURATIONS FOR SHAPE
    ------------------------------------------------------
    -- Do finals configurations (POS SPAWN) like:
    --  > INCREASE EMISSION LIGHT;
    --  > ADD PARTICLES EFFECT ATTACHED TO THE ENTITY;
    --  > ANIMATIONS LIKE ROTATIONS AND MOVEMENT;
    IncreaseEmissiveScale(prefabProperties.tags, properties.emitsLight)
------------------------------------------------------
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- :::::::::::::::::::     CELESTIAL BODIES     :::::::::::::::::
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

-- Pseudo private method to configure prefab properties and more options
function _StarConfiguration(prefabProperties, properties)
    local availableMaterials = {'rock', 'unphysical', 'plaster', 'heavymetal'}
    local availableBrushes = {
        CONSTANTS.VOX.WORLD.STARS.STAR1,
        CONSTANTS.VOX.WORLD.STARS.STAR_REDGIANT
    }

    local voxfile = RandomizePrefabProperty('brush', availableBrushes)

    -- Configure object properties if a type is given (objects properties are optionals)
    prefabProperties.tags = "star_red_giant" -- Tag must by one only and not have spaces to work properly
    prefabProperties.desc = "A Glorious Red Giant."
    prefabProperties.texture = RandomizePrefabProperty('texture')
    prefabProperties.blendtexture = RandomizePrefabProperty('blendtexture')
    prefabProperties.density = "100"
    prefabProperties.strength = "100"
    --prefabProperties.collide = "false" -- gravitty affects
    --prefabProperties.prop = "false"
    -- Change object vox size accordingly to the brush (.vox file)
    -- This logic is needed to change sometimes with some logic to 
    -- open and decrypt .vox files and get the size info
    if voxfile == availableBrushes[1] then
        prefabProperties.size = "40 40 40"
    elseif voxfile == availableBrushes[2] then
        prefabProperties.size = "160 160 160"
    end
    prefabProperties.brush = voxfile
    prefabProperties.material = RandomizePrefabProperty('material', availableMaterials)
    prefabProperties.density = "100"
    prefabProperties.strength = "100"
    if (properties.emitsLight) then
        prefabProperties.pbr = RandomizePrefabProperty('pbr')
    else
        prefabProperties.pbr = "1 1 1 0"
    end
    prefabProperties.color = RandomStringRGB()
    print("prefabProperties.color generated: ", prefabProperties.color)                 
    return prefabProperties
end

--
function _AsteroidConfiguration(prefabProperties, properties)
    -- Configure object properties if a type is given (objects properties are optionals)
    if (properties.type == CONSTANTS.CELESTIALBODY_TYPE.ASTEROID.RANDOM) then
        prefabProperties.tags = "asteroid_default" -- Tag must by one only and not have spaces to work properly
        prefabProperties.desc = "A normal and boring asteroid."
        prefabProperties.brush = CONSTANTS.VOX.WORLD.ASTEROIDS.ASTEROID1
        prefabProperties.size = "20 24 24"
        prefabProperties.texture = RandomizePrefabProperty('texture')
        prefabProperties.blendtexture = RandomizePrefabProperty('blendtexture')
        prefabProperties.color = RandomStringRGB()
    end
        return prefabProperties
end

function _PlanetConfiguration(prefabProperties, properties)
    local availableMaterials = {'rock', 'unphysical', 'dirt', 'foliage', 'plaster'}
    local availableBrushes = {
        CONSTANTS.VOX.WORLD.PLANETS.BIG_PLANET,
        CONSTANTS.VOX.WORLD.PLANETS.BIG_PLANET_DAMAGED,
        CONSTANTS.VOX.WORLD.PLANETS.DWARF_PLANET,
        CONSTANTS.VOX.WORLD.PLANETS.MASSIVE_PLANET -- MASSIVE_PLANET: This can cause some problems
    }

    local voxfile = RandomizePrefabProperty('brush', availableBrushes)
    print(">>>> VOX FILE CHOSEN: ", tostring(voxfile), "<<<<<")
    for _, v in pairs(CONSTANTS.VOX.WORLD.PLANETS) do
        print("_PlanetConfiguration(): CONSTANTS.VOX.WORLD.PLANETS - " .. v)
        table.insert(availableBrushes, v)
    end
    print("_PlanetConfiguration(): availableBrushes -" .. dump(availableBrushes))

    -- Configure object properties if a type is given (objects properties are optionals)
    if (properties.type == CONSTANTS.CELESTIALBODY_TYPE.PLANET.GASEOUS) then
        prefabProperties.tags = "gaseous_planet"
        prefabProperties.desc = "A Gaseous Planet."
        prefabProperties.density = "1.0"
        prefabProperties.strength = "1.0"
        --prefabProperties.collide = "true"
        --prefabProperties.prop = "false"
        prefabProperties.size = "40 39 40"
    -- Change object vox size accordingly to the brush (.vox file)
    -- This logic is needed to change sometimes with some logic to 
    -- open and decrypt .vox files and get the size info
    if voxfile == availableBrushes[1] or voxfile == availableBrushes[2] then
        prefabProperties.size = "256 256 256"
    elseif voxfile == availableBrushes[3] then
        prefabProperties.size = "40 40 40"
    elseif voxfile == availableBrushes[4] then
        -- prefabProperties.size = "1024 1024 1024"
    end
        prefabProperties.brush = voxfile
        prefabProperties.texture = RandomizePrefabProperty('texture')
        prefabProperties.blendtexture = RandomizePrefabProperty('blendtexturetexture')
        -- prefabProperties.pbr = RandomizePrefabProperty('pbr')
        prefabProperties.pbr = "0 0 0 0"
        prefabProperties.material = RandomizePrefabProperty('material', availableMaterials)
        prefabProperties.color = RandomStringRGB()

    elseif (properties.type == CONSTANTS.CELESTIALBODY_TYPE.PLANET.ROCKY) then
        prefabProperties.desc = "A Rocky Planet."
        prefabProperties.tags = "rocky_planet"

    elseif (properties.type == CONSTANTS.CELESTIALBODY_TYPE.PLANET.OCEAN) then
        prefabProperties.desc = "A Ocean Planet."
        prefabProperties.tags = "ocean_planet"
    
    elseif (properties.type == CONSTANTS.CELESTIALBODY_TYPE.PLANET.RANDOM) then
        local rot = GetTableValuesFromProperties(prefabProperties, 'rot')
        prefabProperties.tags = "random_planet"
        prefabProperties.desc = "A Random Planet."
        prefabProperties.rot = ''
        
    end
        return prefabProperties
end

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- ::::::::::::::   COMPLEMENTARY FUNCTIONS     :::::::::::::::::
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

-- Need to be call after spawn
function IncreaseEmissiveScale(tag, emitsLight)
    local shape = FindShape(tag)
    if (shape ~= 0) then
        if (emitsLight) then
            local scale = math.sin(GetTime()) * 1.0 + 1.0
            SetShapeEmissiveScale(shape, scale)
        end
    else 
        print("[X] Error: The shape doesn't exists.")
    end
end