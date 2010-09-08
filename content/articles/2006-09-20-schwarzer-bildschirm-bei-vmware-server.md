---
title: "Schwarzer Bildschirm bei VMware Server"
tags: [VMware, Black Screen]
created_at: 2006-09-20 12:22:40 CEST
updated_at: 2009-07-06 15:50:47 CEST
author: Holger Just

kind: article
publish: true
---

Gerade wollte ich einen Windows Server von einem VMware Server auf einen anderen umziehen. Nach dem Starten der VM auf dem neuen Rechner zeigte mir die Konsole aber nur einen schwarzen Bildschirm.

Ich habe keine Ahnung, was der eigentliche Grund für dieses Verhalten ist, aber wenigstens gibt es einen funktionierenden Workaround.

Man erstellt auf dem Zielserver einfach eine neue VM mit den gewünschten Einstellungen, erstellt aber keine neuen virtullen Festplatten, sondern gibt die bestehenden an. That should do.

[gefunden bei [WhoCares?](http://whocares.de/2006/08/13/successful-migration-to-vmware-server-anyone/)]