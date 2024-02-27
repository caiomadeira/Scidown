function logFile(content1, content2)
  local file, err = io.open("logFile.txt", 'w')
  if file then
      file:write(tostring(content1))
      file:write(tostring(content2))
      file:close()
  else
      DebugPrint("error: ", err)
  end
end

--[[

DUMP FULL TABLE
https://stackoverflow.com/questions/9168058/how-to-dump-a-table-to-console

]]--

function dump(o)
  if type(o) == 'table' then
     local s = '{ '
     for k,v in pairs(o) do
        if type(k) ~= 'number' then k = '"'..k..'"' end
        s = s .. '['..k..'] = ' .. dump(v) .. '\n'
     end
     return s .. '} '
  else
     return tostring(o)
  end
end

function GetSizeOfTable(table)
  local size = 0;

  for k, v in pairs(table) do
      size = size + 1
  end
  DebugPrint("Array length: " .. tostring(size))
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

function random()


end