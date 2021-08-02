#  **pDNS**

## Polling DNS - rel. 0.0.5 (2021/08/01)

A list of DNS servers is presented to the user. For each server an enable/disable flag controls if processing is due.
Upon running the main backtask, each (enabled) server will be questioned about a URL. Response is in the log file.

The application currently uses ```Lua 5.4.3```, ```wxWidgets 3.1.5```, ```wxLua 3.1.0.0``` and ```luasocket 3.0-rc1```.

## Modules


### .1 **convert.lua**

Download ```nameservers.csv``` from https://public-dns.info/.

Run this script to have the csv file converted to a Lua table, which can be the new servers' list.

There's no settings file, since the script is truly little, thus modify the source to suit your needs.

A list of country codes, divided by continent, can be used to filter out rows of no interest.


### .2 **main.lua**

After loading a test file.

![Main dialog inactive](/docs/Main_Dialog1.png)

After testing some servers.

![Main dialog active](/docs/Main_Dialog2.png)

This program is not intended for speed benchmarcking, but rather to question servers.

Eventually, load all names servers and enable each in list, then enable the backtask and cycle 3 or 4 times the sequence:
``purge the failing servers and reset the completion status`` will give you a list of trustful servers.

File ``user.lua`` is a container for plugin functions, it can be modified and reloaded at run time.

File ``data/samplehosts.lua`` holds a table of sample hosts that are assigned circularly to each new server, thus to make all servers target the same host just provide only that name in the list.

For the time being DNS servers are questioned only with a TYPE 1 <<hostname>>. Response and analisys of the response are recorded in the log ``log/protocol.log``.

The status bar shows counters for: Total Servers, Enabled Servers, Responding Addresses, Not Responding Addresses.

When purging servers, a server with 2 addresses, of which 1 is not responding, will be removed, either way.


## List of changes

### Rel. 0.0.5

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

The author can be reached at decuant@gmail.com


## License

The standard MIT license applies.


