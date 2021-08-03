-- ----------------------------------------------------------------------------
--
--  HitTable
--
-- 
-- ----------------------------------------------------------------------------

local _cat	= table.concat
local _frmt = string.format
--local _clock = os.clock

local HitTable	 = { }
HitTable.__index = HitTable

local m_sConfigFile = "data\\Hit-Test.lua"

-- ----------------------------------------------------------------------------
--
function HitTable.new()

	local t =
	{
		m_List		= { },
		m_Modified	= false,
	}

	return setmetatable(t, HitTable)
end

-- ----------------------------------------------------------------------------
--
function HitTable.incKey(self, inRoot, inKey)

	local m = self.m_List
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
	self.m_Modified = true
end

-- ----------------------------------------------------------------------------
--
function HitTable.reset(self)

	self.m_List	= { }
end

-- ----------------------------------------------------------------------------
--
function HitTable.backup(self)

	if not self.m_Modified then return false end
	
	-- build the string
	--
	local tOutput = { }
	local m = self.m_List
	
	tOutput[#tOutput + 1] = "local _hittable =\n{"

	for rootkey, rootvalue in next, m do
		
		tOutput[#tOutput + 1] = _frmt("\n\t[\"%s\"] =\n\t{", rootkey)
		
		local sFormatKey
		
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
	self.m_Modified = false
	
	return true
end

-- ----------------------------------------------------------------------------
--
function HitTable.restore(self)

	local fd = io.open(m_sConfigFile, "r")
	if not fd then return end
	fd:close()
	
	local t = dofile(m_sConfigFile)

	if t then self.m_List = t end
	
	-- add member here
	--
	self.m_Modified = false
end

-- ----------------------------------------------------------------------------
--
return HitTable

-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
