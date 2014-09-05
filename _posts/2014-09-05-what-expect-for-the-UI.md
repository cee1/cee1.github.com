---
layout: post
title: 人机交互：演进与遐想
description: "The evolution and dream of HI"
category: "articles"
tags: GNOME Gtk+ Gsk Clutter Adam ASL IM-style
---
{% include JB/setup %}

# 简言
从前，GNOME，每次发布都带来了新奇的想法，同时也在渐渐重构基础组件。使得美观不仅在其界面，更在其内，这便是优雅。

似乎进入3以后，GNOME的演进不再如此新鲜了。然而内在的进化还在继续，这种低调使得总有点期望 —— 哪天蹦出个GNOME OS，出来个GNOME pad。

目前最古老陈旧的组件大概就是 GTK+ 了。关于 GTK+，曾经有人认为 GTK+ 各种不分离，应当另起炉灶，例如基于 Clutter 完成一套控件，大概是[mx](https://github.com/clutter-project/mx)。

然而随着Meego夭折，Clutter 系的开发和应用也渐微，最近消息是 Clutter 维护者决定另起一库 [Gsk](http://www.bassi.io/articles/2014/07/29/guadec-2014-gsk/)（Gtk+ Scene graph Kit）。大体理由是 Clutter 目前应用最多的是 Clutter-gtk，实际仅发挥其部分功能；另一方面又与Gdk整合又不是很好。

那么，Gsk 带来了哪些变化呢，凭印象说，所见与事件响应分离，本库只处理所见。所见如何产生呢？分矩形块，然后填充矩形内容。矩形块有父子关系，这就涉及如何布局子矩形 —— 有独立的布局对象来处理。
这样，我们不再只能用 GtkHBox 控件来水平一字平铺对象。布局是更加底层的事，便于布局代码复用。

绘制所见时，按照矩形块父子关系，即按场景图（Scene Graph）来遍历节点。

通常UI基础提供哪些服务呢？

1. 输入事件（Controller）

2. 模型（Model）

3. 所见（Views）：布局（layout），绘制 <= 主题引擎

以及综合上述的动画功能（[Clutter初衷](https://developer.gnome.org/clutter-cookbook/stable/animations.html#animations-introduction)）。

还有将物理公式代入动画，使得屏幕控件的动画模拟真实物件的物理行为，例如 Clutter 与两个物理引擎结合的产物：[clutter-box2d](https://github.com/clutter-project/clutter-box2d) 与 [clutter-bullet](https://github.com/clutter-project/clutter-bullet)。

上述提到UI组成中，许多可以用语言来描述。这使得UI界面本身独立于代码，即做到界面与代码的分离。越多的UI用语言来描述，则越发先进。

通常描述是某某对象，其属性是某某某。能这样描述的有布局（XML，JSON，[Eve](http://stlab.adobe.com/group__asl__overview.html#asl_overview_intro_to_adam_and_eve)）、主题（JSON，CSS）还有动画（JSON）。

对于模型的描述，几乎只有 [Adam 语言](http://stlab.adobe.com/group__asl__overview.html#asl_overview_intro_to_adam_and_eve) 。网上有一种意见，是说如果你的UI设计中，发现使用Adam非常方便，那意味着你的UI太复杂了。个人不赞同这个观点，比如看一下gimp的图像处理对话框，许多界面元素是关联的，也不复杂。

然而，若模型的逻辑不好理解 —— 用户不明白为啥他的输入被“篡改”了，就有点讨厌了。也许需要加入帮助/提示环节，但怎么体现？现有上需要增加什么吗？？

一句话，个人对Adam还是比较着迷的，希望将来有机会去重构C语言版本，并且和Gtk+整合。

# 遐想
最近在[泰晓投了个稿](http://www.tinylab.org/new-ui-design-im-style-cellphone-ui-intro/)，是推销一个**即时通讯风格的手机界面**的想法（以及专利）。

这个想法的起因是考虑设计一种不同于苹果引领的图标风格手机界面，以及微软开创的磁贴风格的手机界面 —— 不同于这两者的一种手机界面。

想到了即时通讯 —— 和App聊天 —— 每个App都有一个接收用户命令的通道，最好是自然语言。系统的UI基础中提供语音和语义辨识服务，来供App解析命令。

当然手动输入也是可以的，但。。。这不就是命令行了吗？进一步想，为了提高输入效率，我们来重载输入法，加入提示。例如输入日期时，提示“昨天，今天，明天...“，供用户一点输入。且越关联上下文的提示越有益。

再进一步想，我们输入复杂点的东西，输入法里面开始出现控件，例如combobox，额，这不又回到了原来的图形界面上了吗。对此呵呵一声，地球是圆的，UI也是圆的。。

最后想，大概所有App都通过一个聊天小条条来使用，大概是不可行的吧？唯一的疑问是适用范围有多少？适用带来的实用又有多少呢？？
