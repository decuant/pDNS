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
local _sort		= table.sort
local _floor	= math.floor
local _abs		= math.abs

-- ----------------------------------------------------------------------------
--
local m_logger	= trace.new("debug")

-- the random number generator
--
local m_random  = random.new()
m_random:initialize()

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
	sAppVersion	= "0.0.6",				-- application's version
	sAppName	= "Polling DNS",		-- name for the application
	sRelDate 	= "2021/08/12",

	tServers	= { },					-- list of DNS servers
	iColSort	= 0,					-- column used for sorting
	
	tHitTest	= nil,					-- hit test counters
	tFailAddr	= nil,					-- hit fail counters
	iTheresold	= 5,					-- cut high filter
	
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
-- get the next hostname from the list in samplehosts.lua
--
local function GetCyclicHost()

	local iCurHost	= m_App.iCurHost
	local tSamples	= m_App.tSamples

	if not next(tSamples) then return "" end

	iCurHost = iCurHost + 1
	if iCurHost > #tSamples then iCurHost = 1 end
	
	m_App.iCurHost = iCurHost
	return tSamples[iCurHost]
end

-- ----------------------------------------------------------------------------
-- get a casual hostname from the list in samplehosts.lua
--
local function GetRandomHost()
	
	local tSamples	= m_App.tSamples
	if not next(tSamples) then return "" end
	
	-- take a random index
	--
	local iCurHost = _floor(m_random:getBoxed(1, #tSamples + 1))

	return tSamples[iCurHost]
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
--
local function IndexFromText(inStart, inText)
--	m_logger:line("IndexFromText")
	
	local tServers = m_App.tServers
	if not next(tServers) then return -1 end
	
	inText = inText or ""
	if 0 == #inText then return -1 end
	
	local sMatch = inText:lower()
	
	for i=inStart, #tServers do
		
		if _find(tServers[i].sReference:lower(), sMatch, 1, true) then
			
			return i
		end
	end
	
	return -1
end

-- ----------------------------------------------------------------------------
-- swap elements around in the servers' list
--
local function OnCheckValid()
--	m_logger:line("OnCheckValid")

	local tServers = m_App.tServers

	for _, server in next, tServers do
		
		if 0 == server.iDnsExpected then server.iEnabled = 0 end
	end
end

-- ----------------------------------------------------------------------------
-- invert first with last
--
local function OnInvert()
--	m_logger:line("OnInvert")

	local tServers	= m_App.tServers
	local iMax		= _floor(#tServers / 2)
	local y

	for i=1, iMax do
		
		y = #tServers - i + 1
		
		tServers[i], tServers[y] = tServers[y], tServers[i]
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
	local y

	for i=1, iMax do
		
		y = _floor(m_random:getBoxed(ilower, iUpper))
		
		tServers[i], tServers[y] = tServers[y], tServers[i]
	end
	
	-- not sorted
	--
	m_App.iColSort = 0
end

-- ----------------------------------------------------------------------------
-- sort the list based on column index
-- if the list is already sorted then invert it
--
local function OnSort(inColumn)
--	m_logger:line("OnSort")

	_compare2 = function(a, b)
		
		if not a.tAddresses[1] or not b.tAddresses[1] then return true end
		
		return a.tAddresses[1]:IP4Number() < b.tAddresses[1]:IP4Number()
	end

	_compare3 = function(a, b)
		
		if not a.tAddresses[2] or not b.tAddresses[2] then return true end
		
		return a.tAddresses[2]:IP4Number() < b.tAddresses[2]:IP4Number()
	end

	_compare4 = function(a, b)	
		
		return a.sReference < b.sReference 
	end
	
	-- check for an invert
	--
	if m_App.iColSort == inColumn then 
		
		OnInvert()
		m_App.iColSort = 0
		
		return
	end

	-- apply the sorting here
	--
	local tServers	= m_App.tServers

	if 2 == inColumn then
		
		table.sort(tServers, _compare2)
		
	elseif 3 == inColumn then
	
		table.sort(tServers, _compare3)
		
	elseif 4 == inColumn then
		
		table.sort(tServers, _compare4)
	end
	
	m_App.iColSort = inColumn
end

-- ----------------------------------------------------------------------------
-- enable servers at random
-- will behave incrementally during session
--
local function OnFuzzyEnable()
--	m_logger:line("OnFuzzyEnable")

	local tServers = m_App.tServers
	if 0 == #tServers then return end

	-- make a random start point
	--
	local iIndex = _floor(m_random:getBoxed(1, 3))

	-- use a random step
	--
	while #tServers >= iIndex do
		
		if 0 == tServers[iIndex].iEnabled then
			
			tServers[iIndex].iEnabled = _floor(m_random:getBoxed(0, 2))
		end
		
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
--	m_logger:line("OnFilterFailing")

	if 0 >= inTheresold then return 0 end

	local tServers = m_App.tServers
	if not next(tServers) then return 0 end
	
	local tFailAddr = m_App.tFailAddr
	local tList		= tFailAddr.tList
	if not next(tList) then return 0 end

	-- check each server
	--
	local iTouch = 0
	
	for _, server in next, tServers do
		
		-- get the compny name in failing list
		--
		local tCompany = tList[server.sReference]
		
		if tCompany then
			
			-- for each address of the server
			--
			for i, addr in next, server.tAddresses do
				
				-- get the hits, if any
				--
				local iCounter = tCompany[addr.sAddress]
				
				if iCounter and inTheresold <= iCounter then
					
					server:ChangeAddress(i, "")
					iTouch = iTouch + 1
				end
			end
		end
	end
	
	-- disable row when a server has not 1 valid ip address
	--
	OnCheckValid()
	
	return iTouch
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
-- apply filter for failing addresses with defaults
--
local function OnBasicFilter()
--	m_logger:line("OnBasicFilter")

	-- automatic blanketing of most erroneous addresses
	--
	local iTheresold = m_App.iTheresold

	local iFilterOut = OnFilterFailing(iTheresold)

	if 0 < iFilterOut then
		
		m_logger:line("Cut high filter: " .. iTheresold)
		m_logger:line("Suppressed addresses: " .. iFilterOut)
	end
	
	return 0 < iFilterOut
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
--
local function OnPurgeInvalid()
--	m_logger:line("OnPurgeInvalid")

	local tServers	= m_App.tServers
	local tResult	= { }
	
	if not next(tServers) then return 0 end
	
	for _, server in next, tServers do
		
		if 0 < server.iDnsExpected then tResult[#tResult + 1] = server end
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
-- import hosts' list from file
--
local function OnSetRandomHosts()
	
	local tServers	= m_App.tServers
	if not next(tServers) then return false end

	for _, server in next, tServers do
		
		server:SetQuestion(1, GetRandomHost())
	end

	return true
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
	
	return iBatch, iLastIndex
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
			tServers[i]:SetQuestion(1, GetCyclicHost())
		end
		
		m_App.tServers = tServers
	end
	
	-- reset the sort
	--
	m_App.iColSort = 0
	
--	OnBasicFilter()

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
	if 0 == LoadSampleHosts() then
		
		m_logger:line("Hostnames not specified!")
	end

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

	-- close all streams
	--
	m_logger:closeall()
end

-- ----------------------------------------------------------------------------
--
local function SetupPublic()

	m_App.ImportDNSFile = ImportServersFromFile
	m_App.SaveDNSFile	= SaveServersFile
	m_App.SetRandomHosts= OnSetRandomHosts
	m_App.EnableServers	= EnableServers
	m_App.PurgeInvalid	= OnPurgeInvalid
	m_App.PurgeServers	= PurgeServers
	m_App.DeleteServers	= DeleteServers
	m_App.BasicFilter	= OnBasicFilter
	m_App.RunBatch		= OnRunBatch
	m_App.Scramble		= OnScramble
	m_App.Sort			= OnSort
	m_App.FuzzyEnable	= OnFuzzyEnable
	m_App.ToggleAll		= OnToggleAll
	m_App.FilterByRef	= OnFilterByRef
	m_App.FilterFailing	= OnFilterFailing
	m_App.IndexFromText = IndexFromText
end

-- ----------------------------------------------------------------------------
-- run it
--
SetupPublic()
RunApplication()

-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
