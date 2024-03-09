#include "sources/utils.lua"
#include "../settings.lua"
#include "sources/commons/constants.lua"
#include "sources/prefab.lua"


 -- Meta Class

Debug = { 
    enableDebug = MOD.DEBUG,
    enableFlyMode = false,
    enableUILog = false,
    enableUIWorld = true
}

-- Derived Class method new

function Debug:new(o, enableUILog) 
    o = o or { } -- Create an object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    self.enableDebug = MOD.DEBUG
    self.enableFlyMode = self.enableDebug or false
    self.enableUILog = enableUILog or self.enableDebug
    self.enableUIWorld = enableUILog or self.enableUIWorld
    if self.enableDebug then
        print("Debug is Enabled.")
        print("FlyMode: ", self.enableFlyMode)
        print("UILogs: ", self.enableUILog)
        print("UIWord: ", self.enableUIWorld)
    else
        print("Debug is Disabled.")
    end
    return o
end

-- Derived class method flyMode 

function Debug:flyMode()
    local velocity, direction, scroll;
    local speed = 8
    local customSpeed = 1
    local lastScroll = -1

    if InputPressed("f") then
        self.enableFlyMode = not self.enableFlyMode
    end

    if self.enableFlyMode == true then
        -- This is can be use in vehicle control
        direction = Vec(0, 0, 0)

        if(InputDown("up")) then
            direction[3] = -1
        end

        if(InputDown("down")) then
            direction[3] = 1
        end

        if(InputDown("left")) then
            direction[1] = -1
        end

        if(InputDown("right")) then
            direction[1] = 1
        end
        
        direction = TransformToParentVec(GetCameraTransform(), Vec(direction[1], 0, direction[3]))
        
        if(InputDown("space")) then
            direction[2] = 1
        end

        if(InputDown("ctrl")) then
            direction[2] = -1
        end

        if(InputDown("shift")) then
            scroll = InputValue("mousewheel")

            if math.abs(scroll) > 0 then
                lastScroll = GetTime()
                customSpeed = math.clamp(customSpeed + scroll, 1, 100)
            end
            
            speed = 15 + customSpeed * customSpeed
        else
            speed = 8
        end

        if(VecLength(direction) > 0) then
            direction = VecNormalize(direction)
        end

        velocity = VecScale(direction, speed)
        velocity[2] = velocity[2] + 0.166666698455811
        SetPlayerVelocity(velocity)
    end
end

function Debug:BodiesSceneCount()
    local count = 0;
    local totalBodyCount = { };

    bodies = FindBodies(nil, true)
    count = count + 1
    for i in pairs(bodies) do
        print("body [ " .. count .. " ] in scene: ", bodies[i])
        table.insert(totalBodyCount, bodies[i])
    end
    print("Total Body count in scene: ", #totalBodyCount)
end


-----------------------------------------------
-- ********************************************
-- **    DEBUG USER INTERFACE INFO FUNCTIONS
-- ********************************************
-----------------------------------------------

function Debug:UIDebug()
    local w, h, x, y;
    w = 400;
    h = 800;
    x = 60;
    y = 60;
    if self.enableUILog then
        -- Debug container rect
        UiTranslate(x, y) -- Change the rect position
        UiPush()
            UiColor(0, 0, 0) -- Change the color of Rect
            UiRect(w, h) -- Draw rect with given width and height
        UiPop()

        -- Debug Mod title
        UiPush()
            UiColor(1, 1, 1) -- Green
            UiFont("regular.ttf", 36)
            UiTranslate(x - 10, y)
            UiText(MOD.NAME .. ": Debug Menu")
        
        -- Debug UI World Debug
            UiResetColor()
            if self.enableUIWorld then
                UiColor(0, 1, 0) -- Green
            else
                UiColor(1, 0, 0) -- Red
            end
            UiTranslate(0, y - 5)
            UiText("[Press T] UI World Debug: " .. tostring(self.enableUIWorld))

        -- Debug Fly mode
            UiResetColor()
            if self.enableFlyMode then
                UiColor(0, 1, 0) -- Green
            else
                UiColor(1, 0, 0) -- Red
            end
            UiTranslate(0, y - 5)
            UiText("[Press F] FlyMode: " .. tostring(self.enableFlyMode))

        -- Debug Player Transform
            UiColor(1, 0, 1)
            UiFont("regular.ttf", 24)
            UiTranslate(0, y - 10)
            UiText("Player Transform: " .. dump(GetPlayerTransform()))
        UiPop() 
    end
end

-- World Debug Drawing
function Debug:worldDebug()
    if InputPressed("t") then
        self.enableUIWorld = not self.enableUIWorld
    end

    if self.enableUIWorld then
        local worldWidth = CONSTANTS.WORLD.SIZE.WIDTH
        local worldHeight = CONSTANTS.WORLD.SIZE.HEIGHT
        local worldDepth = CONSTANTS.WORLD.SIZE.DEPTH

        -- World debug line
        --Draw white debug line
        --DebugLine(Vec(0, 0, 0), Vec(-10, 5, -10))
        local celestialBodyShape;
        local celestialShapeLocalTrans;
        --Draw red debug line
        local x1, y1, z1;
        local x2, y2, z2;
        x1 = 1;
        y1 = 1;
        z1 = 1;

        x2 = worldWidth;
        y2 = worldHeight;
        z2 = 0;

        local p1 = Vec(x1, y1, 0) -- (x1, y1, z1) 
        local p2 = Vec(x2, y2, 0) -- (x2, y2, z2)

        --local a = (y1 - y2) / (x1 - x2) -- calculate angular coefficient -- dont forget the parenthesis
        --print("[DEBUG CLASS] Angular coefficient (a):\n" .. y1 .. " - " .. y2 .. " / " .. x1 .. " - " .. x2 .. "= " .. a)
        
        local groupTags = {'star', 'random_planet', 
        'asteroid_default','random_planet', 'rocky_planet', 
        'gaseous_planet','star_red_giant', 'asteroid', 'planet',
         'black_hole', 'natural_satellite'}

        for i=1, #groupTags do
            celestialBodyShape = CreateBodyForShape(groupTags[i])
            celestialShapeLocalTrans = GetShapeLocalTransform(celestialBodyShape).pos
            --print("celestialShapeLocalTrans:", dump(celestialShapeLocalTrans))
            DebugLine(p1, celestialShapeLocalTrans, 1, 1, 0)
        end
    end
end

function calcAngularCoefficient(x1, x2, y1, y2)
    local a = (y1 - y2) / (x1 - x2) -- calculate angular coefficient
end

--- Help functions 