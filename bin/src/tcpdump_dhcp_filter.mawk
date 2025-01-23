#!/usr/bin/mawk -f

BEGIN {
	active=0
}

/DHCP-Message Option 53, length 1: Request|DHCP-Message \(53\), length 1: Request/ {
	active=1
}

/Requested-IP/{
	requested_ip=$NF
}
/Hostname Option|Hostname \(12\),/ {
	hostname=$NF
	gsub("\"","", hostname)
	gsub("\^@", "", hostname)
}
/Option 255|END \(255\)/ {
	if(active == 0) {
		next
	}
	active=0
	print hostname" "requested_ip
}

