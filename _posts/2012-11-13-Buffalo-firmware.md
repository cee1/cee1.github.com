---
layout: post
title: "WZR-HP-G450H固件更新从OpenWrt到DDWrt"
description: "Buffalo WZR-HP-G450H固件更新，提供了从原厂固件到OpenWrt的方法，提供了从OpenWrt到DDWrt的方法，并提供解密固件的下载" 
category: "无线相关"
tags: [无线路由, OpenWrt, DDWrt]
---
{% include JB/setup %}

# 这篇文章诞生的理由 #

我们不能简单的一句“存在即是合理”来敷衍。因为很多时候我们通过Google找到的资料，没法解决问题，所以说制造网路垃圾就是在浪费别人的时间。这篇文章的目地就是避免其他人走弯路，从这个方面说应该还是有存在的理由。

在学习无线相关的东西的时候，将Buffalo WZR-HP-G450H这款无线路由器的固件烧为OpenWrt。弄完后，准备恢复到原厂固件时。傻眼了，不能直接通过WEB界面恢复回去了。在网络上搜了很多资料，折腾了两天才搞好!

# 从原厂固件到OpenWrt #

刷OpenWrt的时候是通过tftp进行烧写的。步骤也写在这里吧，虽然网上也能直接查到

环境为一台无线路由器，一台安装了ubuntu的笔记本，一个交换机。  
将无线路由器，笔记本通过网线连接到交换机上。无线路由器网络接口使用挨着WLAN口的那个。

在ubuntu机器开启一个终端运行下面命令:  
	# apt-get install tftp  ---> 安装tftp客户端
	# ifconfig eth0 192.168.11.2 ---> 将右上角的网络管理器关闭，然后通过该命令设置网络IP
	# arp -s 192.168.11.1 02:aa:bb:cc:dd:23  ---> 将IP地址与MAC地址绑定。这个MAC是Uboot中的
	# tftp   --->运行tftp客户端软件，通过它能够向路由其发送固件
	tftp-> verbose
	tftp-> binary
	tftp-> trace
	tftp-> connect 192.168.11.1
	tftp-> put openwrt-ar71xx-generic-wzr-hp-g450h-squashfs-tftp.bin ---> 将路由器电源拔掉再插入后回车

等待一会儿，会有数据传输的提示。传输完后，不要马上断电，可观察到Diag灯在闪动。  
大概1分钟左右后会熄灭，然后路由器会自动重启。  
注意的是OpenWrt烧完，其IP地址为192.168.1.1。笔记本IP地址，可通过DHCP获取。 
刚烧完的OpenWrt没有Web界面，只能通过telnet登录。 如需WEB界面，可以安装luci，参考[Luci]   
固件下载地址参考[OpenWrt]  

[Luci]: http://wiki.openwrt.org/doc/howto/luci.essentials  
[OpenWrt]: http://downloads.openwrt.org/snapshots/trunk/ar71xx/  

# 从OpenWrt到原厂提供的DDWrt #

DDWrt官方是不支持这个型号的路由器，该版本的DDWrt都是Buffalo原厂提供。  
可从[Buffalo Firmware] 下载  

[Buffalo Firmware]: http://www.buffalo-china.com/drvmanual/download_details.php?type=1&id=465

将DDWrt压缩包解开后，能够看到一个后缀为enc的文件。enc代表加密，这个固件是加密过的，所以我们没有办法直接通过tftp去烧写。需要将其解密才行，开始使用buffalo-enc工具进行解密，折腾的一阵子没有搞定。  
原厂固件也是加密过的，也不能直接使用的。  
300系列的貌似没有加密，只需要将文件的头截掉就可以了。 

思路转换为怎么获取解密的固件，然后通过Google，找到一个方法就是，通过另一台安装了DDWrt的路由器，将其/dev/mtd/1内容导出，这个内容就是解密后的固件。

很幸运，在公司找到了另一台450H机器，通过WEB界面更新为DDWrt版本。ssh登录到该路由器，然后运行  
	#cat /dev/mtd/1 > mtd1  
	#scp mtd1 huhb@192.168.11.2: 

将其拷贝到笔记本上。这个地方绕了一个弯路。因为自己也做底层开发，一般会看看flash的布局  
	root@OpenWrt:~# cat /proc/mtd           
	dev:    size   erasesize  name
	mtd0: 01000000 00010000 "spi0.0"
	mtd1: 01000000 00010000 "spi0.1"
	mtd2: 00040000 00010000 "u-boot"
	mtd3: 00010000 00010000 "u-boot-env"
	mtd4: 00010000 00010000 "ART"
	mtd5: 00100000 00010000 "uImage"
	mtd6: 01e80000 00010000 "rootfs"
	mtd7: 01d20000 00010000 "rootfs_data"
	mtd8: 00020000 00010000 "user_property"
	mtd9: 01f80000 00010000 "firmware"

	root@DD-WRT:~# cat /proc/mtd 
	dev:    size   erasesize  name
	mtd0: 00050000 00010000 "RedBoot"
	mtd1: 01f80000 00010000 "linux"
	mtd2: 00d3e000 00010000 "rootfs"
	mtd3: 01120000 00010000 "ddwrt"
	mtd4: 00010000 00010000 "nvram"
	mtd5: 00010000 00010000 "FIS directory"
	mtd6: 00010000 00010000 "board_config"
	mtd7: 02000000 00010000 "fullflash"
	mtd8: 00010000 00010000 "uboot-env"

两个版本很不一样，不知道到dd到OpenWrt哪个分区上。最后将DDWrt几个分区都弄出来，然后dd到对应的分区中。  
折腾了很长时间没有搞定。看到有sysupgrade这个命令可以使用，运行  
	root@OpenWrt:~# sysupgrade -n mtd1
	Sending TERM to remaining processes ... dnsmasq ntpd syslogd klogd hotplug2 ubusd netifd 
	Sending KILL to remaining processes ... 
	Switching to ramdisk...
	Performing system upgrade...
	Unlocking firmware ...

	Writing from <stdin> to firmware ...  [w] --->停在这不动了。

看到stdin提示，以为不能这么用。马上CTRL+C中断掉。又试了mtd命令等等。后面还分析更新固件的WEB界面，将DDWrt的httpd程序弄到OpenWrt上，希望能够通过WEB界面去刷，但是在OpenWrt运行后，没有页面出现的。最后又回到sysupgrade这个命令上了，将mtd1通过二进制工具打开，能够到kernel的信息，结尾有许多无效的数据，使用dd将FFFF开始的尾巴去掉，保存新文件为firmware.bin。

	root@OpenWrt:~# sysupgrade -n firmware.bin 
	Sending TERM to remaining processes ... dnsmasq ntpd syslogd klogd hotplug2 ubusd netifd 
	Sending KILL to remaining processes ... 
	Switching to ramdisk...
	Performing system upgrade...
	Unlocking firmware ...

	Writing from <stdin> to firmware ...  [w]  ---> 这一次没有中断其运行，等了一会儿出现下面的打印

	Writing from <stdin> to firmware ...     
	Upgrade completed
	Rebooting system...

看到这个信息，我知道成功了。晕呀！就是这样弄好的。

最后总结就是：使用解密固件，然后通过sysupgrade即可恢复到原来系统。  
重点就是这个解密固件了。将其放到[这里](http://huhb.github.com/assets/image/firmware.bin) 供下载

DDWrt与原厂固件可以直接通过WEB界面互刷,不再罗嗦了。
