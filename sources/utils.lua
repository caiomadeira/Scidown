--[[

DUMP FULL TABLE
https://stackoverflow.com/questions/9168058/how-to-dump-a-table-to-console

]]--

function dump(o)
  if type(o) == 'table' then
     local s = '\n\n { \n'
     for k,v in pairs(o) do
        if type(k) ~= 'number' then k = '"'..k..'"' end
        s = s .. '   ['..k..'] = ' .. dump(v) .. '\n'
     end
     return s .. ' } \n\n'
  else
     return tostring(o)
  end
end

function GetSizeOfTable(table)
  local size = 0;

  for k, v in pairs(table) do
      size = size + 1
  end
  print("Array length: " .. tostring(size))
  return size
end

-- https://stackoverflow.com/questions/6075262/lua-table-tostringtablename-and-table-fromstringstringtable-functions
function serializeTable(val, name, skipnewlines, depth)
  skipnewlines = skipnewlines or false
  depth = depth or 0

  local tmp = string.rep(" ", depth)

  if name then tmp = tmp .. name .. " = " end

  if type(val) == "table" then
      tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")

      for k, v in pairs(val) do
          tmp =  tmp .. serializeTable(v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
      end

      tmp = tmp .. string.rep(" ", depth) .. "}"
  elseif type(val) == "number" then
      tmp = tmp .. tostring(val)
  elseif type(val) == "string" then
      tmp = tmp .. string.format("%q", val)
  elseif type(val) == "boolean" then
      tmp = tmp .. (val and "true" or "false")
  else
      tmp = tmp .. "\"[inserializeable datatype:" .. type(val) .. "]\""
  end

  return tmp
end

--[[

ConvertStrToTable

 param t: str
 Convert a table(t)/(with the lenght of 3 only (Vec)) to a string

]]--
-- Used to get Spawn Coordinates from prefab str and return as a table
function ConvertStrToTable(str)
    local values = {  }
    for num in str:gmatch("%S+") do -- Use gmatch "%S+" regex pattern to separate float numbers
        num = tonumber(num)
        --print("ConvertStrToTable [var: " .. num .."] type: ".. type(num))
        -- Need to convert all table values to float to avoid 
        -- an table with string values
        table.insert(values, tonumber(num))
    end
    if (#values == 3) then
        --print("ConvertStrToTable: table length is 3")
        --print("Final ConvertStrToTable TABLE: " .. dump(values))
        return values
    else
        print("[x] ConvertStrToTable: table length is not 3.")
    end
end

--[[
ConvertTableToStr

param t: table
Make the opposite thing that ConvertStrToTable(t) do.

]]--

function ConvertTableToStr(t)
    local strAux;
    --print("> ConvertTableToStr: " .. type(t) .. " :", dump(t))
    if #t == 3 then -- Check if table size == 3 beacause the Vec() is a function that only accepts 3 values
        strAux = t[1] .. " " .. t[2] .. " " .. t[3]
        --print("> ConvertTableToStr: strAux: " .. strAux, type(strAux))
        return strAux
    else
        return ''
    end
end

--[[
-- The function that limits a number in a certain range usually called Clamp.
-- https://stackoverflow.com/questions/64878491/how-do-you-make-a-range-in-lua
function math.Clamp(val, min, max)
    return math.min(math.max(val, min), max)
end
]]--

--[[

CalculateCubeTotalArea(edge) 

Calculate total area of a cube.
It's used to calculate the World (Scene) area;

]]--

function CalculateCubeTotalArea(edge) 
    return 6*(edge^2);
end


--[[

CalculateCubeLateralArea

Calculate lateral area of a cube.
It's used to calculate the World (Scene) area;

]]--

function CalculateCubeLateralArea(s) 
    return 4*(s^2);
end

--[[
    
CalculateCubeBaseArea

Calculate base area of a cube.
It's used to calculate the World (Scene) area;

]]--

function CalculateCubeBaseArea(b) 
    return b^2;
end


-- Clamp
function math.clamp(num, min, max)
	if num < min then
		num = min
	elseif num > max then
		num = max    
	end
	
	return num
end

-- Lerp
function math.lerp(from, to, t)
	return from + (to - from) * math.clamp(t, 0, 1)
end

function Round(num, dp)
    --[[
    round a number to so-many decimal of places, which can be negative, 
    e.g. -1 places rounds to 10's,  
    
    examples
        173.2562 rounded to 0 dps is 173.0
        173.2562 rounded to 2 dps is 173.26
        173.2562 rounded to -1 dps is 170.0
    ]]--
    local mult = 10^(dp or 0)
    return math.floor(num * mult + 0.5)/mult
end
