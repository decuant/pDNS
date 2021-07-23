-- ----------------------------------------------------------------------------
--
--  pDNS - polling dns
--
-- ----------------------------------------------------------------------------

local trace		= require("lib.trace")		-- shortcut for tracing
local _			= require("lib.window")		-- GUI for the application
local DNSFactory= require("lib.dnsclient")

local _frmt		= string.format
local _cat		= table.concat

-- ----------------------------------------------------------------------------
--
local m_logger = trace.new("debug")

-- ----------------------------------------------------------------------------
--
local m_App =
{
	sAppVersion		= "0.0.3",				-- application's version
	sAppName		= "Polling DNS",		-- name for the application
	sRelDate 		= "2021/07/19",

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
local function PurgeHosts(inWhich)
	m_logger:line("PurgeHosts")

	local tServers	= m_App.tServers
	local tResult	= { }
	
	for _, server in next, tServers do
		
		if 1 == server.iEnabled and server:HasCompletedAll() then
			
			local iDnsRes 	= server:Result()
			local iExpected = 0
			
			for i=1, #server.tAddresses do
				
				if server:IsValid(i) then iExpected = iExpected + (1 << (i - 1)) end
			end
			
			if 1 == inWhich then
				
				-- keep failed
				--
				if iExpected ~= iDnsRes then tResult[#tResult + 1] = server end
			else
				
				-- keep responding
				--
				if iExpected == iDnsRes then tResult[#tResult + 1] = server end
			end
			
		else
			
			-- if not enabled or not completed then must save it
			--
			tResult[#tResult + 1] = server
		end
	end
	
	-- if we have results then swap tables
	--
	if #tResult then m_App.tServers = tResult end
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
	
	if _tList then m_App.tSamples = _tList end

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
	
	CreateMainWindow(m_App)
	ShowMainWindow()
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
	m_App.PurgeHosts	= PurgeHosts
end

-- ----------------------------------------------------------------------------
-- run it
--
SetupPublic()
RunApplication()

-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
