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