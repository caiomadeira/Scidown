#include "sources/prefab.lua"
#include "sources/utils.lua"

World = {
    size = {
        width = 300,
        height = 100,
        depth = 300
    }
}

PREFAB_COLORS = {
    RED = "0.5 0.5 0.5",
    BLUE = "0.0 1.0 0.93"
}

CelestialBodies = {

    --[[
    STAR HAS MANY TYPES:
    RED_GIANT:
        - BIG SIZE;
        - COLOR: RED;
        - HIGH GRAVITY EFFECT;
        - HAS PARTICLE EFFECT;

    BLUE_SUPER_GIANT: 
        - VERY BIG SIZE; 
        - COLOR: BLUE;
        - HIGH GRAVITY EFFECT;
        - HAS PARTICLE EFFECT;

    BROWN_DWARF:
        - SMALL SIZE; 
        - COLOR: WHITE;
        - VERY HIGH GRAVITY EFFECT;
        - NO_LIGHT.
        - NO PARTICLE EFFECT;
    ]]--


    STAR = { -- DEFAULT CONFIGURATION
        name = 'STAR',
        type = 'RED_GIANT';
        emitsLight = false, 
        gravitStrength = 30,
        allowRotation = false,
        spawnChance = 70,
        prefab = Prefabs.star
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
        name = 'PLANET',
        moonCount = 0,
        type = 'GASEOUS', -- GASEOUS, ROCKY OR OCEAN
        gravitStrength = 30,
        allowRotation = true,
        allowMovement = true, -- allow translation movement
        spawnChance = 100,
    },

    ASTEROID = {
        name = 'ASTEROIRD',
        allowRotation = true,
        allowMovement = true,
        velocity = 50,
        spawnChance = 100,
    },

    NATURAL_SATELLITE = {
        name = 'NATURAL_SATELLITE',
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
        name = 'BLACK_HOLE',
        gravitStrength = 100,
        allowRotation = true,
    }
}

--[[

Create a custom celestial body with Random Properties

]]--


function CreateCustomCelestialBody(object)

    -- Check type of param entered
    assert(type(object)=="table", DebugPrint("[>] Nice: Param is a table."))

    if (object.name == 'STAR') then
        DebugPrint('STAR')
        -- Insert into a table aditional properties
        CreateStar(object)
        
    elseif (object == 'PLANET') then
        DebugPrint('PLANET')

    elseif (object == 'ASTEROID') then
        DebugPrint('ASTEROID')

    elseif (object == 'NATURAL_SATELLITE') then
        DebugPrint('NATURAL_SATELLITE')

    elseif (object == 'BLACK_HOLE') then
        DebugPrint('BLACK_HOLE')

    else
        DebugPrint("[x] Error in CreateCustomCelestialBody(type)")
    end
end

function CreateStar(properties) 
    -- Table values
    -- This values are special beacause they need to be converted to a table
    local prefabProperties = properties.prefab; -- Separete prefab properties
    local pos, rot, color, size;
    local posValues, rotValues, colorValues, sizeValues;

    -- local tableValues = GetTableValuesFromProperties(properties, 'pos')
    -- DebugPrint("table size: " .. tostring(#tableValues))
    
    -- Its important to have disponible this values as vector or integer
    -- because we gone use later in this function
    posValues = GetTableValuesFromProperties(prefabProperties, 'pos')
    rotValues = GetTableValuesFromProperties(prefabProperties, 'rot')
    colorValues = GetTableValuesFromProperties(prefabProperties, 'color')
    sizeValues = GetTableValuesFromProperties(prefabProperties, 'size')

    pos = CreateTableStringForXML(posValues)
    rot = CreateTableStringForXML(rotValues)
    color = CreateTableStringForXML(colorValues)
    size = CreateTableStringForXML(sizeValues)

    DebugPrint("::::: POS STRING > " .. pos)
    DebugPrint("::::: ROT STRING > " .. rot)
    DebugPrint("::::: COLOR STRING > " .. color)
    DebugPrint("::::: SIZE STRING > " .. size)
    
    DebugPrint("External Properties: " .. dump(properties))

    DebugPrint("prefabProperties.name: " .. prefabProperties.name)
    DebugPrint("objectProperties.type: " .. properties.type)

    -- Configure object properties if a type is given (objects properties are optionals)
    if (prefabProperties.name == string.lower(properties.name)) then
        if (properties.type == 'RED_GIANT') then
            prefabProperties.desc = "A Glorious Red Giant."
            prefabProperties.tags = "star_red_giant"
            if (properties.gravitStrength > 50) then
                prefabProperties.density = "100"
                prefabProperties.strength = "100"
            else
                prefabProperties.density = "10"
                prefabProperties.strength = "10"
            end
            if (properties.emitsLight) then
                prefabProperties.pbr = "0 0 0 32"
            else
                prefabProperties.pbr = "1 1 1 0"
            end
            prefabProperties.color = PREFAB_COLORS.RED
        end
    end

    local base = "<voxbox name=" .. "'".. prefabProperties.name .. "'" .. " " ..
            "tags=" .. "'".. prefabProperties.tags .. "'" .. " " ..
            "pos=" .. "'".. pos .. "'" .. " " ..
            "rot=" .. "'".. rot .. "'" .. " " ..
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
            "color=" .. "'" .. prefabProperties.color .. "'" .. " " ..
            "/>"
    -- local xml = "<voxbox size='10 10 10' prop='false' material='wood'/>"
    -- if the object dont have the 'pos' property

    -- Sets an default spawn position maybe its a good idea make a method for that
    local t
    if pos == '' then
        t = Transform(Vec(10, 10, 0))
    else
        Transform(Vec(0, 0, 0))
    end
	Spawn(base, Transform(Vec(10, 10, 0)))
    
    -- Check if the object has CREATED (shape and body)
    local handleShape = FindShape(prefabProperties.tags, true)
    local handleBody = FindBody(prefabProperties.tags, true)
    DebugPrint("Handled body: " .. tostring(handleBody))
    DebugPrint("Handled shape: " .. tostring(handleShape))

    if handleShape ~= 0 then
        DebugPrint(":::: [" .. string.upper(prefabProperties.name)  .. "] CREATED ::::")
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