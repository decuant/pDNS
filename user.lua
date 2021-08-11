-- ----------------------------------------------------------------------------
--
-- pDNS - polling dns
--
-- user functions to customise the application
--
-- ----------------------------------------------------------------------------

--local trace		= require("lib.trace")			-- shortcut for tracing

-- ----------------------------------------------------------------------------
--
--local m_logger	= trace.new("debug")

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
local function OnRefreshWindow()

	local  thisApp = _G.m_ThisApp
	local  hManWin = thisApp.hMainWin

	hManWin.ShowServers()
	hManWin.UpdateDisplay()
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
local function FilterByRef(inText)

	local  thisApp = _G.m_ThisApp

	thisApp.FilterByRef(inText)
	return true
end

-- ----------------------------------------------------------------------------
--
local function Menu_Modify_FilterEurope()
	
	FilterByRef(m_sEurope)
	OnRefreshWindow()

	return true
end

-- ----------------------------------------------------------------------------
--
local function Menu_Modify_FilterFailing()
	
	local  thisApp = _G.m_ThisApp

	thisApp.FilterFailing(25)
	OnRefreshWindow()

	return true
end

-- ----------------------------------------------------------------------------
--
local function Menu_Stats_Trimmer()
	
	local tHitTest  = _G.m_HitTest
	local tFailAddr = _G.m_FailAddr
	
	tHitTest:trimmer(10, 200)
	tFailAddr:trimmer(5, 50)

	return true
end

-- ----------------------------------------------------------------------------
--
local functions =
{
	{Menu_Convert_Servers, 		"Make new servers",		"Make nameservers-all the new list"},
	{Menu_Modify_FilterEurope,	"Filter Europe",		"Only servers in Europe"},
	{Menu_Modify_FilterFailing, "Filter failing",		"Match addresses in the failing list"},
	{nil,						"",						""},
	{Menu_Stats_Trimmer,		"Statistics trimmer",	"Perform low trim and a high trim on both statistics"},
}

return functions

-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
