#include "sources/utils.lua"
#include "../settings.lua"

 -- Meta Class

Debug = { 
    enableDebug = MOD.DEBUG,
    enableFlyMode = false,
    enableUILog = false
}

-- Derived Class method new

function Debug:new(o) 
    o = o or { } -- Create an object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    self.enableDebug = MOD.DEBUG
    self.enableFlyMode = self.enableDebug or false
    self.enableUILog = self.enableDebug or false
    if self.enableDebug then
        print("Debug is Enabled.")
        print("FlyMode: ", self.enableFlyMode)
        print("UILogs: ", self.enableUILogs)
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
                customSpeed = math.clamp(customSpeed + scroll, 1, 10)
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

    -- Debug container rect
    UiTranslate(x, y) -- Change the rect position
    UiPush()
        UiColor(0, 0, 0) -- Change the color of Rect
        UiRect(w, h) -- Draw rect with given width and height
    UiPop()

    -- Debug container title
    UiPush()
        UiColor(1, 1, 1) -- Green
        UiFont("regular.ttf", 36)
        UiTranslate(x - 10, y)
        UiText(MOD.NAME .. ": Debug Menu")
    
    -- Debug Mod title
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
