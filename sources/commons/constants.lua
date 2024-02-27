--[[
---------------------------------------------
constants.lua
by Caio Madeira
    
    Where are there all constants in project.
    For convenience, all tables and keys is 
    written in upper case. Table names and keys 
    must be in singular.

---------------------------------------------
]]--

PATH = {
    PREFAB = 'MOD/assets/models/prefabs/',
    PALLETE = 'MOD/assets/palletes/',
    SKYBOX = 'MOD/assets/skybox/',
    SPRITE = 'MOD/assets/sprites/',
    VOX = 'MOD/assets/vox/',
}

PREFAB = {
    SPACESHIP_SMALL1 = PATH.PREFAB .. 'vehicles/spaceship_small1.xml',
    SAFEHOUSE = PATH.PREFAB .. 'world/safehouse.xml',
}

PALLETE = {
    MOON2 = 'moon2.png',
    PLANET1 = 'planet1.png',
    PLANET2 = 'planet2.png',
    PLANET3 = 'planet3.png',
}

SKYBOX = {
    SPACE = 'space.dds',
}

SPRITE = {
    TESTSPRITE = 'testSprite.png'
}

VOX = {
    VEHICLES = {
        SPACESHIP_SMALL1 = PATH.VOX .. 'vehicles/spaceship_small1.vox',
    },

    WORLD = {
        ASTEROID = PATH.VOX .. '/world/asteroids/asteroid1.vox',
        BIG_PLANET_DAMAGED = PATH.VOX .. '/world/planets/big_planet_damaged.vox',
        BIG_PLANET = PATH.VOX .. '/world/planets/big_planet.vox',
        DWARF_PLANET = PATH.VOX .. '/world/planets/dwarf_planet.vox',
        MASSIVE_PLANET = PATH.VOX .. '/world/planets/massive_planet.vox',
        MOON1 = PATH.VOX .. '/world/satellites/moon1.vox',
        MOON2 = PATH.VOX .. '/world/satellites/moon2.vox',
        STAR_REDGIANT = PATH.VOX .. '/world/stars/star_redgiant.vox',
        STAR1 = PATH.VOX .. '/world/stars/star1.vox'
    }
}

CELESTIAL_BODY_TYPE = {
    STAR = { "RED_GIANT" },
    PLANET = {"GASEOUS_PLANET", "ROCKY_PLANET", "OCEAN_PLANET" },
    ASTEROID = { "ASTEROID_DEFAULT" },
    NATURAL_SATELLITE = { "NATURAL_SATELLITE_DEFAULT" },
    BLACK_HOLE = { "MASSIVE", "HYPERMASSIVE" },
    NEBULOSA = { "NEBULOSA_DEFAULT" },
}