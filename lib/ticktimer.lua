-- ----------------------------------------------------------------------------
--
--  TickTimer
--
-- counts the time elapsed between a start time and time now
-- the accurancy of this timer object relies on the frequency
-- its methods are called
-- ----------------------------------------------------------------------------

local _frmt  = string.format
local _clock = os.clock

local ticktimer	  = { }
ticktimer.__index = ticktimer

-- ----------------------------------------------------------------------------
--
function ticktimer.new(inName)

	inName = inName or "ANY"

	local t =
	{
		m_Name		= inName,	-- a name for the object
		m_NextTick	= 0,		-- next time to fire
		m_TickFrame	= 0,		-- firing delay
		m_Enabled	= false,	-- timer is actually enabled
	}

	return setmetatable(t, ticktimer)
end

-- ----------------------------------------------------------------------------
--
function ticktimer.setup(self, inInterval, inEnabled)

	self.m_Enabled	 = inEnabled
	self.m_TickFrame = inInterval
	self.m_NextTick  = _clock() + self.m_TickFrame
end

-- ----------------------------------------------------------------------------
--
function ticktimer.reset(self)

	self.m_NextTick = _clock() + self.m_TickFrame
end

-- ----------------------------------------------------------------------------
--
function ticktimer.enable(self, inEnable)

	self.m_Enabled = inEnable
end

-- ----------------------------------------------------------------------------
--
function ticktimer.isEnabled(self)

	return self.m_Enabled
end

-- ----------------------------------------------------------------------------
--
function ticktimer.hasFired(self)

	if self.m_Enabled then return _clock( ) >= self.m_NextTick end

	-- timer is disabled
	--
	return false
end

-- ----------------------------------------------------------------------------
--
function ticktimer.remainingTime(self)

	return self.m_NextTick - _clock()
end

-- ----------------------------------------------------------------------------
--
function ticktimer.elapsedTime(self)

	return _clock() - (self.m_NextTick - self.m_TickFrame)
end

-- ----------------------------------------------------------------------------
--
function ticktimer.toString(self)

	local sEnable = "Disabled"
	if self.m_Enabled then sEnable = "Enabled" end
	
	return _frmt("[%s] [%s] remaining [%.04f]", self.m_Name, sEnable, self:remainingTime())
end

-- ----------------------------------------------------------------------------
--
return ticktimer

-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
