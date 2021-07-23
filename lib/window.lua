-- ----------------------------------------------------------------------------
--
--  Mainframe
--
-- ----------------------------------------------------------------------------

local wx 		= require("wx")					-- uses wxWidgets for Lua
local constants	= require("lib.constants")		-- global constants
local trace		= require("lib.trace")			-- shortcut for tracing
local palette	= require("lib.wxX11Palette")	-- declarations for colors

local _frmt		= string.format
local _min		= math.min
local _max		= math.max
local _abs		= math.abs

-- ----------------------------------------------------------------------------
--
local m_thisApp			= nil
local m_iBkTskInterval	= 5
local m_iBatchLimit		= 10

-- ----------------------------------------------------------------------------
--
local m_logger = trace.new("debug")

-- ----------------------------------------------------------------------------
-- colors combinations
--
local m_tDefColours <const> = 
{
	tSchemeDark =
	{
		cColBk0	= palette.Orange,
		cColFo0	= palette.WhiteSmoke,
		cColBk1	= palette.Black,
		cColFo1	= palette.WhiteSmoke,
		cColBk2	= palette.Gray15,
		cColFo2	= palette.WhiteSmoke,
		cColBk3	= palette.Gray40,
		cColFo3	= palette.Burlywood2,
		cFail	= palette.OrangeRed,
		cSucc	= palette.MediumSeaGreen,
		cLines	= palette.Gray60,
		CLblBk	= palette.MediumPurple4,
		CLblFo	= palette.PaleGoldenrod,
	},
	
	tSchemePale =
	{
		cColBk0	= palette.CornflowerBlue,
		cColFo0	= palette.Blue4,
		cColBk1	= palette.Gray100,
		cColFo1	= palette.Black,
		cColBk2	= palette.WhiteSmoke,
		cColFo2	= palette.Black,
		cColBk3	= palette.Honeydew2,
		cColFo3	= palette.DodgerBlue4,
		cFail	= palette.IndianRed,
		cSucc	= palette.MediumAquamarine,
		cLines	= palette.Ivory3,
		CLblBk	= palette.Wheat3,
		CLblFo	= palette.Ivory1,
	},
}

-- ----------------------------------------------------------------------------
-- grid's labels
--
local m_sGdLbls =
{
	"E.", "#1", "#2", "Organization"
}

local m_tGdFont = {13, "Calibri"}					-- font for the grid and notebook

-- ----------------------------------------------------------------------------
-- default dialog size and position
--
local m_tDefWinProp =
{
	window_xy	= {20,	 20},						-- top, left
	window_wh	= {750,	265},						-- width, height
	grid_ruler	= {75, 200, 200, 500},				-- size of each column
}

-- ----------------------------------------------------------------------------
-- contains various handlers and values
--
local m_Mainframe = 
{
	hWindow			= nil,         					-- window handle
	hNotebook		= nil,							-- notebook handle
	hStatusBar		= nil,							-- statusbar handle

	hGridDNSList	= nil,							-- grid
	tColors			= m_tDefColours.tSchemeDark,	-- colours for the grid

	hTickTimer		= nil,							-- timer associated with window
	bReentryLock	= false,						-- avoid re-entrant calling
	iTaskCounter	= 0,							-- backtask calls counter

	sSettings		= "window.ini",					-- filename for settings
	tWinProps		= m_tDefWinProp,				-- window layout settings
}

-- ----------------------------------------------------------------------------
-- read dialogs' settings from settings file
--
local function ReadSettings()
--	m_logger:line("ReadSettings")

	local fd = io.open(m_Mainframe.sSettings, "r")
	if not fd then return end

	fd:close()

	local settings = dofile(m_Mainframe.sSettings)

	if settings then m_Mainframe.tWinProps = settings end
end

-- ----------------------------------------------------------------------------
-- save a table to the settings file
--
local function SaveSettings()
--	m_logger:line("SaveSettings")

	local fd = io.open(m_Mainframe.sSettings, "w")
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
--local function SetStatusText(inText)
	
--	local hBar = m_Mainframe.hStatusBar
	
--	hBar:SetStatusText(inText, 0)
--end

-- ----------------------------------------------------------------------------
--
local function SetStatusCounter(inValue)
	
	local hBar = m_Mainframe.hStatusBar
	
	hBar:SetStatusText(tostring(inValue), 1)
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
			hTick:Start(m_iBkTskInterval, false)
			
			m_logger:line("Backtask started")
		end
	else
		
		if hTick then
			
			hTick:Stop()
			hTick = nil
			
			m_logger:line("Backtask stopped")			
		end
	end
	
	-- store handle
	--
	m_Mainframe.hTickTimer = hTick
end

-- ----------------------------------------------------------------------------
-- read the settings file
--
local function ShowServers()
--	m_logger:line("ShowServers")
	
	-- remove all rows
	--
	local grid = m_Mainframe.hGridDNSList
	
	if 0 < grid:GetNumberRows() then
		
		grid:DeleteRows(0, grid:GetNumberRows())
	end

	-- --------------------------------
	-- fill the servers' grid
	--
	local tDNS = m_thisApp.tServers			-- here we are sure the table is not empty
	
	grid:AppendRows(#tDNS, false)			-- create empty rows
	
	local tCurrent

	for iRow=0, #tDNS - 1 do
		
		tCurrent = tDNS[iRow + 1]
		
		grid:SetCellValue(iRow, 0, tostring(tCurrent.iEnabled))		-- active state
		grid:SetCellValue(iRow, 1, tCurrent.tAddresses[1].sAddress)	-- ip address
		grid:SetCellValue(iRow, 2, tCurrent.tAddresses[2].sAddress)	-- ip address
		grid:SetCellValue(iRow, 3, tCurrent.sReference)				-- url or name
	end
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
-- read the settings file
--
local function OnImportServers()
--	m_logger:line("OnImportServers")
	
	-- read the settings file and create the clients
	--
	local ret

	ret = m_thisApp.ImportDNSFile()
	
	if 0 == ret then DlgMessage("Failed to read DNS servers' list\nor the list is empty") return end

	ShowServers()
end
	
-- ----------------------------------------------------------------------------
-- set the enable flag for all DNS servers or a specific row
--
local function SetEnable(inRow, inEnabled)
	
	local tDNS = m_thisApp.tServers
	
	if 0 == #tDNS then return end
	if inRow >= #tDNS then return end
	
	local grid = m_Mainframe.hGridDNSList	
	local tCurrent
	
	if -1 == inRow then
		
		-- all rows
		--
		for iIndex=0, #tDNS - 1 do
		
			tCurrent = tDNS[iIndex + 1]
			
			tCurrent.iEnabled = inEnabled		-- update memory
			
			grid:SetCellValue(iIndex, 0, tostring(tCurrent.iEnabled))		-- active state
		end
		
	else
		
		-- selected row only
		--
		tCurrent = tDNS[inRow + 1]
		
		tCurrent.iEnabled = inEnabled			-- update memory
		
		grid:SetCellValue(inRow, 0, tostring(tCurrent.iEnabled))		-- active state		
	end
end

-- ----------------------------------------------------------------------------
-- toggle the enable/disable flag for the selected rows
--
local function OnToggleEnable()
--	m_logger:line("OnToggleEnable")	
	
	local grid 		= m_Mainframe.hGridDNSList
	local tSelected = grid:GetSelectedRows():ToLuaTable()
	local iValue
	
	for i=1, #tSelected do
		
		iValue = grid:GetCellValue(tSelected[i], 0)
		
		SetEnable(tSelected[i], _abs(iValue - 1))
	end
end

-- ----------------------------------------------------------------------------
-- reset the DNS client to the start
--
local function OnResetCompleted()
--	m_logger:line("OnResetCompleted")

	local tServers	= m_thisApp.tServers
	local grid 		= m_Mainframe.hGridDNSList
	local tColors	= m_Mainframe.tColors

	-- check each server
	--
	for _, server in next, tServers do server:Restart() end

	for i=1, #tServers do
		
		grid:SetCellBackgroundColour(i - 1, 1, tColors.cColBk1)
		grid:SetCellBackgroundColour(i - 1, 2, tColors.cColBk2)
	end
	
	grid:ForceRefresh()					-- seldom there's no colour changing
end

-- ----------------------------------------------------------------------------
-- reset the DNS client to the start
--
local function OnPurgeHosts(inWhich)
--	m_logger:line("OnPurgeHosts")

	if m_thisApp.PurgeHosts(inWhich) then ShowServers()	end
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
	
	m_Mainframe.iTaskCounter = m_Mainframe.iTaskCounter + 1

	local tServers	= m_thisApp.tServers
	local tColors	= m_Mainframe.tColors
	local iBatch	= 0

	-- check each server
	--
	for i =1, #tServers do

		if 1 == tServers[i].iEnabled and not tServers[i]:HasCompletedAll() then
			
			iBatch = iBatch + 1
			
			tServers[i]:RunTask()
		
			-- update the display
			--
			if tServers[i]:HasCompletedAll() then
				
				local grid = m_Mainframe.hGridDNSList
				local iDnsRes = tServers[i]:Result()
				
				for y=1, 2 do
					
					if 0 < ((iDnsRes >> (y - 1)) & 0x01) then
					
						grid:SetCellBackgroundColour(i - 1, y, tColors.cSucc)
					else
						
						-- extra check to avoid colouring a cell without address
						--
						if tServers[i]:IsValid(y) then
							
							grid:SetCellBackgroundColour(i - 1, y, tColors.cFail)
						end
					end
				end
				
				grid:MakeCellVisible(i - 1, 0)
				grid:ForceRefresh()					-- seldom there's no colour changing
			end
		end
		
		if m_iBatchLimit == iBatch then break end	-- check for end of batch
	end

	SetStatusCounter(m_Mainframe.iTaskCounter)

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
		
	elseif 1 == iCol then
		
		tRow.tAddresses[1].sAddress = aValue
		
	elseif 2 == iCol then
		
		tRow.tAddresses[2].sAddress = aValue
		
	elseif 3 == iCol then
		
		tRow.sReference = aValue
	end
end

-- ----------------------------------------------------------------------------
-- window size changed
--
local function OnSize()
--	m_logger:line("OnSize")

	local sizeClient = m_Mainframe.hWindow:GetClientSize()
	local sizeBar 	 = m_Mainframe.hStatusBar:GetSize()

	-- space available for the notebook
	--
	m_Mainframe.hNotebook:SetSize(sizeClient)

	-- grids on notebook
	--
	local size = m_Mainframe.hNotebook:GetClientSize()
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

	-- update the current settings
	--
	local tWinProps = { }
	
	tWinProps.window_xy = {pos:GetX(), pos:GetY()}
	tWinProps.window_wh = {size:GetWidth(), size:GetHeight()}
	tWinProps.grid_ruler= tColWidths

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
	local iFontSize	= m_tGdFont[1]
	local sFontname	= m_tGdFont[2]
	
	local fntCell = wx.wxFont( iFontSize, wx.wxFONTFAMILY_MODERN, wx.wxFONTSTYLE_NORMAL,
							   wx.wxFONTWEIGHT_LIGHT, false, sFontname, wx.wxFONTENCODING_SYSTEM)

	local fntLbl  = wx.wxFont( iFontSize - 1, wx.wxFONTFAMILY_MODERN, wx.wxFONTSTYLE_NORMAL,
							   wx.wxFONTWEIGHT_LIGHT, false, sFontname, wx.wxFONTENCODING_SYSTEM)

	local tAttrs = { }

	tAttrs[1] = wx.wxGridCellAttr(tColors.cColFo0, tColors.cColBk0, fntCell, wx.wxALIGN_CENTRE, wx.wxALIGN_CENTRE)
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
-- show the main window and runs the main loop
--
local function ShowMainWindow()
--	m_logger:line("ShowMainWindow")

	if not m_Mainframe.hWindow then return end

	m_Mainframe.hWindow:Show(true)
	
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
local function CreateMainWindow(inApplication)
--	trace:line("CreateMainWindow")
	
	m_thisApp  = inApplication
	
	-- read deafult positions for the dialogs
	--
	ReadSettings()
  
	-- unique IDs for the menu
	-- 
	local rcMnuImportFile	= NewMenuID()
	local rcMnuSaveFile		= NewMenuID()
	
	local rcMnuToggleBkTsk	= NewMenuID()
	local rcMnuResetCmpltd	= NewMenuID()
	
	local rcMnuDisableAll   = NewMenuID()
	local rcMnuEnableAll	= NewMenuID()
	local rcMnuToggleEn		= NewMenuID()

	local rcMnuFilter_OK	= NewMenuID()
	local rcMnuFilter_KO	= NewMenuID()

	-- ------------------------------------------------------------------------	
	-- create a window
	--
	local tWinProps = m_Mainframe.tWinProps
	
	local pos  = tWinProps.window_xy
	local size = tWinProps.window_wh

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
	mnuFile:Append(wx.wxID_EXIT,    "E&xit\tAlt-X",				"Quit the program")
	
	local mnuEdit = wx.wxMenu("", wx.wxMENU_TEAROFF)

	mnuEdit:Append(rcMnuDisableAll,	"Disable all rows\tCtrl-D",	"Each DNS entry will be disabled")
	mnuEdit:Append(rcMnuEnableAll,	"Enable all rows\tCtrl-E",	"Each DNS entry will be anabled")
	mnuEdit:Append(rcMnuToggleEn,	"Toggle selected rows\tCtrl-T",	"Toggle enable/disable for selection")
	
	local mnuCmds = wx.wxMenu("", wx.wxMENU_TEAROFF)

	mnuCmds:Append(rcMnuToggleBkTsk,"Toggle backtask\tCtrl-B",	"Start/Stop the backtask")
	mnuCmds:Append(rcMnuResetCmpltd,"Reset completed\tCtrl-R",	"Reset the completed flag")
	
	local mnuFilt = wx.wxMenu("", wx.wxMENU_TEAROFF)

	mnuFilt:Append(rcMnuFilter_OK,	"Purge failed\tCtrl-Z",		"Remove non responding hosts")
	mnuFilt:Append(rcMnuFilter_KO,	"Purge succeeded\tCtrl-X",	"Remove responding hosts")

	local mnuHelp = wx.wxMenu("", wx.wxMENU_TEAROFF)

	mnuHelp:Append(wx.wxID_ABOUT,    "&About",					"About the application")

	-- create the menu bar and associate sub-menus
	--
	local mnuBar = wx.wxMenuBar()

	mnuBar:Append(mnuFile,	"&File")
	mnuBar:Append(mnuEdit,	"&Edit")
	mnuBar:Append(mnuCmds,	"&Commands")
	mnuBar:Append(mnuFilt,	"&Filter")
	mnuBar:Append(mnuHelp,	"&Help")

	frame:SetMenuBar(mnuBar)

	-- ------------------------------------------------------------------------
	-- create the bottom status bar
	--
	local stsBar = frame:CreateStatusBar(3, wx.wxST_SIZEGRIP)

	stsBar:SetFont(wx.wxFont(11, wx.wxFONTFAMILY_DEFAULT, wx.wxFONTSTYLE_NORMAL, wx.wxFONTWEIGHT_NORMAL))      
	stsBar:SetStatusWidths({-1, 75, 50}); 

	stsBar:SetStatusText(m_thisApp.sAppName, 0)  
	frame:SetStatusBarPane(0)                   	-- this is reserved for the menu

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

	frame:Connect(rcMnuDisableAll,	wx.wxEVT_COMMAND_MENU_SELECTED, function() SetEnable(-1, 0) end)
	frame:Connect(rcMnuEnableAll,	wx.wxEVT_COMMAND_MENU_SELECTED,	function() SetEnable(-1, 1) end)
	frame:Connect(rcMnuToggleEn,	wx.wxEVT_COMMAND_MENU_SELECTED,	OnToggleEnable)

	frame:Connect(rcMnuToggleBkTsk,	wx.wxEVT_COMMAND_MENU_SELECTED,	function() EnableBacktask(not BacktaskRunning()) end)
	frame:Connect(rcMnuResetCmpltd,	wx.wxEVT_COMMAND_MENU_SELECTED,	OnResetCompleted)
	
	frame:Connect(rcMnuFilter_OK,	wx.wxEVT_COMMAND_MENU_SELECTED,	function() OnPurgeHosts(constants.Purge.failed) end)
	frame:Connect(rcMnuFilter_KO,	wx.wxEVT_COMMAND_MENU_SELECTED, function() OnPurgeHosts(constants.Purge.verified) end)

	frame:Connect(wx.wxID_EXIT,		wx.wxEVT_COMMAND_MENU_SELECTED, CloseMainWindow)
	frame:Connect(wx.wxID_ABOUT,	wx.wxEVT_COMMAND_MENU_SELECTED, OnAbout)

	-- ------------------------------------------------------------------------
	-- create a notebook style pane and apply styles
	--
	local iFontSize	= m_tGdFont[1]
	local sFontname	= m_tGdFont[2]

	local notebook = wx.wxNotebook(frame, wx.wxID_ANY)
	local fntNote  = wx.wxFont( iFontSize, wx.wxFONTFAMILY_MODERN, wx.wxFONTSTYLE_NORMAL,
							    wx.wxFONTWEIGHT_BOLD, false, sFontname, wx.wxFONTENCODING_SYSTEM)

	notebook:SetBackgroundColour(palette.Gray20)
	notebook:SetFont(fntNote)

	local gridDNS = wx.wxGrid(notebook, wx.wxID_ANY, wx.wxDefaultPosition, notebook:GetSize())	

	notebook:AddPage(gridDNS, "DNS Servers", true, 0)
--	notebook:AddPage(gridDNS, "Experiment", false, 0)
	
	SetGridStyles(gridDNS)											-- apply styles to grids

	frame:Connect(wx.wxEVT_GRID_CELL_CHANGED, OnCellChanged)		-- connect the event to a handler

	-- assign an icon
	--
	local icon = wx.wxIcon("lib/icons/pDNS.ico", wx.wxBITMAP_TYPE_ICO)
	frame:SetIcon(icon)

	--  store for later
	--
	m_Mainframe.hWindow		= frame
	m_Mainframe.hStatusBar	= stsBar	
	m_Mainframe.hNotebook	= notebook
	m_Mainframe.hGridDNSList= gridDNS
end

-- ----------------------------------------------------------------------------
-- associate functions
--
local function SetupPublic()
	m_Mainframe.CreateMainWindow	= CreateMainWindow
	m_Mainframe.ShowMainWindow		= ShowMainWindow
	m_Mainframe.CloseMainWindow		= CloseMainWindow
end

-- ----------------------------------------------------------------------------
--
SetupPublic()

return m_Mainframe

-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------