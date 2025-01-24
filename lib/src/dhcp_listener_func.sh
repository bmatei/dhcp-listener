#!/bin/bash

find_iface() {
	ip a | grep "inet " -B 3 |\
		awk '/^[0-9][0-9]*:/ {print $2}' |\
		sed -e 's/://' -e 's/@.*$//' |\
		grep -v "^lo$" | head -n 1
}

dhcp_data() {
	unbuffer tcpdump -ni "$IFACE" -vvv 'udp port 67 or udp port 68'
}

host_ip_filter() {
	tcpdump_dhcp_filter.mawk -Winteractive
}
