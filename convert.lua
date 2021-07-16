-- ----------------------------------------------------------------------------
--
--  convert - convert a csv file to Lua's table format
--
-- ----------------------------------------------------------------------------

local trace		= require("lib.trace")		-- shortcut for tracing

local _frmt		= string.format
local _cat		= table.concat

-- ----------------------------------------------------------------------------
--
local m_logger = trace.new("convert")

-- ----------------------------------------------------------------------------
--
local m_App =
{
	sAppVersion		= "0.0.1",				-- application's version
	sAppName		= "convert",			-- name for the application
	sRelDate 		= "2021/07/14",

	tLines			= { },					-- lines read from file
	tServers		= { },					-- list of DNS servers
}

-- ----------------------------------------------------------------------------
--
local m_Config =
{
	sFileInput		= "data/nameservers.csv",
	sFileOutput		= "data/nameservers.lua",
}

-- ----------------------------------------------------------------------------
-- convert a row to a text line
--
local function ToString(inTable)
	
	local sOutput = { }
	
	for i=1, 3 do
		
		sOutput[#sOutput + 1] = _frmt("\"%s\"", inTable[i])
--	sOutput[#sOutput + 1] = _frmt("\"%s\"", inTable[2])
--	sOutput[#sOutput + 1] = _frmt("\"%s\"", inTable[3])
	end

	return _cat(sOutput, ", ")
end

-- ----------------------------------------------------------------------------
-- save servers to file
--
local function SaveServers()
	m_logger:line("SaveServers")

	local tServers = m_App.tServers
	
	-- get the file's content
	--
	local  fhSrc = io.open(m_Config.sFileOutput, "w")
	if not fhSrc then
		
		m_logger:line("Unable to open destination file: " .. m_Config.sFileOutput)
		
		return false
	end
	
	fhSrc:write("local _servers =\n{\n")
	
	for _, aServer in next, tServers do
		
		local sLineOfText = ToString(aServer)
		
		fhSrc:write("\t{0," .. sLineOfText .. "},\n")
	end
	
	fhSrc:write("}\n\nreturn _servers\n")

	fhSrc:close()

	return true
end

-- ----------------------------------------------------------------------------
--
local function Process()
	m_logger:line("Process")
	
	local tLines = m_App.tLines
	local tServers = { }
	
	if 0 == #tLines then return false end
	
	local tEnabled = {1, 0, 0, 1, 1, 1}				-- columns enabled for each line
	
	for _, aLine in next, tLines do
		
		-- split tokens
		--
		local iCellIndex = 1
		local tCurRow = { }
		local sPartial = ""
		
		for sToken in string.gmatch(aLine, "[^,]*") do
			
			if 1 == tEnabled[iCellIndex] then
				
				-- some names have a comma embedded and it's quoted in "
				-- like: "ShenZhen Sunrise Technology Co.,Ltd."
				--
				if sToken:find("\"", 1, true) then
					
					if 0 == #sPartial then
						
						sPartial = sToken:gsub("\"", "")
					else
						
						sToken	 = sPartial .. sToken:gsub("\"", "")
						sPartial = ""
					end
				end
				
				if 0 == #sPartial then
					
					tCurRow[#tCurRow + 1] = sToken
				end
			end
			
			if 0 == #sPartial then iCellIndex = iCellIndex + 1 end
			if iCellIndex > #tEnabled then break end
		end
		
		local sLabel = tCurRow[2]
		
		local tExisting = tServers[sLabel]
		
		if not tExisting then
			
			-- add a new entry
			--
			tServers[sLabel] = {tostring(tCurRow[1]), "", sLabel .. " - " .. tCurRow[4] .. " (" .. tCurRow[3] .. ")"}
		else
		
			-- substitute 2nd address
			--
			tServers[sLabel][2] = tostring(tCurRow[1])
		end
	end
	
	-- store table
	--
	m_App.tServers = tServers
	
	return true
end

-- ----------------------------------------------------------------------------
-- read the files as lines
--
local function GetLines()
	m_logger:line("GetLines")
	
	-- get the file's content
	--
	local  fhSrc = io.open(m_Config.sFileInput, "r")
	if not fhSrc then
		
		m_logger:line("Unable to open source file: " .. m_Config.sFileInput)
		
		return false
	end

	-- read the whole line with the end of line too
	--
	local tLines	= { }
	local iBinned	= 0

	-- add line by line
	--
	local sLine = fhSrc:read("*L")

	while sLine do
		
		-- skip IPV6 entries
		--
		if sLine:find("::", 1, true) then
			
--			m_logger:line("Binned: " .. sLine)
			iBinned = iBinned + 1
		else
			
			tLines[#tLines + 1] = sLine
		end
		
		sLine = fhSrc:read("*L")
	end

	fhSrc:close()
	
	-- associate values read
	--
	m_App.tLines = tLines
	
	m_logger:line("Read lines count:   " .. #tLines)
	m_logger:line("Binned lines count: " .. iBinned)	

	return true
end

-- ----------------------------------------------------------------------------
-- basically if we have some command in the commands' list because of an
-- override then communicate with the scanner and exit
--
local function RunApplication()
--	m_logger:line("RunApplication")
	
	-- open logging and the output file
	--
	m_logger:open()
	
	if GetLines() and Process() then SaveServers() end
	
	m_logger:close()
end

-- ----------------------------------------------------------------------------
-- run it
--
RunApplication()

-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
