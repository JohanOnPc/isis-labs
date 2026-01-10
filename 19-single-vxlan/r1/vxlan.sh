#!/bin/bash

ip link add br100 type bridge
ip link add vxlan100 type vxlan id 100 local 10.0.0.1 dstport 4789
ip link set vxlan100 master br100
ip link set eth2 master br100
ip link set br100 up
ip link set vxlan100 up

bridge fdb append 00:00:00:00:00:00 dev vxlan100 dst 10.0.0.3