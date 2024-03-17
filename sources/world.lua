#include "sources/prefab.lua"
#include "sources/utils.lua"
#include "sources/commons/constants.lua"
#include "sources/spawn.lua"
#include "../settings.lua"

CelestialBodies = {
    STAR = { -- DEFAULT CONFIGURATION
        name = 'STAR',
        type = 'RED_GIANT'; 
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
}

function CreateCelestialBody(properties, randomSpawn, rangeInterval) 
    randomSpawn = randomSpawn or true -- set default param if user doesn't provide
    -- Table values
    -- This values are special beacause they need to be converted to a table
    local prefabProperties = properties.prefab; -- Separete prefab properties
    --[[
    ***********************************************
        Prefab position 
        - 1. Allows random position
        - 2. Allows manual position
    ***********************************************
     ]]--
    if randomSpawn == true then
        prefabProperties.pos = ConvertTableToStr(RandomPosition(rangeInterval))
        print("[+] CreateCelestialBody() | spawn RANDOM" .. prefabProperties.pos)
    end

    -- Configure object properties if a type is given (objects properties are optionals)
    -- Check if the prefab name matches with property name
    if (prefabProperties.name == string.lower(properties.name)) then 
        if (prefabProperties.name == string.lower('STAR')) then --
            _StarConfiguration(prefabProperties, properties)

        elseif (prefabProperties.name == string.lower('ASTEROID')) then
            _AsteroidConfiguration(prefabProperties, properties)

        elseif (prefabProperties.name == string.lower('PLANET')) then
            _PlanetConfiguration(prefabProperties, properties)

        elseif (prefabProperties.name == string.lower('NATURAL_SATELLITE')) then
            _MoonConfiguration(prefabProperties, properties)

        elseif (prefabProperties.name == string.lower('BLACK_HOLE')) then
            _BlackHoleConfiguration(prefabProperties, properties)

        else    
            print("[!] No prefab configuration for".. prefabProperties.name .. " Setting as default prefab table config.")
        end
    end

    ------- OBJECT XML SCENE CREATION -----------------------
    -- TODO: Move to a function
    -- For now its only voxbox
    local prefabXml = CreateXMLPrefab(prefabProperties)
    --------- SPAWN RULES -----------------------
    -- THE SPAWN TRANSFORM IS ANOTHER PARAM AND I DON'T KNOW WHY I NEED THIS beacause
    -- THE PREFAB ALREADY HAS.
    --local spawnTransform = Transform(Vec(pos[1], pos[2], pos[3]))
    local spawnTransform = Transform(ConvertStrToTable(prefabProperties.pos))
    Spawn(prefabXml, spawnTransform, true)
    ---------------------------------------------
    -- BODY AND SHAPE RULES
    ---------------------------------------------
    -- CREATE A BODY FOR SHAPE AND CHECK IF IS IsBodyActive
    -- For performance reasons, bodies that don't move are taken out of the simulation. 
    local handleShape = CreateBodyForShape(prefabProperties.tags)
    --local handleShape = FindShape(prefabProperties.tags, true)
    HasShapeCreated(handleShape, prefabProperties, prefabXml)

    ------------------------------------------------------
    -- ADDITIONAL CONFIGURATIONS FOR SHAPE
    ------------------------------------------------------
    -- Do finals configurations (POS SPAWN) like:
    --  > INCREASE EMISSION LIGHT;
    --  > ADD PARTICLES EFFECT ATTACHED TO THE ENTITY;
    --  > ANIMATIONS LIKE ROTATIONS AND MOVEMENT;
    IncreaseEmissiveScale(prefabProperties.tags, properties.emitsLight)
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- :::::::::::::::::::     CELESTIAL BODIES     :::::::::::::::::
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function _BlackHoleConfiguration(prefabProperties, properties)

    prefabProperties.tags = "black_hole"
    prefabProperties.desc = "Stay away from this."
    prefabProperties.size = "256 256 256"
    prefabProperties.density = "100"
    prefabProperties.strength = "100"
    prefabProperties.brush = CONSTANTS.VOX.WORLD.BLACK_HOLE.DEFAULT
    prefabProperties.texture = '1'
    prefabProperties.blendtexture = '1'
    prefabProperties.material = 'unphysical'
    prefabProperties.pbr = '0 0 0 0'
    prefabProperties.color = '0 0 0 0'
    return prefabProperties
end


-- Pseudo private method to configure prefab properties and more options
function _MoonConfiguration(prefabProperties, properties)
    local availableBrushes = {
        CONSTANTS.VOX.WORLD.NATURAL_SATELLITES.MOON1,
        CONSTANTS.VOX.WORLD.NATURAL_SATELLITES.MOON2
    }
    local voxfile = RandomizePrefabProperty('brush', availableBrushes)

    prefabProperties.brush = voxfile
    prefabProperties.texture = '1'
    prefabProperties.blendtexture = '1'
    prefabProperties.material = 'rocky'
    prefabProperties.pbr = '0 0 0 0'
    prefabProperties.color = '0 0 0 0'

    if voxfile == availableBrushes[1] then -- NORMAL STAR
        prefabProperties.tags = "moon1"
        prefabProperties.desc = "A moon."
        prefabProperties.size = "40 40 40"
        prefabProperties.density = "100"
        prefabProperties.strength = "100"
    elseif voxfile == availableBrushes[2] then -- RED GIANT STAR
        prefabProperties.tags = "moon2"
        prefabProperties.desc = "Another moon."
        prefabProperties.size = "100 100 100"
        prefabProperties.density = "100"
        prefabProperties.strength = "100"
    end
    return prefabProperties
end

-- Pseudo private method to configure prefab properties and more options
function _StarConfiguration(prefabProperties, properties)
    local availableBrushes = {
        CONSTANTS.VOX.WORLD.STARS.STAR1,
        CONSTANTS.VOX.WORLD.STARS.STAR_REDGIANT
    }

    local voxfile = RandomizePrefabProperty('brush', availableBrushes)

    prefabProperties.brush = voxfile
    prefabProperties.texture = RandomizePrefabProperty('texture')
    prefabProperties.blendtexture = RandomizePrefabProperty('blendtexture')
    prefabProperties.material = 'unphysical'
    prefabProperties.pbr = RandomizePrefabProperty('pbr')
    prefabProperties.color = RandomStringRGB()

    if voxfile == availableBrushes[1] then -- NORMAL STAR
        prefabProperties.tags = "star"
        prefabProperties.desc = "A Silly Star"
        prefabProperties.size = "40 40 40"
        prefabProperties.density = "10"
        prefabProperties.strength = "10"
    elseif voxfile == availableBrushes[2] then -- RED GIANT STAR
        prefabProperties.tags = "star_red_giant"
        prefabProperties.desc = "A Glorious Red Giant."
        prefabProperties.size = "160 160 160"
        prefabProperties.density = "100"
        prefabProperties.strength = "100"
    end
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

    -- *************************
    -- GLOBAL ADJUSTS
    -- *************************
    local voxfile = RandomizePrefabProperty('brush', availableBrushes)
    -- Set size and brush
    if voxfile == availableBrushes[1] or voxfile == availableBrushes[2] then
        prefabProperties.size = "256 256 256"
    elseif voxfile == availableBrushes[3] then
        prefabProperties.size = "40 40 40"
    elseif voxfile == availableBrushes[4] then
        prefabProperties.size = "300 300 300"
    end
    prefabProperties.brush = voxfile
    --prefabProperties.collide = "true"
   -- prefabProperties.prop = "false"

    -- Configure object properties if a type is given (objects properties are optionals)
    if (properties.type == CONSTANTS.CELESTIALBODY_TYPE.PLANET.GASEOUS) then
        prefabProperties.tags = "gaseous_planet"
        prefabProperties.desc = "A Gaseous Planet."
        prefabProperties.density = "1.0"
        prefabProperties.strength = "1.0"
        prefabProperties.texture = RandomizePrefabProperty('texture')
        prefabProperties.blendtexture =  RandomizePrefabProperty('blendtexturetexture')
        prefabProperties.pbr = RandomizePrefabProperty('pbr')
        prefabProperties.material = 'unphysical'
        prefabProperties.color = RandomStringRGB()

    elseif (properties.type == CONSTANTS.CELESTIALBODY_TYPE.PLANET.ROCKY) then
        prefabProperties.desc = "A Rocky Planet."
        prefabProperties.tags = "rocky_planet"
        prefabProperties.rot = '0.0 0.0 0.0'
        prefabProperties.color = RandomStringRGB()
        prefabProperties.pbr = "0 0 0 0"
        prefabProperties.material = "rocky" 

    elseif (properties.type == CONSTANTS.CELESTIALBODY_TYPE.PLANET.OCEAN) then
        prefabProperties.desc = "A Ocean Planet."
        prefabProperties.tags = "ocean_planet"
        prefabProperties.rot = '0.0 0.0 0.0'
        prefabProperties.color = "0.0 0.97 1.0" -- BLUE COLOR
        prefabProperties.pbr = "0 0 0 " .. math.random(1, 32)
        prefabProperties.material = "glass"
    
    elseif (properties.type == CONSTANTS.CELESTIALBODY_TYPE.PLANET.RANDOM) then
        prefabProperties.tags = "random_planet"
        prefabProperties.desc = "A Random Planet."
        prefabProperties.rot = '0.0 0.0 0.0'
        prefabProperties.color = RandomStringRGB()
        prefabProperties.pbr = "0 0 0 " .. math.random(1, 32)
        prefabProperties.texture = RandomizePrefabProperty('texture')
        prefabProperties.blendtexture = RandomizePrefabProperty('blendtexturetexture')
        prefabProperties.material = RandomizePrefabProperty('material', availableMaterials) 
    end

	DebugLine(Vec(GetPlayerTransform().pos), Vec(ConvertStrToTable(prefabProperties.pos)), 1, 0, 0)

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