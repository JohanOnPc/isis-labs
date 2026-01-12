#!/bin/bash

ip link add br-red type bridge
ip link add vxlan1000 type vxlan id 1000 local 10.0.0.2 dstport 4789
ip link set vxlan1000 master br-red
ip link set eth3 master br-red
ip link set br-red up
ip link set vxlan1000 up

ip link add br-blue type bridge
ip link add vxlan1001 type vxlan id 1001 local 10.0.0.2 dstport 4789
ip link set vxlan1001 master br-blue
ip link set eth4 master br-blue
ip link set br-blue up
ip link set vxlan1001 up

bridge fdb append 00:00:00:00:00:00 dev vxlan1000 dst 10.0.0.1
bridge fdb append 00:00:00:00:00:00 dev vxlan1000 dst 10.0.0.3
bridge fdb append 00:00:00:00:00:00 dev vxlan1001 dst 10.0.0.1