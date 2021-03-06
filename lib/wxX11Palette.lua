-- ----------------------------------------------------------------------------
--
--  wxX11Palette - X11 colours
--
-- ----------------------------------------------------------------------------

local wx = require("wx")

-- ----------------------------------------------------------------------------
-- note: using the default wxALPHA_OPAQUE as 4th parameter
-- the other possible parameter is wxALPHA_TRANSPARENT
--
local wxX11Palette =
{
	["Snow"]           = wx.wxColour(255, 250, 250),
	["GhostWhite"]     = wx.wxColour(248, 248, 255),
	["WhiteSmoke"]     = wx.wxColour(245, 245, 245),
	["Gainsboro"]      = wx.wxColour(220, 220, 220),
	["FloralWhite"]    = wx.wxColour(255, 250, 240),
	["OldLace"]        = wx.wxColour(253, 245, 230),
	["Linen"]          = wx.wxColour(250, 240, 230),
	["AntiqueWhite"]   = wx.wxColour(250, 235, 215),
	["PapayaWhip"]     = wx.wxColour(255, 239, 213),
	["BlanchedAlmond"] = wx.wxColour(255, 235, 205),
	["Bisque"]         = wx.wxColour(255, 228, 196),
	["PeachPuff"]      = wx.wxColour(255, 218, 185),
	["NavajoWhite"]    = wx.wxColour(255, 222, 173),
	["Moccasin"]       = wx.wxColour(255, 228, 181),
	["Cornsilk"]       = wx.wxColour(255, 248, 220),
	["Ivory"]          = wx.wxColour(255, 255, 240),
	["LemonChiffon"]   = wx.wxColour(255, 250, 205),
	["Seashell"]       = wx.wxColour(255, 245, 238),
	["Honeydew"]       = wx.wxColour(240, 255, 240),
	["MintCream"]      = wx.wxColour(245, 255, 250),
	["Azure"]          = wx.wxColour(240, 255, 255),
	["AliceBlue"]      = wx.wxColour(240, 248, 255),
	["Lavender"]       = wx.wxColour(230, 230, 250),
	["LavenderBlush"]  = wx.wxColour(255, 240, 245),
	["MistyRose"]      = wx.wxColour(255, 228, 225),
	["White"]          = wx.wxColour(255, 255, 255),
	["Black"]          = wx.wxColour(0, 0, 0),
	["DarkSlateGray"]  = wx.wxColour(47, 79, 79),
	["DimGray"]        = wx.wxColour(105, 105, 105),
	["SlateGray"]      = wx.wxColour(112, 128, 144),
	["LightSlateGray"] = wx.wxColour(119, 136, 153),
	["Gray"]           = wx.wxColour(192, 192, 192),
	["LightGray"]      = wx.wxColour(211, 211, 211),
	["MidnightBlue"]   = wx.wxColour(25, 25, 112),
	["Navy"]           = wx.wxColour(0, 0, 128),
	["NavyBlue"]       = wx.wxColour(0, 0, 128),
	["CornflowerBlue"] = wx.wxColour(100, 149, 237),
	["DarkSlateBlue"]  = wx.wxColour(72, 61, 139),
	["SlateBlue"]      = wx.wxColour(106, 90, 205),
	["MediumSlateBlue"] = wx.wxColour(123, 104, 238),
	["LightSlateBlue"] = wx.wxColour(132, 112, 255),
	["MediumBlue"]     = wx.wxColour(0, 0, 205),
	["RoyalBlue"]      = wx.wxColour(65, 105, 225),
	["Blue"]           = wx.wxColour(0, 0, 255),
	["DodgerBlue"]     = wx.wxColour(30, 144, 255),
	["DeepSkyBlue"]    = wx.wxColour(0, 191, 255),
	["SkyBlue"]        = wx.wxColour(135, 206, 235),
	["LightSkyBlue"]   = wx.wxColour(135, 206, 250),
	["SteelBlue"]      = wx.wxColour(70, 130, 180),
	["LightSteelBlue"] = wx.wxColour(176, 196, 222),
	["LightBlue"]      = wx.wxColour(173, 216, 230),
	["PowderBlue"]     = wx.wxColour(176, 224, 230),
	["PaleTurquoise"]  = wx.wxColour(175, 238, 238),
	["DarkTurquoise"]  = wx.wxColour(0, 206, 209),
	["MediumTurquoise"] = wx.wxColour(72, 209, 204),
	["Turquoise"]      = wx.wxColour(64, 224, 208),
	["Cyan"]           = wx.wxColour(0, 255, 255),
	["LightCyan"]      = wx.wxColour(224, 255, 255),
	["CadetBlue"]      = wx.wxColour(95, 158, 160),
	["MediumAquamarine"] = wx.wxColour(102, 205, 170),
	["Aquamarine"]     = wx.wxColour(127, 255, 212),
	["DarkGreen"]      = wx.wxColour(0, 100, 0),
	["DarkOliveGreen"] = wx.wxColour(85, 107, 47),
	["DarkSeaGreen"]   = wx.wxColour(143, 188, 143),
	["SeaGreen"]       = wx.wxColour(46, 139, 87),
	["MediumSeaGreen"] = wx.wxColour(60, 179, 113),
	["LightSeaGreen"]  = wx.wxColour(32, 178, 170),
	["PaleGreen"]      = wx.wxColour(152, 251, 152),
	["SpringGreen"]    = wx.wxColour(0, 255, 127),
	["LawnGreen"]      = wx.wxColour(124, 252, 0),
	["Green"]          = wx.wxColour(0, 255, 0),
	["Chartreuse"]     = wx.wxColour(127, 255, 0),
	["MediumSpringGreen"] = wx.wxColour(0, 250, 154),
	["GreenYellow"]    = wx.wxColour(173, 255, 47),
	["LimeGreen"]      = wx.wxColour(50, 205, 50),
	["YellowGreen"]    = wx.wxColour(154, 205, 50),
	["ForestGreen"]    = wx.wxColour(34, 139, 34),
	["OliveDrab"]      = wx.wxColour(107, 142, 35),
	["DarkKhaki"]      = wx.wxColour(189, 183, 107),
	["Khaki"]          = wx.wxColour(240, 230, 140),
	["PaleGoldenrod"]  = wx.wxColour(238, 232, 170),
	["LightGoldenrodYel"] = wx.wxColour(250, 250, 210),
	["LightYellow"]    = wx.wxColour(255, 255, 224),
	["Yellow"]         = wx.wxColour(255, 255, 0),
	["Gold"]           = wx.wxColour(255, 215, 0),
	["LightGoldenrod"] = wx.wxColour(238, 221, 130),
	["Goldenrod"]      = wx.wxColour(218, 165, 32),
	["DarkGoldenrod"]  = wx.wxColour(184, 134, 11),
	["RosyBrown"]      = wx.wxColour(188, 143, 143),
	["IndianRed"]      = wx.wxColour(205, 92, 92),
	["SaddleBrown"]    = wx.wxColour(139, 69, 19),
	["Sienna"]         = wx.wxColour(160, 82, 45),
	["Peru"]           = wx.wxColour(205, 133, 63),
	["Burlywood"]      = wx.wxColour(222, 184, 135),
	["Beige"]          = wx.wxColour(245, 245, 220),
	["Wheat"]          = wx.wxColour(245, 222, 179),
	["SandyBrown"]     = wx.wxColour(244, 164, 96),
	["Tan"]            = wx.wxColour(210, 180, 140),
	["Chocolate"]      = wx.wxColour(210, 105, 30),
	["Firebrick"]      = wx.wxColour(178, 34, 34),
	["Brown"]          = wx.wxColour(165, 42, 42),
	["DarkSalmon"]     = wx.wxColour(233, 150, 122),
	["Salmon"]         = wx.wxColour(250, 128, 114),
	["LightSalmon"]    = wx.wxColour(255, 160, 122),
	["Orange"]         = wx.wxColour(255, 165, 0),
	["DarkOrange"]     = wx.wxColour(255, 140, 0),
	["Coral"]          = wx.wxColour(255, 127, 80),
	["LightCoral"]     = wx.wxColour(240, 128, 128),
	["Tomato"]         = wx.wxColour(255, 99, 71),
	["OrangeRed"]      = wx.wxColour(255, 69, 0),
	["Red"]            = wx.wxColour(255, 0, 0),
	["HotPink"]        = wx.wxColour(255, 105, 180),
	["DeepPink"]       = wx.wxColour(255, 20, 147),
	["Pink"]           = wx.wxColour(255, 192, 203),
	["LightPink"]      = wx.wxColour(255, 182, 193),
	["PaleVioletRed"]  = wx.wxColour(219, 112, 147),
	["Maroon"]         = wx.wxColour(176, 48, 96),
	["MediumVioletRed"] = wx.wxColour(199, 21, 133),
	["VioletRed"]      = wx.wxColour(208, 32, 144),
	["Magenta"]        = wx.wxColour(255, 0, 255),
	["Violet"]         = wx.wxColour(238, 130, 238),
	["Plum"]           = wx.wxColour(221, 160, 221),
	["Orchid"]         = wx.wxColour(218, 112, 214),
	["MediumOrchid"]   = wx.wxColour(186, 85, 211),
	["DarkOrchid"]     = wx.wxColour(153, 50, 204),
	["DarkViolet"]     = wx.wxColour(148, 0, 211),
	["BlueViolet"]     = wx.wxColour(138, 43, 226),
	["Purple"]         = wx.wxColour(160, 32, 240),
	["MediumPurple"]   = wx.wxColour(147, 112, 219),
	["Thistle"]        = wx.wxColour(216, 191, 216),
	["Snow1"]          = wx.wxColour(255, 250, 250),
	["Snow2"]          = wx.wxColour(238, 233, 233),
	["Snow3"]          = wx.wxColour(205, 201, 201),
	["Snow4"]          = wx.wxColour(139, 137, 137),
	["Seashell1"]      = wx.wxColour(255, 245, 238),
	["Seashell2"]      = wx.wxColour(238, 229, 222),
	["Seashell3"]      = wx.wxColour(205, 197, 191),
	["Seashell4"]      = wx.wxColour(139, 134, 130),
	["AntiqueWhite1"]  = wx.wxColour(255, 239, 219),
	["AntiqueWhite2"]  = wx.wxColour(238, 223, 204),
	["AntiqueWhite3"]  = wx.wxColour(205, 192, 176),
	["AntiqueWhite4"]  = wx.wxColour(139, 131, 120),
	["Bisque1"]        = wx.wxColour(255, 228, 196),
	["Bisque2"]        = wx.wxColour(238, 213, 183),
	["Bisque3"]        = wx.wxColour(205, 183, 158),
	["Bisque4"]        = wx.wxColour(139, 125, 107),
	["PeachPuff1"]     = wx.wxColour(255, 218, 185),
	["PeachPuff2"]     = wx.wxColour(238, 203, 173),
	["PeachPuff3"]     = wx.wxColour(205, 175, 149),
	["PeachPuff4"]     = wx.wxColour(139, 119, 101),
	["NavajoWhite1"]   = wx.wxColour(255, 222, 173),
	["NavajoWhite2"]   = wx.wxColour(238, 207, 161),
	["NavajoWhite3"]   = wx.wxColour(205, 179, 139),
	["NavajoWhite4"]   = wx.wxColour(139, 121, 94),
	["LemonChiffon1"]  = wx.wxColour(255, 250, 205),
	["LemonChiffon2"]  = wx.wxColour(238, 233, 191),
	["LemonChiffon3"]  = wx.wxColour(205, 201, 165),
	["LemonChiffon4"]  = wx.wxColour(139, 137, 112),
	["Cornsilk1"]      = wx.wxColour(255, 248, 220),
	["Cornsilk2"]      = wx.wxColour(238, 232, 205),
	["Cornsilk3"]      = wx.wxColour(205, 200, 177),
	["Cornsilk4"]      = wx.wxColour(139, 136, 120),
	["Ivory1"]         = wx.wxColour(255, 255, 240),
	["Ivory2"]         = wx.wxColour(238, 238, 224),
	["Ivory3"]         = wx.wxColour(205, 205, 193),
	["Ivory4"]         = wx.wxColour(139, 139, 131),
	["Honeydew1"]      = wx.wxColour(240, 255, 240),
	["Honeydew2"]      = wx.wxColour(224, 238, 224),
	["Honeydew3"]      = wx.wxColour(193, 205, 193),
	["Honeydew4"]      = wx.wxColour(131, 139, 131),
	["LavenderBlush1"] = wx.wxColour(255, 240, 245),
	["LavenderBlush2"] = wx.wxColour(238, 224, 229),
	["LavenderBlush3"] = wx.wxColour(205, 193, 197),
	["LavenderBlush4"] = wx.wxColour(139, 131, 134),
	["MistyRose1"]     = wx.wxColour(255, 228, 225),
	["MistyRose2"]     = wx.wxColour(238, 213, 210),
	["MistyRose3"]     = wx.wxColour(205, 183, 181),
	["MistyRose4"]     = wx.wxColour(139, 125, 123),
	["Azure1"]         = wx.wxColour(240, 255, 255),
	["Azure2"]         = wx.wxColour(224, 238, 238),
	["Azure3"]         = wx.wxColour(193, 205, 205),
	["Azure4"]         = wx.wxColour(131, 139, 139),
	["SlateBlue1"]     = wx.wxColour(131, 111, 255),
	["SlateBlue2"]     = wx.wxColour(122, 103, 238),
	["SlateBlue3"]     = wx.wxColour(105, 89, 205),
	["SlateBlue4"]     = wx.wxColour(71, 60, 139),
	["RoyalBlue1"]     = wx.wxColour(72, 118, 255),
	["RoyalBlue2"]     = wx.wxColour(67, 110, 238),
	["RoyalBlue3"]     = wx.wxColour(58, 95, 205),
	["RoyalBlue4"]     = wx.wxColour(39, 64, 139),
	["Blue1"]          = wx.wxColour(0, 0, 255),
	["Blue2"]          = wx.wxColour(0, 0, 238),
	["Blue3"]          = wx.wxColour(0, 0, 205),
	["Blue4"]          = wx.wxColour(0, 0, 139),
	["DodgerBlue1"]    = wx.wxColour(30, 144, 255),
	["DodgerBlue2"]    = wx.wxColour(28, 134, 238),
	["DodgerBlue3"]    = wx.wxColour(24, 116, 205),
	["DodgerBlue4"]    = wx.wxColour(16, 78, 139),
	["SteelBlue1"]     = wx.wxColour(99, 184, 255),
	["SteelBlue2"]     = wx.wxColour(92, 172, 238),
	["SteelBlue3"]     = wx.wxColour(79, 148, 205),
	["SteelBlue4"]     = wx.wxColour(54, 100, 139),
	["DeepSkyBlue1"]   = wx.wxColour(0, 191, 255),
	["DeepSkyBlue2"]   = wx.wxColour(0, 178, 238),
	["DeepSkyBlue3"]   = wx.wxColour(0, 154, 205),
	["DeepSkyBlue4"]   = wx.wxColour(0, 104, 139),
	["SkyBlue1"]       = wx.wxColour(135, 206, 255),
	["SkyBlue2"]       = wx.wxColour(126, 192, 238),
	["SkyBlue3"]       = wx.wxColour(108, 166, 205),
	["SkyBlue4"]       = wx.wxColour(74, 112, 139),
	["LightSkyBlue1"]  = wx.wxColour(176, 226, 255),
	["LightSkyBlue2"]  = wx.wxColour(164, 211, 238),
	["LightSkyBlue3"]  = wx.wxColour(141, 182, 205),
	["LightSkyBlue4"]  = wx.wxColour(96, 123, 139),
	["SlateGray1"]     = wx.wxColour(198, 226, 255),
	["SlateGray2"]     = wx.wxColour(185, 211, 238),
	["SlateGray3"]     = wx.wxColour(159, 182, 205),
	["SlateGray4"]     = wx.wxColour(108, 123, 139),
	["LightSteelBlue1"] = wx.wxColour(202, 225, 255),
	["LightSteelBlue2"] = wx.wxColour(188, 210, 238),
	["LightSteelBlue3"] = wx.wxColour(162, 181, 205),
	["LightSteelBlue4"] = wx.wxColour(110, 123, 139),
	["LightBlue1"]     = wx.wxColour(191, 239, 255),
	["LightBlue2"]     = wx.wxColour(178, 223, 238),
	["LightBlue3"]     = wx.wxColour(154, 192, 205),
	["LightBlue4"]     = wx.wxColour(104, 131, 139),
	["LightCyan1"]     = wx.wxColour(224, 255, 255),
	["LightCyan2"]     = wx.wxColour(209, 238, 238),
	["LightCyan3"]     = wx.wxColour(180, 205, 205),
	["LightCyan4"]     = wx.wxColour(122, 139, 139),
	["PaleTurquoise1"] = wx.wxColour(187, 255, 255),
	["PaleTurquoise2"] = wx.wxColour(174, 238, 238),
	["PaleTurquoise3"] = wx.wxColour(150, 205, 205),
	["PaleTurquoise4"] = wx.wxColour(102, 139, 139),
	["CadetBlue1"]     = wx.wxColour(152, 245, 255),
	["CadetBlue2"]     = wx.wxColour(142, 229, 238),
	["CadetBlue3"]     = wx.wxColour(122, 197, 205),
	["CadetBlue4"]     = wx.wxColour(83, 134, 139),
	["Turquoise1"]     = wx.wxColour(0, 245, 255),
	["Turquoise2"]     = wx.wxColour(0, 229, 238),
	["Turquoise3"]     = wx.wxColour(0, 197, 205),
	["Turquoise4"]     = wx.wxColour(0, 134, 139),
	["Cyan1"]          = wx.wxColour(0, 255, 255),
	["Cyan2"]          = wx.wxColour(0, 238, 238),
	["Cyan3"]          = wx.wxColour(0, 205, 205),
	["Cyan4"]          = wx.wxColour(0, 139, 139),
	["DarkSlateGray1"] = wx.wxColour(151, 255, 255),
	["DarkSlateGray2"] = wx.wxColour(141, 238, 238),
	["DarkSlateGray3"] = wx.wxColour(121, 205, 205),
	["DarkSlateGray4"] = wx.wxColour(82, 139, 139),
	["Aquamarine1"]    = wx.wxColour(127, 255, 212),
	["Aquamarine2"]    = wx.wxColour(118, 238, 198),
	["Aquamarine3"]    = wx.wxColour(102, 205, 170),
	["Aquamarine4"]    = wx.wxColour(69, 139, 116),
	["DarkSeaGreen1"]  = wx.wxColour(193, 255, 193),
	["DarkSeaGreen2"]  = wx.wxColour(180, 238, 180),
	["DarkSeaGreen3"]  = wx.wxColour(155, 205, 155),
	["DarkSeaGreen4"]  = wx.wxColour(105, 139, 105),
	["SeaGreen1"]      = wx.wxColour(84, 255, 159),
	["SeaGreen2"]      = wx.wxColour(78, 238, 148),
	["SeaGreen3"]      = wx.wxColour(67, 205, 128),
	["SeaGreen4"]      = wx.wxColour(46, 139, 87),
	["PaleGreen1"]     = wx.wxColour(154, 255, 154),
	["PaleGreen2"]     = wx.wxColour(144, 238, 144),
	["PaleGreen3"]     = wx.wxColour(124, 205, 124),
	["PaleGreen4"]     = wx.wxColour(84, 139, 84),
	["SpringGreen1"]   = wx.wxColour(0, 255, 127),
	["SpringGreen2"]   = wx.wxColour(0, 238, 118),
	["SpringGreen3"]   = wx.wxColour(0, 205, 102),
	["SpringGreen4"]   = wx.wxColour(0, 139, 69),
	["Green1"]         = wx.wxColour(0, 255, 0),
	["Green2"]         = wx.wxColour(0, 238, 0),
	["Green3"]         = wx.wxColour(0, 205, 0),
	["Green4"]         = wx.wxColour(0, 139, 0),
	["Chartreuse1"]    = wx.wxColour(127, 255, 0),
	["Chartreuse2"]    = wx.wxColour(118, 238, 0),
	["Chartreuse3"]    = wx.wxColour(102, 205, 0),
	["Chartreuse4"]    = wx.wxColour(69, 139, 0),
	["OliveDrab1"]     = wx.wxColour(192, 255, 62),
	["OliveDrab2"]     = wx.wxColour(179, 238, 58),
	["OliveDrab3"]     = wx.wxColour(154, 205, 50),
	["OliveDrab4"]     = wx.wxColour(105, 139, 34),
	["DarkOliveGreen1"] = wx.wxColour(202, 255, 112),
	["DarkOliveGreen2"] = wx.wxColour(188, 238, 104),
	["DarkOliveGreen3"] = wx.wxColour(162, 205, 90),
	["DarkOliveGreen4"] = wx.wxColour(110, 139, 61),
	["Khaki1"]         = wx.wxColour(255, 246, 143),
	["Khaki2"]         = wx.wxColour(238, 230, 133),
	["Khaki3"]         = wx.wxColour(205, 198, 115),
	["Khaki4"]         = wx.wxColour(139, 134, 78),
	["LightGoldenrod1"] = wx.wxColour(255, 236, 139),
	["LightGoldenrod2"] = wx.wxColour(238, 220, 130),
	["LightGoldenrod3"] = wx.wxColour(205, 190, 112),
	["LightGoldenrod4"] = wx.wxColour(139, 129, 76),
	["LightYellow1"]   = wx.wxColour(255, 255, 224),
	["LightYellow2"]   = wx.wxColour(238, 238, 209),
	["LightYellow3"]   = wx.wxColour(205, 205, 180),
	["LightYellow4"]   = wx.wxColour(139, 139, 122),
	["Yellow1"]        = wx.wxColour(255, 255, 0),
	["Yellow2"]        = wx.wxColour(238, 238, 0),
	["Yellow3"]        = wx.wxColour(205, 205, 0),
	["Yellow4"]        = wx.wxColour(139, 139, 0),
	["Gold1"]          = wx.wxColour(255, 215, 0),
	["Gold2"]          = wx.wxColour(238, 201, 0),
	["Gold3"]          = wx.wxColour(205, 173, 0),
	["Gold4"]          = wx.wxColour(139, 117, 0),
	["Goldenrod1"]     = wx.wxColour(255, 193, 37),
	["Goldenrod2"]     = wx.wxColour(238, 180, 34),
	["Goldenrod3"]     = wx.wxColour(205, 155, 29),
	["Goldenrod4"]     = wx.wxColour(139, 105, 20),
	["DarkGoldenrod1"] = wx.wxColour(255, 185, 15),
	["DarkGoldenrod2"] = wx.wxColour(238, 173, 14),
	["DarkGoldenrod3"] = wx.wxColour(205, 149, 12),
	["DarkGoldenrod4"] = wx.wxColour(139, 101, 8),
	["RosyBrown1"]     = wx.wxColour(255, 193, 193),
	["RosyBrown2"]     = wx.wxColour(238, 180, 180),
	["RosyBrown3"]     = wx.wxColour(205, 155, 155),
	["RosyBrown4"]     = wx.wxColour(139, 105, 105),
	["IndianRed1"]     = wx.wxColour(255, 106, 106),
	["IndianRed2"]     = wx.wxColour(238, 99, 99),
	["IndianRed3"]     = wx.wxColour(205, 85, 85),
	["IndianRed4"]     = wx.wxColour(139, 58, 58),
	["Sienna1"]        = wx.wxColour(255, 130, 71),
	["Sienna2"]        = wx.wxColour(238, 121, 66),
	["Sienna3"]        = wx.wxColour(205, 104, 57),
	["Sienna4"]        = wx.wxColour(139, 71, 38),
	["Burlywood1"]     = wx.wxColour(255, 211, 155),
	["Burlywood2"]     = wx.wxColour(238, 197, 145),
	["Burlywood3"]     = wx.wxColour(205, 170, 125),
	["Burlywood4"]     = wx.wxColour(139, 115, 85),
	["Wheat1"]         = wx.wxColour(255, 231, 186),
	["Wheat2"]         = wx.wxColour(238, 216, 174),
	["Wheat3"]         = wx.wxColour(205, 186, 150),
	["Wheat4"]         = wx.wxColour(139, 126, 102),
	["Tan1"]           = wx.wxColour(255, 165, 79),
	["Tan2"]           = wx.wxColour(238, 154, 73),
	["Tan3"]           = wx.wxColour(205, 133, 63),
	["Tan4"]           = wx.wxColour(139, 90, 43),
	["Chocolate1"]     = wx.wxColour(255, 127, 36),
	["Chocolate2"]     = wx.wxColour(238, 118, 33),
	["Chocolate3"]     = wx.wxColour(205, 102, 29),
	["Chocolate4"]     = wx.wxColour(139, 69, 19),
	["Firebrick1"]     = wx.wxColour(255, 48, 48),
	["Firebrick2"]     = wx.wxColour(238, 44, 44),
	["Firebrick3"]     = wx.wxColour(205, 38, 38),
	["Firebrick4"]     = wx.wxColour(139, 26, 26),
	["Brown1"]         = wx.wxColour(255, 64, 64),
	["Brown2"]         = wx.wxColour(238, 59, 59),
	["Brown3"]         = wx.wxColour(205, 51, 51),
	["Brown4"]         = wx.wxColour(139, 35, 35),
	["Salmon1"]        = wx.wxColour(255, 140, 105),
	["Salmon2"]        = wx.wxColour(238, 130, 98),
	["Salmon3"]        = wx.wxColour(205, 112, 84),
	["Salmon4"]        = wx.wxColour(139, 76, 57),
	["LightSalmon1"]   = wx.wxColour(255, 160, 122),
	["LightSalmon2"]   = wx.wxColour(238, 149, 114),
	["LightSalmon3"]   = wx.wxColour(205, 129, 98),
	["LightSalmon4"]   = wx.wxColour(139, 87, 66),
	["Orange1"]        = wx.wxColour(255, 165, 0),
	["Orange2"]        = wx.wxColour(238, 154, 0),
	["Orange3"]        = wx.wxColour(205, 133, 0),
	["Orange4"]        = wx.wxColour(139, 90, 0),
	["DarkOrange1"]    = wx.wxColour(255, 127, 0),
	["DarkOrange2"]    = wx.wxColour(238, 118, 0),
	["DarkOrange3"]    = wx.wxColour(205, 102, 0),
	["DarkOrange4"]    = wx.wxColour(139, 69, 0),
	["Coral1"]         = wx.wxColour(255, 114, 86),
	["Coral2"]         = wx.wxColour(238, 106, 80),
	["Coral3"]         = wx.wxColour(205, 91, 69),
	["Coral4"]         = wx.wxColour(139, 62, 47),
	["Tomato1"]        = wx.wxColour(255, 99, 71),
	["Tomato2"]        = wx.wxColour(238, 92, 66),
	["Tomato3"]        = wx.wxColour(205, 79, 57),
	["Tomato4"]        = wx.wxColour(139, 54, 38),
	["OrangeRed1"]     = wx.wxColour(255, 69, 0),
	["OrangeRed2"]     = wx.wxColour(238, 64, 0),
	["OrangeRed3"]     = wx.wxColour(205, 55, 0),
	["OrangeRed4"]     = wx.wxColour(139, 37, 0),
	["Red1"]           = wx.wxColour(255, 0, 0),
	["Red2"]           = wx.wxColour(238, 0, 0),
	["Red3"]           = wx.wxColour(205, 0, 0),
	["Red4"]           = wx.wxColour(139, 0, 0),
	["DeepPink1"]      = wx.wxColour(255, 20, 147),
	["DeepPink2"]      = wx.wxColour(238, 18, 137),
	["DeepPink3"]      = wx.wxColour(205, 16, 118),
	["DeepPink4"]      = wx.wxColour(139, 10, 80),
	["HotPink1"]       = wx.wxColour(255, 110, 180),
	["HotPink2"]       = wx.wxColour(238, 106, 167),
	["HotPink3"]       = wx.wxColour(205, 96, 144),
	["HotPink4"]       = wx.wxColour(139, 58, 98),
	["Pink1"]          = wx.wxColour(255, 181, 197),
	["Pink2"]          = wx.wxColour(238, 169, 184),
	["Pink3"]          = wx.wxColour(205, 145, 158),
	["Pink4"]          = wx.wxColour(139, 99, 108),
	["LightPink1"]     = wx.wxColour(255, 174, 185),
	["LightPink2"]     = wx.wxColour(238, 162, 173),
	["LightPink3"]     = wx.wxColour(205, 140, 149),
	["LightPink4"]     = wx.wxColour(139, 95, 101),
	["PaleVioletRed1"] = wx.wxColour(255, 130, 171),
	["PaleVioletRed2"] = wx.wxColour(238, 121, 159),
	["PaleVioletRed3"] = wx.wxColour(205, 104, 137),
	["PaleVioletRed4"] = wx.wxColour(139, 71, 93),
	["Maroon1"]        = wx.wxColour(255, 52, 179),
	["Maroon2"]        = wx.wxColour(238, 48, 167),
	["Maroon3"]        = wx.wxColour(205, 41, 144),
	["Maroon4"]        = wx.wxColour(139, 28, 98),
	["VioletRed1"]     = wx.wxColour(255, 62, 150),
	["VioletRed2"]     = wx.wxColour(238, 58, 140),
	["VioletRed3"]     = wx.wxColour(205, 50, 120),
	["VioletRed4"]     = wx.wxColour(139, 34, 82),
	["Magenta1"]       = wx.wxColour(255, 0, 255),
	["Magenta2"]       = wx.wxColour(238, 0, 238),
	["Magenta3"]       = wx.wxColour(205, 0, 205),
	["Magenta4"]       = wx.wxColour(139, 0, 139),
	["Orchid1"]        = wx.wxColour(255, 131, 250),
	["Orchid2"]        = wx.wxColour(238, 122, 233),
	["Orchid3"]        = wx.wxColour(205, 105, 201),
	["Orchid4"]        = wx.wxColour(139, 71, 137),
	["Plum1"]          = wx.wxColour(255, 187, 255),
	["Plum2"]          = wx.wxColour(238, 174, 238),
	["Plum3"]          = wx.wxColour(205, 150, 205),
	["Plum4"]          = wx.wxColour(139, 102, 139),
	["MediumOrchid1"]  = wx.wxColour(224, 102, 255),
	["MediumOrchid2"]  = wx.wxColour(209, 95, 238),
	["MediumOrchid3"]  = wx.wxColour(180, 82, 205),
	["MediumOrchid4"]  = wx.wxColour(122, 55, 139),
	["DarkOrchid1"]    = wx.wxColour(191, 62, 255),
	["DarkOrchid2"]    = wx.wxColour(178, 58, 238),
	["DarkOrchid3"]    = wx.wxColour(154, 50, 205),
	["DarkOrchid4"]    = wx.wxColour(104, 34, 139),
	["Purple1"]        = wx.wxColour(155, 48, 255),
	["Purple2"]        = wx.wxColour(145, 44, 238),
	["Purple3"]        = wx.wxColour(125, 38, 205),
	["Purple4"]        = wx.wxColour(85, 26, 139),
	["MediumPurple1"]  = wx.wxColour(171, 130, 255),
	["MediumPurple2"]  = wx.wxColour(159, 121, 238),
	["MediumPurple3"]  = wx.wxColour(137, 104, 205),
	["MediumPurple4"]  = wx.wxColour(93, 71, 139),
	["Thistle1"]       = wx.wxColour(255, 225, 255),
	["Thistle2"]       = wx.wxColour(238, 210, 238),
	["Thistle3"]       = wx.wxColour(205, 181, 205),
	["Thistle4"]       = wx.wxColour(139, 123, 139),
	["Gray0"]          = wx.wxColour(0, 0, 0),
	["Gray1"]          = wx.wxColour(3, 3, 3),
	["Gray2"]          = wx.wxColour(5, 5, 5),
	["Gray3"]          = wx.wxColour(8, 8, 8),
	["Gray4"]          = wx.wxColour(10, 10, 10),
	["Gray5"]          = wx.wxColour(13, 13, 13),
	["Gray6"]          = wx.wxColour(15, 15, 15),
	["Gray7"]          = wx.wxColour(18, 18, 18),
	["Gray8"]          = wx.wxColour(20, 20, 20),
	["Gray9"]          = wx.wxColour(23, 23, 23),
	["Gray10"]         = wx.wxColour(26, 26, 26),
	["Gray11"]         = wx.wxColour(28, 28, 28),
	["Gray12"]         = wx.wxColour(31, 31, 31),
	["Gray13"]         = wx.wxColour(33, 33, 33),
	["Gray14"]         = wx.wxColour(36, 36, 36),
	["Gray15"]         = wx.wxColour(38, 38, 38),
	["Gray16"]         = wx.wxColour(41, 41, 41),
	["Gray17"]         = wx.wxColour(43, 43, 43),
	["Gray18"]         = wx.wxColour(46, 46, 46),
	["Gray19"]         = wx.wxColour(48, 48, 48),
	["Gray20"]         = wx.wxColour(51, 51, 51),
	["Gray21"]         = wx.wxColour(54, 54, 54),
	["Gray22"]         = wx.wxColour(56, 56, 56),
	["Gray23"]         = wx.wxColour(59, 59, 59),
	["Gray24"]         = wx.wxColour(61, 61, 61),
	["Gray25"]         = wx.wxColour(64, 64, 64),
	["Gray26"]         = wx.wxColour(66, 66, 66),
	["Gray27"]         = wx.wxColour(69, 69, 69),
	["Gray28"]         = wx.wxColour(71, 71, 71),
	["Gray29"]         = wx.wxColour(74, 74, 74),
	["Gray30"]         = wx.wxColour(77, 77, 77),
	["Gray31"]         = wx.wxColour(79, 79, 79),
	["Gray32"]         = wx.wxColour(82, 82, 82),
	["Gray33"]         = wx.wxColour(84, 84, 84),
	["Gray34"]         = wx.wxColour(87, 87, 87),
	["Gray35"]         = wx.wxColour(89, 89, 89),
	["Gray36"]         = wx.wxColour(92, 92, 92),
	["Gray37"]         = wx.wxColour(94, 94, 94),
	["Gray38"]         = wx.wxColour(97, 97, 97),
	["Gray39"]         = wx.wxColour(99, 99, 99),
	["Gray40"]         = wx.wxColour(102, 102, 102),
	["Gray41"]         = wx.wxColour(105, 105, 105),
	["Gray42"]         = wx.wxColour(107, 107, 107),
	["Gray43"]         = wx.wxColour(110, 110, 110),
	["Gray44"]         = wx.wxColour(112, 112, 112),
	["Gray45"]         = wx.wxColour(115, 115, 115),
	["Gray46"]         = wx.wxColour(117, 117, 117),
	["Gray47"]         = wx.wxColour(120, 120, 120),
	["Gray48"]         = wx.wxColour(122, 122, 122),
	["Gray49"]         = wx.wxColour(125, 125, 125),
	["Gray50"]         = wx.wxColour(127, 127, 127),
	["Gray51"]         = wx.wxColour(130, 130, 130),
	["Gray52"]         = wx.wxColour(133, 133, 133),
	["Gray53"]         = wx.wxColour(135, 135, 135),
	["Gray54"]         = wx.wxColour(138, 138, 138),
	["Gray55"]         = wx.wxColour(140, 140, 140),
	["Gray56"]         = wx.wxColour(143, 143, 143),
	["Gray57"]         = wx.wxColour(145, 145, 145),
	["Gray58"]         = wx.wxColour(148, 148, 148),
	["Gray59"]         = wx.wxColour(150, 150, 150),
	["Gray60"]         = wx.wxColour(153, 153, 153),
	["Gray61"]         = wx.wxColour(156, 156, 156),
	["Gray62"]         = wx.wxColour(158, 158, 158),
	["Gray63"]         = wx.wxColour(161, 161, 161),
	["Gray64"]         = wx.wxColour(163, 163, 163),
	["Gray65"]         = wx.wxColour(166, 166, 166),
	["Gray66"]         = wx.wxColour(168, 168, 168),
	["Gray67"]         = wx.wxColour(171, 171, 171),
	["Gray68"]         = wx.wxColour(173, 173, 173),
	["Gray69"]         = wx.wxColour(176, 176, 176),
	["Gray70"]         = wx.wxColour(179, 179, 179),
	["Gray71"]         = wx.wxColour(181, 181, 181),
	["Gray72"]         = wx.wxColour(184, 184, 184),
	["Gray73"]         = wx.wxColour(186, 186, 186),
	["Gray74"]         = wx.wxColour(189, 189, 189),
	["Gray75"]         = wx.wxColour(191, 191, 191),
	["Gray76"]         = wx.wxColour(194, 194, 194),
	["Gray77"]         = wx.wxColour(196, 196, 196),
	["Gray78"]         = wx.wxColour(199, 199, 199),
	["Gray79"]         = wx.wxColour(201, 201, 201),
	["Gray80"]         = wx.wxColour(204, 204, 204),
	["Gray81"]         = wx.wxColour(207, 207, 207),
	["Gray82"]         = wx.wxColour(209, 209, 209),
	["Gray83"]         = wx.wxColour(212, 212, 212),
	["Gray84"]         = wx.wxColour(214, 214, 214),
	["Gray85"]         = wx.wxColour(217, 217, 217),
	["Gray86"]         = wx.wxColour(219, 219, 219),
	["Gray87"]         = wx.wxColour(222, 222, 222),
	["Gray88"]         = wx.wxColour(224, 224, 224),
	["Gray89"]         = wx.wxColour(227, 227, 227),
	["Gray90"]         = wx.wxColour(229, 229, 229),
	["Gray91"]         = wx.wxColour(232, 232, 232),
	["Gray92"]         = wx.wxColour(235, 235, 235),
	["Gray93"]         = wx.wxColour(237, 237, 237),
	["Gray94"]         = wx.wxColour(240, 240, 240),
	["Gray95"]         = wx.wxColour(242, 242, 242),
	["Gray96"]         = wx.wxColour(245, 245, 245),
	["Gray97"]         = wx.wxColour(247, 247, 247),
	["Gray98"]         = wx.wxColour(250, 250, 250),
	["Gray99"]         = wx.wxColour(252, 252, 252),
	["Gray100"]        = wx.wxColour(255, 255, 255),
}

-- ----------------------------------------------------------------------------
--
return wxX11Palette

-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
