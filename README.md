#  **pDNS**

## Polling DNS - rel. 0.0.4 (2021/07/23)

A list of DNS servers is presented to the user. For each server an enable/disable flag controls if processing is due.
Upon running the main backtask, each (enabled) server will be questioned about a URL. Response is in the log file.

The application currently uses ```Lua 5.4.2```, ```wxWidgets 3.1.4```, ```wxLua 3.1.0.0``` and ```luasocket 3.0-rc1```.

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

## List of changes

### Rel. 0.0.4

- Test for valid IP4 address.
- Modified the window's ini file to support control over the font to use.
- Added deletion of selected servers.
- Added possibility to purge from the servers' list either the verified or the failing ones.


## Author

The author can be reached at decuant@gmail.com


## License

The standard MIT license applies.


