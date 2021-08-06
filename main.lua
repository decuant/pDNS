-- ----------------------------------------------------------------------------
--
-- pDNS - polling dns
--
-- ----------------------------------------------------------------------------

local trace		= require("lib.trace")			-- shortcut for tracing
local mainWin	= require("lib.window")			-- GUI for the application
local hits  	= require("lib.hittable")
local DNSFactory= require("lib.dnsclient")		-- DNS client
local random	= require("lib.random")			-- random number generator

local _frmt		= string.format
local _find		= string.find
local _gmatch	= string.gmatch
local _cat		= table.concat
local _floor	= math.floor
local _abs		= math.abs

-- ----------------------------------------------------------------------------
--
local m_logger	= trace.new("debug")
local m_random  = random.new()

-------------------------------------------------------------------------------
-- crate the statistic table and set the enable flag
--


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
	sAppVersion	= "0.0.5",				-- application's version
	sAppName	= "Polling DNS",		-- name for the application
	sRelDate 	= "2021/08/01",

	tServers	= { },					-- list of DNS servers
	tHitTest	= nil,					-- hit test counters
	tFailAddr	= nil,
	
	iCurHost	= 0,					-- index for the next host
	tSamples	= { },					-- list of sample hosts
	
	hMainWin	= mainWin,
}

-- ----------------------------------------------------------------------------
--
local m_Config =
{
	sConfigFile	= "data/servers.lua",
	sHostsFile	= "data/samplehosts.lua",
}

--_ENV.FileList = m_Config						-- make it globally accessible

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
-- swap elements around in the servers' list
--
local function OnCheckValid()
	m_logger:line("OnCheckValid")

	local tServers	= m_App.tServers

	for _, server in next, tServers do
		
		if 0 == server.iDnsExpected then server.iEnabled = 0 end
	end
end

-- ----------------------------------------------------------------------------
-- swap elements around in the servers' list
--
local function OnScramble()
--	m_logger:line("OnScramble")

	local tServers	= m_App.tServers
	local iMax		= _floor(#tServers / 2)
	local iUpper	= #tServers
	local ilower	= iMax + 1

	local tTemp
	local iSwap

	for i=1, iMax do
		
		iSwap = _floor(m_random:getBoxed(ilower, iUpper))
		
		tTemp 			= tServers[i]
		tServers[i]		= tServers[iSwap]
		tServers[iSwap] = tTemp
	end
end

-- ----------------------------------------------------------------------------
-- swap elements around in the servers' list
--
local function OnFuzzyToggle()
--	m_logger:line("OnFuzzyToggle")

	local tServers = m_App.tServers
	if 0 == #tServers then return end

	-- make a random start point
	--
	local iIndex = _floor(m_random:getBoxed(1, 5))

	-- use a random step
	--
	while #tServers >= iIndex do
		
		tServers[iIndex].iEnabled = _floor(m_random:getBoxed(0, 2))
		
		iIndex = iIndex + _floor(m_random:getBoxed(1, 5))
	end
	
	OnCheckValid()
end

-- ----------------------------------------------------------------------------
-- swap elements around in the servers' list
--
local function OnToggleAll()
--	m_logger:line("OnFuzzyToggle")

	local tServers = m_App.tServers
	if 0 == #tServers then return end

	for _, server in next, tServers do
		
		server.iEnabled = _abs(server.iEnabled - 1)
	end
	
	OnCheckValid()
end

-- ----------------------------------------------------------------------------
-- swap elements around in the servers' list
--
local function OnFilterFailing(inTheresold)
	m_logger:line("OnFilterFailing")

	local tServers = m_App.tServers
	if 0 == #tServers then return end
	
	local tFailAddr = m_App.tFailAddr
	if 0 == tFailAddr:count() then return end

	local tList		= tFailAddr.tList
	local tCompany
	local iCounter
	
	for _, server in next, tServers do
		
		tCompany = tList[server.sReference]
		
		if tCompany then
			
			for i, addr in next, server.tAddresses do
				
				iCounter = tCompany[addr.sAddress]
				
				if iCounter and inTheresold <= iCounter then
					
					m_logger:line("Blanking address: " .. addr.sAddress)
					
					server:ChangeAddress(i, "")
				end
			end
		end
	end
	
	OnCheckValid()
end

-- ----------------------------------------------------------------------------
-- select servers that have some text in sReference
-- selection string supports multiple options with ';'
--
local function OnFilterByRef(inString)
--	m_logger:line("OnFilterByRef")

	local tServers = m_App.tServers
	if 0 == #tServers then return false end

	inString = inString or ""
	if 0 == #inString then return false end
	
	-- list without repetitions
	--
	local tNewList = { }
	
	-- check if inServer is not in tNewList
	--
	Exists = function(inServer)
		
		for _, test in next, tNewList do
			
			if test == inServer then return true end
		end
		
		return false
	end		

	-- for each token process all servers
	--
	for sToken in _gmatch(inString, "[^;]*") do
		
		if 0 < #sToken then
			
			for _, server in next, tServers do
				
				if _find(server.sReference, sToken, 1, true) then
					
					if not Exists(server) then
						
						tNewList[#tNewList + 1] = server
					end
				end
			end
		end
	end
	
	-- check if changed
	--
	if 0 < #tNewList then
		
		m_App.tServers = tNewList
		collectgarbage()
		
		return true
	end
	
	return false
end

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
	
	OnCheckValid()

	for _, server in next, tServers do
		
		if 1 == server.iEnabled and server:HasCompletedAll() then
			
			local iResult, iExpected = server:ClientStatus()
			
			if Purge.verified == inWhich then
				
				-- keep failed
				--
				if iResult ~= iExpected then
					
					tResult[#tResult + 1] = server
				end
			else
				
				-- keep responding
				--
				if iResult == iExpected then
					
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

	-- if either the rows' list or the servers' list are empty
	-- then return an empty list
	--
	if not next(tServers) or not next(inRowsList) then return tReturn end

	local tReturn = { }
	local server

	for _, row in next, inRowsList do
		
		server = tServers[row]
		
		if server then 
			
			if 0 == server.iDnsExpected then 
				
				server.iEnabled = 0
			else
				
				server.iEnabled = inEnabled 
				tReturn[#tReturn + 1] = row
			end
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
-- run a task for each server in list, up to limit in parameter
--
local function OnRunBatch(inLimit)
--	m_logger:line("OnRunBatch")

	local tServers	= m_App.tServers
	local iBatch	= 0
	local iLastIndex= 0

	-- check each server
	--
	for i, tCurrent in next, tServers do
		
		if 1 == tCurrent.iEnabled and not tCurrent:HasCompletedAll() then
			
			-- cyle it
			--
			tCurrent:RunTask()
			iBatch = iBatch + 1
			
			-- status changed
			--
			if tCurrent:HasCompletedAll() then iLastIndex = i end
		end
		
		-- check for end of batch
		--
		if inLimit == iBatch then break end
	end
	
	-- if idling then flush stats
	--
	if 0 == iBatch then 
		
		if m_App.tHitTest:backup() then collectgarbage() end
	end
	
	return iBatch, iLastIndex
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
	
	-- automatic blanketing of most erroneous addresses
	--
	OnFilterFailing(50)

	return #m_App.tServers
end

-- ----------------------------------------------------------------------------
-- save servers' list to file
--
local function SaveServersFile()
--	m_logger:line("SaveServersFile")	
	
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
	
	m_logger:time(m_App.sAppName .. " [Rel. " .. m_App.sAppVersion .. "]")	
	
	assert(os.setlocale('ita', 'all'))
	m_logger:line("Current locale is [" .. os.setlocale() .. "]")
	
	-- load hosts from sample file
	--
	LoadSampleHosts()
	
	m_random:initialize()
	
	-- load the hit test table
	-- (enable/disable in parameter)
	--
	m_App.tHitTest = hits.new(true, "data\\Hit-Test.lua")
	m_App.tHitTest:restore()

	-- again, load the purged addresses
	--
	m_App.tFailAddr = hits.new(true, "data\\Hit-Fail.lua")
	m_App.tFailAddr:restore()
	
	-- register globally
	--
	_G.m_ThisApp	= m_App
	_G.m_HitTest	= m_App.tHitTest
	_G.m_FailAddr	= m_App.tFailAddr
	
	return true
end

-- ----------------------------------------------------------------------------
-- from here on the GUI will have control
-- the timer function of the main window will keep alive this module
--
local function ShowGUI()
--	m_logger:line("ShowGUI")
	
	mainWin.CreateMainWindow()
	mainWin.ShowMainWindow()
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

	m_App.tHitTest:backup()
	m_App.tFailAddr:backup()

	m_logger:line(m_App.sAppName .. " terminated")

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
	m_App.RunBatch		= OnRunBatch
	m_App.Scramble		= OnScramble
	m_App.FuzzyToggle	= OnFuzzyToggle
	m_App.ToggleAll		= OnToggleAll
	m_App.FilterByRef	= OnFilterByRef
	m_App.FilterFailing	= OnFilterFailing
end

-- ----------------------------------------------------------------------------
-- run it
--
SetupPublic()
RunApplication()

-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
