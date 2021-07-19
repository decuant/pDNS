#  **pDNS**

## Project description - rel. 0.0.3 (2021/07/19)

A list of DNS servers is presented to the user. For each server an enable/disable flag controls if processing is due.
Upon running the main backtask, each (enabled) server will be questioned about a URL. Response is in the log file.



## Modules


# .1 **convert.lua**

Download ```nameservers.csv``` from https://public-dns.info/.

Run this script to have the csv file converted to a Lua table, which can be the new servers' list.


# .2 **main.lua**

![Main dialog inactive](/docs/Main_Dialog1.png)


## Author

The author can be reached at decuant@gmail.com


## License

The standard MIT license applies.
