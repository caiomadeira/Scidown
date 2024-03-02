--[[
---------------------------------------------
test.lua
by Caio Madeira
    
    Module for test mod and Teardown API functions.
    All functions start with test.

---------------------------------------------
]]--

--[[
******************************************************************
NOTE: I have a problem. I want to get name functions, but 
dosent have an bult-in solution for this. So, i leave it here to
elaborate futhermore.
*****************************************************************

UnitTestsRegistry = { 
    RandomPrefabPropertyTests = {
        functable1_ShouldReturnStrType = { 
            name = "test_RandomPrefabProperty_ShouldReturnStrType" 
        },

        metatable1_ShouldReturnStrType = { },
    }
 }

 UnitTestsRegistry.RandomPrefabPropertyTests.metatable1_ShouldReturnStrType.__call = function ()
    print "test" 
end

setmetatable(
    UnitTestsRegistry.RandomPrefabPropertyTests.functable1_ShouldReturnStrType,
    UnitTestsRegistry.RandomPrefabPropertyTests.metatable1_ShouldReturnStrType
)

UnitTestsRegistry.RandomPrefabPropertyTests.functable1_ShouldReturnStrType()
print(">>>" .. UnitTestsRegistry.RandomPrefabPropertyTests.functable1_ShouldReturnStrType.name)
]] -- 

require('settings')

if MOD.TESTS then
    require('sources.prefab')
    require('sources.commons.constants')
    require('sources.utils')
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

--[[
**********************************************
CalculateCubeTotalArea()
**********************************************
]]--

function test_CalculateCubeTotalArea()
    local side = 150
    local f = CalculateCubeTotalArea(side)
    print("\n")
    print("Init Function output:")
    print("> test_CalculateCubeTotalArea")
    print("-----------------------")
    print("Result: ", f)
    print("-----------------------")
    print("End Function output:")
    print("\n")
    if side == 7 then
        luaunit.assertEquals(f, 294, 'Wrong result.')
    elseif side == 150 then
        luaunit.assertEquals(f, 135000, 'Wrong result.')
    end
end


--[[
**********************************************
ConvertTableToStr()
**********************************************
]]--

function test_ConvertTableToStr_ShouldReturnTable()
    local dummy = { 3.0, 19.0, 0.9 }
    local resultExpected = '3.0 19.0 0.9'
    local onFailureMsg = tostring(dummy) .. " is different than " .. tostring(resultExpected)
    local f = ConvertTableToStr(dummy)
    if f == '' then
        luaunit.fail("The function returned an empty string. Wich is one of thoose cases.")
    end
    luaunit.assertEquals(f, resultExpected, onFailureMsg)
end

--[[
**********************************************
RandomPrefabProperty()
**********************************************
]]--
function test_RandomPrefabProperty_ShouldReturnStrType()
    local dummyProperty = 'texture'
    local resultExpected = 'string'
    local onFailureMsg = "Type doesn't match."
    local f = RandomPrefabProperty(dummyProperty)
    luaunit.assertEquals(type(f), resultExpected, onFailureMsg)
    dummyProperty = 'blendtexture'
    luaunit.assertEquals(type(f), resultExpected, onFailureMsg)
end

--[[
**********************************************
CalculateAxisAccordingWorldAndObject()
**********************************************
]]--

-- Check: Return Type
function test_CalcSpawnPosOffset_ShouldReturnTableType()
    local time = os.time()
    local dummyobjectPos = { 3.0, 10.0, 34.0 }
    local dummyWordLength = { 
        CONSTANTS.WORLD.SIZE.WIDTH - 100,
        CONSTANTS.WORLD.SIZE.HEIGHT - 40,
        CONSTANTS.WORLD.SIZE.DEPTH - 100
    }
    print("\n")
    print("Init Function output:")
    print("> test_CalcSpawnPosWithOffset_ShouldReturnTableType")
    print("-----------------------")
    local f = CalcSpawnPosWithOffset(dummyobjectPos, dummyWordLength, 1.5)
    print("-----------------------")
    print("End Function output:")
    print("\n")

    local resultExpected = 'table'
    local onFailureMsg = "Type doesn't match."

    luaunit.assertEquals(type(f),resultExpected, onFailureMsg)
end

function test_CalcSpawnPosWithOffset_WhenSomeValueIsNegative_ShouldReturnTable()
    local time = os.time()
    -- if you setup some table value with negative, it always be 
    -- a negative in result of function
    local dummyobjectPos = { 201.0, -10.0, 35.0 }
    local dummyWordLength = { 
        CONSTANTS.WORLD.SIZE.WIDTH - 100,
        CONSTANTS.WORLD.SIZE.HEIGHT - 40,
        CONSTANTS.WORLD.SIZE.DEPTH - 100
    }

    print("\n")
    print("Init Function output:")
    print("> test_CalcSpawnPosWithOffset_WhenSomeValueIsNegative_ShouldReturnTable")
    print("-----------------------")
    local f = CalcSpawnPosWithOffset(dummyobjectPos, dummyWordLength, 1.5)
    print("-----------------------")
    print("End Function output:")
    print("\n")
    --local resultExpected = 'table'
    --local onFailureMsg = "The value is not negative."

    --luaunit.assertEquals(type(f), resultExpected, onFailureMsg)
end

os.exit(luaunit.LuaUnit.run())
else 
    os.execute("echo ::::::::: TESTS ENV DISABLED ::::::::::")
    os.execute("echo You need to set APP_TESTS=true in 'config.lua' file.")
end
