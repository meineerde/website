---
title: "Reverse Ajax"
tags: [lang:German, Reverse AJAX, AJAX]
created_at: 2006-05-27 18:19:24 CEST
updated_at: 2009-07-06 22:47:21 CEST
author: Holger Just

kind: article
publish: true
---

[Ajax](http://de.wikipedia.org/wiki/Ajax_%28Programmierung%29) ist eine tolle Sache. Man kann sehr nette interaktive Benutzeroberflächen bauen. Es gibt nur ein großes Problem.

Was tun, wenn man auf dem Server Daten hat, die er an den Client senden will, aber der Client hat nicht direkt danach gefragt? Z.B., wenn bei einem Chat der andere was sagt, oder wenn eine neue Mail angekommen ist und das Interface soll es anzeigen.

Auf [Prokata](http://prokata.com/reverseajax) wird eine Zusammenfassung der dafür zur Zeit nutzbaren Lösungen gegeben. In aller Kürze sind das

* Pollen
* Langlebige HTTP-Verbindungen
* Verzögertes Update bei der nächste Anfrage