#include "sources/commons/constants.lua"

Prefabs = {
    naturalSatellite = {
        name = 'natural_satellite',
        tags = 'natural_satellite',
        pos = '5.0 15.0 5.9',
        rot = "0 0 0",
        desc ="A magnific natural satellite.",
        texture = "30",
        blendtexture = "10",
        density = "100",
        strength = "100",
        collide = "true",
        prop = "false",
        size = "40 39 40",
        brush ="MOD/assets/models/moon.vox",
        material = "rock",
        color = '0.72 0.12 0.32'
    },
    
    planet = {
        name = 'planet',
        tags = 'planet',
        pos = '3.0 19.0 0.9',
        rot = "0 0 0",
        desc ="A strange planet.",
        texture = "30",
        blendtexture = "10",
        density = "100",
        strength = "100",
        collide = "true",
        prop = "false",
        size = "40 39 40",
        brush ="MOD/assets/models/planet.vox",
        material = "rock",
        color = '0.72 0.12 0.32'
    },

    star = {
        name = 'star',
        tags = 'star',
        pos = '9.4 10.0 -6.4',
        rot = "0 0 0",
        desc ="A beautiful star.",
        texture = "20",
        blendtexture = "15",
        density = "100",
        strength = "100",
        collide = "false",
        prop = "false", -- allows to create a dynamic body
        size = "40 39 40",
        brush ="MOD/assets/models/star.vox",
        material = "rock",
        pbr= "0 0 0 32",
        color = '0.5 0.5 0.5',
    },

    asteroid = {
        name = 'asteroid',
        tags = 'asteroid',
        pos = '0.0 1.0 1.0',
        rot = "0 0 0",
        desc ="A fast asteroid.",
        texture = "5",
        blendtexture = "6",
        density = "10",
        strength = "10",
        collide = "true",
        prop = "true", -- allows to create a dynamic body
        size = "40 39 40",
        brush ="MOD/assets/models/asteroid.vox",
        material = "rock",
        pbr= "0 0 0 0",
        color = '0.5 0.5 0.5',
    }, 

    Particles = {
        nebulosa = {
            name = 'nebulosa',
            pos = {0, 1, 0},
            velocity = {1, 5, -1},
            duration = 1.0, 
            collide = 1, -- 0 or 1
            emissive = 10,
            alpha = {0.2, 0.2},
            rotation = 4,
            color1 = {1, 1, 0},
            color2 = {1, 0, 0},
            tile = 5 -- 5 fire or 0 smoke
        },

        giantStar = {
            name = 'giantStar',
            pos = {0, 1, 0},
            velocity = {1, 5, -1},
            duration = 1.0, 
            collide = 1, -- 0 or 1
            emissive = 10,
            alpha = {0.2, 0.2},
            rotation = 4,
            color1 = {1, 1, 0},
            color2 = {1, 0, 0},
            tile = 5 -- 5 fire or 0 smoke
        }
    }
}

-- TODO: Refactor this trash
function CreateXMLPrefab(properties, debug)
    local xmlTable = {  }
    count = 0;

    -- FOR VOX 
    for key, value in pairs(properties) do
        if (tostring(key) == 'type' and tostring(value) == 'vox') then
            count = count + 1
            if (tostring(key) == 'type') then
                xmlTable[1] = '<' .. value .. ''
            elseif (tostring(key) == 'name') then
                xmlTable[2] = " " .. key .. '=' .. '"' .. value .. '" '
            else
                -- CHECK IF THE NEXT KEY IS EQUAL NIL (THE LAST IN ARRAY)
                if next(properties, key) == nil then
                    xmlTable[count] = " " .. key .. '=' .. '"' .. value .. '"/>'
                else
                    xmlTable[count] = " " .. key .. '=' .. '"' .. value .. '" '
                end
            end 
        end
    end

    -- FOR VOXBOX 
    for key, value in pairs(properties) do
        if (tostring(key) == 'type' and tostring(value) == 'voxbox') then
            xmlTable[1] = '<' .. value .. ''
        elseif (tostring(key) == 'name') then
            xmlTable[2] = " " .. key .. '=' .. '"' .. value .. '" '
        else
            count = count + 1
            if next(properties, key) == nil then
                xmlTable[count] = " " .. key .. '=' .. '"' .. value .. '"/>'
            else
                xmlTable[count] = " " .. key .. '=' .. '"' .. value .. '" '            
            end
        end
    end

    if debug then
        DebugPrint("::::::: XML STRUCTURE for " .. tostring(properties['name']) .. ":::::::\n")
        DebugPrint(dump(xmlTable))
        DebugPrint("XML created.")
        DebugPrint(":::::::::::::::::::::\n")
    end
    return xmlTable -- Return the table
end

function SpawnPrefab(properties, debug)
    local xmlProperties = CreateXMLPrefab(properties)
    local xmlCombined = table.concat(xmlProperties, "") -- Convert into a string

    local prefabCoord = GetTableValuesFromProperties(properties, 'pos')
    Spawn(xmlCombined, Transform(Vec(prefabCoord[1], prefabCoord[2] , prefabCoord[3])), true, true)
	 --Spawn(xmlCombined, Transform(Vec(-9.4, 0.0 , -9.4)))
    if debug then
        DebugPrint("::::::: PREFAB COORD :::::::\n")
        DebugPrint(dump(prefabCoord))
        DebugPrint(":::::::::::::::::::::\n")
        DebugPrint("::::::: FEEDBACK :::::::\n")
        DebugPrint("XML full string: " .. xmlCombined)
        DebugPrint("Prefab [" .. string.upper(properties.name)  .. "] spawned.")
    end
end

-- Get Spawn Coordinates from prefab table
function GetTableValuesFromProperties(properties, key)
    local values = {  }
    -- DebugPrint("[+] GetTableValuesFromProperties: " ..dump(properties))
    for k, v in pairs(properties) do
        if k == key then
            for num in v:gmatch("%S+") do -- Use gmatch "%S+" regex pattern to separate float numbers
                table.insert(values, num)
            end
        end
    end
    return values
end

-- Spawn object according to the player's position
-- TODO: Refactor this trash
function SpawnObjectAccordingPlayerPos(object, xOffset, yOffset, zOffset, isXmlFile)
    DebugPrint(":::::::: SpawnObjectAccordingPlayerPos :::::::::")
    local pPos = GetPlayerTransform().pos
    local newPosX, newPosY, newPosZ

    -- POS X
    if pPos[1] >= 2 then
        newPosX = pPos[1] * xOffset
    else -- minor than zero
        newPosX = pPos[1] + xOffset
    end

    -- POS Y
    if pPos[2] >= 2 then
        newPosY = pPos[2] * yOffset
    else -- minor than zero
        newPosY = pPos[2] + yOffset
    end

    -- POS Z
    if pPos[3] >= 2 then
        newPosZ = pPos[3] * zOffset
    else -- minor than zero
        newPosZ = pPos[3] + zOffset
    end
    
    if isXmlFile then
        Spawn(object, Transform(Vec(newPosX, newPosY , newPosZ)), true, true)
    else
        object.pos = tostring(newPosX) .. " " .. tostring(newPosY) .. " " .. tostring(newPosZ) .. " " 
        DebugPrint(">> SPAWNED PREFAB " .. object.name .. " POS: " ..  object.pos)
        SpawnPrefab(object)
    end

    DebugPrint("::::::::::::::::::::::::::")
end

function RandomPrefabProperty(name)
    local num, max;
    local min = 0;
    if (name == 'blendtexture') then -- Range of 0-15
        DebugPrint('BLENDTEXTURE')
        max = 15
    elseif (name == 'texture') then -- Range of 0-31
        DebugPrint('TEXTURE')
        max = 31
    end
    num = math.random(min, max); 
    DebugPrint("Random " .. tostring(name) .. ": " .. tostring(num))
    return tostring(num);
end