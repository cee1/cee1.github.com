---
layout: post
title: "Life with Mac -- day one"
description: "Hello Mac"
category: "Experience"
tags: Mac osx
---
{% include JB/setup %}

With a Macbook air, 2013 in hand, the first thing needs to do is an upgrade of the Mac OS X.

# Upgrading to Mac OS X 10.9 Mavericks
* Source: [macworld.com](http://www.macworld.com/article/2056561/how-to-make-a-bootable-mavericks-install-drive.html)
* Method: Make a liveUSB installer, boot from it(hold "Option" key while in the white booting screen) and do the installation.
* Options:
  1. Use createinstallmedia -- an utility inside Mavericks installer.
  2. Use Disk Utility -- dd installer boot image to U-disk, then copy installation files.

Suppose we have already downloaded the Mavericks installer(~5.9GB) from Appstore.

## Use createinstallmedia 
1. Locate Mavericks installer bundle(a folder) in Applications folder.
2. Format a >8GB U-disk with "Untitled" as its name through Disk Utility.
3. Open a terminal, type the following command:

    sudo /Applications/Install\ OS\ X\ Mavericks.app/Contents/Resources/createinstallmedia --volume /Volumes/Untitled --applicationpath /Applications/Install\ OS\ X\ Mavericks.app --nointeraction

## Use Disk Utility 

Note, in this way:

1. You will not get a Recovery HD partition if your Mac’s drive doesn’t already have one.
2. Without a Recovery HD partition, "find my mac" will **not** work!

Steps:

1. Locate Mavericks installer bundle(a folder) in Applications folder. "Right Click"(Control + Click or tap with two fingers) it, and choose *Show Package Contents*.
2. In the folder that appears, open Contents/*Shared Support*
3. Double-click "InstallESD.dmg" in *Shared Support* folder, this will mount the volume, and add an "OS X Install ESD" entry in Finder.
4. Open a terminal, type the following command:

    open /Volumes/OS\ X\ Install\ ESD/BaseSystem.dmg
5. Launch Disk Utility, select **BaseSystem.dmg**, and then click the Restore button in the main part of the window.
6. Plug in an U-disk, drag the desired partition(**not** the one named EFI) into the destination field on the right.
7. Click *Restore*, and click *Erase* in the poped warning dialog.
8. Eject the BaseSystem.dmg in Disk Utility (select it and click *Eject* button in the toolbar) 
9. Open the destination(with label 'OS X Base System') partition, open *System/Installation* folder.
10. Delete the symbol link named "Packages", copy "Packages" folder in the mounted OS X Install ESD volume here.
