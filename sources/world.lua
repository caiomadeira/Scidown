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
**************************************************************
SetupCustomCelestialBody(properties, allowRandomSpawn)

--------------------------------------------------------------
Create a custom celestial body with Random (or not) Properties
**************************************************************
]]--
function PopulateWorld(min, max)
 -- ...
end

--[[
**************************************************************
SetupCustomCelestialBody(properties, allowRandomSpawn)

--------------------------------------------------------------
Create a custom celestial body with Random (or not) Properties
**************************************************************
]]--

function SetupCustomCelestialBody(properties, allowRandomSpawn)
    -- :::::::::::::::::::::::::
    -- :::: distanceDividir ::::
    -- :::::::::::::::::::::::::
    -- Provides a magic number wich dividers and change the proximity with player
    -- if the number is high, the proximity withc player is higher, otherwise,
    -- if the number is LOW, the object is FAR from player
    local distanceDivider = 5.0;

    if (properties ~= nil) then
        CreateCelestialBody(properties, allowRandomSpawn, distanceDivider)
    else
        print("[x] CreateCustomCelestialBody: OBJECT IS NIL")
    end
end

function CreateCelestialBody(properties, allowRandomSpawn, distanceDivider) 
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
        randomSpawnPos = ConvertTableToStr(RandomizeObjectPosition(prefabProperties.pos, distanceDivider))
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
            _PlanetConfiguration(prefabProperties, properties)
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
            " />"
    ------------------------------------------------------
    -- ******** CREATE A BODY AND ATTACH TO SHAPE



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
    -- BODY AND SHAPE RULES
    ---------------------------------------------
    -- CREATE A BODY FOR SHAPE AND CHECK IF IS IsBodyActive
    -- For performance reasons, bodies that don't move are taken out of the simulation. 
    local handleShape = FindShape(prefabProperties.tags, true)
    local handleShapeBody = GetShapeBody(handleShape) -- For some reason, the body is not created
    if handleShapeBody ~=0 then
        print("body for " .. prefabProperties.tags .. " found with handle: ", handleShapeBody)
        SetTag(handleShapeBody, prefabProperties.tags)
        print("Tag setted? ", HasTag(handleShape, prefabProperties.tags))
        if IsBodyActive(handleShapeBody) then
            print("Body is active.")
        else
            print("Body is NOT active.")
            SetBodyDynamic(handleShapeBody, false)
            print("Now, is body dinamic? ", IsBodyActive(handleShapeBody))
        end


    else 
        print("body for " .. prefabProperties.tags .. " not found. ", handleShapeBody)
    end
    -- Do finals configurations (POS SPAWN) like:
    --  > INCREASE EMISSION LIGHT;
    --  > ADD PARTICLES EFFECT ATTACHED TO THE ENTITY;
    --  > ANIMATIONS LIKE ROTATIONS AND MOVEMENT;

    IncreaseEmissiveScale(prefabProperties.tags, properties.emitsLight)
        
    -- Check if the object has CREATED (shape and body) and gives a feedback if debug is active
    if handleShape ~= 0 then
        -- Print formated prefab xml properties 
        print(":::::::::::::: PREFAB [" .. string.upper(prefabProperties.name)  .. "] CREATED :::::::::::::::::::")
        for p in base:gmatch("%S+") do
            if string.find(p, "<") or string.find(p, "/>") then
                print(p)
            else
                print("\t", p)
            end
        end
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
    local availableMaterials = {'rock', 'unphysical', 'plaster', 'heavymetal'}
    local availableBrushes = {
        CONSTANTS.VOX.WORLD.STARS.STAR1,
        CONSTANTS.VOX.WORLD.STARS.STAR_REDGIANT
    }

    local brush = RandomizePrefabProperty('brush', availableBrushes)

    -- Configure object properties if a type is given (objects properties are optionals)
    prefabProperties.tags = "star_red_giant" -- Tag must by one only and not have spaces to work properly
    prefabProperties.desc = "A Glorious Red Giant."
    prefabProperties.texture = RandomizePrefabProperty('texture')
    prefabProperties.blendtexture = RandomizePrefabProperty('blendtexture')
    prefabProperties.density = "100"
    prefabProperties.strength = "100"
    prefabProperties.collide = "false" -- gravitty affects
    prefabProperties.prop = "false"

    -- Change object vox size accordingly to the brush (.vox file)
    -- This logic is needed to change sometimes with some logic to 
    -- open and decrypt .vox files and get the size info
    if brush == availableBrushes[1] then
        prefabProperties.size = "40 40 40"
    elseif brush == availableBrushes[2] then
        prefabProperties.size = "160 160 160"
    end
    prefabProperties.brush = brush
    prefabProperties.material = RandomizePrefabProperty('material', availableMaterials)
    prefabProperties.density = "100"
    prefabProperties.strength = "100"
    if (properties.emitsLight) then
        prefabProperties.pbr = RandomizePrefabProperty('pbr')
    else
        prefabProperties.pbr = "1 1 1 0"
    end

    local r = math.random() + math.random(0, 1)
    local g = math.random() + math.random(0, 1)
    local b = math.random() + math.random(0, 1)
    
    -- Truncate the values and rounding because there's no built-in function for that
    r = Round(r, 1)
    g = Round(g, 1)
    b = Round(b, 1)

    -- If some of RGB values are HIGHER than 1.0
    if (r > 1.0) then r = 1.0 end
    if (g > 1.0) then g = 1.0 end
    if (b > 1.0) then b = 1.0 end

    -- If some of RGB values are LOWER than 0.0
    if (r < 0.0) then r = 0.0 end
    if (g < 0.0) then g = 1.0 end
    if (b < 0.0) then b = 1.0 end

    print("random r g b: ", r, g, b)

    -- prefabProperties.color = '0.5 0.5 0.5'

    prefabProperties.color = tostring(r) .. 
                             " " .. tostring(g) .. 
                             " " .. tostring(b)

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
        prefabProperties.color = CONSTANTS.COLORS.STR.RED
    end
        return prefabProperties
end

function _PlanetConfiguration(prefabProperties, properties)
    local availableMaterials = {'rock', 'unphysical', 'dirt', 'foliage', 'plaster'}
    local availableBrushes;

    for k, v in pairs(CONSTANTS.VOX.WORLD.PLANETS) do
        print("_PlanetConfiguration(): CONSTANTS.VOX.WORLD.PLANETS - " .. v)
        table.insert(availableBrushes, v)
    end
    print("_PlanetConfiguration(): availableBrushes -" .. dump(availableBrushes))

    -- Configure object properties if a type is given (objects properties are optionals)
    if (properties.type == CONSTANTS.CELESTIALBODY_TYPE.PLANET.GASEOUS) then
        prefabProperties.desc = "A Gaseous Planet."
        prefabProperties.tags = "gaseous_planet"
        prefabProperties.density = "100"
        prefabProperties.strength = "100"
        prefabProperties.collide = "true"
        prefabProperties.prop = "false"
        prefabProperties.size = "40 39 40"
        prefabProperties.brush = RandomizePrefabProperty('brush', availableBrushes)
        prefabProperties.texture = RandomizePrefabProperty('texture')
        prefabProperties.blendtexture = RandomizePrefabProperty('blendtexturetexture')
        prefabProperties.pbr = RandomizePrefabProperty('pbr')
        prefabProperties.material = RandomizePrefabProperty('material', availableMaterials)
        prefabProperties.color = '0.72 0.12 0.32'

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