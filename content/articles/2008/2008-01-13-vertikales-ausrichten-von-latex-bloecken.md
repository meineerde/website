---
title: "Vertikales Ausrichten von LaTeX-Blöcken"
tags: [lang:German, LaTeX, Minipage]
created_at: 2008-01-13 23:46:40 CET
updated_at: 2009-07-07 03:48:21 CEST
author: Holger Just

kind: article
publish: true
---

Der oder die Eine oder Andere wird vielleicht mal drauf stoßen, dass man in LaTeX-Tabellen die vertikale Ausrichtung von Elementen nicht direkt bestimmen kann. Das ist sehr ärgerlich, wenn man zum Beispiel Grafiken in einer Tabelle setzen will und sie vertikal zentriert in den Zellen ausrichten will.

Hier hilft eine sogenannte Minipage. Das ist eine syntaktische Möglichkeit, eigene Boxen zu definieren, an denen man dann definieren kann, welche Ausrichtung ihre Inhalte gegenüber der Grundlinie haben. Das kann dann etwa so aussehen:

<% filter :code, :latex do %>
\begin{tabular}{c|c}
  Links & Rechts \\
  \hline
  \begin{minipage}[c]{5cm}
    \begin{center}
      \includegraphics[width=4.5cm]{img/klein}
    \end{center}
  \end{minipage} &
  \begin{minipage}[c]{5cm}
    \begin{center}
      \includegraphics[width=4.5cm]{img/sehr_hoch}
    \end{center}
  \end{minipage} \\
\end{tabular}
<% end %>

Der interessante Teil ist das `c` in eckigen Klammern nach `\begin{minipage}`. Hier kann man die vertikale Ausrichtung als `t`op, `c`enter oder `b`ottom angeben.

Weitere Beispiele und eine genauere Beschreibung findet sich auch in [The Not so Short Introduction to LaTeX 2e](http://www.ctan.org/tex-archive/info/lshort/english/lshort.pdf) im Kapiel 6.6.

## Nachtrag
Eine weitere (von mir jetzt nicht getestete) Möglichkeit, die auf dem [Koma-Script](http://dante.ctan.org/CTAN/macros/latex/contrib/koma-script/)  basiert findet sich beim [KOMA-Script documentation project](http://www.komascript.de/node/718#comment-1710).