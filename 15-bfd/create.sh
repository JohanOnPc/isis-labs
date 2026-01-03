#!/bin/bash

sudo ip link add br0 type bridge
sudo ip link set br0 up

sudo ip address add 10.0.0.4/32 dev br0
sudo ip -6 address add 2001:db8:cafe:4::1/64 dev br0