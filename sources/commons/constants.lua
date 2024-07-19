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
    PREFAB = 'MOD/assets/prefabs/',
    PALLETE = 'MOD/assets/palletes/',
    SKYBOX = 'MOD/assets/skybox/',
    SPRITE = 'MOD/assets/sprites/',
    VOX = 'MOD/assets/vox/',
}

CONSTANTS = {

    TAGS = {
        'star', 'random_planet', 'asteroid_default','random_planet', 
        'rocky_planet', 'gaseous_planet','star_red_giant', 'asteroid', 'planet',
    'black_hole', 'natural_satellite'
    },

    WORLD = {
        SIZE = {
            WIDTH = 300, -- X
            HEIGHT = 150, -- Y 
            DEPTH = 300 -- Z
        }
    },
    
    PREFAB = {
        VEHICLES = {
            SPACESHIP_SMALL1 = PATH.PREFAB .. 'vehicles/spaceship_small1.xml',
        },

        BUILDINGS = {
            SAFEHOUSE = PATH.PREFAB .. 'world/building/safehouse.xml',
        }
    },
    
    PALLETE = {
        MOON2 = 'moon2.png',
        PLANET1 = 'planet1.png',
        PLANET2 = 'planet2.png',
        PLANET3 = 'planet3.png',
    },

    SKYBOX = {
        SPACE = PATH.SKYBOX .. 'space.dds',
        PLANET1 = PATH.SKYBOX .. 'desert2_aftermoon.dds',
    },
    
    SPRITE = {
        TESTSPRITE = 'testSprite.png'
    },
    
    VOX = {
        VEHICLES = {
            SPACESHIP_SMALL1 = PATH.VOX .. 'vehicles/spaceship_small1.vox',
        },
    
        WORLD = {
            ASTEROIDS = {
                ASTEROID1 = PATH.VOX .. 'world/asteroids/asteroid1.vox',
            },
            PLANETS = {
                BIG_PLANET_DAMAGED = PATH.VOX .. 'world/planets/big_planet_damaged.vox',
                BIG_PLANET = PATH.VOX .. 'world/planets/big_planet.vox',
                DWARF_PLANET = PATH.VOX .. 'world/planets/dwarf_planet.vox',
                MASSIVE_PLANET = PATH.VOX .. 'world/planets/massive_planet.vox',
            },

            NATURAL_SATELLITES = {
                MOON1 = PATH.VOX .. 'world/satellites/moon1.vox',
                MOON2 = PATH.VOX .. 'world/satellites/moon2.vox',
            }, 

            STARS = {
                STAR_REDGIANT = PATH.VOX .. 'world/stars/star_redgiant.vox',
                STAR1 = PATH.VOX .. 'world/stars/star1.vox'
            },

            BLACK_HOLE = {
                DEFAULT = PATH.VOX .. 'world/black_holes/big_blackhole.vox' 
            },
        }
    },
    
    CELESTIALBODY_TYPE = { 
        STAR = { 
            RED_GIANT = "RED_GIANT",
            RANDOM = "RANDOM"
        },

        PLANET = {
            GASEOUS = "GASEOUS_PLANET", 
            ROCKY = "ROCKY_PLANET", 
            OCEAN = "OCEAN_PLANET",
            RANDOM = "RANDOM"
        },

        ASTEROID = { RANDOM = "RANDOM" },
        NATURAL_SATELLITE = { DEFAULT = "NATURAL_SATELLITE_DEFAULT", RANDOM = "RANDOM"},
        BLACK_HOLE = { MASSIVE = "MASSIVE", HYPERMASSIVE = "HYPERMASSIVE" },
        NEBULOSA = { RANDOM = "RANDOM" },
    },

    COLORS = {
        STR = {
            RED = "0.5 0.5 0.5",
            BLUE = "0.0 1.0 0.93",
            YELLOW = "0.92 0.6 0.09"
        },

        TABLE = {
            VIBRANT_RED = {2.55, 0, 0},
            VIBRANT_YELLOW = {2.55, 1.8, 0}
        }
    }
}