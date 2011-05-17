---
title: "Servervirtualisierung mit Linux"
tags: [lang:de, OpenVZ, Xen]
created_at: 2006-08-03 16:45:31 CEST
updated_at: 2009-07-06 20:09:09 CEST
author: Holger Just

kind: article
publish: true
---

In der aktuellen [c't](http://www.heise.de/ct/) werden verschiedene Anbieter von Root-Servern [getestet](http://www.heise.de/ct/06/16/134/). Dabei beschränken sich die Autoren auf Anbieter von vollständig dedizierten Servern und mittels [Virtuozzo](http://www.swsoft.com/de/products/virtuozzo/) virtualisierten Root-Servern.

[Wolfgang Lonien](http://wolfgang.lonien.de), ein Debian- und Opensource-Verfechter findet das so [gar nicht OK](http://wolfgang.lonien.de/?p=152), schließlich ist Virtuozzo eine kommerzielle und in seinen Augen technisch merkwürdige Lösung. Mit [Xen](http://www.cl.cam.ac.uk/Research/SRG/netos/xen/) gibt es außerdem eine anerkannte Opensource-Lösung.

Ich bin allerdings der Ansicht, dass für Hosting-Szenarien, wo eine Vielzahl gleichartiger Systeme benötigt werden, Xen eher ungeeigent ist. Warum sollte ich für jeden virtuellen Server einen eigenen Kernel mit einer großen Virtualisierungsschicht laufen lassen wenn doch überall das gleiche System läuft? Warum soll ich mir selbst die Möglichkeit nehmen, die virtuellen Server effizient zu verwalten?

Virtuozzo hat in der Tat das "Problem", dass es kommerziell ist. Es hat sich gezeigt, dass man auch mit [freier Software](http://www.gnu.org/philosophy/free-sw.html) Geld verdienen kann, indem man bezahlten Support leistet, der im Hosting-Umfeld auch genutzt wird. 

Und genau hier greift [OpenVZ](http://www.openvz.org) an. Es stellt genau wie Virtuozzo isolierte Umgebungen zur Verfügung, die als virtuelle Server genutzt werden. Der große Vorteil ist, dass auf dem ganzen System - im Gegensatz zu Xen - nur ein Kernel läuft, der quasi geteilt wird, sodass die virtuellen Umgebungen (Virtual Environments - VEs, bzw. Virtual Private Servers - VPSs) sich wie physikalische Server verhalten. Mit der Ausnahme, dass halt keine Kernelerweiterungen oder gar ein ganz eigener Kernel eingesetzt werden kann.

Außerdem ist OpenVZ - wie der Name schon andeutet - Open Source (der Kernel selbst unter [GPL](http://openvz.org/documentation/licenses/gnu-gpl), die User-Level Tools <del>unter [QPL](http://openvz.org/documentation/licenses/qpl)</del><ins>auch</ins>) und stellt damit die Opensource-Alternative zu Virtuozzo dar, wird aber ebenso von SWsoft supportet.

Ein unschlagbarer Vorteil ist aber, dass ich virtuelle Maschinen mit minimaler Downtime zwischen physikalischen Servern verschieben kann. Dabei wird der aktuelle Zustand der virtuellen Maschine erhalten, sodass der Client nur eine leicht erhöhte Verzögerung bemerkt. Einschränkend muss allerdings gesagt werden, dass das bisher nur beim Einsatz der als *development kernel* bezeichneten Version der 2.6.16er Linuxkernels mit gleicher Kernelversion auf Quell- und Zielserver funktioniert.

Durch die "flache" Virtualisierung hat man außerdem die Möglichkeit, alle virtuellen Server von einer Stelle aus zu verwalten, da man in VPS 0 (also dem "eigentlichen" System) direkt auf die Konsole der laufenden VPSs zugreifen kann. So können beispielsweise Updates zentral angestoßen werden, ohne sich einzeln an 300 Servern einzuloggen.

Die Kritik von Wolfgang, dass Virtuozzo QMail verlangt, kann ich nicht nachvollziehen. Vielmehr ist es wohl so, dass bei den meisten Virtuozzo-Installationen auch Plesk eingesetzt wird, was dann entsprechend QMail verlangt. OpenVZ (und soweit ich das herausfinden konnte auch Virtuozzo) verlangen selbst nicht den Einsatz von QMail.

Darum bin ich gerade dabei, eine Lösung basierend auf VMwares GSX-Server (heißt jetzt [VMware Server](http://www.vmware.com/products/server/)) auf OpenVZ zu migrieren. Dadurch werden wir nach bisherigen Schätzungen ein Mehrfaches der Performance bei gleichen Hardware erreichen.
