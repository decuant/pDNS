-- ----------------------------------------------------------------------------
--
--  HitTable
--
-- 
-- ----------------------------------------------------------------------------

local _cat	= table.concat
local _frmt = string.format

local HitTable	 = { }
HitTable.__index = HitTable

local m_sConfigFile = "data\\Hit-Test.lua"

-- ----------------------------------------------------------------------------
--
function HitTable.new(inEnable, inFilename)

	inEnable = inEnable or false
	inFilename = inFilename or m_sConfigFile
	
	local t =
	{
		bEnabled	= inEnable,
		bModified	= false,
		sConfigFile	= inFilename,
		
		tList		= { },
	}

	return setmetatable(t, HitTable)
end

-- ----------------------------------------------------------------------------
--
function HitTable.count(self)
	
	local iCount = 0
	
	for _, item in next, self.tList do iCount = iCount + 1 end

	return iCount
end

-- ----------------------------------------------------------------------------
--
function HitTable.getParent(self, inString)

	return self.tList[inString]
end

-- ----------------------------------------------------------------------------
--
function HitTable.incKey(self, inRoot, inKey)

	if not self.bEnabled then return end
	
	inRoot = inRoot or "?? Root ??"
	inKey  = inKey  or "?? Key  ??"

	if 0 == #inRoot or 0 == #inKey then return end

	local m = self.tList		-- master
	local r = m[inRoot]			-- root
	
	-- check root
	--
	if not r then 
		
		m[inRoot] = { }			-- create branch
		r = m[inRoot]
	end
	
	-- check entry
	--
	local t = r[inKey]
	
	if not t then
		
		r[inKey] = 0			-- create leaf
	end
	
	-- inc value
	--
	r[inKey] = r[inKey] + 1
	
	-- need save
	--
	self.bModified = true
end

-- ----------------------------------------------------------------------------
--
function HitTable.delete(self, inRoot, inKey)

	if not self.bEnabled then return end
	
	inRoot = inRoot or ""
	inKey  = inKey  or ""

	if 0 == #inRoot or 0 == #inKey then return end
	
	-- check root
	--
	local r = self.tList[inRoot]
	if not r then return end

	-- check entry and remove
	--
	if r[inKey] then r[inKey] = nil end
	
	-- check if root empty and remove
	--
	if not next(r) then self.tList[inRoot] = nil end

	-- need save
	--
	self.bModified = true
end
-- ----------------------------------------------------------------------------
--
function HitTable.reset(self)

	self.tList		= { }
	self.bModified	= false
end

-- ----------------------------------------------------------------------------
--
function HitTable.trimmer(self, inLowerBound)

	local tRoot		= self.tList
	local bModified	= false
	
	for sKey, parent in next, tRoot do
		
		for sLbl, row in next, parent do
			
			if inLowerBound and inLowerBound > row then 
				
				parent[sLbl] = nil
				
				bModified = true
			end
		end
		
		-- check if parent empty and remove
		--
		if not next(parent) then 
			
			self.tList[sKey] = nil
			
			bModified = true
		end
	end

	self.bModified	= bModified
end

-- ----------------------------------------------------------------------------
--
function HitTable.backup(self)

	if not self.bEnabled then return false end
	if not self.bModified then return false end
	
	-- build the string
	--
	local tRoot		= self.tList
	local tOutput 	= { }
	local sFormatKey
	
	tOutput[#tOutput + 1] = "local _hittable =\n{"

	for rootkey, rootvalue in next, tRoot do
		
		tOutput[#tOutput + 1] = _frmt("\n\t[\"%s\"] =\n\t{", rootkey)
		
		for key, value in next, rootvalue do
			
			sFormatKey = _frmt("[\"%s\"]", key)
		
			tOutput[#tOutput + 1] = _frmt("\t\t%- 19s = %d,", sFormatKey, value)
		end
		
		tOutput[#tOutput + 1] = "\t},"
	end
	
	tOutput[#tOutput + 1] = "}\n\nreturn _hittable\n"
	
	-- process file
	--
	local fd = io.open(self.sConfigFile, "w")
	if not fd then return false end
	
	fd:write(_cat(tOutput, "\n"))
	fd:close()
	
	-- reset status here
	--
	self.bModified = false
	
	return true
end

-- ----------------------------------------------------------------------------
--
function HitTable.restore(self)
	
	if not self.bEnabled then return end

	local fd = io.open(self.sConfigFile, "r")
	if not fd then return end
	fd:close()
	
	local t = dofile(self.sConfigFile)

	if t then self.tList = t end
	
	-- add member here
	--
	self.bModified = false
end

-- ----------------------------------------------------------------------------
--
return HitTable

-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
