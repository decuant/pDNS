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
-- wait for a process to complete, reads stdout from caller
-- gives result in statusbar
--
local function WaitForComplete(inHFile, inMessage)

	wx.wxBeginBusyCursor()
	
	if inHFile then
		
		local sStdOut = inHFile:read("l")
		inHFile:close()
		
--		if sStdOut then	SetStatusText(inMessage .. ": " .. sStdOut) end
	end
	
	wx.wxEndBusyCursor()
end

-- ----------------------------------------------------------------------------
--
local function OnRefreshWindow(inWindow)
	
	inWindow.ShowServers()
	inWindow.UpdateDisplay()
end

-- ----------------------------------------------------------------------------
--
local function Menu_Convert_Servers(inApplication, inMainWindow)
	
	local hFile, sError = io.popen("lua ./convert.lua data\\nameservers-all.csv data\\servers.lua", "r")

	if not hFile then
		
		sError = sError or ""
		
		DlgMessage(_format("Failed to do the conversion\n%s", sError))
		return
	end
	
	WaitForComplete(hFile, "Made new servers")	
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
	
	inApplication.FilterFailing(25)
	OnRefreshWindow(inMainWindow)

	return true
end

-- ----------------------------------------------------------------------------
--
local functions =
{
	{Menu_Convert_Servers, 		"Make new servers",	"Make nameservers-all the new list"},
	{Menu_Modify_FilterEurope,	"Filter Europe",	"Only servers in Europe"},
	{Menu_Modify_FilterFailing, "Filter failing",	"Match addresses in the failing list"},
}

return functions

-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
