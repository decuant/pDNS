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
local m_sEurope = "(ES);(IT);(CH);(FR);(DE);(NL);(SE);(FI);(NO);(GB);"

-- ----------------------------------------------------------------------------
--
local function FilterByRef(inApplication, inText)
	
	inApplication.FilterByRef(inText)
	return true
end

-- ----------------------------------------------------------------------------
--
local function Menu_Modify_FilterEurope(inApplication, inMainWindow)
	
	FilterByRef(inApplication, m_sEurope)
	OnRefreshWindow(inMainWindow)

	return true
end

-- ----------------------------------------------------------------------------
--
local function Menu_Modify_FilterFailing(inApplication, inMainWindow)
	
	inApplication.FilterFailing(35)
	OnRefreshWindow(inMainWindow)

	return true
end

-- ----------------------------------------------------------------------------
--
local functions =
{
	{Menu_Copy_All2Servers, "Make new servers\tCtrl-1",	"Make nameservers-all the new list"},
	{Menu_Modify_Scramble,	"Scramble list\tCtrl-2",	"Rebuild the list in random order"},
	{Menu_Modify_FuzzyToggle, "Fuzzy toggle\tCtrl-3",	"Toggle enable in random fashion"},
	{Menu_Modify_FilterEurope, "Filter Europe\tCtrl-4",	"Only servers in Europe"},
	{Menu_Modify_FilterFailing, "Filter failing\tCtrl-5",	"Match addresses in the failing list"},
}

return functions

-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
