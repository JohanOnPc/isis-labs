#!/bin/bash

ip link add vrf-blue type vrf table 1000
ip link set vrf-blue up

ip link add vxlan1000 type vxlan id 1000 local 10.0.0.4 dstport 4789 nolearning
ip link set vxlan1000 addr aa:bb:cc:dd:ee:04
ip link set vxlan1000 master vrf-blue addrgenmode none
ip link set vxlan1000 up
ip link set eth2 master vrf-blue

ip route add 172.16.2.0/24 via 10.0.0.2 dev vxlan1000 onlink vrf vrf-blue
ip route add 172.16.3.0/24 via 10.0.0.3 dev vxlan1000 onlink vrf vrf-blue

ip neigh add 10.0.0.2 lladdr aa:bb:cc:dd:ee:02 dev vxlan1000 nud noarp extern_learn
ip neigh add 10.0.0.3 lladdr aa:bb:cc:dd:ee:03 dev vxlan1000 nud noarp extern_learn

bridge fdb add aa:bb:cc:dd:ee:02 dev vxlan1000 dst 10.0.0.2 self extern_learn
bridge fdb add aa:bb:cc:dd:ee:03 dev vxlan1000 dst 10.0.0.3 self extern_learn