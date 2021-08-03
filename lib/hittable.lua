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
function HitTable.new(inEnable)

	inEnable = inEnable or false
	
	local t =
	{
		bEnabled	= inEnable,
		tList		= { },
		bModified	= false,
	}

	return setmetatable(t, HitTable)
end

-- ----------------------------------------------------------------------------
--
function HitTable.incKey(self, inRoot, inKey)

	if not self.bEnabled then return end

	local m = self.tList
	local r = m[inRoot]
	
	-- check root
	--
	if not r then 
		
		m[inRoot] = { }
		r = m[inRoot]
	end
	
	-- check entry
	--
	local t = r[inKey]
	
	if not t then
		
		r[inKey] = 0
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
function HitTable.reset(self)

	self.tList	= { }
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
		
			tOutput[#tOutput + 1] = _frmt("\t\t%- 20s= %d,", sFormatKey, value)
		end
		
		tOutput[#tOutput + 1] = "\t},"
	end
	
	tOutput[#tOutput + 1] = "}\n\nreturn _hittable\n"
	
	-- process file
	--
	local fd = io.open(m_sConfigFile, "w")
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

	local fd = io.open(m_sConfigFile, "r")
	if not fd then return end
	fd:close()
	
	local t = dofile(m_sConfigFile)

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