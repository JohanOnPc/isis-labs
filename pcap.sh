#!/bin/bash

if [[ "$#" -eq 2 ]]
then
    sudo ip netns exec $1 tcpdump -U -nni $2 -w - | /mnt/c/Program\ Files/Wireshark/Wireshark.exe -k -i -
else
    echo "Please execute this command as: pcap.sh <container> <interface>"
fi