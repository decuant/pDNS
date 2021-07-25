-- ----------------------------------------------------------------------------
--
-- pDNS - polling dns
--
-- ----------------------------------------------------------------------------

local trace		= require("lib.trace")			-- shortcut for tracing
local mainWin	= require("lib.window")			-- GUI for the application
local DNSFactory= require("lib.dnsclient")		-- DNS client

local _frmt		= string.format
local _cat		= table.concat

-- ----------------------------------------------------------------------------
--
local m_logger = trace.new("debug")

-- ----------------------------------------------------------------------------
-- options for the Purge filter
--
local Purge =
{
	failed	 = 0,
	verified = 1,
}

_ENV.Purge = Purge							-- make it globally accessible
	
-- ----------------------------------------------------------------------------
--
local m_App =
{
	sAppVersion		= "0.0.4",				-- application's version
	sAppName		= "Polling DNS",		-- name for the application
	sRelDate 		= "2021/07/23",

	tServers		= { },					-- list of DNS servers
	
	iCurHost		= 0,					-- index for the next host
	tSamples		= { },					-- list of sample hosts
}

-- ----------------------------------------------------------------------------
--
local m_Config =
{
	sConfigFile		= "data/servers.lua",
	sHostsFile		= "data/samplehosts.lua",
}

-- ----------------------------------------------------------------------------
-- get a name from the list in samplehosts.lua
--
local function GetNextHost()
	
	local iCurHost	= m_App.iCurHost
	local tSamples	= m_App.tSamples
	
	iCurHost = iCurHost + 1
	if iCurHost > #tSamples then iCurHost = 1 end
	
	m_App.iCurHost = iCurHost
	return tSamples[iCurHost]
end

-- ----------------------------------------------------------------------------
--

-- ----------------------------------------------------------------------------
--

-- ----------------------------------------------------------------------------
--

-- ----------------------------------------------------------------------------
-- remove servers from the main table depending on the criteria
-- 0: remove failing hosts
-- 1: remove responding hosts
--
local function PurgeServers(inWhich)
--	m_logger:line("PurgeServers")

	local tServers	= m_App.tServers
	local tResult	= { }
	
	if not next(tServers) then return false end

	for _, server in next, tServers do
		
		if 1 == server.iEnabled and server:HasCompletedAll() then
			
			local iDnsRes 	= server:Result()
			local iExpected = 0
			
			-- sum up the expected result
			--
			for i=1, #server.tAddresses do
				
				if server:IsValid(i) then iExpected = iExpected + (1 << (i - 1)) end
			end
			
			if Purge.verified == inWhich then
				
				-- keep failed
				--
				if iExpected ~= iDnsRes then
					
					tResult[#tResult + 1] = server
				end
			else
				
				-- keep responding
				--
				if iExpected == iDnsRes then
					
					tResult[#tResult + 1] = server
				end
			end
		else
			
			-- if not enabled or not completed then must save it
			--
			tResult[#tResult + 1] = server
		end
	end
	
	-- if we have results then swap tables
	--
	local bModified	= (#m_App.tServers ~= #tResult)
	
	if bModified then
		
		m_App.tServers = tResult
		collectgarbage()
	end
	
	return bModified
end

-- ----------------------------------------------------------------------------
-- receive a list of rows to update and returns a list of rows updated
-- note that it's a 1 based list
--
local function EnableServers(inRowsList, inEnabled)
--	m_logger:line("EnableServers")

	local tServers 	= m_App.tServers
	local tReturn	= { }

	-- if either the rows' list or the servers' list are empty
	-- then return an empty list
	--
	if not next(tServers) or not next(inRowsList) then return tReturn end

	local server

	for _, row in next, inRowsList do
		
		server = tServers[row]
		
		if server then 
			
			server.iEnabled = inEnabled 
			tReturn[#tReturn + 1] = row
		end
	end

	return tReturn
end

-- ----------------------------------------------------------------------------
-- receive a list of rows to delete
-- note that it's a 1 based list
--
local function DeleteServers(inRowsList)
--	m_logger:line("DeleteServers")
	
	local tServers 	= m_App.tServers
	
	-- check if applicable
	--
	if not next(tServers) or not next(inRowsList) then return end
	
	local tList = { }
	local y 	= 1
	
	for i=1, #inRowsList do
		
		while inRowsList[i] > y do
			
			tList[#tList + 1] = tServers[y]
			y = y + 1
		end
		
		y = inRowsList[i] + 1
	end
	
	-- copy over the remaining servers
	--
	while y <= #tServers do
		
		tList[#tList + 1] = tServers[y]
		y = y + 1
	end

	-- store result
	--
	m_App.tServers = tList
	collectgarbage()
end

-- ----------------------------------------------------------------------------
-- import hosts' list from file
--
local function LoadSampleHosts()
--	m_logger:line("LoadSampleHosts")	
	
	local sConfigFile = m_Config.sHostsFile
	
	m_logger:line("Loading hosts from file [" .. sConfigFile .. "]")

	-- reset old values
	--
	m_App.iCurHost	= 0
	m_App.tSamples	= { }
	
	-- process file
	--
	if not wx.wxFileName().Exists(sConfigFile) then return 0 end

	local _tList = dofile(sConfigFile)
	
	if _tList then 
		
		m_App.tSamples = _tList
		collectgarbage()	
	end

	return #m_App.tSamples
end

-- ----------------------------------------------------------------------------
-- import servers' list from file
--
local function ImportServersFromFile()
--	m_logger:line("ImportServersFromFile")	
	
	local sConfigFile = m_Config.sConfigFile
	
	m_logger:line("Loading servers from file [" .. sConfigFile .. "]")

	-- reset old values
	--
	m_App.tServers = { }
	collectgarbage()
	
	-- process file
	--
	if not wx.wxFileName().Exists(sConfigFile) then return 0 end

	local _tList = dofile(sConfigFile)
	
	if _tList then
	
		-- assign the just loaded list
		--
		local tServers = { }
		
		-- create a dns client for each
		--
		for i, data in next, _tList do
		
			-- assign enable state and name
			--
			tServers[i] = DNSFactory.new(data[1], data[4])
			
			-- assign addresses
			--
			tServers[i]:AddAddress(data[2])
			tServers[i]:AddAddress(data[3])
			
			-- assign a host for question
			--
			tServers[i]:SetQuestion(1, GetNextHost())
		end
		
		m_App.tServers = tServers
	end
	
	return #m_App.tServers
end

-- ----------------------------------------------------------------------------
-- save servers' list to file
--
local function SaveServersFile()
	m_logger:line("SaveServersFile")	
	
	local sConfigFile = m_Config.sConfigFile
	
	m_logger:line("Saving servers to file [" .. sConfigFile .. "]")
	
	-- build the string
	--
	local tOutput = { }
	local tServers = m_App.tServers
	
	tOutput[#tOutput + 1] = "local _servers =\n{"

	for _, server in next, tServers do
		
		tOutput[#tOutput + 1] = _frmt("\t{%s},", server:ToString())
	end
	
	tOutput[#tOutput + 1] = "}\n\nreturn _servers\n"
	
	-- process file
	--
	local fd = io.open(sConfigFile, "w")
	if not fd then return false end
	
	fd:write(_cat(tOutput, "\n"))
	io.close(fd)

	return true
end

-- ----------------------------------------------------------------------------
-- preamble
--
local function SetUpApplication()
--	m_logger:line("SetUpApplication")
	
	math.randomseed(os.time())
	
	m_logger:time(m_App.sAppName .. " [Rel. " .. m_App.sAppVersion .. "]")	
	
	assert(os.setlocale('ita', 'all'))
	m_logger:line("Current locale is [" .. os.setlocale() .. "]")
	
	-- load hosts from sample file
	--
	LoadSampleHosts()
	
	return true
end

-- ----------------------------------------------------------------------------
-- from here on the GUI will have control
-- the timer function of the main window will keep alive this module
--
local function ShowGUI()
--	m_logger:line("ShowGUI")
	
	mainWin.CreateMainWindow(m_App)
	mainWin.ShowMainWindow()
end

-- ----------------------------------------------------------------------------
-- leave clean
--
local function QuitApplication()
--	m_logger:line("QuitApplication")
	
--	CloseMainWindow()
	
	m_logger:line(m_App.sAppName .. " terminated")
end

-- ----------------------------------------------------------------------------
-- basically if we have some command in the commands' list because of an
-- override then communicate with the scanner and exit
--
local function RunApplication()
--	m_logger:line("RunApplication")

	Purge.failed = -2

	-- open logging and the output file
	--
	m_logger:open()

	if SetUpApplication() then ShowGUI() end

	QuitApplication()

	m_logger:close()
end

-- ----------------------------------------------------------------------------
--
local function SetupPublic()

	m_App.ImportDNSFile = ImportServersFromFile
	m_App.SaveDNSFile	= SaveServersFile
	m_App.EnableServers	= EnableServers
	m_App.PurgeServers	= PurgeServers
	m_App.DeleteServers	= DeleteServers
end

-- ----------------------------------------------------------------------------
-- run it
--
SetupPublic()
RunApplication()

-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
