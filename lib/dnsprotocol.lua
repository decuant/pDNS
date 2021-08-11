--[[
*	dnsprotocol.lua
*
*	https://public-dns.info/
*	https://www.iana.org/assignments/dns-parameters/dns-parameters.xhtml
*
*	DNS protocol message formatting and reply unwinding.
]]

-- ----------------------------------------------------------------------------
--
local trace = require("lib.trace")
local _		= require("lib.hittable")

local _frmt	= string.format
local _chr	= string.char
local _cat	= table.concat
local _sub	= string.sub
local _byte	= string.byte

-- ----------------------------------------------------------------------------
-- if the required trace does not exist then allocate a new one
--
local m_trace = trace.new("protocol")
m_trace:enable(false)
m_trace:open()

-------------------------------------------------------------------------------
-- note that errors start from 0, but in Lua...
--
local tDnsErrCodes =
{
	[1]  = "No error occurred",
	[2]  = "Bad query, format error",
	[3]  = "The server has failed internally",
	[4]  = "The specified name does not exist in the domain",
	[5]  = "Query not supported by the server",
	[6]  = "For policy the server refused to answer",
	[7]  = "A name exists when it should not",
	[8]  = "A resource record set exixts that it should not",
	[9]  = "A resource record set that should exists does not",
	[10] = "Server not authoritative for the zone required",
	[11] = "Specified name is not in specified zone",
	[12] = "DSO-TYPE not implemented",
	[13] = "Not assigned",
	[14] = 13,
	[15] = 13,
	[16] = "Bad OPT version",
	[17] = "TSIG signature failure",
	[18] = "Key not recognized",
	[19] = "Signature out of time window",
	[20] = "Bad TKEY Mode",
	[21] = "Duplicate key name",
	[22] = "Algorithm not supported",
	[23] = "Bad Truncation",
	[24] = "Bad/missing server cookie",
}

-------------------------------------------------------------------------------
-- return a sequential integer, up to a limit and then cycle
--
local m_iLowSeed	= 0x0adb
local m_iTopSeed	= 0x0bda
local m_iCurSeed	= m_iLowSeed

local function _getSeed()
	
	m_iCurSeed = m_iCurSeed + 0x0001
	
	if m_iTopSeed < m_iCurSeed then m_iCurSeed = m_iLowSeed end
	
	return m_iCurSeed
end

-------------------------------------------------------------------------------
--
local DnsProtocol   = { }
DnsProtocol.__index = DnsProtocol

-- ----------------------------------------------------------------------------
--
function DnsProtocol.new()

	local t =
	{
		iMsgId		= 0x0000,
		iType		= 0x0001,
		
		tFlags1	=
		{
			iRd		= 0x0001,		-- Recursion desired
			iTc		= 0x0000,		-- Truncation flag
			iAa		= 0x0000,		-- Authoritative answer flag
			iOp		= 0x0000,		-- Opcode
			iQy		= 0x0000,		-- Query/Response flag
		},
		
		tFlags2	=
		{
			iRc		= 0x0000,		-- Return code
			iRa		= 0x0000,		-- Recursion available
		},
		
		tCounters =
		{
			iQd		=  0x0000,		-- Questions
			iAn		=  0x0000,		-- Answers
			iNs		=  0x0000,		-- Authoritative servers	
			iAr		=  0x0000,		-- Additional records
		},
		
		sUrlReq		= "",
	}

	return setmetatable(t, DnsProtocol)
end

-- ----------------------------------------------------------------------------
-- format the frame for 1 query
--
function DnsProtocol.FormatIPQuery(self, inType, inDestUrl)
--	m_trace:line("FormatIPQuery")
	
	if not inDestUrl or 0 == #inDestUrl then return nil, 0 end
	
	-- store values
	--
	self.iMsgId = _getSeed()
	self.iType	= inType
	
	-- frame header
	--
	local tHeader = { }
	local tFlags1 = self.tFlags1

	tHeader[1] = _chr(self.iMsgId >> 8)
	tHeader[2] = _chr(self.iMsgId % 0x0100)

	tHeader[3] = _chr((tFlags1.iRd << 0) + (tFlags1.iTc << 1) +
				 (tFlags1.iAa << 2) + (tFlags1.iOp << 3) +
				 (tFlags1.iQy << 7))

	tHeader[4] = _chr(0)		-- return code cleared
	
	tHeader[5] = "\0\1"			-- QDCOUNT
	tHeader[6] = "\0\0"			-- ANCOUNT
	tHeader[7] = "\0\0"			-- NSCOUNT
	tHeader[8] = "\0\0"			-- ARCOUNT
	
	-- frame query address
	--
	local tFrame = { _cat(tHeader) }
	
	-- split tokens
	--
	for sToken in string.gmatch(inDestUrl, "[^.]*") do
		
		tFrame[#tFrame + 1] = _chr(#sToken)
		tFrame[#tFrame + 1] = sToken
	end
	
	-- check for valid url format
	--
	if 1 == #tFrame then return nil, 0 end
	
	tFrame[#tFrame + 1] = "\0"							-- null terminator
	tFrame[#tFrame + 1] = _chr(self.iType >> 8)
	tFrame[#tFrame + 1] = _chr(self.iType % 0x0100)
	tFrame[#tFrame + 1] = "\0\1"						-- class IN	
	
	-- this is the full frame, 1 question
	--
	return _cat(tFrame), self.iMsgId
end

-- ----------------------------------------------------------------------------
-- fills in the protocol status from a received message
--
function DnsProtocol.ParseHeader(self, inFrame, inMatchId)
--	m_trace:line("ParseHeader")

	m_trace:paragraph("Message Header")
	
	local iId = _byte(_sub(inFrame, 1, 1)) * 256 + _byte(_sub(inFrame, 2, 2))

	if inMatchId ~= iId then 
		
		m_trace:showerr("Failed id match", inMatchId)
		
		return {0, 0, 0, 0}
	end
	
	local tFlags1	= { }
	local iCurCh1	= _byte(_sub(inFrame, 3, 3))
	
	tFlags1.iRd		= (iCurCh1 >> 0) & 0x01			-- should be 1
	tFlags1.iTc		= (iCurCh1 >> 1) & 0x01			-- should be 0
	tFlags1.iAa		= (iCurCh1 >> 2) & 0x01			-- should be 1
	tFlags1.iOp		= (iCurCh1 >> 3) & 0x0f			-- should be 0
	tFlags1.iQy		= (iCurCh1 >> 7) & 0x01			-- should be 1
	
	m_trace:line("Recursion desired           = " .. tFlags1.iRd)
	m_trace:line("Truncation flag             = " .. tFlags1.iTc)
	m_trace:line("Authoritative answer flag   = " .. tFlags1.iAa)
	m_trace:line("Opcode                      = " .. tFlags1.iOp)
	m_trace:line("Query/Response flag         = " .. tFlags1.iQy)

	local tFlags2	= { }
	local iCurCh2	= _byte(_sub(inFrame, 4, 4))
	
	tFlags2.iRc	= (iCurCh2 >> 0) & 0x0f				-- should be 0
	tFlags2.iZero	= 0								-- 3 bits set to 0
	tFlags2.iRa	= (iCurCh2 >> 7) & 0x01				-- should be 0 for no error
	
	m_trace:line("Return code                 = " .. tFlags2.iRc)
	m_trace:line("Recursion available         = " .. tFlags2.iRa)
	
	local tFlags3	= { }
	
	tFlags3.iQdCount =  _byte(_sub(inFrame, 5, 5)) * 256 + _byte(_sub(inFrame, 6, 6))			-- Questions
	tFlags3.iAnCount =  _byte(_sub(inFrame, 7, 7)) * 256 + _byte(_sub(inFrame, 8, 8))			-- Answers
	tFlags3.iNsCount =  _byte(_sub(inFrame, 9, 9)) * 256 + _byte(_sub(inFrame, 10, 10))			-- Authoritative Servers	
	tFlags3.iArCount =  _byte(_sub(inFrame, 11, 11)) * 256 + _byte(_sub(inFrame, 12, 12))		-- Additional records

	m_trace:line("Questions count             = " .. tFlags3.iQdCount)
	m_trace:line("Answers count               = " .. tFlags3.iAnCount)
	m_trace:line("Authoritative servers count = " .. tFlags3.iNsCount)	
	m_trace:line("Additional records count    = " .. tFlags3.iArCount)
	
	return {tFlags2.iRc, tFlags3.iAnCount, tFlags3.iNsCount, tFlags3.iArCount}
end

-- ----------------------------------------------------------------------------
-- fields information for data
--
function DnsProtocol.ParseInfo(self, inFrame, iIndex)
--	m_trace:line("ParseInfo")
	
	local iPtr =  _byte(_sub(inFrame, iIndex + 0, iIndex + 0))
	iIndex = iIndex + 1
	
	local iPtr =  _byte(_sub(inFrame, iIndex + 0, iIndex + 0))
	iIndex = iIndex + 1
	
	local iType =  _byte(_sub(inFrame, iIndex, iIndex)) * 256 + _byte(_sub(inFrame, iIndex + 1, iIndex + 1))	
	iIndex = iIndex + 2

	local iClass =  _byte(_sub(inFrame, iIndex, iIndex)) * 256 + _byte(_sub(inFrame, iIndex + 1, iIndex + 1))	
	iIndex = iIndex + 2

	local iTTL =  (_byte(_sub(inFrame, iIndex + 0, iIndex + 0)) << 24) + 
				  (_byte(_sub(inFrame, iIndex + 1, iIndex + 1)) << 16) +
				  (_byte(_sub(inFrame, iIndex + 2, iIndex + 2)) <<  8) + 
				  (_byte(_sub(inFrame, iIndex + 3, iIndex + 3)) <<  0) 
	iIndex = iIndex + 4
	
	local iRLen =  _byte(_sub(inFrame, iIndex, iIndex)) * 256 + _byte(_sub(inFrame, iIndex + 1, iIndex + 1))	
	iIndex = iIndex + 2

	m_trace:line("Pointer value               = " .. _frmt("0x%02x", iPtr))
	
	if 0x00 ~= iPtr then
		
		m_trace:line("Type of query               = " .. iType)
		m_trace:line("Class (protocol)            = " .. iClass)
		m_trace:line("Time to live                = " .. iTTL)
		m_trace:line("Record lenght               = " .. iRLen)
	end
	
	return iPtr, iRLen, iType, iIndex	
end

-- ----------------------------------------------------------------------------
-- parse the received message's body
--
function DnsProtocol.ParseBody(self, inFrame, inIndex)
--	m_trace:line("ParseBody")

	local tUrl = { }									-- build the url string
	local iIndex  = inIndex + 1
	local iLenght = _byte(_sub(inFrame, inIndex, inIndex))

	while 0 < iLenght do
		
		tUrl[#tUrl + 1] = _sub(inFrame, iIndex, iIndex + iLenght - 1)
		
		iIndex = iIndex + iLenght
		iLenght = _byte(_sub(inFrame, iIndex, iIndex))
		iIndex = iIndex + 1
	end

	local sURL = _cat(tUrl, ".")

	local iType =  _byte(_sub(inFrame, iIndex, iIndex)) * 256 + _byte(_sub(inFrame, iIndex + 1, iIndex + 1))	
	iIndex = iIndex + 2

	local iClass =  _byte(_sub(inFrame, iIndex, iIndex)) * 256 + _byte(_sub(inFrame, iIndex + 1, iIndex + 1))	
	iIndex = iIndex + 2

	m_trace:line("URL requested               = " .. sURL)
	m_trace:line("Type of query               = " .. iType)
	m_trace:line("Class (protocol)            = " .. iClass)

	return iIndex
end

-- ----------------------------------------------------------------------------
-- get the IP out of the buffer
--
function DnsProtocol.GetIP4Addr(self, inFrame, inRLen, inIndex)

	local tIpParts	= { }
	local iIndex 	= inIndex
	local iRLen 	= inRLen
	
	-- check lenght
	--
	if #inFrame < (iIndex + iRLen - 1) then return #inFrame, "OVERFLOW" end
	
	-- get the parts
	--
	for i=1, iRLen do
		
		tIpParts[i] = tostring(_byte(_sub(inFrame, iIndex + i - 1, iIndex + i - 1)))
	end
	
	iIndex = iIndex + iRLen
	
	return iIndex, _cat(tIpParts, ".")
end

-- ----------------------------------------------------------------------------
-- get the alias url out of the buffer
--
function DnsProtocol.GetURL(self, inFrame, inIndex)
	
	local tUrl	 = { }
	local iIndex = inIndex
	local iStop  = nil
	
	local iLenght = _byte(_sub(inFrame, iIndex, iIndex))
	iIndex = iIndex + 1
	
	while 0 < iLenght do
		
		tUrl[#tUrl + 1] = _sub(inFrame, iIndex, iIndex + iLenght - 1)
		iIndex = iIndex + iLenght
		
		iLenght = _byte(_sub(inFrame, iIndex, iIndex))
		iIndex  = iIndex + 1
		
		-- first string in an alias, get address and rollback
		--
		if 0xc0 == iLenght then
			
			iStop = iIndex + 1
			
			iIndex	= _byte(_sub(inFrame, iIndex, iIndex)) + 1
			iLenght = _byte(_sub(inFrame, iIndex, iIndex))
			iIndex  = iIndex + 1
		end
		
		-- something went wrong
		--
		if not iLenght then return #inFrame, "OVERFLOW" end
	end
	
	-- reassign from where we were
	--
	if iStop then iIndex = iStop end
	
	return iIndex, _cat(tUrl, ".")
end

-- ----------------------------------------------------------------------------
-- parse the answers
--
function DnsProtocol.ParseAnswers(self, inFrame, inCount, inIndex)

	m_trace:paragraph("Answers")
	
	-- ----------------------
	-- for each answer
	--
	local _, iRLen, iType, iIndex = self:ParseInfo(inFrame, inIndex)
	
	while 0 < inCount and 0 < iRLen do
		
		-- switch on the type returned
		--
		if 1 == iType then
			
			iIndex, sIP4Addr = self:GetIP4Addr(inFrame, iRLen, iIndex)
			
			-- increment the hit test
			--
			_G.m_HitTest:incKey(self.sUrlReq, sIP4Addr)
			
			m_trace:line("Assigned Ip address         = " .. sIP4Addr)
			
		elseif 5 == iType then
			
			iIndex, sUrl = self:GetURL(inFrame, iIndex)
			
			m_trace:line("Alias                       = " .. sUrl)			
		else
			
			m_trace:showerr("Type of query not supported", iType)
		end
		
		m_trace:line("")
		
		inCount = inCount - 1
		
		if 0 < inCount and iIndex < #inFrame then
			
			_, iRLen, iType, iIndex = self:ParseInfo(inFrame, iIndex)
		end
	end

	return iIndex
end

-- ----------------------------------------------------------------------------
-- parse the authoritatives
--
function DnsProtocol.ParseAuthoritatives(self, inFrame, inCount, inIndex)

	m_trace:paragraph("Authoritatives")

	-- ----------------------
	-- for each answer
	--
	local iPtr, iRLen, iType, iIndex = self:ParseInfo(inFrame, inIndex)
	
	while 0 < inCount and 0 < iRLen do
		
		if #inFrame <= iIndex then 
			
			m_trace:showerr("Buffer overflow: ", iIndex)
			break 
		end
		
		-- switch on the type returned
		--
		if 0x00 == iPtr then
			
			iIndex, sUrl = self:GetURL(inFrame, iIndex - 1)
			
			m_trace:line("Alias                   ⭯  = " .. sUrl)
			
		elseif 1 == iType then
			
			iIndex, sIP4Addr = self:GetIP4Addr(inFrame, iRLen, iIndex)
			
			m_trace:line("Assigned Ip address         = " .. sIP4Addr)
			
		elseif 2 == iType then
			
			iIndex, sUrl = self:GetURL(inFrame, iIndex)
			
			m_trace:line("Alias                       = " .. sUrl)
			
		elseif 6 == iType then
			
			-- type of record found only once during tests
			--
			iIndex, sUrl = self:GetURL(inFrame, iIndex)
			m_trace:line("Alias                   ⁇   = " .. sUrl)

		else			
			
			m_trace:showerr("Type of query not supported", iType)
			break
		end
		
		m_trace:line("")
		
		inCount = inCount - 1
		
		if 0 < inCount and iIndex < #inFrame then
			
			iPtr, iRLen, iType, iIndex = self:ParseInfo(inFrame, iIndex)
		end
	end

	return iIndex
end

-- ----------------------------------------------------------------------------
-- parse the received message
--
function DnsProtocol.ParseMessage(self, inFrame, inMatchId, inHostname)
--	m_trace:line("ParseMessage")

	inFrame   = inFrame or ""
	inMatchId = inMatchId or 0

	if 0 == #inFrame or 0 >= inMatchId then return false end

	self.sUrlReq = inHostname
	
	m_trace:summary("Hostname: " .. inHostname)
	m_trace:dump("Response frame", inFrame)

	-- ----------------------
	-- Header
	--
	local tAnswers	= self:ParseHeader(inFrame, inMatchId)
	local bReturn	= false
	
	if 0 < tAnswers[1] then
		
		local sMessage = tDnsErrCodes[tAnswers[1] + 1]
		
		m_trace:showerr("Return code failure", sMessage)
	else
		
		-- ----------------------
		-- Body
		--
		local iIndex	= 0x0c + 1
		local iRLen		= 0
		local iType		= 0
		
		iIndex  = self:ParseBody(inFrame, iIndex)
		
		if 0 < tAnswers[2] then
			
			iIndex = self:ParseAnswers(inFrame, tAnswers[2], iIndex)
		end
		
		if 0 < tAnswers[3] then
			
			iIndex = self:ParseAuthoritatives(inFrame, tAnswers[3], iIndex)
		end
		
	--	if 0 < tAnswers[4] then
			
	--		inFrame = _sub(inFrame, iIndex, -1)					-- remove the body
	--		iIndex  = self:ParseAuthoritatives(inFrame, tAnswers[4])
	--	end
		bReturn = true
	end

	m_trace:line("")
	m_trace:endsummary()

	return bReturn
end

-- ----------------------------------------------------------------------------
--
return DnsProtocol

-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
