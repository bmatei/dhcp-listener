#!/usr/bin/env bats

@test "TCP Host IP filter test" {
	[ "$(echo "$DNSMASQ_RESP_TCPDUMP" | host_ip_filter)" \
		= "test_data.hostname 192.168.111.8" ]
	 [ "$(echo "$DIGI_WIFI6_RESP_TCPDUMP" | host_ip_filter)" \
		= "test2 192.168.1.254" ]
}

setup()
{
	PATH=./bin/src:$PATH
	source lib/src/dhcp_listener_func.sh
}

DIGI_WIFI6_RESP_TCPDUMP='
19:20:21.881446 IP (tos 0x10, ttl 128, id 0, offset 0, flags [none], proto UDP (17), length 328)
    0.0.0.0.68 > 255.255.255.255.67: [udp sum ok] BOOTP/DHCP, Request from 00:23:5a:0e:ad:ed, length 300, xid 0xc3a3215b, Flags [none] (0x0000)
	  Client-Ethernet-Address 00:23:5a:0e:ad:ed
	  Vendor-rfc1048 Extensions
	    Magic Cookie 0x63825363
	    DHCP-Message (53), length 1: Request
	    Requested-IP (50), length 4: 192.168.1.254
	    Hostname (12), length 5: "test2"
	    Parameter-Request (55), length 13: 
	      Subnet-Mask (1), BR (28), Time-Zone (2), Default-Gateway (3)
	      Domain-Name (15), Domain-Name-Server (6), Unknown (119), Hostname (12)
	      Netbios-Name-Server (44), Netbios-Scope (47), MTU (26), Classless-Static-Route (121)
	      NTP (42)
	    END (255), length 0
	    PAD (0), length 0, occurs 28
'

DNSMASQ_RESP_TCPDUMP='
19:13:05.385765 IP (tos 0x10, ttl 128, id 0, offset 0, flags [none], proto UDP (17), length 328)
    0.0.0.0.68 > 255.255.255.255.67: [udp sum ok] BOOTP/DHCP, Request from 00:16:3e:03:4a:8c, length 300, xid 0xf4bed64a, Flags [none] (0x0000)
	  Client-Ethernet-Address 00:16:3e:03:4a:8c
	  Vendor-rfc1048 Extensions
	    Magic Cookie 0x63825363
	    DHCP-Message Option 53, length 1: Request
	    Requested-IP Option 50, length 4: 192.168.111.8
	    Hostname Option 12, length 11: "test_data.hostname"
	    Parameter-Request Option 55, length 13: 
	      Subnet-Mask, BR, Time-Zone, Default-Gateway
	      Domain-Name, Domain-Name-Server, Option 119, Hostname
	      Netbios-Name-Server, Netbios-Scope, MTU, Classless-Static-Route
	      NTP
	    END Option 255, length 0
	    PAD Option 0, length 0, occurs 22
19:13:05.387351 IP (tos 0x0, ttl 64, id 0, offset 0, flags [none], proto UDP (17), length 576)
    192.168.110.1.67 > 192.168.111.8.68: [udp sum ok] BOOTP/DHCP, Reply, length 548, xid 0xf4bed64a, Flags [none] (0x0000)
	  Your-IP 192.168.111.8
	  Server-IP 192.168.1.1
	  Client-Ethernet-Address 00:16:3e:03:4a:8c
	  Vendor-rfc1048 Extensions
	    Magic Cookie 0x63825363
	    DHCP-Message Option 53, length 1: ACK
	    Server-ID Option 54, length 4: 192.168.110.1
	    Lease-Time Option 51, length 4: 86400
	    Subnet-Mask Option 1, length 4: 255.255.254.0
	    Default-Gateway Option 3, length 4: 192.168.110.1
	    Domain-Name-Server Option 6, length 8: 192.168.110.6,192.168.110.1
	    Domain-Name Option 15, length 5: "local"
	    END Option 255, length 0
	    PAD Option 0, length 0, occurs 263
'
