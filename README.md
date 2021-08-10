#  **pDNS**


## Polling DNS - rel. 0.0.5 (2021/08/01)


A list of DNS servers is presented to the user. Each server can be enabled or disabled. Running the backtask, enabled servers will be questioned about a URL. Response is in the log file.

The application runs with ```Lua 5.4.3```, ```wxWidgets 3.1.5```, ```wxLua 3.1.0.0``` and ```luasocket 3.0-rc1```.

Log files use some UTF8 characters.



## Modules



### .1 **convert.lua**


Download ```nameservers.csv``` from https://public-dns.info/.

Run this script to have the csv file converted to a Lua table, which can be the new servers' list.

A list of country codes, grouped by continent, can be used to filter out rows of no interest.

There's no settings file.



### .2 **main.lua**


Starting the application with the predefined file.

![Main dialog inactive](/docs/Main_Dialog1.png)

Starting the backtask to poll each enabled server.

![Main dialog active](/docs/Main_Dialog2.png)

It runs a backtask on the main window timer and tests a batch of servers per tick. Beside recommendations DNS servers work with UDP and as it is not supported by wxLua, the program uses ``luasocket`` (on Windows the required filename is ``socket.dll``). Other concurrent implementations are not advisable. This program is not intended for speed benchmarking, but to question servers.

The pre-configured ``data/servers.lua`` is the servers' address list in Lua table format.

File ``data/samplehosts.lua`` holds a Lua table of __Hosts for Sampling__, assigned circularly to each new server, thus to make all servers target the same host provide only that name in the list. If the list is big scramble the servers' list, save and reload; this shuffles the host assigned to a server.

For the time being DNS servers are questioned only with a ``TYPE 1 <hostname>``. Response and analisys of the response are recorded in the log ``log/protocol.log``.

When purging servers note that a server with 2 addresses having different responding status is a logical failure.

At file load time a filter is applied, it will blank addresses that are found too often in the failing servers' list. Theresold is fixed in code. Failures are consecutive, a success will reset the server's address status. Polling servers often will automatically let have a purified list of servers that are almost always responding.

The application does not enforce to save the file if modified.

File ``user.lua`` is a container for plugin functions, it can be modified and reloaded at run time.

The status bar shows counters for: Servers, Enabled, Responding, Not Responding (of which the first 2 are servers and the last 2 are addresses).

For both Filter and Find functions use ```;``` for multi-keys in logical OR (as ```(IT);(FR)```).

## Response


This is a typical response.

```

05815: ----- [ Response 2983 ] -----
00000000  0B A7 81 80 00 01 00 03 00 00 00 00 0A 73 61 74  .?.?.........sat
00000010  65 6C 6C 69 74 65 73 03 70 72 6F 00 00 01 00 01  ellites.pro.....
00000020  C0 0C 00 01 00 01 00 00 01 2C 00 04 68 1A 03 0E  ?........,..h...
00000030  C0 0C 00 01 00 01 00 00 01 2C 00 04 AC 43 44 B4  ?........,..?CD?
00000040  C0 0C 00 01 00 01 00 00 01 2C 00 04 68 1A 02 0E  ?........,..h...
05816: Recursion desired           = 1
05817: Truncation flag             = 0
05818: Authoritative answer flag   = 0
05819: Opcode                      = 0
05820: Query/Response flag         = 1
05821: Return code                 = 0
05822: Recursion available         = 1
05823: Questions count             = 1
05824: Answers count               = 3
05825: Authoritative servers count = 0
05826: Additional records count    = 0
05827: URL requested               = satellites.pro
05828: Type of query    (req)      = 1
05829: Class (protocol) (req)      = 1
05830: 
05831: Pointer value               = 0x0c
05832: Type of query    (ans)      = 1
05833: Class (protocol) (ans)      = 1
05834: Time to live                = 300
05835: Record lenght               = 4
05836: Assigned Ip address         = 104.26.3.14
05837: Pointer value               = 0x0c
05838: Type of query    (ans)      = 1
05839: Class (protocol) (ans)      = 1
05840: Time to live                = 300
05841: Record lenght               = 4
05842: Assigned Ip address         = 172.67.68.180
05843: Pointer value               = 0x0c
05844: Type of query    (ans)      = 1
05845: Class (protocol) (ans)      = 1
05846: Time to live                = 300
05847: Record lenght               = 4
05848: Assigned Ip address         = 104.26.2.14
05849: 
```

Some replies might have more information.

```
02371: Questions count             = 1
02372: Answers count               = 4
02373: Authoritative servers count = 4
02374: Additional records count    = 4
02375: URL requested               = time.com
```

The server replied at the specified ip address, but the reply is a DNS error code.

```
01930: ℹ Return code failure: The specified name does not exist in the domain
01943: ℹ Return code failure: The server has failed internally
02543: ℹ Return code failure: For policy the server refused to answer
```



## Hit Test


A basic count of ip address hits is enabled in code at the protocol level. It is dumped into the ``data`` folder and can grow big. Some hosts never change ip address, while others change it every few seconds.

This is an example.

```
local _hittable =
{

	["www.wordreference.com"] =
	{
		["138.201.122.174"] = 12,
		["23.111.171.90"]   = 3,
		["195.201.57.207"]  = 8,
	},

	["fixounet.free.fr"] =
	{
		["212.27.63.105"]   = 29,
	},

	["news.ycombinator.com"] =
	{
		["209.216.230.240"] = 17,
	},

	["observablehq.com"] =
	{
		["104.22.20.220"]   = 22,
		["172.67.37.221"]   = 22,
		["104.22.21.220"]   = 22,
	},

	["www.opensubtitles.org"] =
	{
		["104.26.8.126"]    = 18,
		["172.67.72.143"]   = 18,
		["104.26.9.126"]    = 18,
	},

	["www.barbarianfc.co.uk"] =
	{
		["52.17.214.161"]   = 4,
	},

	...
```

A similar list traces the number of times a server' s address has failed responding. This file is used at start up to blank addresses in the servers' list.

This is an example.

```
local _hittable =
{

	["JSC Kazakhtelecom - Almaty (KZ)"] =
	{
		["92.46.44.18"]     = 5,
		["178.88.161.200"]  = 5,
	},

	["Evolutio Cloud Enabler S.A. Unipersonal -  (ES)"] =
	{
		["212.66.160.2"]    = 9,
		["212.163.193.3"]   = 9,
	},

	["Regional TeleSystems Ltd. - Ryazan (RU)"] =
	{
		["193.9.242.78"]    = 15,
		["193.9.240.62"]    = 15,
	},

```


## List of changes


### Rel. 0.0.5

- Flush all open log streams at close.
- Protocol parsing at authoritatives.
- Added sorting by column.
- Call convert.lua to make a fresh servers' list in user menu.
- Save last used find/filter text in .ini file.
- Reworked the menus.
- Added filter/find text function.
- Filter servers' list using the failing list.
- Dump list of failing servers' addresses (with enable/disable).
- Dump protocol statistics (with enable/disable).
- Added extra check in convert.lua.
- Added counters in the status bar.
- Load set of functions in external file as menu.
- Fuzzy toggle the enable flag for each server in list.
- Scramble servers' list.
- Minimized grid resfresh calls.


### Rel. 0.0.4


- Test for valid IP4 address.
- Modified the window's ini file to support control over the font to use.
- Added deletion of selected servers.
- Added possibility to purge from the servers' list either the verified or the failing ones.


## Author

decuant


## License

The standard MIT license applies.


