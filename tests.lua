--[[
---------------------------------------------
test.lua
by Caio Madeira
    
    Module for test mod and Teardown API functions.
    All functions start with test.

---------------------------------------------
]]--

ENABLE_TESTS = true

if ENABLE_TESTS then
    require('sources.prefab')
    luaunit = require('lib.luaunit')

-- Set local function simulating a private function
    -- in this case local functions are ignored by luaunit
    -- so, i can call this in another file if i want to test the API                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
local function testVecAdd(a, b)
    print(":::::: " .. "testVecAdd()" .. " ::::::")
    local a = { 2, 3, 2}
    local b = { 1, 1, 1}
    if #a ~= 3 and #b ~= 3 then
        error("One of vectors not have three values.")
    end
    local c = VecAdd(a, b)
    print("Sum of vector a and b: " .. VecStr(c))
    print(":::::::::::::::::::::::::::::::::::::::")
end

function testRandomPrefabPropertyType()
    luaunit.assertEquals(type(RandomPrefabProperty('texture')), 'string', 'Type match.')
end


os.exit(luaunit.LuaUnit.run())
else os.execute("echo [x] ENABLE_TESTS=" .. tostring(ENABLE_TESTS))
end
