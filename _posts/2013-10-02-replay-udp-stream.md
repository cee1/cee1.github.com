---
layout: post
title: "重放pcap捕捉的udp流"
description: "Wireshark等捕获的流，进行重放，从而分析流的类型。此处的情景主要为分析某UDP流"
category: "Templates"
tags: tcpreplay pcap wireshark
---
{% include JB/setup %}

# 问题情景
使用wireshark捕获了含有某UDP流的抓包数据。现在需要：

1. 分离出此UDP流
2. 在新网络中的节点间重放

从而分析UDP流的状况

# 步骤
**分离UDP流**

在wireshark中输入合适的过滤器，例如"udp.src_port==<port>"，选择“Export specified Packets”，选择“Displayed”，然后保存。假设保存为stage1.pcap。

**改写MAC地址**

将源MAC地址改为XX:XX:XX:XX:XX:XX，目标MAC地址改为NN:NN:NN:NN:NN:NN

`tcprewrite --enet-dmac=NN:NN:NN:NN:NN:NN --enet-smac=XX:XX:XX:XX:XX:XX --infile=stage1.pcap --outfile=stage2.pcap`

**改写IP地址**

首先要生成cache文件，tcpprep主要用来分离服务端和客户端的流，但此处纯粹是为了后面命令的必要性：

`tcpprep -p -i stage2.pcap -o tmp.cache`

然后改写IP地址：

`tcprewrite --endpoints=<dest_ip>:<src_ip> --cachefile=tmp.cache --infile=stage2.pcap --outfile=stage3.pcap`

**重放UDP流**

`tcpreplay --intf1=<interface> stage3.pcap`

这里<interface>可以是eth0, wlan0...
