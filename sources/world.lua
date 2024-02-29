#include "sources/prefab.lua"
#include "sources/utils.lua"
#include "sources/commons/colors.lua"
#include "sources/commons/constants.lua"


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
    },

    NEBULOSA = {
        name = 'NEBULOSA',
        type = 'NEBULOSA_DEFAULT',
        spawnChance = 10,
        prefab = Prefabs.Particles.nebulosa
    },

    GIANT_STAR = {
        name = 'GIANT_STAR',
        type = 'GIANT_STAR_DEFAULT',
        spawnChance = 10,
        prefab = Prefabs.Particles.giantStar
    }
}

--[[

Create a custom celestial body with Random (or not) Properties

]]--


function SetupCustomCelestialBody(properties, allowRandomSpawn)
    -- Check type of param entered
    --assert(type(object)=="table", print("[>] SetupCustomCelestialBody: Param is a table."))

    if (properties ~= nil) then
        CreateCelestialBody(properties, allowRandomSpawn)
    else
        print("[x] CreateCustomCelestialBody: OBJECT IS NIL")
    end
end

function CreateCelestialBody(properties, allowRandomSpawn) 
    -- Table values
    -- This values are special beacause they need to be converted to a table
    local prefabProperties = properties.prefab; -- Separete prefab properties
    local randomSpawnPos;
    -- The object (prefab) position, rotiation, color and size as STRING
    local prefabPositionStr, prefabRotationStr;
    -- local  prefabColorStr, prefabSizeStr; 
    local prefabPositionTable, prefabRotationTable;
    -- local prefabColorTable, prefabSizeTable;
    print("prefab.properfties pos: ", prefabProperties.pos)

    if allowRandomSpawn == true then
        randomSpawnPos = ConvertTableToStr(RandomizeObjectPosition(prefabProperties.pos))
        print("[+] function() CreateCelestialBody() | prebProperties.pos: " .. dump(randomSpawnPos))
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
            --print("Star config")
            _StarConfiguration(prefabProperties, properties)

        elseif (prefabProperties.name == string.lower('ASTEROID')) then
            --print("asteroid config")
            _AsteroidConfiguration(prefabProperties, properties)
            
        elseif (prefabProperties.name == string.lower('PLANET')) then
            --print("planet config")
            -- _PlanetConfiguration(prefabProperties, properties)
            -- TODO: Need to check the moonCount to spawn in planets orbits
            --if (properties.moonCount > 0) then
                --_NaturalSatelliteConfiguration(prefabProperties, properties)
            --end
        end
    end

    ------- OBJECT XML SCENE CREATION -----------------------
    -- TODO: Move to a function
    -- For now its only voxbox
    local base = "<voxbox name=" .. "'".. prefabProperties.name .. "'" .. " " ..
            "tags=" .. "'".. prefabProperties.tags .. "'" .. " " ..
            "pos=" .. "'".. randomSpawnPos .. "'" .. " " ..
            "rot=" .. "'".. prefabProperties.rot .. "'" .. " " ..
            "desc=" .. "'".. prefabProperties.desc .. "'" .. " " ..
            "texture=" .. "'".. prefabProperties.texture .. "'" .. " " ..
            "blendtexture=" .. "'".. prefabProperties.blendtexture .. "'" .. " " ..
            "density=" .. "'".. prefabProperties.density .. "'" .. " " ..
            "strength=" .. "'".. prefabProperties.strength .. "'" .. " " ..
            "collide=" .. "'".. prefabProperties.collide .. "'" .. " " ..
            "prop=" .. "'".. prefabProperties.prop .. "'" .. " " ..
            "size=" .. "'".. prefabProperties.size .. "'" .. " " ..
            "brush=" .. "'".. prefabProperties.brush .. "'" .. " " ..
            "material=" .. "'".. prefabProperties.material .. "'" .. " " ..
            "pbr=" .. "'".. prefabProperties.pbr .. "'" .. " " ..
            "color=" .. "'" .. prefabProperties.color .. "'" ..
            "/>"
    ------------------------------------------------------


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
    Spawn(base, spawnTransform)
    ---------------------------------------------

    local handleShape = FindShape(prefabProperties.tags, true)
    -- local handleBody = FindBody(prefabProperties.tags, true) -- For some reason, the body is not created

    -- Do finals configurations (POS SPAWN) like:
    --  > INCREASE EMISSION LIGHT;
    --  > ADD PARTICLES EFFECT ATTACHED TO THE ENTITY;
    --  > ANIMATIONS LIKE ROTATIONS AND MOVEMENT;

    IncreaseEmissiveScale(prefabProperties.tags, properties.emitsLight)
        
    -- Check if the object has CREATED (shape and body) and gives a feedback if debug is active
    if handleShape ~= 0 then
        print(":::::::::::::: PREFAB [" .. string.upper(prefabProperties.name)  .. "] CREATED :::::::::::::::::::")
        print(base)
        print(":::::::::::::::::::::::::::::::::::::::::::::::::")
    else
        print("XXXXXXXXXXXXX PREFAB [" .. string.upper(prefabProperties.name)  .. "] NOT CREATED XXXXXXXXXXXXX")
    end
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- :::::::::::::::::::     CELESTIAL BODIES     :::::::::::::::::
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

-- Pseudo private method to configure prefab properties and more options
function _StarConfiguration(prefabProperties, properties)
    -- Configure object properties if a type is given (objects properties are optionals)
    if (properties.type == CONSTANTS.CELESTIALBODY_TYPE.STAR.RED_GIANT) then
        prefabProperties.desc = "A Glorious Red Giant."
        prefabProperties.tags = "star_red_giant" -- Tag must by one only and not have spaces to work properly
        prefabProperties.brush = CONSTANTS.VOX.WORLD.STARS.STAR_REDGIANT
        prefabProperties.size = "160 160 156"
        if (properties.gravitStrength > 50) then
            prefabProperties.density = "100"
            prefabProperties.strength = "100"
        else
            prefabProperties.density = "10"
            prefabProperties.strength = "10"
        end
        if (properties.emitsLight) then
            prefabProperties.pbr = "0 0 0 20"
        else
            prefabProperties.pbr = "1 1 1 0"
        end
        prefabProperties.color = PREFAB_COLORS.RED
    end
        return prefabProperties
end

--
function _AsteroidConfiguration(prefabProperties, properties)
    -- Configure object properties if a type is given (objects properties are optionals)
    if (properties.type == CONSTANTS.CELESTIALBODY_TYPE.ASTEROID.RANDOM) then
        prefabProperties.desc = "A normal and boring asteroid."
        prefabProperties.tags = "asteroid_default" -- Tag must by one only and not have spaces to work properly
        prefabProperties.brush = CONSTANTS.VOX.WORLD.ASTEROIDS.ASTEROID1
        prefabProperties.size = "20 24 24"
        prefabProperties.texture = RandomPrefabProperty('texture')
        prefabProperties.blendtexture = RandomPrefabProperty('blendtexture')
        prefabProperties.color = PREFAB_COLORS.RED
    end
        return prefabProperties
end

function _PlanetConfiguration(prefabProperties, properties)
    -- Configure object properties if a type is given (objects properties are optionals)
    if (properties.type == CONSTANTS.CELESTIALBODY_TYPE.PLANET.GASEOUS) then
        prefabProperties.desc = "A Gaseous Planet."
        prefabProperties.tags = "gaseous_planet"
    
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