---
layout: post
title: "Life with Mac -- day two"
description: "First glance of Mac"
category: "Experience"
tags: Mac osx
---
{% include JB/setup %}

The mac GUI, with name of Aqua, that's a top *Menu Bar* which will show different contents on different focused applications, and a bottom *Dock* per-desktop.

The default focused applicaion is Finder, so it can't quit by 'Command + q'.

It's bit familiar if you're a GNOME 3 user.

Go through the filesystem, that's quite different compared with Linux:

* The file name extension of dynamic libraries is ".dylib", not ".so".
* Framework: a collection of libraries and related data. A framework provides a "gate file" to link, which will hide links to framework's internal libraries.
* "A file" in Finder may not be a file, it could be a directory -- the bundle, especially files saved by pages(equivalently to Libreoffice writer), keynotes(equivalently to Libreoffice Presentation).
* To install an application, just drag bundle of the application to the Applications folder, to uninstall just do the reverse -- though this may not be a clean uninstall.
* Software may be packed to ".pkg" files, there's no uninstaller for ".pkg" files though. You may do

    lsbom -f -l -s -pf /var/db/receipts/com.foo.bar.myapp.pkg.bom

  and delete each file manually.
* Services of applications: Menu Bar -> Application Name -> Services
* /dev/disk1s0 vs /dev/sdb1 in U-disk case; /dev/disk1s0 vs /dev/loop0 in .dmg file case
* plist vs ini, XML json, GVariant etc. plist may be in format of XML, json or binary
* otool -L vs ldd

Preferred apps:

* Wondershare Player: the media player supporting more formats than quicktime.
* From Apple:
  * Xcode: not only an IDE, but also git, gcc, lldb ...
  * iWorks: Pages, Keynote and Numbers
  * Aperture: more powerful than iPhoto
* CleanMyMac 2: scan for possible useless files, save spaces...
* Hex Fiend: a hex editor, a free version is available on its offical site
* Avira: Antivirus
