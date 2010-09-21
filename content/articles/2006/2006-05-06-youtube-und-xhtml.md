---
title: "YouTube und XHTML"
tags: [lang:de, Youtube, XHTML]
created_at: 2006-05-06 20:16:28 CEST
updated_at: 2009-07-06 23:40:09 CEST
author: Holger Just

kind: article
publish: true
---

Gerade hab ich mal wieder meine eigene Seite [überprüft](http://validator.w3.org/check?uri=http%3A%2F%2Fwww.meine-er.de%2F) und musste dabei feststellen, dass der "normale" YouTube-Code leider nicht dem XHTML 1.1-Standard entspricht. Um genau zu sein, entspricht er überhaupt keinen (X)HTML-Standard:

<% filter :code, :html do %>
<object width="425" height="350">
  <param name="movie"
   value="http://www.youtube.com/v/DEINE_VIDEO_ID"></param>
   <embed src="http://www.youtube.com/v/DEINE_VIDEO_ID"
   type="application/x-shockwave-flash" width="425"
   height="350"></embed>
</object>
<% end %>

Schuld ist der `<embed>`-Tag. Das ist was zutiefst Proprietäres als seeligen Netscape 2.0 Zeiten (imerhin schon 10 Jahre her) und hat nie Eingang in eine HTML-Spezifikation gefunden.

Wie kann mal also den Flash-Player von [YouTube](http://www.youtube.com/) so einbinden, dass das ganze validiert? Bei [Wildbits](http://www.wildbits.de/2006/04/02/youtube-xhtml/) wird ein Code-Fragment beschrieben, in dem einfach der `<embed>`-Tag weggelassen wird und dafür die entsprechenden Daten im übergeordneten `<object>`-Tag definiert werden. Das Ganze sieht dann so aus:

<% filter :code, :html do %>
<div style="text-align:center">
  <object type="application/x-shockwave-flash"
   style="width:425px; height:350px"
   data="http://www.youtube.com/v/DEINE_VIDEO_ID">
    <param name="movie"
     value="http://www.youtube.com/v/DEINE_VIDEO_ID"></param>
  </object>
</div>
<% end %>

Damit ist dann auch alles wieder schick und ich kann weiter den einschlägigen Webstandards fröhnen.

Ich frag mich nur, warum man das nicht gleich statt dieses komischen Codes von oben bei YouTube anbieten kann. Ich dachte ja immer, dass Web 2.0 auch valider Code heißt. Tja, und ich hatte mich schon gefreut...