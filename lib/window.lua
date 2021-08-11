-- ----------------------------------------------------------------------------
--
--  Mainframe
--
-- ----------------------------------------------------------------------------

local wx 		= require("wx")					-- uses wxWidgets for Lua
local trace		= require("lib.trace")			-- shortcut for tracing
local palette	= require("lib.wxX11Palette")	-- declarations for colors

local _frmt		= string.format
local _sub		= string.sub
local _gmatch	= string.gmatch
local _min		= math.min
local _max		= math.max
local _abs		= math.abs

-- ----------------------------------------------------------------------------
--
local m_thisApp = nil

-- ----------------------------------------------------------------------------
--
local m_logger = trace.new("debug")

-- ----------------------------------------------------------------------------
-- colors combinations
--
local m_tDefColours = 
{
	tSchemeDark =
	{
		cColBk0	= palette.WhiteSmoke,
		cColFo0	= palette.DeepPink,
		cColBk1	= palette.Gray20,
		cColFo1	= palette.WhiteSmoke,
		cColBk2	= palette.Gray10,
		cColFo2	= palette.WhiteSmoke,
		cColBk3	= palette.Gray20,
		cColFo3	= palette.NavajoWhite1,
		cFail	= palette.VioletRed1,
		cSucc	= palette.SeaGreen3,
		cLines	= palette.Gray10,
		CLblBk	= palette.DarkSlateBlue,
		CLblFo	= palette.Honeydew2,
		cHighlt	= palette.DarkSlateGray2,
	},

	tSchemeContrast =
	{
		cColBk0	= palette.PaleGreen2,
		cColFo0	= palette.RoyalBlue4,
		cColBk1	= palette.LightBlue2,
		cColFo1	= palette.Black,
		cColBk2	= palette.LightBlue3,
		cColFo2	= palette.Black,
		cColBk3	= palette.SteelBlue4,
		cColFo3	= palette.LightCyan1,
		cFail	= palette.MediumPurple2,
		cSucc	= palette.Yellow1,
		cLines	= palette.SteelBlue4,
		CLblBk	= palette.Gray20,
		CLblFo	= palette.LightSalmon3,
		cHighlt	= palette.MediumOrchid,
	},
	
	tSchemeIvory =
	{
		cColBk0	= palette.Orange,
		cColFo0	= palette.White,
		cColBk1	= palette.Ivory3,
		cColFo1	= palette.Gray10,
		cColBk2	= palette.Ivory2,
		cColFo2	= palette.Gray10,
		cColBk3	= palette.Ivory1,
		cColFo3	= palette.Firebrick,
		cFail	= palette.Violet,
		cSucc	= palette.SkyBlue1,
		cLines	= palette.Gray50,
		CLblBk	= palette.Ivory4,
		CLblFo	= palette.Gray20,
		cHighlt	= palette.NavajoWhite3,
	},
	
	tSchemeMatte =
	{
		cColBk0	= palette.SlateGray2,
		cColFo0	= palette.Firebrick,
		cColBk1	= palette.MediumPurple1,
		cColFo1	= palette.Black,
		cColBk2	= palette.MediumPurple2,
		cColFo2	= palette.Black,
		cColBk3	= palette.WhiteSmoke,
		cColFo3	= palette.Black,
		cFail	= palette.PaleVioletRed1,
		cSucc	= palette.MediumAquamarine,
		cLines	= palette.LightYellow3,
		CLblBk	= palette.Gray75,
		CLblFo	= palette.Gray25,
		cHighlt	= palette.Salmon1,
	},
}

-- ----------------------------------------------------------------------------
-- grid's labels anf font
--
local m_sGdLbls =
{
	"E.", "#1", "#2", "Organization"
}

-- ----------------------------------------------------------------------------
-- default dialog size and position
--
local m_tDefWinProp =
{
	window_xy	= {20,	 20},						-- top, left
	window_wh	= {750,	265},						-- width, height
	grid_ruler	= {75, 200, 200, 500},				-- size of each column
	use_font	= {12, "Calibri"},					-- font for grid and tab
	filter		= "",
}

-- ----------------------------------------------------------------------------
--
local TaskOptions =
{
	iTaskInterval	= 50,							-- timer interval
	iBatchLimit		= 15,							-- max servers per taks
}

-- ----------------------------------------------------------------------------
-- contains various handlers and values
--
local m_Mainframe = 
{
	hWindow			= nil,         					-- window handle
	hNotebook		= nil,							-- notebook handle
	hEditFind		= nil,
	hStatusBar		= nil,							-- statusbar handle

	hGridDNSList	= nil,							-- grid
	tColors			= m_tDefColours.tSchemeDark,	-- colours for the grid
	tWinProps		= m_tDefWinProp,				-- window layout settings

	hTickTimer		= nil,							-- timer associated with window
	bReentryLock	= false,						-- avoid re-entrant calling
	
	tStatus			= {0, 0, 0, 0},					-- total, enabled, completed, failed

	iSearchStart	= 1,							-- current start for search
}

-- ----------------------------------------------------------------------------
-- create a filename just for the machine running on
--
local function SettingsName()
	
	return "window@" .. wx.wxGetHostName() .. ".ini"
end

-- ----------------------------------------------------------------------------
-- read dialogs' settings from settings file
--
local function ReadSettings()
--	m_logger:line("ReadSettings")

	local sFilename = SettingsName()

	local fd = io.open(sFilename, "r")
	if not fd then return end

	fd:close()

	local tSettings = dofile(sFilename)

	if tSettings then m_Mainframe.tWinProps = tSettings end
end

-- ----------------------------------------------------------------------------
-- save a table to the settings file
--
local function SaveSettings()
--	m_logger:line("SaveSettings")

	local fd = io.open(SettingsName(), "w")
	if not fd then return end

	fd:write("local window_ini =\n{\n")

	local tWinProps = m_Mainframe.tWinProps
	local sLine

	sLine = _frmt("\twindow_xy\t= {%d, %d},\n", tWinProps.window_xy[1], tWinProps.window_xy[2])
	fd:write(sLine)

	sLine = _frmt("\twindow_wh\t= {%d, %d},\n", tWinProps.window_wh[1], tWinProps.window_wh[2])
	fd:write(sLine)

	sLine = _frmt("\tgrid_ruler\t= {%d, %d, %d, %d},\n", 
					tWinProps.grid_ruler[1], tWinProps.grid_ruler[2],
					tWinProps.grid_ruler[3], tWinProps.grid_ruler[4])
	fd:write(sLine)
	
	sLine = _frmt("\tuse_font\t= {%d, \"%s\"},\n", tWinProps.use_font[1], tWinProps.use_font[2])
	fd:write(sLine)	

	sLine = _frmt("\tfilter\t\t= \"%s\",\n", tWinProps.filter)
	fd:write(sLine)	
	
	fd:write("}\n\nreturn window_ini\n")
	io.close(fd)
end

-- ----------------------------------------------------------------------------
-- Generate a unique new wxWindowID
--
local ID_IDCOUNTER = wx.wxID_HIGHEST + 1
local NewMenuID = function()
	
	ID_IDCOUNTER = ID_IDCOUNTER + 1
	return ID_IDCOUNTER
end

-- ----------------------------------------------------------------------------
-- Simple interface to pop up a message
--
local function DlgMessage(message)

	wx.wxMessageBox(message, m_thisApp.sAppName,
					wx.wxOK + wx.wxICON_INFORMATION, m_Mainframe.hWindow)
end

-- ----------------------------------------------------------------------------
--
local function OnAbout()

	DlgMessage(_frmt(	"%s [%s] Rel. date [%s]\n %s, %s, %s",
						m_thisApp.sAppName, m_thisApp.sAppVersion, m_thisApp.sRelDate,
						_VERSION, wxlua.wxLUA_VERSION_STRING, wx.wxVERSION_STRING))
end

-- ----------------------------------------------------------------------------
--
local function SetStatusText(inText)
	
	local hBar = m_Mainframe.hStatusBar
	
	hBar:SetStatusText(inText, 1)
	
	m_logger:line(inText)	
end

-- ----------------------------------------------------------------------------
--
local m_SymbInd  = 0
local m_tSymbols =
{
	"  |",	"  /",	"  -",	"  \\"
}

local function UpdateProgress()
	
	local hBar = m_Mainframe.hStatusBar
	
	m_SymbInd = m_SymbInd + 1
	if  #m_tSymbols < m_SymbInd then m_SymbInd = 1 end
	
	hBar:SetStatusText(m_tSymbols[m_SymbInd], 0)
end

-- ----------------------------------------------------------------------------
--
local function UpdateStatus(inStatusTable)
	
	local hBar		= m_Mainframe.hStatusBar
	local tStatus 	= m_Mainframe.tStatus
	local bRefresh	= false
	
	-- check if refresh
	--
	for i=1, #tStatus do
		
		if tStatus[i] ~= inStatusTable[i] then
			
			bRefresh = true
			break
		end
	end
	
	if not bRefresh then return end

	-- save values and update screen
	-- total, enabled, completed, failed
	--
	for i=1, #tStatus do 
		
		tStatus[i] = inStatusTable[i]
		
		hBar:SetStatusText(" " .. tostring(tStatus[i]), i + 1)
	end
end

-- ----------------------------------------------------------------------------
--
local function BacktaskRunning()
--	m_logger:line("BacktaskRunning")
	
	return nil ~= m_Mainframe.hTickTimer
end

-- ----------------------------------------------------------------------------
-- enable or disable the Windows timer object of the window
--
local function EnableBacktask(inEnable)
--	m_logger:line("EnableBacktask")
	
	local hTick = m_Mainframe.hTickTimer
	
	if inEnable then
		
		if not hTick then
		
			hTick = wx.wxTimer(m_Mainframe.hWindow, wx.wxID_ANY)
			hTick:Start(TaskOptions.iTaskInterval, false)
			
			SetStatusText("Backtask started")
		end
	else
		
		if hTick then
			
			hTick:Stop()
			hTick = nil
			
			SetStatusText("Backtask stopped")
		end
	end
	
	-- store handle
	--
	m_Mainframe.hTickTimer = hTick
end

-- ----------------------------------------------------------------------------
-- read the settings file
--
local function ResetDescBkClr()
--	m_logger:line("ResetDescBkClr")
	
	local hGrid		= m_Mainframe.hGridDNSList
	local iCount	= hGrid:GetNumberRows()
	local tDefault	= m_Mainframe.tColors.cColBk3
	
	if 0 == iCount then return end
	
	for i=1, iCount do
		
		hGrid:SetCellBackgroundColour(i - 1, 3, tDefault)
	end
	
	hGrid:ForceRefresh()
end

-- ----------------------------------------------------------------------------
-- read the settings file
--
local function ShowServers()
--	m_logger:line("ShowServers")
	
	-- remove all rows
	--
	local hGrid = m_Mainframe.hGridDNSList
	
	if 0 < hGrid:GetNumberRows() then
		
		hGrid:DeleteRows(0, hGrid:GetNumberRows())
	end

	-- --------------------------------
	-- fill the servers' grid
	--
	local tDNS = m_thisApp.tServers			-- here we are sure the table is not empty
	
	hGrid:AppendRows(#tDNS, false)			-- create empty rows
	
	local tCurrent

	for iRow=0, #tDNS - 1 do
		
		tCurrent = tDNS[iRow + 1]
		
		hGrid:SetCellValue(iRow, 0, tostring(tCurrent.iEnabled))		-- active state
		hGrid:SetCellValue(iRow, 1, tCurrent.tAddresses[1].sAddress)	-- ip address
		hGrid:SetCellValue(iRow, 2, tCurrent.tAddresses[2].sAddress)	-- ip address
		hGrid:SetCellValue(iRow, 3, tCurrent.sReference)				-- url or name
	end
	
	UpdateStatus({#tDNS, 0, 0, 0})
end

-- ----------------------------------------------------------------------------
-- update the display
--
local function UpdateDisplay()
--	m_logger:line("UpdateDisplay")

	local tDNS	  = m_thisApp.tServers			-- here we are sure the table is not empty
	local hGrid	  = m_Mainframe.hGridDNSList
	local tColors = m_Mainframe.tColors
	local tStatus = {#tDNS, 0, 0, 0}			-- total, enabled, completed, failed

	for i, tCurrent in next, tDNS do
		
		if 1 == tCurrent.iEnabled then tStatus[2] = tStatus[2] + 1 end
		
		if tCurrent:HasCompletedAll() then
			
			for y=1, 2 do
				
				if tCurrent:IsResponseOK(y) then
				
					hGrid:SetCellBackgroundColour(i - 1, y, tColors.cSucc)
					tStatus[3] = tStatus[3] + 1
				else
					
					-- extra check to avoid colouring a cell without address
					--
					if tCurrent:IsValid(y) then
						
						hGrid:SetCellBackgroundColour(i - 1, y, tColors.cFail)
						tStatus[4] = tStatus[4] + 1
					end
				end
			end
		end
	end
	
	UpdateStatus(tStatus)
end

-- ----------------------------------------------------------------------------
-- save the settings file
--
local function OnScramble()
--	m_logger:line("OnScramble")

	m_thisApp.Scramble()

	ShowServers()
	UpdateDisplay()
	
	-- text not found, wrap search
	--
	m_Mainframe.iSearchStart = 1
end

-- ----------------------------------------------------------------------------
-- save the settings file
--
local function OnSaveServers()
--	m_logger:line("OnSaveServers")

	local ret = m_thisApp.SaveDNSFile()

	if 0 == ret then DlgMessage("Failed to save DNS servers' list") return end
end

-- ----------------------------------------------------------------------------
-- read the servers' file
--
local function OnImportServers()
--	m_logger:line("OnImportServers")
	
	-- read the settings file and create the clients
	--
	local ret = m_thisApp.ImportDNSFile()
	
	if 0 == ret then DlgMessage("Failed to read DNS servers' list\nor the list is empty") return end

	ShowServers()
	UpdateDisplay()
end

-- ----------------------------------------------------------------------------
--
local function OnFilterByRef(event)
--	m_logger:line("OnSearchText")

	local sText = m_Mainframe.hEditFind:GetValue()
	if 0 == #sText then return end

	if m_thisApp.FilterByRef(sText) then
		
		ShowServers()
		UpdateDisplay()
		
		-- restart the search from the top
		--
		m_Mainframe.iSearchStart = 1
	end
end

-- ----------------------------------------------------------------------------
--
local function OnSearchText(event)
--	m_logger:line("OnSearchText")

	-- don't process further if not pressed the command key
	--
	if wx.WXK_RETURN ~= event:GetKeyCode() then
		
		event:Skip()
		return
	end

	local sText 	= m_Mainframe.hEditFind:GetValue()
	local hGrid		= m_Mainframe.hGridDNSList
	local iStart	= m_Mainframe.iSearchStart
	local bkColor	= m_Mainframe.tColors.cHighlt
	
	-- at start cancel the old findings
	--
	if 1 == iStart then ResetDescBkClr() end

	-- get the row containing the text
	-- might start from 0 if first search
	-- otherwise go ahead
	--
	local iMinIdx = nil
	local tTokens = { }
	
	-- collect all tokens
	--
	for sToken in _gmatch(sText, "[^;]*") do
		
		if sToken and 0 < #sToken then tTokens[#tTokens + 1] = sToken end
	end
	
	-- parse the list for each token
	-- and find the lowest index
	--
	for i, sToken in next, tTokens do
		
		local iIndex = m_thisApp.IndexFromText(iStart, sToken)
		
		if 0 < iIndex then
			
			if not iMinIdx or iMinIdx > iIndex then 
			
				iMinIdx = iIndex
			end
		end
	end
	
	-- check the row
	--
	if iMinIdx then
		
		hGrid:SetCellBackgroundColour(iMinIdx - 1, 3, bkColor)
--		if not hGrid:IsVisible(iMinIdx - 1, 3) then
			
			hGrid:MakeCellVisible(iMinIdx - 1, 3)
--		end		
		hGrid:ForceRefresh()
		
		-- advance for next search
		--
		m_Mainframe.iSearchStart = iMinIdx + 1
		return
	end

	-- text not found, wrap search
	--
	m_Mainframe.iSearchStart = 1

	DlgMessage("End of file.")
end

-- ----------------------------------------------------------------------------
-- set the enable flag for all DNS servers or a specific row
-- here the inRow ca have 2 values:
-- -1 means all rows
-- a zero based index (wxWidgets is zero based)
--
local function SetEnable(inRow, inEnabled)
--	m_logger:line("SetEnable")	

	local tServers	= m_thisApp.tServers
	local tRowsList	= { }
	
	if -1 == inRow then
		
		-- all rows
		--		
		for i=1, #tServers do tRowsList[i] = i end
	else
		
		-- selected row only
		--
		tRowsList[1] = inRow + 1
	end
	
	-- give a list of rows and get back a list of rows
	--
	tRowsList = m_thisApp.EnableServers(tRowsList, inEnabled)
	
	local grid = m_Mainframe.hGridDNSList	
	
	for i=1, #tRowsList do
		
		grid:SetCellValue(tRowsList[i] - 1, 0, tostring(inEnabled))
	end
end

-- ----------------------------------------------------------------------------
-- toggle the enable/disable flag for the selected rows
--
local function OnToggleSelected()
--	m_logger:line("OnToggleSelected")

	local grid 		= m_Mainframe.hGridDNSList
	local tSelected = grid:GetSelectedRows():ToLuaTable()
	local iValue
	
	for i=1, #tSelected do
		
		iValue = grid:GetCellValue(tSelected[i], 0)
		
		SetEnable(tSelected[i], _abs(iValue - 1))
	end
	
	UpdateDisplay()
end

-- ----------------------------------------------------------------------------
-- toggle the enable/disable flag for the selected rows
--
local function OnToggleAll()
--	m_logger:line("OnToggleAll")

	m_thisApp.ToggleAll()
	
	-- refresh view
	--
	ShowServers()
	UpdateDisplay()
end
-- ----------------------------------------------------------------------------
-- call for the enable/disable all
--
local function OnEnableAll(inValue)
--	m_logger:line("OnEnableAll")
	
	SetEnable(-1, inValue)
	
	ShowServers()
	UpdateDisplay()	
end

-- ----------------------------------------------------------------------------
-- fuzzy enable servers
--
local function OnFuzzyEnable()

	m_thisApp.FuzzyEnable()
	
	-- refresh view
	--
	ShowServers()
	UpdateDisplay()
end

-- ----------------------------------------------------------------------------
-- delete selected rows
--
local function OnDeleteSelected()
--	m_logger:line("OnDeleteSelected")	

	local grid 		= m_Mainframe.hGridDNSList
	local tSelected = grid:GetSelectedRows():ToLuaTable()
	
	if not next(tSelected) then DlgMessage("Select rows to delete") return end

	-- from base 0 to base 1
	--
	for i=1, #tSelected do tSelected[i] = tSelected[i] + 1 end
	
	-- remove
	--
	m_thisApp.DeleteServers(tSelected)

	-- refresh view
	--
	ShowServers()
	UpdateDisplay()
end

-- ----------------------------------------------------------------------------
-- reset the DNS client to the start
--
local function OnResetCompleted()
--	m_logger:line("OnResetCompleted")

	local tServers	= m_thisApp.tServers
	local grid 		= m_Mainframe.hGridDNSList
	local tColors	= m_Mainframe.tColors

	-- set each server to unchecked
	--
	for _, server in next, tServers do server:Restart() end

	for i=1, #tServers do
		
		grid:SetCellBackgroundColour(i - 1, 1, tColors.cColBk1)
		grid:SetCellBackgroundColour(i - 1, 2, tColors.cColBk2)
	end
	
	UpdateDisplay()
	grid:ForceRefresh()					-- seldom there's no colour changing
end

-- ----------------------------------------------------------------------------
-- reset the DNS client to the start
--
local function OnPurgeServers(inWhich)
--	m_logger:line("OnPurgeServers")

	if m_thisApp.PurgeServers(inWhich) then
		
		ShowServers()
		UpdateDisplay()
	end
end

-- ----------------------------------------------------------------------------
-- reset the DNS client to the start
--
local function OnPurgeInvalid(inWhich)
--	m_logger:line("OnPurgeInvalid")

	if m_thisApp.PurgeInvalid() then
		
		ShowServers()
		UpdateDisplay()
	end
end

-- ----------------------------------------------------------------------------
-- tick timer backtask
-- uses a simple boolean to avoid re-entry calls
--
local function OnTickTimer()

	-- check if it is still running
	--
	if m_Mainframe.bReentryLock then return end
	m_Mainframe.bReentryLock = true

--	m_logger:line("OnTickTimer")

	local iBatch, iLast = m_thisApp.RunBatch(TaskOptions.iBatchLimit)
	
	if 0 < iBatch and 0 < iLast then 
		
		UpdateDisplay()
		
		local hGrid = m_Mainframe.hGridDNSList
		
		if not hGrid:IsVisible(iLast - 1, 0) then
			
			hGrid:MakeCellVisible(iLast - 1, 0)
		end
		
		hGrid:ForceRefresh()			-- seldom there's no colour changing
	end

	UpdateProgress()

	m_Mainframe.bReentryLock = false
end
-- ----------------------------------------------------------------------------
-- a cell was modified
--
local function OnCellChanged(event)
--	m_logger:line("OnCellChanged")
	
	local hGrid = m_Mainframe.hGridDNSList
	
    local iRow	 = event:GetRow()
    local iCol	 = event:GetCol()
	local aValue = hGrid:GetCellValue(iRow, iCol)
	local tRow	 = m_thisApp.tServers[iRow + 1]
	
	-- treat the enable disable
	--
	if 0 == iCol then
		
		local iValue = tonumber(aValue) or 0
		
		iValue = _min(1, _max(0, iValue))
		
		tRow.iEnabled = iValue
		
		hGrid:SetCellValue(iRow, iCol, tostring(iValue))
		
	elseif 3 == iCol then
		
		tRow.sReference = aValue
	else
		
		-- check for a valid ip4 address
		--
		local tAddress = tRow.tAddresses[iCol]
		
		if not tAddress:ChangeAddress(aValue) then
			
			tAddress:ChangeAddress("")
			hGrid:SetCellValue(iRow, iCol, "")
		end
	end
end

-- ----------------------------------------------------------------------------
-- window size changed
--
local function OnLabelSelected(event)
--	m_logger:line("OnLabelSelected")

    local iRow	 = event:GetRow()
    local iCol	 = event:GetCol()

	-- the Enabled column is excluded
	--
	if -1 == iRow and 0 < iCol and 4 > iCol then
		
		m_thisApp.Sort(iCol + 1)			-- grid index starts from 0
		
		ShowServers()
		UpdateDisplay()
		
	else
		-- chain default processing
		--
		event:Skip()		
	end
end

-- ----------------------------------------------------------------------------
-- window size changed
--
local function OnSize()
--	m_logger:line("OnSize")

	if not m_Mainframe.hWindow then return end

	local grid	 = m_Mainframe.hGridDNSList
	local hEdit  = m_Mainframe.hEditFind
	local iHeight= hEdit:GetSize():GetHeight()
	local iWidth = grid:GetColSize(3)
	local iLeft  = grid:GetRowLabelSize() + grid:GetColSize(0) + grid:GetColSize(1) + grid:GetColSize(2)
	
	-- align the find text window to the company\s description
	--
	if 0 < iWidth then
		
		hEdit:SetSize(iWidth, iHeight)
		hEdit:Move(iLeft + 4, 2)
	end

	-- space available for the notebook
	--
	local size = m_Mainframe.hWindow:GetClientSize()
	m_Mainframe.hNotebook:SetSize(size)

	-- grids on notebook
	--
	local sizeBar = m_Mainframe.hStatusBar:GetSize()
	
	size = m_Mainframe.hNotebook:GetClientSize()
	size:SetWidth(size:GetWidth() - 6)
	size:SetHeight(size:GetHeight() - sizeBar:GetHeight())
	
	m_Mainframe.hGridDNSList:SetSize(size)
end

-- ----------------------------------------------------------------------------
-- called when closing the window
--
local function OnCloseMainframe()
--	m_logger:line("OnCloseMainframe")
  
	if not m_Mainframe.hWindow then return end

	-- stop the backtask timer
	--
	EnableBacktask(false)
	wx.wxGetApp():Disconnect(wx.wxEVT_TIMER)

	-- need to convert from size to pos
	--
	local pos  = m_Mainframe.hWindow:GetPosition()
	local size = m_Mainframe.hWindow:GetSize()
	
	local tColWidths = { }
	local grid		 = m_Mainframe.hGridDNSList
	
	for i=1, 4 do
		
		tColWidths[i] = grid:GetColSize(i - 1)
	end
	
	-- filter text
	--
	local sFilterText = m_Mainframe.hEditFind:GetValue()

	-- update the current settings
	--
	local tWinProps = { }
	
	tWinProps.window_xy = {pos:GetX(), pos:GetY()}
	tWinProps.window_wh = {size:GetWidth(), size:GetHeight()}
	tWinProps.grid_ruler= tColWidths
	tWinProps.use_font	= m_Mainframe.tWinProps.use_font				-- just copy over
	tWinProps.filter	= sFilterText
	
	m_Mainframe.tWinProps = tWinProps			-- switch structures

	SaveSettings()								-- write to file

	m_Mainframe.hWindow.Destroy(m_Mainframe.hWindow)
	m_Mainframe.hWindow = nil
end

-- ----------------------------------------------------------------------------
-- apply styles to the grid's elements
--
local function SetGridStyles(inGrid)
--	m_logger:line("SetGridStyles")

	local tWinProps = m_Mainframe.tWinProps
	local tRulers	= tWinProps.grid_ruler
	local tColors	= m_Mainframe.tColors
	local iFontSize	= tWinProps.use_font[1]
	local sFontname	= tWinProps.use_font[2]
	
	local fntCell = wx.wxFont( iFontSize, wx.wxFONTFAMILY_MODERN, wx.wxFONTSTYLE_NORMAL,
							   wx.wxFONTWEIGHT_LIGHT, false, sFontname, wx.wxFONTENCODING_SYSTEM)
						
	local fntCellBold = wx.wxFont( iFontSize - 1, wx.wxFONTFAMILY_MODERN, wx.wxFONTSTYLE_NORMAL,
							   wx.wxFONTWEIGHT_BOLD, false, sFontname, wx.wxFONTENCODING_SYSTEM)

	local fntLbl  = wx.wxFont( iFontSize - 2, wx.wxFONTFAMILY_MODERN, wx.wxFONTSTYLE_SLANT,
							   wx.wxFONTWEIGHT_LIGHT, false, sFontname, wx.wxFONTENCODING_SYSTEM)

	local tAttrs = { }

	tAttrs[1] = wx.wxGridCellAttr(tColors.cColFo0, tColors.cColBk0, fntCellBold, wx.wxALIGN_CENTRE, wx.wxALIGN_CENTRE)
	tAttrs[2] = wx.wxGridCellAttr(tColors.cColFo1, tColors.cColBk1, fntCell, wx.wxALIGN_CENTRE, wx.wxALIGN_CENTRE)
	tAttrs[3] = wx.wxGridCellAttr(tColors.cColFo2, tColors.cColBk2, fntCell, wx.wxALIGN_CENTRE, wx.wxALIGN_CENTRE)
	tAttrs[4] = wx.wxGridCellAttr(tColors.cColFo3, tColors.cColBk3, fntCell, wx.wxALIGN_CENTRE, wx.wxALIGN_CENTRE)	

	inGrid:CreateGrid(50, #tRulers)								-- some rows ad libitum
	inGrid:DisableDragRowSize()
	inGrid:DisableDragCell()
	inGrid:SetSelectionMode(1) 									-- wx.wxGridSelectRows = 1

	-- headers and rows
	--
	inGrid:SetLabelBackgroundColour(tColors.CLblBk)
	inGrid:SetLabelTextColour(tColors.CLblFo)
	inGrid:SetGridLineColour(tColors.cLines)
	inGrid:SetLabelFont(fntLbl)

	-- properties for columns
	--
	for i=1, #tRulers do
		
		inGrid:SetColSize(i - 1, tRulers[i])					-- size
		inGrid:SetColAttr(i - 1, tAttrs[i])						-- style
		inGrid:SetColLabelValue(i - 1, m_sGdLbls[i])			-- labels
	end
end

-- ----------------------------------------------------------------------------
-- load functions from the module functions.lua
-- re-create the menu entries
--
local rcMnuLoadFxs	= NewMenuID()
	
local function OnLoadFunctions()
--	m_logger:line("OnLoadFunctions")

	-- find the menu "Functions"
	--
	local menuBar = m_Mainframe.hWindow:GetMenuBar()
	local menuLoad, menuFxs = menuBar:FindItem(rcMnuLoadFxs)
	
	if not menuFxs then DlgMessage("Internal error!") return end

	-- remove the menus except the very first
	--
	local iCount = menuFxs:GetMenuItemCount()

	for i=1, iCount - 1 do
		
		menuFxs:Remove(menuFxs:FindItemByPosition(1))
	end

	-- compile and import functions
	--
	local functions	 = dofile("user.lua")
	
	-- create the menu entries
	--
	for i, item in next, functions do
		
		local id = NewMenuID()
		
		-- protected function to execute
		--
		MenuItemCmd = function()
			
			-- interpreted code at run time
			-- locals are out of scope here at run time
			-- use full names to select objects
			--
			local bRet = pcall(item[1])
			
			if not bRet then DlgMessage(item[2] .. " failed!") end
			
			return bRet
		end
		
		if 0 < #item[2] then
			
			menuFxs:Append(id, _frmt("%s\tCtrl-%d", item[2], i), item[3])
			m_Mainframe.hWindow:Connect(id, wx.wxEVT_COMMAND_MENU_SELECTED, MenuItemCmd)
		else
			
			menuFxs:AppendSeparator()
		end
	end

end

-- ----------------------------------------------------------------------------
-- show the main window and runs the main loop
--
local function ShowMainWindow()
--	m_logger:line("ShowMainWindow")

	if not m_Mainframe.hWindow then return end

	m_Mainframe.hWindow:Show(true)
	
	OnLoadFunctions()
	OnImportServers()
	
	-- run the main loop
	--
	wx.wxGetApp():MainLoop()
end

-- ----------------------------------------------------------------------------
--
local function CloseMainWindow()
--	m_logger:line("CloseMainWindow")
	
	if m_Mainframe.hWindow then OnCloseMainframe() end
end

-- ----------------------------------------------------------------------------
-- called to create the main window
--
local function CreateMainWindow()
--	trace:line("CreateMainWindow")

	m_thisApp  = _G.m_ThisApp

	-- read deafult positions for the dialogs
	--
	ReadSettings()

	-- unique IDs for the menu
	-- 
	local rcMnuImportFile	= NewMenuID()
	local rcMnuSaveFile		= NewMenuID()
	local rcMnuScramble		= NewMenuID()
	local rcMnuFilterText	= NewMenuID()

	local rcMnuDisableAll   = NewMenuID()
	local rcMnuEnableAll	= NewMenuID()
	local rcMnuEnableFuz	= NewMenuID()
	local rcMnuToggleSel	= NewMenuID()
	local rcMnuToggleAll	= NewMenuID()

	local rcMnuPurge_VALID	= NewMenuID()
	local rcMnuPurge_OK		= NewMenuID()
	local rcMnuPurge_KO		= NewMenuID()
	local rcMnuPurge_DEL	= NewMenuID()
	
	local rcMnuToggleBkTsk	= NewMenuID()
	local rcMnuResetCmpltd	= NewMenuID()	

	-- ------------------------------------------------------------------------	
	-- create a window
	--
	local tWinProps = m_Mainframe.tWinProps

	local pos  = tWinProps.window_xy
	local size = tWinProps.window_wh
	
	local iFontSize	= tWinProps.use_font[1]
	local sFontname	= tWinProps.use_font[2]
	
	local sTitle = m_thisApp.sAppName .. " [" ..	m_thisApp.sAppVersion .. "]"

	local frame = wx.wxFrame(wx.NULL, wx.wxID_ANY, sTitle,
							 wx.wxPoint(pos[1], pos[2]), wx.wxSize(size[1], size[2]))

	frame:SetMinSize(wx.wxSize(300, 200)) 						

	-- ------------------------------------------------------------------------
	-- create the menus
	--
	local mnuFile = wx.wxMenu("", wx.wxMENU_TEAROFF)

	mnuFile:Append(rcMnuImportFile,	"Import Servers\tCtrl-I",	"Read the settings file")
	mnuFile:Append(rcMnuSaveFile,	"Save Servers\tCtrl-S",		"Write the settings file")
	mnuFile:AppendSeparator()
	mnuFile:Append(rcMnuScramble,	"Scramble list",			"Scramble the current list")
	mnuFile:Append(rcMnuFilterText,	"Filter list",				"Filter servers by text")
	mnuFile:AppendSeparator()
	mnuFile:Append(wx.wxID_EXIT,    "E&xit\tAlt-X",				"Quit the program")

	local mnuEdit = wx.wxMenu("", wx.wxMENU_TEAROFF)

	mnuEdit:Append(rcMnuDisableAll,	"Disable all rows\tCtrl-D",	"Each DNS entry will be disabled")
	mnuEdit:Append(rcMnuEnableAll,	"Enable all rows\tCtrl-E",	"Each DNS entry will be anabled")
	mnuEdit:Append(rcMnuEnableFuz,	"Fuzzy enable\tCtrl-Q", 	"Enable servers at random")
	mnuEdit:Append(rcMnuToggleSel,	"Toggle selected rows\tCtrl-T",	"Toggle enable/disable for selection")
	mnuEdit:Append(rcMnuToggleAll,	"Invert all\tCtrl-A",		"Toggle enable/disable for all rows")

	local mnuFilt = wx.wxMenu("", wx.wxMENU_TEAROFF)


	mnuFilt:Append(rcMnuPurge_VALID,"Purge invalid\tCtrl-W",	"Remove servers without address")
	mnuFilt:Append(rcMnuPurge_OK,	"Purge failed\tCtrl-X",		"Remove not responding servers")
	mnuFilt:Append(rcMnuPurge_KO,	"Purge responding\tCtrl-Y",	"Remove responding servers")
	mnuFilt:AppendSeparator()
	mnuFilt:Append(rcMnuPurge_DEL,	"Delete selected\tCtrl-Z",	"Build a new list without selected")

	local mnuCmds = wx.wxMenu("", wx.wxMENU_TEAROFF)

	mnuCmds:Append(rcMnuToggleBkTsk,"Toggle backtask\tCtrl-B",	"Start/Stop the backtask")
	mnuCmds:Append(rcMnuResetCmpltd,"Reset completed\tCtrl-R",	"Reset the completed flag")

	local mnuFunc = wx.wxMenu("", wx.wxMENU_TEAROFF)
	
	mnuFunc:Append(rcMnuLoadFxs, "Reload functions\tCtrl-L",	"Load functions.lua, create menu entries")

	local mnuHelp = wx.wxMenu("", wx.wxMENU_TEAROFF)

	mnuHelp:Append(wx.wxID_ABOUT,    "&About",					"About the application")

	-- create the menu bar and associate sub-menus
	--
	local mnuBar = wx.wxMenuBar()

	mnuBar:Append(mnuFile,	"&File")
	mnuBar:Append(mnuEdit,	"&Enable")
	mnuBar:Append(mnuFilt,	"&Delete")
	mnuBar:Append(mnuCmds,	"&Commands")
	mnuBar:Append(mnuFunc,  "&Functions")
	mnuBar:Append(mnuHelp,	"&Help")

	frame:SetMenuBar(mnuBar)

	-- ------------------------------------------------------------------------
	-- create the bottom status bar
	-- (wxSB_SUNKEN    0x0003)
	--
	local stsBar = frame:CreateStatusBar(6, 0)

	stsBar:SetFont(wx.wxFont(iFontSize - 2, wx.wxFONTFAMILY_DEFAULT, wx.wxFONTSTYLE_NORMAL, wx.wxFONTWEIGHT_NORMAL))      
	stsBar:SetStatusWidths({20, -1, 75, 50, 50, 50})
	stsBar:SetStatusStyles({wx.wxSB_FLAT, 3, wx.wxSB_FLAT, wx.wxSB_FLAT, wx.wxSB_FLAT, wx.wxSB_FLAT})
	stsBar:SetStatusText(m_thisApp.sAppName, 1)
	
	frame:SetStatusBarPane(1)                  -- this is reserved for the menu
	
	-- ------------------------------------------------------------------------
	-- standard event handlers
	--
	frame:Connect(wx.wxEVT_CLOSE_WINDOW, CloseMainWindow)
	frame:Connect(wx.wxEVT_SIZE,		 OnSize)
	frame:Connect(wx.wxEVT_TIMER,		 OnTickTimer)

	-- menu event handlers
	--
	frame:Connect(rcMnuImportFile,	wx.wxEVT_COMMAND_MENU_SELECTED,	OnImportServers)
	frame:Connect(rcMnuSaveFile,	wx.wxEVT_COMMAND_MENU_SELECTED,	OnSaveServers)
	frame:Connect(rcMnuScramble,	wx.wxEVT_COMMAND_MENU_SELECTED,	OnScramble)
	frame:Connect(rcMnuFilterText,	wx.wxEVT_COMMAND_MENU_SELECTED,	OnFilterByRef)

	frame:Connect(rcMnuDisableAll,	wx.wxEVT_COMMAND_MENU_SELECTED, function() OnEnableAll(0) end)
	frame:Connect(rcMnuEnableAll,	wx.wxEVT_COMMAND_MENU_SELECTED,	function() OnEnableAll(1) end)
	frame:Connect(rcMnuEnableFuz,	wx.wxEVT_COMMAND_MENU_SELECTED,	OnFuzzyEnable)
	frame:Connect(rcMnuToggleSel,	wx.wxEVT_COMMAND_MENU_SELECTED,	OnToggleSelected)
	frame:Connect(rcMnuToggleAll,	wx.wxEVT_COMMAND_MENU_SELECTED,	OnToggleAll)

	frame:Connect(rcMnuPurge_VALID,	wx.wxEVT_COMMAND_MENU_SELECTED,	OnPurgeInvalid)
	frame:Connect(rcMnuPurge_OK,	wx.wxEVT_COMMAND_MENU_SELECTED,	function() OnPurgeServers(Purge.failed) end)
	frame:Connect(rcMnuPurge_KO,	wx.wxEVT_COMMAND_MENU_SELECTED, function() OnPurgeServers(Purge.verified) end)
	frame:Connect(rcMnuPurge_DEL,	wx.wxEVT_COMMAND_MENU_SELECTED, OnDeleteSelected)
	
	frame:Connect(rcMnuLoadFxs, 	wx.wxEVT_COMMAND_MENU_SELECTED,	OnLoadFunctions)

	frame:Connect(rcMnuToggleBkTsk,	wx.wxEVT_COMMAND_MENU_SELECTED,	function() EnableBacktask(not BacktaskRunning()) end)
	frame:Connect(rcMnuResetCmpltd,	wx.wxEVT_COMMAND_MENU_SELECTED,	OnResetCompleted)

	frame:Connect(wx.wxID_EXIT,		wx.wxEVT_COMMAND_MENU_SELECTED, CloseMainWindow)
	frame:Connect(wx.wxID_ABOUT,	wx.wxEVT_COMMAND_MENU_SELECTED, OnAbout)

	-- ------------------------------------------------------------------------
	-- create a notebook style pane and apply styles
	--
	local notebook = wx.wxNotebook(frame, wx.wxID_ANY)
	local fntNote  = wx.wxFont( iFontSize, wx.wxFONTFAMILY_MODERN, wx.wxFONTSTYLE_NORMAL,
							    wx.wxFONTWEIGHT_BOLD, false, sFontname, wx.wxFONTENCODING_SYSTEM)

	notebook:SetBackgroundColour(palette.Gray20)
	notebook:SetFont(fntNote)

	local newGrid = wx.wxGrid(notebook, wx.wxID_ANY, wx.wxDefaultPosition, notebook:GetSize()) 
	notebook:AddPage(newGrid, "Servers List", true, 0)
	SetGridStyles(newGrid)

	frame:Connect(wx.wxEVT_GRID_CELL_CHANGED, 		OnCellChanged)		-- validate input from user
	frame:Connect(wx.wxEVT_GRID_LABEL_LEFT_CLICK,	OnLabelSelected)	-- apply sort
	
	-- ------------------------------------------------------------------------
	-- control for finding text
	--
	local fntFind = wx.wxFont( iFontSize, wx.wxFONTFAMILY_MODERN, wx.wxFONTSTYLE_NORMAL,
							   wx.wxFONTWEIGHT_BOLD, false, sFontname, wx.wxFONTENCODING_SYSTEM)
						
	local iEdWidth  = 500											-- width of the edit control
	local iEdHeight = notebook:GetCharHeight() + 6

	local editFind = wx.wxTextCtrl(	notebook, wx.wxID_ANY, "", wx.wxDefaultPosition, 
									wx.wxSize(iEdWidth, iEdHeight), wx.wxTE_PROCESS_ENTER)

	editFind:SetFont(wx.wxFont(fntFind))

	editFind:Connect(wx.wxEVT_CHAR, OnSearchText)
	
	-- assign the last text used in text box
	--
	editFind:WriteText(tWinProps.filter)

	-- assign an icon
	--
	local icon = wx.wxIcon("lib/icons/pDNS.ico", wx.wxBITMAP_TYPE_ICO)
	frame:SetIcon(icon)

	--  store for later
	--
	m_Mainframe.hWindow		= frame
	m_Mainframe.hStatusBar	= stsBar	
	m_Mainframe.hNotebook	= notebook
	m_Mainframe.hGridDNSList= newGrid
	m_Mainframe.hEditFind	= editFind
end

-- ----------------------------------------------------------------------------
-- associate functions
--
local function SetupPublic()
	m_Mainframe.CreateMainWindow	= CreateMainWindow
	m_Mainframe.ShowMainWindow		= ShowMainWindow
	m_Mainframe.CloseMainWindow		= CloseMainWindow
	m_Mainframe.ShowServers			= ShowServers
	m_Mainframe.UpdateDisplay		= UpdateDisplay
end

-- ----------------------------------------------------------------------------
--
SetupPublic()

return m_Mainframe

-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------