---
layout: post
title: "Life with Mac -- day three"
description: "Plant a tiny GNU environment"
category: "templates"
tags: Mac osx cerbero
---
{% include JB/setup %}

Instead of installing a Linux Distro, plant a tiny GNU enivironment within osx will be more lightweight. The options are [gentoo-prefix](http://prefix.gentoo.org) and [MacPorts](http://www.macports.org). But they are still too heavy to me, so I choosed cerbero, the build system of GStreamer SDK.

## cerbero and GStreamer SDK
cerbero is written in python, and seems borrowing compiling rules from jhbuild - the build system of GNOME.

The steps are quite simple:

1. git clone cerbero repo from [GStreamerSDK](http://cgit.freedesktop.org/gstreamer-sdk/cerbero/) or [GStreamer](http://cgit.freedesktop.org/gstreamer/cerbero/), the former corresponds to the SDK versions of GStreamer. You can configure it in ~/.cerbero/cerbero.cbc.

   Here is my cerbero.cbc:
<pre>
    # The compiled software will be installed to this path.
    prefix = '/Users/cee1/Lab/cerbero/output' 

    # Various building folders are under this path.
    home_dir = '/Users/cee1/Lab/cerbero/workdir'
</pre>

   And do a cerbero bootstrap:

<pre>
    /path/to/cerbero/cerbero-uninstalled bootstrap
</pre>

2. Install GStreamer SDK if you don't want to compile many packages. GStreamer SDK contains many basic GNOME libraries, it can be downloaded from [gstreamer.freedesktop.org/data/pkg/osx/](http://gstreamer.freedesktop.org/data/pkg/osx/), just install the following two .pkgs:

   * gstreamer-1.0-X.X.X-universal.pkg
   * gstreamer-1.0-devel-X.X.X-universal.pkg

3. Make a folder named $USER-scope in $HOME, put the [environment](https://raw.github.com/cee1/cee1.archive/master/templates/mac-osx-env/environment) file there, and do:
<pre>
    echo ". $HOME/$USER-scope/environment" >> ~/.bashrc
    echo ". $HOME/.bashrc" >> ~/.bash_profile

    # Add some entries in $USER-scope
    cd $HOME/$USER-scope
    ln -s /Users/cee1/Lab/cerbero/output cerbero
    ln -s /Library/Frameworks/GStreamer.framework .
</pre>

Now you can build software by **/path/to/cerbero/cerbero-uninstalled shell**, this will throw a bash with necessary environment variables set.

## Recompile GStreamer SDK
In osx, it seems an executable file can link to more than one dynamic libraries with the same name. In practise, I found a binary linked to two glib s in different paths, and this may cause some strange problems. So I decided to re-compile a new GStreamer SDK. This will give me a more complete GStreamer and new enough libraries - I can just keep on glib in $HOME/$USER-scope.

To do this, I needs to hack cerbero to let it apply '$USER-scope/environment' before doing each operation: [github.com/cee1/cerbero-mac](https://github.com/cee1/cerbero-mac)

Re-compile GStreamer SDK:

    /path/to/cerbero/cerbero-uninstalled package gstreamer-1.0

    # Modify po/Makefile if it complains about the GETTEXT version

    # Ignore packing errors, the packages are not needed but the files under $USER-scope/cerbero are

## If you need to hack
Here're some useful hack tools

* lldb: [quite different to gdb](http://lldb.llvm.org/lldb-gdb.html) in terms of command.
* otool: readelf, objdump plus ldd. I used this the disassemble binary, when hack the binary by Hex Fiend.
* dtruss: a strace like tool.
