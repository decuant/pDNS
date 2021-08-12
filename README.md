#  **pDNS**


## Polling DNS - rel. 0.0.6 (2021/08/12)


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

It runs a backtask on the main window timer and tests a batch of servers per tick. UDP is not supported by wxLua, the program uses ``luasocket`` (on Windows the required filename is ``socket.dll``). This program is not intended for speed benchmarking, but to question servers.

The pre-configured ``data/servers.lua`` is the servers' address list in Lua table format.

File ``data/samplehosts.lua`` holds a Lua table of __Hosts for Sampling__, assigned circularly to each new server, thus to make all servers target the same host provide only that name in the list. If the list is big scramble the servers' list, save and reload; this shuffles the host assigned to a server.

For the time being DNS servers are questioned only with a ``TYPE 1 <hostname>``. Response and analisys of the response are recorded in the log ``log/protocol.log``.

When purging servers note that a server with 2 addresses having different responding status is a logical failure.

The application does not enforce to save the servers' file if modified.

Whit the backtask enabled, if the application is idling then a scheduler timer is started. When the timer fires then the scheduling routine is called. In this implementation is hard coded.

File ``user.lua`` is a container for plugin functions, it can be modified and reloaded at run time.

The status bar shows counters for: Servers, Enabled, Responding, Not Responding (of which the first 2 are servers and the last 2 are addresses).

For both Filter and Find functions use ```;``` for multi-keys in logical OR (as ```(IT);(FR)```).

## Response


This is a typical response.


```
05196: ⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻
05197: Hostname: tineye.com
05198: 
05199: ----- [ Response frame ] -----
00000000  0B 52 81 80 00 01 00 03 00 02 00 0C 06 74 69 6E  .R.?.........tin
00000010  65 79 65 03 63 6F 6D 00 00 01 00 01 C0 0C 00 01  eye.com.....?...
00000020  00 01 00 00 01 2C 00 04 68 16 34 8E C0 0C 00 01  .....,..h.4??...
00000030  00 01 00 00 01 2C 00 04 68 16 35 8E C0 0C 00 01  .....,..h.5??...
00000040  00 01 00 00 01 2C 00 04 AC 43 15 EE C0 0C 00 02  .....,..?C.?...
00000050  00 01 00 00 A3 43 00 15 04 65 6D 6D 61 02 6E 73  ....?C...emma.ns
00000060  0A 63 6C 6F 75 64 66 6C 61 72 65 C0 13 C0 0C 00  .cloudflare?.?..
00000070  02 00 01 00 00 A3 43 00 06 03 73 69 64 C0 5D C0  .....?C...sid?]?
00000080  79 00 01 00 01 00 00 F4 E9 00 04 AC 40 21 8F C0  y......?..?@!.?
00000090  79 00 01 00 01 00 00 F4 E9 00 04 AD F5 3B 8F C0  y......?...?;.?
000000A0  79 00 01 00 01 00 00 F4 E9 00 04 6C A2 C1 8F C0  y......?..l??.?
000000B0  58 00 01 00 01 00 01 14 19 00 04 AC 40 20 70 C0  X..........?@ p?
000000C0  58 00 01 00 01 00 01 14 19 00 04 AD F5 3A 70 C0  X...........?:p?
000000D0  58 00 01 00 01 00 01 14 19 00 04 6C A2 C0 70 C0  X..........l??p?
000000E0  79 00 1C 00 01 00 01 19 C4 00 10 2A 06 98 C1 00  y.......?..*.??.
000000F0  50 00 00 00 00 00 00 AC 40 21 8F C0 79 00 1C 00  P......?@!.?y...
00000100  01 00 01 19 C4 00 10 26 06 47 00 00 58 00 00 00  ....?..&.G..X...
00000110  00 00 00 AD F5 3B 8F C0 79 00 1C 00 01 00 01 19  ....?;.?y.......
00000120  C4 00 10 28 03 F8 00 00 50 00 00 00 00 00 00 6C  ?..(.?..P......l
00000130  A2 C1 8F C0 58 00 1C 00 01 00 01 47 0A 00 10 28  ??.?X......G...(
00000140  03 F8 00 00 50 00 00 00 00 00 00 6C A2 C0 70 C0  .?..P......l??p?
00000150  58 00 1C 00 01 00 01 47 0A 00 10 2A 06 98 C1 00  X......G...*.??.
00000160  50 00 00 00 00 00 00 AC 40 20 70 C0 58 00 1C 00  P......?@ p?X...
00000170  01 00 01 47 0A 00 10 26 06 47 00 00 50 00 00 00  ...G...&.G..P...
00000180  00 00 00 AD F5 3A 70                             ....?:p
05200: 
05201: ⭆ Message Header:
05202: 
05203: Recursion desired           = 1
05204: Truncation flag             = 0
05205: Authoritative answer flag   = 0
05206: Opcode                      = 0
05207: Query/Response flag         = 1
05208: Return code                 = 0
05209: Recursion available         = 1
05210: Questions count             = 1
05211: Answers count               = 3
05212: Authoritative servers count = 2
05213: Additional records count    = 12
05214: URL requested               = tineye.com
05215: Type of query    (req)      = 1
05216: Class (protocol) (req)      = 1
05217: 
05218: ⭆ Answers:
05219: 
05220: Pointer value               = 0x0c
05221: Type of query    (ans)      = 1
05222: Class (protocol) (ans)      = 1
05223: Time to live                = 300
05224: Record lenght               = 4
05225: Assigned Ip address         = 104.22.52.142
05226: 
05227: Pointer value               = 0x0c
05228: Type of query    (ans)      = 1
05229: Class (protocol) (ans)      = 1
05230: Time to live                = 300
05231: Record lenght               = 4
05232: Assigned Ip address         = 104.22.53.142
05233: 
05234: Pointer value               = 0x0c
05235: Type of query    (ans)      = 1
05236: Class (protocol) (ans)      = 1
05237: Time to live                = 300
05238: Record lenght               = 4
05239: Assigned Ip address         = 172.67.21.238
05240: 
05241: 
05242: ⭆ Authoritatives:
05243: 
05244: Pointer value               = 0x0c
05245: Type of query    (ans)      = 2
05246: Class (protocol) (ans)      = 1
05247: Time to live                = 41795
05248: Record lenght               = 21
05249: Alias                       = emma.ns.cloudflare.com
05250: 
05251: Pointer value               = 0x0c
05252: Type of query    (ans)      = 2
05253: Class (protocol) (ans)      = 1
05254: Time to live                = 41795
05255: Record lenght               = 6
05256: Alias                       = sid.ns.cloudflare.com
```


The server replied at the specified ip address, but the reply is a DNS error code.

```
01930: ℹ Return code failure: The specified name does not exist in the domain
01943: ℹ Return code failure: The server has failed internally
02543: ℹ Return code failure: For policy the server refused to answer
```



## Hits & Failures counters


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

The third address looks a bluff. The fourth useless.

```
	["hostwinds.com"] =
	{
		["104.18.16.143"]   = 590,
		["104.18.17.143"]   = 590,
		["162.241.226.169"] = 1,
		["127.0.0.1"]       = 1,
	},
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


### Rel. 0.0.6


- Modified sorting to use the IP4 address as number, not text.
- Added scheduler to repeat a task when in idle and after timer.
- Added menu entry to assign random hosts to servers.

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


