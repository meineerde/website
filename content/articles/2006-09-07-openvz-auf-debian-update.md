---
title: "OpenVZ auf Debian - Update"
tags: [lang:German, OpenVZ, Debian, Thorsten Schifferdecker]
created_at: 2006-09-07 12:03:44 CEST
updated_at: 2009-07-06 16:54:01 CEST
author: Holger Just

kind: article
publish: true
---

Anfang August hatte ich auf ein etwas umfangreicheres Howto zur Installation von OpenVZ auf Debian Sarge [verwiesen](/2006/08/04/openvz-auf-debian). Dabei hatte ich noch bemängelt, dass relativ viel Handarbeit, sprich das Kompilieren eines Kernels nötig war. Die Userlevel-Tools, also vzctl und vzquote, waren damals schon über das APT-Repository von Thorsten Schifferdecker auf [debian.systs.org](http://debian.systs.org) verfügbar, die Kernel eben noch nicht.

Neulich hab ich bei einen `apt-get update` festestellt, dass jetzt das komplette OpenVZ-Paket verfügbar ist. (OK, Thorsten hat mit in einem Kommentar auch darauf [hingewiesen](/2006/08/openvz-auf-debian#comment-204).)

Das Tolle daran ist, dass sich die Installation von OpenVZ auf einem laufenden Debian-System damit auf 6 Zeilen reduziert.

1.  Hinzufügen des Repositories zur apt-Liste.
<% filter :code_simple, :bash do %>
echo "deb http://debian.systs.org/ stable openvz" >> /etc/apt/sources.list
apt-get update
<% end %>
2. Kernel und Tools installieren.
<% filter :code_simple, :bash do %>
apt-get install vzctl vzquota vzctl-template-debian
<% end %>
    Je nachdem, ob man ein SMP-System mit mehreren Prozessoren (oder Hyperthreading) hat, oder nur ein 1-Prozessor-System installiert man dann den passenden Treiber.
<% filter :code_simple, :bash do %>
apt-get instal kernel-image-2.6.8-stable-ovz
<% end %>
    oder
<% filter :code_simple, :bash do %>
  apt-get instal kernel-image-2.6.8-stable-ovz-smp
<% end %>
3. Anschließend muss man nur noch Grub updaten und das System neu starten.
<% filter :code_simple, :bash do %>
/sbin/update-grub
shutdown -r now
<% end %>
Und das wars dann auch schon.

Wem selbst das zu viel Arbeit ist (und jetzt kein Rant über faule Admins...), der kann auch den fertigen [Debian-Installer](http://debian.systs.org/openvz/77/forzza-installer-14-ready-stable-release-upload/) von Thorsten hernehmen und ein neues Debian-System gleich mit OpenVZ installieren. Ist die Welt nicht schön? =:D