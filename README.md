## Description
`dhcp-listener` is a small collection of shell scripts based on tcpdump that is intended to run as daemon and notifies other software about IP allocated by DHCP events.

It maintains a list of `subscribers` in `/usr/share/dhcp_listener/subscribers` one per line. Each subscriber is an executable that can be found in `$PATH` and will be called with two positional params:
1. The Host of the machine that requested the IP address
2. The IP address that was just allocated

Example: `subscribed-cli nginx-proxy 192.168.1.15`

An example in the wild can be seen here: https://github.com/bmatei/internal-dns/blob/main/src/new_dhcp_event_cb.sh

If you have any questions feel free to ping me at busui.matei1994@gmail.com

## Build dependencies:
 * bats (https://github.com/bats-core)
 * build-rules (https://github.com/bmatei/build_rules)
