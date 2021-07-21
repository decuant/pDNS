--[[
*	dnsclient.lua
*
*	A client for a DNS server.
*
*	https://public-dns.info/
*
*	Uses UDP.
*	Makes queries only for address resolution.
*	The operation is split into 4 steps:
*		.1	allocate an UDP Lua object;
*		.2	sends a query to the server;
*		.3	receive an answer;
*		.4	close the UDP Lua object.
*	This means that the main processing function has to be called
*	repeatedly until completion (either a succcess or a failure).
*	All operations will retry if failing, up to a hard coded limit.
*	The class holds a integer member variable that signal the success
*	of all addresses for that client, which means:
*		0	complete failure
*		1	address 1 succeeded
*		2	address 2 succeeded
*		3	both addresses succeeded
*
*
* NB: 	although on ZeroBrane require "socket" would work anyway, running
*		the application from a shell won't work, thus it is necessary to
*		use the require "socket.core".
*		in socket.dll the entry point is "luaopen_socket_core"!
]]

-- ----------------------------------------------------------------------------
--
local socket	= require("socket.core")
local DNSProt	= require("lib.dnsprotocol")
local Timers	= require("lib.ticktimer")
local trace 	= require("lib.trace")

local _udp	= socket.udp
local _frmt	= string.format
local _cat	= table.concat


-- ----------------------------------------------------------------------------
-- if the required trace does not exist then allocate a new one
--
local m_trace = trace.new("debug")

-- ----------------------------------------------------------------------------
-- the protocol class is all static, it's not necessary to allocate
-- multiple instances (1 for each address)
--
local m_Protocol = DNSProt.new()

-- ----------------------------------------------------------------------------
-- list of test urls
--
local m_tHostURLs =
{ 	
	"worldweather.wmo.int",
	"www.ildubbio.news",
	"www.barbarianfc.co.uk",
	"support.microsoft.com",
	"www.example.com",
	"lua-users.org",
	"pcsupport.lenovo.com",
	"news.ycombinator.com",
	"graphics.stanford.edu",
	"www.ilfattoquotidiano.it",
	"root-servers.org",
	"time.com",
	"www.wordreference.com",
	"photo.net",
	"www.opensubtitles.org",
	"worldarchery.sport",
	"en.wikipedia.org",
	"dillinger.io",
	"wxwidgets.org",
	"docs.microsoft.com",
	"satellites.pro",
	"english.alarabiya.net",
	"www.facebook.com",
	"www.baobabs.com",
	"www.gmail.com",
	"tineye.com",
	"www.nasa.gov",
	"www.imdb.com",
	"it.glosbe.com",
	"olympics.com",
	"www.thisanerror.xyz",
	"www.photo.net",
	"it.yahoo.com",
}

-- ----------------------------------------------------------------------------
-- get a name from the list above
--
local m_iCurHost = 0

local function _getNextHost()
	
	m_iCurHost = m_iCurHost + 1
	if m_iCurHost > #m_tHostURLs then m_iCurHost = 1 end
	
	return m_tHostURLs[m_iCurHost]
end

-- ----------------------------------------------------------------------------
-- remove leading whitespace from string.
-- http://en.wikipedia.org/wiki/Trim_(programming)
--
local function str_ltrim(inString)
	
	if not inString then return "" end

	return inString:gsub("^%s*", "")
end

-------------------------------------------------------------------------------
--
local Address   = { }
Address.__index = Address

local m_MaxProtStep = 5
local m_MaxProtRetr = 4
local m_ProtTimeout	= 0.500

-- ----------------------------------------------------------------------------
--
function Address.new(inAddress)

	local t =
	{
		sAddress	= str_ltrim(inAddress),
		
		tTickAt  	= Timers.new(sIPAddr),
		iRetries 	= 0,
		
		iCurStep	= 1,
		iCurFrameId	= 0,
		hSocket		= nil,
	}
	
	-- disable if empty address
	--
	if 0 == #t.sAddress then t.iCurStep = m_MaxProtStep end
	
	return setmetatable(t, Address)
end

-- ----------------------------------------------------------------------------
--
function Address.IsValid(self)

	return 0 < #self.sAddress
end

-- ----------------------------------------------------------------------------
-- check if we're done with stepping
--
function Address.HasCompleted(self)
	
	return not (m_MaxProtStep > self.iCurStep)
end

-- ----------------------------------------------------------------------------
-- check if we're done with stepping
--
function Address.ResetCompleted(self)
	
	self.iRetries	 = 0
	self.iCurStep	 = 1
	self.iCurFrameId = 0
end

-------------------------------------------------------------------------------
--
local DnsClient   = { }
DnsClient.__index = DnsClient

-- ----------------------------------------------------------------------------
-- client for a DNS server
--
function DnsClient.new(inEnabled, inLabel)

	local t =
	{
		iEnabled	= inEnabled or 0,			-- enabled flag
		sReference	= inLabel or "",			-- reference name
		
		tAddresses	= { },						-- associated addresses
		iDnsResult	= 0,						-- 0/1/2/3 result of query
	}
	
	return setmetatable(t, DnsClient)
end

-- ----------------------------------------------------------------------------
--
function DnsClient.ToString(self)
	
	local sOutput = { }
	
	sOutput[#sOutput + 1] = _frmt("%d", self.iEnabled)
	
	for i=1, #self.tAddresses do
		
		sOutput[#sOutput + 1] = _frmt("\"% 15s\"", self.tAddresses[i].sAddress)
	end
	
	sOutput[#sOutput + 1] = _frmt("\"%s\"", self.sReference)
	
	return _cat(sOutput, ", ")
end

-- ----------------------------------------------------------------------------
--
function DnsClient.AddAddress(self, inAddress)

	if not inAddress then return end
	
	self.tAddresses[#self.tAddresses + 1] = Address.new(inAddress)
end

-- ----------------------------------------------------------------------------
-- check for valid address
--
function DnsClient.IsValid(self, inIndex)
	
	local tAddress = self.tAddresses[inIndex]
	
	if tAddress then return tAddress:IsValid() end
	
	return false
end

-- ----------------------------------------------------------------------------
-- check if we're done with stepping
--
function DnsClient.HasCompleted(self, inIndex)
	
	local tAddress = self.tAddresses[inIndex]
	
	if tAddress and tAddress:IsValid() then return tAddress:HasCompleted() end
	
	return true
end

-- ----------------------------------------------------------------------------
-- check if we're done with stepping
--
function DnsClient.Restart(self)
	
	for i=1, #self.tAddresses do
		
		self.tAddresses[i]:ResetCompleted()
	end
	
	self.iDnsResult = 0
end

-- ----------------------------------------------------------------------------
-- check if we're done with stepping
--
function DnsClient.HasCompletedAll(self)
	
	local bReturn = true
	
	for i=1, #self.tAddresses do
		
		bReturn = bReturn and self:HasCompleted(i)
	end
	
	return bReturn
end

-- ----------------------------------------------------------------------------
-- get the return value after query and answer
--
function DnsClient.Result(self)
	
	return self.iDnsResult
end

-- ----------------------------------------------------------------------------
-- main switch
--
function DnsClient.ProcessStatus(self, inIndex)
--	m_trace:line("ProcessStatus")

	local tAddress	= self.tAddresses[inIndex]
	
	if not tAddress then 
		
		m_trace:showerr("Program error, invalid index", inIndex)
		
		return false
	end
	
	-- check valid protocol step
	--
	local iProtStep	= tAddress.iCurStep
	
	if iProtStep > m_MaxProtStep then
		
		m_trace:showerr("Program error, invalid protocol step", iProtStep)
		
		return false
	end
	
	local sAddress	= tAddress.sAddress
	local hSocket	= tAddress.hSocket
	local tTickAt	= tAddress.tTickAt
	local bReturn	= false

	-- check for the current retry
	--
	if not tTickAt:isEnabled() then
		
		tTickAt:setup(m_ProtTimeout, true)			-- time out for operation
		tAddress.iRetries = 1
	else
		
		if tTickAt:hasFired() then
			
			tTickAt:reset()
			tAddress.iRetries = tAddress.iRetries + 1
--			
--			m_trace:line(_frmt("RESET %s retries [%d]", tTickAt:toString(), tAddress.iRetries))
--		else
--			
--			m_trace:line(_frmt("RETRY %s retries [%d]", tTickAt:toString(), tAddress.iRetries))
		end
	end

	-- check if too many retries
	--
	if m_MaxProtRetr <= tAddress.iRetries then
		
		m_trace:showerr("Too many retries", sAddress)
		
		-- shutdown
		--
		iProtStep = m_MaxProtStep - 1
	end

	-- --------------------
	-- --------------------
	-- switch on the status
	--
	if 1 == iProtStep then
		
		m_trace:line("• Allocating: " .. sAddress)
		
		hSocket = assert(_udp())
		hSocket:settimeout(0.0002)				-- socket.dll won't work without
		
		-- remember status
		--
		tAddress.hSocket	= hSocket
		tAddress.iCurStep	= 2
		tTickAt:enable(false)
		
		bReturn				= true
		
	elseif 2 == iProtStep then
		
		m_trace:line("• Sending: " .. sAddress)
		
		-- build the query
		--
		local sQuestion, iFrameId = m_Protocol:FormatIPQuery(1, _getNextHost())
		
		if not sQuestion or not hSocket:sendto(sQuestion, sAddress, 53) then
			
			m_trace:showerr( "No question sent", sAddress)
		else
			
			m_trace:dump("Query", sQuestion)
			
			-- remember status
			--
			tAddress.iCurStep	= 3
			tAddress.iCurFrameId= iFrameId
			tTickAt:enable(false)

			bReturn				= true
		end
		
	elseif 3 == iProtStep then
		
		m_trace:line("• Receiving: " .. sAddress)
		
		local sCurFrame = hSocket:receive()
		
		if not sCurFrame or 0 == #sCurFrame then
			
			m_trace:showerr( "No data received", sAddress)
		else
			
			m_trace:dump("Reply", sCurFrame)
			
			if m_Protocol:ParseMessage(sCurFrame, tAddress.iCurFrameId) then
				
				self.iDnsResult = self.iDnsResult + inIndex
			end
			
			-- remember status
			--
			tAddress.iCurStep	= 4
			tTickAt:enable(false)
			
			bReturn				= true			
		end
		
	elseif 4 == iProtStep then
		
		m_trace:line("• Windup: " .. sAddress)
		
		-- remember status
		--
		tAddress.hSocket	= nil
		tAddress.iCurStep	= m_MaxProtStep
		tTickAt:enable(false)						-- disable the tick timer
		
		bReturn				= true
	end

	return bReturn
end

-- ----------------------------------------------------------------------------
-- process each address
--
function DnsClient.RunTask(self)
--	m_trace:line("RunTask")

	if 0 == self.iEnabled then return end
	
	-- fail check (nothing to do)
	--
	if 0 == #self.tAddresses then return end
	
	m_trace:summary("Server: " .. self.sReference)	
	
	-- for each defined address
	--
	for iIndex=1, #self.tAddresses do
		
		if self:IsValid(iIndex) and not self:HasCompleted(iIndex) then
			
			-- advance stepping
			--
			self:ProcessStatus(iIndex)
		end
	end
	
	m_trace:endsummary()
end

-- ----------------------------------------------------------------------------
--
return DnsClient

-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
