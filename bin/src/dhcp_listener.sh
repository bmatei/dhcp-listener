#!/bin/bash

INSTALL_PATH=${INSTALL_PATH:-/usr}

. $INSTALL_PATH/lib/dhcp_listener_func.sh
. $INSTALL_PATH/lib/event_handler.sh

DB="$INSTALL_PATH/share/dhcp_listener/subscribers"
IFACE=${IFACE:-$(find_iface)}

if [ -z "$1" ]; then
	dhcp_data | host_ip_filter | event_handler "$DB"
	exit
fi

case "$1" in
	-s|--subscribe)
		subscribe "$2" "$DB"
	;;
	-u|--unsubscribe)
		unsubscribe "$2" "$DB"
	;;
esac
