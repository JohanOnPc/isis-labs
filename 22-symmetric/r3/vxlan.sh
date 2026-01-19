#!/bin/bash

#vrf blue
ip link add vrf-blue type vrf table 1000
ip link set vrf-blue up

ip link add vxlan1000 type vxlan id 1000 local 10.0.0.3 dstport 4789 nolearning
ip link set vxlan1000 addr aa:bb:cc:dd:ee:03
ip link set vxlan1000 master vrf-blue addrgenmode none
ip link set vxlan1000 up
ip link set eth2 master vrf-blue

ip route add 172.16.2.0/24 via 10.0.0.2 dev vxlan1000 onlink vrf vrf-blue
ip route add 172.16.4.0/24 via 10.0.0.4 dev vxlan1000 onlink vrf vrf-blue

ip neigh add 10.0.0.2 lladdr aa:bb:cc:dd:ee:02 dev vxlan1000 nud noarp extern_learn
ip neigh add 10.0.0.4 lladdr aa:bb:cc:dd:ee:04 dev vxlan1000 nud noarp extern_learn

bridge fdb add aa:bb:cc:dd:ee:02 dev vxlan1000 dst 10.0.0.2 self extern_learn
bridge fdb add aa:bb:cc:dd:ee:04 dev vxlan1000 dst 10.0.0.4 self extern_learn

#vrf red
ip link add vrf-red type vrf table 1100
ip link set vrf-red up

#L2VNI
ip link add br100 type bridge
ip address add dev br100 192.168.3.1/24
ip link set br100 master vrf-red addrgenmode none
ip link set br100 addr aa:bb:cc:dd:03:01
ip link add vxlan100 type vxlan id 100 local 10.0.0.3 dstport 4789
ip link set vxlan100 master br100 addrgenmode none
ip link set eth3 master br100
ip link set br100 up
ip link set vxlan100 up

bridge fdb add 00:00:00:00:00:00 dev vxlan100 dst 10.0.0.4 self extern_learn

#L3VNI
ip link add vxlan1100 type vxlan id 1100 local 10.0.0.3 dstport 4789 nolearning
ip link set vxlan1100 addr aa:bb:cc:dd:ee:03
ip link set vxlan1100 master vrf-red addrgenmode none
ip link set vxlan1100 up

#Type 5 evpn prefix route equivalent
ip route add 192.168.2.0/24 via 10.0.0.2 dev vxlan1100 onlink vrf vrf-red

ip neigh add 10.0.0.2 lladdr aa:bb:cc:dd:ee:02 dev vxlan1100 nud noarp extern_learn

bridge fdb add aa:bb:cc:dd:ee:02 dev vxlan1100 dst 10.0.0.2 self extern_learn