# stalker-middleware catch up server

This script will check if the proccess for recording channel is running and if current file exists. 

You have to specify the list of multicast IP addresses and the ID for each channel in ch_list.txt. The format of the file must be:

[ip address] [channel_id]

for example: 

224.21.21.70 76

After you create ch_list.txt.

In my case the file ch_list.txt is located in /cs/, if you decide to place it in another directory, please modify the scirpt.
