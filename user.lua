-- ----------------------------------------------------------------------------
--
-- pDNS - polling dns
--
-- user functions to customise the application
--
-- ----------------------------------------------------------------------------

local trace		= require("lib.trace")			-- shortcut for tracing
--local mainWin	= require("lib.window")			-- GUI for the application

--local _frmt		= string.format
--local _cat		= table.concat
--local _floor	= math.floor

-- ----------------------------------------------------------------------------
--
local m_logger	= trace.new("debug")

-- ----------------------------------------------------------------------------
--
local function OnRefreshWindow(inWindow)
	
	inWindow.ShowServers()
	inWindow.UpdateDisplay()
end

-- ----------------------------------------------------------------------------
--
local function Menu_Copy_All2Servers(inApplication, inMainWindow)
	
	return os.execute("copy /Y data\\nameservers-all.lua data\\servers.lua")
end

-- ----------------------------------------------------------------------------
--
local function Menu_Modify_Scramble(inApplication, inMainWindow)
	
	inApplication.Scramble()
	OnRefreshWindow(inMainWindow)

	return true
end

-- ----------------------------------------------------------------------------
--
local function Menu_Modify_FuzzyToggle(inApplication, inMainWindow)
	
	inApplication.FuzzyToggle()
	OnRefreshWindow(inMainWindow)

	return true
end

-- ----------------------------------------------------------------------------
--
local functions =
{
	{Menu_Copy_All2Servers, "Make new servers",	"Make nameservers-all the new list"},
	{Menu_Modify_Scramble,	"Scramble list",	"Rebuild the list in random order"},
	{Menu_Modify_FuzzyToggle, "Fuzzy toggle",	"Toggle enable in random fashion"},
}

return functions

-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
