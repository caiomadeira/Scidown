#include "sources/prefab.lua"
#include "sources/utils.lua"

World = {
    size = {
        width = 300,
        height = 100,
        depth = 300
    }
}

CelestialBodyConfig = {
    STAR = { 
        emitsLight = true, 
        gravitStrength = 30,
        allowRotation = false,
        spawnChance = 70,
    },

    --[[
    GASEOUS PLANETS:
        - particles effects; 
        - can be toxic; 
        - not solid at all;
        - low density;
        - big scale;
        - HIGH moon count;

    ROCKY PLANETS: 
        - are solid; 
        - not have particles effects;
        - lower moon count;

    OCEAN PLANETS:
        - just water in a sphere;

    ]]--

    PLANET = {
        moonCount = 0,
        type = 'GASEOUS', -- GASEOUS, ROCKY OR OCEAN
        gravitStrength = 30,
        allowRotation = true,
        allowMovement = true, -- allow translation movement
        spawnChance = 100,
    },

    ASTEROID = {
        allowRotation = true,
        allowMovement = true,
        velocity = 50,
        spawnChance = 100,
    },

    NATURAL_SATELLITE = {
        gravitStrength = 30,
        allowRotation = true,
        allowMovement = true,
        velocity = 50,
    },

        --[[
    BLACK HOLES:
        - INFINITE (HIGH) density;
        - Absorves bodies (and the player) and delete it
    ]]--

    BLACK_HOLE = {
        gravitStrength = 100,
        allowRotation = true,
    }
}

--[[

Create a custom celestial body with Random Properties

]]--


function CreateCustomCelestialBody(bodyType)

    -- Check type of params entered
    assert(type(bodyType)=="table", DebugPrint("[>] Nice: Param is a table."))

    if (bodyType == CelestialBodyConfig.STAR) then
        DebugPrint('STAR')
        
    elseif (bodyType == CelestialBodyConfig.PLANET) then
        DebugPrint('PLANET')

    elseif (bodyType == CelestialBodyConfig.ASTEROID) then
        DebugPrint('ASTEROID')

    elseif (bodyType == CelestialBodyConfig.NATURAL_SATELLITE) then
        DebugPrint('NATURAL_SATELLITE')

    elseif (bodyType == CelestialBodyConfig.BLACK_HOLE) then
        DebugPrint('BLACK_HOLE')

    else
        DebugPrint("[x] Error in CreateCustomCelestialBody(type)")
    end
end

function CreateStar(properties) 

    -- String, Boolean and Interer(Number) values
    local name, tags, desc, blendtexture, density, 
    strength, collide, prop, brush, material, pbr;

    -- Table values
    local pos, rot, color, size;
    local posValues, rotValues, colorValues, sizeValues;

    -- local tableValues = GetTableValuesFromProperties(properties, 'pos')
    -- DebugPrint("table size: " .. tostring(#tableValues))
    
    -- Its important to have disponible this values as vector or integer
    -- because we gone use later in this function
    posValues = GetTableValuesFromProperties(properties, 'pos')
    rotValues = GetTableValuesFromProperties(properties, 'rot')
    colorValues = GetTableValuesFromProperties(properties, 'color')
    sizeValues = GetTableValuesFromProperties(properties, 'size')

    pos = CreateTableStringForXML(posValues)
    rot = CreateTableStringForXML(rotValues)
    color = CreateTableStringForXML(colorValues)
    size = CreateTableStringForXML(sizeValues)

    DebugPrint("::::: POS STRING > " .. pos)
    DebugPrint("::::: ROT STRING > " .. rot)
    DebugPrint("::::: COLOR STRING > " .. color)
    DebugPrint("::::: SIZE STRING > " .. size)

    local base = "<voxbox name=" .. "'".. properties.name .. "'" .. " " ..
            "tags=" .. "'".. properties.tags .. "'" .. " " ..
            "pos=" .. "'".. pos .. "'" .. " " ..
            "rot=" .. "'".. rot .. "'" .. " " ..
            "desc=" .. "'".. properties.desc .. "'" .. " " ..
            "texture=" .. "'".. properties.blendtexture .. "'" .. " " ..
            "density=" .. "'".. properties.density .. "'" .. " " ..
            "strength=" .. "'".. properties.strength .. "'" .. " " ..
            "collide=" .. "'".. properties.collide .. "'" .. " " ..
            "prop=" .. "'".. properties.prop .. "'" .. " " ..
            "size=" .. "'".. properties.size .. "'" .. " " ..
            "brush=" .. "'".. properties.brush .. "'" .. " " ..
            "material=" .. "'".. properties.material .. "'" .. " " ..
            --"pbr=" .. "'".. properties.pbr .. "'" .. " " ..
            "color=" .. "'" .. properties.color .. "'" .. " " ..
            "/>"
    -- local xml = "<voxbox size='10 10 10' prop='false' material='wood'/>"
	Spawn(base, Transform(Vec(0, 10, 0)))
    

    -- Check if the object has CREATED (shape and body)
    local handleShape = FindShape(properties.tags, true)
    if handleShape ~= 0 then
        DebugPrint(handleShape)
        DebugPrint(":::::::::::::::: STAR CREATED ::::::::::::::::")
        DebugPrint(base)
        DebugPrint(":::::::::::::::::::::::::::::::::::::::::::::")
    else
        DebugPrint("XXXXXXXXXXXXX OBJECT NOT CREATED XXXXXXXXXXXXX")
    end
end


function CreateTableStringForXML(table)
    local strAux;

    if #table == 3 then -- Check if table size == 3 beacause the Vec() is a function that only accepts 3 values
        strAux = table[1] .. " " .. 
                table[2] .. " " ..
                table[3]
        --DebugPrint("POS STRING: " .. strAux)
        return strAux
    else
        return ''
    end
end