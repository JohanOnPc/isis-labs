#!/bin/bash

ip link add vrf-tenant type vrf table 1000
ip link set vrf-tenant up

ip link add br-red type bridge
ip address add dev br-red 172.16.10.2/24
ip link set br-red master vrf-tenant
ip link add vxlan10010 type vxlan id 10010 local 10.0.0.3 dstport 4789
ip link set vxlan10010 master br-red
ip link set eth2 master br-red
ip link set br-red up
ip link set vxlan10010 up

ip link add br-blue type bridge
ip address add dev br-blue 172.16.11.2/24
ip link set br-blue master vrf-tenant
ip link add vxlan10011 type vxlan id 10011 local 10.0.0.3 dstport 4789
ip link set vxlan10011 master br-blue
ip link set eth3 master br-blue
ip link set br-blue up
ip link set vxlan10011 up

bridge fdb append 00:00:00:00:00:00 dev vxlan10010 dst 10.0.0.1
bridge fdb append 00:00:00:00:00:00 dev vxlan10011 dst 10.0.0.1