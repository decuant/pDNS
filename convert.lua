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
-- these are filters examples divided by continent
-- since name servers country codes are 2 digit long I used the list below
--
-- https://worldpopulationreview.com/country-rankings/list-of-countries-by-continent
--
-- https://en.wikipedia.org/wiki/Country_code_top-level_domain
--
local m_tF_Europe =
{
	"(IT)",				-- Italy
	"(SM)",				-- San Marino
	"(VA)",				-- Vatican City
	"(GR)",				-- Greece
	"(PO)",				-- Poland
	"(DE)",				-- Germany
	"(AT)",				-- Austria
	"(BE)",				-- Belgium
	"(NL)",				-- Netherlands
	"(FR)",				-- France
	"(DK)",				-- Denmark
	"(FI)",				-- Finland
	"(IS)",				-- Iceland
	"(NO)",				-- Norway
	"(SE)",				-- Sweden
	"(CZ)",				-- Czech Republic
	"(SK)",				-- Slovakia
	"(HU)",				-- Hungary
	"(RO)",				-- Romania
	"(EE)",				-- Estonia
	"(LV)",				-- Latvia
	"(LT)",				-- Lithuania
	"(MD)",				-- Moldova
	"(LI)",				-- Liechtenstein
	"(LU)",				-- Luxembourg
	"(MC)",				-- Monaco
	"(CH)",				-- Switzerland	
	"(ES)",				-- Spain
	"(PT)",				-- Portugal
	"(AD)",				-- Andorra
	"(SI)",				-- Slovenia
	"(HR)",				-- Croatia (Hrvatska)
	"(RS)",				-- Serbia
	"(ME)",				-- Montenegro
	"(MK)",				-- North Macedonia
	"(AL)",				-- Albania
	"(UK)",				-- United Kingdom
	"(IE)",				-- Ireland
}

local m_tF_NorthAmerica =
{
	"(CA)",				-- Canada
	"(US)",				-- United States
	"(MX)",				-- Mexico
	"(CU)",				-- Cuba
	"(JM)",				-- Jamaica
	"(GT)",				-- Guatemala
}

local m_tF_SouthAmerica =
{
	"(AR)",				-- Argentina
	"(BO)",				-- Bolivia
	"(BR)",				-- Brazile
	"(CO)",				-- Colombia
}

local m_tF_Asia =
{
	"(AE)",				-- United Arab Emirates
	"(BT)", 			-- Buthan
	"(CN)",				-- China
	"(RU)", 			-- Russia
	"(HK)",				-- Hong Kong
	"(TR)",				-- Turkey
	"(TW)",				-- Taiwan
	"(MV)",				-- Maldives
}

local m_tF_Africa =
{
	"(AO)",				-- Angola
	"(RW)",				-- RWanda
	"(TZ)",				-- Tanzania
	"(ZA)",				-- South Africa
	"(ZM)",				-- Zambia
	"(ZW)",				-- Zimbabwe
}

local m_tF_Oceania =
{
	"(AU)",				-- Australia
	"(NZ)",				-- New Zealand
	"(PG)",				-- Papua New Guinea
	"(WS)",				-- Samoa
}

local m_tF_Antarctica =
{
	"(AQ)",				-- Antarctica	(1 entry in big list)
}

-- ----------------------------------------------------------------------------
--
-- nameservers.csv			filtered list of responding servers
--
-- nameservers-all.csv		complete list of registered servers
--
local m_Config =
{
	sFileInput		= "data/nameservers-all.csv",
	sFileOutput		= "data/nameservers-all.lua",
	
	tFilters		= nil, -- m_tF_Europe,
}

-- ----------------------------------------------------------------------------
-- remove leading whitespace from string.
-- http://en.wikipedia.org/wiki/Trim_(programming)
--
local function str_ltrim(inString)
	
	if not inString then return "" end

	return inString:gsub("^%s*", "")
end

-- ----------------------------------------------------------------------------
-- test if the input string is a valid ip4 address
--
local function str_testip4(inString)
	
	inString = str_ltrim(inString) 
	if 0 == #inString then return false end
	
	local iNumber
	local iParts = 0
	
	for sToken in string.gmatch(inString, "[^.]*") do
		
		iNumber = tonumber(sToken) or -1
		
		if 0 > iNumber or 256 <= iNumber then return false end
		
		iParts = iParts + 1
	end

	return 4 == iParts
end

-- ----------------------------------------------------------------------------
-- select rows that contain the specified text
--
local function ApplyFilters(inTable)
	
	if not inTable then return nil end
	
	local tResults = { }
	local tFilters = m_Config.tFilters
	
	if not tFilters or 0 == #tFilters then return inTable end
	
	for _, server in next, inTable do
		
		for i=1, #tFilters do
			
			-- add the row if filter found
			--
			if server[3]:find(tFilters[i], 1, true) then
				
				tResults[#tResults + 1] = server
				break
			end
		end
	end
	
	return tResults
end

-- ----------------------------------------------------------------------------
-- convert a row to a text line
--
local function ToString(inTable)
	
	local sOutput = { }
	
	-- provide a decent format for the addresses
	--
	for i=1, 2 do
		
		sOutput[#sOutput + 1] = _frmt("\"% 15s\"", inTable[i])
	end

	sOutput[#sOutput + 1] = _frmt("\"%s\"", inTable[3])

	return _cat(sOutput, ", ")
end

-- ----------------------------------------------------------------------------
-- save servers to file
--
local function SaveServers()
	m_logger:line("SaveServers")

	local tServers = m_App.tServers
	
	if not tServers then
		
		m_logger:line("Servers' list is empty!")
		
		return false
	end	
	
	-- get the file's content
	--
	local  fhSrc = io.open(m_Config.sFileOutput, "w")
	if not fhSrc then
		
		m_logger:line("Unable to open destination file: " .. m_Config.sFileOutput)
		
		return false
	end
	
	fhSrc:write("local _servers =\n{\n")
	
	for _, aServer in next, tServers do
		
		fhSrc:write("\t{0," .. ToString(aServer) .. "},\n")
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
		local iCellIndex	= 1
		local tCurRow		= { }
		local sPartial		= ""
		local sLabel		= ""
		
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
		
		if str_testip4(tCurRow[1]) then
		
			-- rows are not stored by index but using a label
			--
			sLabel = tCurRow[2]
			
			if not tServers[sLabel] then
				
				-- add a new entry
				--
				tServers[sLabel] = {tostring(tCurRow[1]), "", sLabel .. " - " .. tCurRow[4] .. " (" .. tCurRow[3] .. ")"}
			else
			
				-- substitute 2nd address
				--
				tServers[sLabel][2] = tostring(tCurRow[1])
			end
		else
			
			m_logger:showerr("invalid buffer", aLine)
		end
	end
	
	-- store table
	--
	m_App.tServers = ApplyFilters(tServers)
	
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
			
			m_logger:line("Binned: " .. sLine)
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
local function RunApplication(...)
--	m_logger:line("RunApplication")
	
	-- open logging and the output file
	--
	m_logger:open()
	
	-- get the arguments if any
	--
	local tArgs = { }

	for _, v in ipairs {...} do tArgs[#tArgs + 1] = v end	
	
	if tArgs[1] then  m_Config.sFileInput	= tArgs[1] end
	if tArgs[2] then  m_Config.sFileOutput	= tArgs[2] end
	
	-- process it
	--
	if GetLines() and Process() then SaveServers() end
	
	m_logger:close()
end

-- ----------------------------------------------------------------------------
-- run it
--
RunApplication(...)

-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
