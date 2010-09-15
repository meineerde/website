---
title: "Kurze URLs mit TWiki"
tags: [lang:German, TWiki, ShortURLs, mod_rewrite]
created_at: 2006-05-13 00:59:01 CEST
updated_at: 2009-09-01 14:48:21 CEST
author: Holger Just

kind: article
publish: true
---

Wenn Leute von [Wikis](http://de.wikipedia.org/wiki/Wiki) reden, dann meinen sie häufig die Wikipedia. Dies ist aber "nur" eine Anwendung davon. Sie basiert auf dem [Mediawiki](http://www.mediawiki.org/). Daneben gibt es eine Reihe anderer Wikisysteme, z.B. eben [TWiki](http://www.twiki.org/).

TWiki hat den Vorteil, dass es eine weitreichende Rechteverwaltung bietet und somit auch als Public-Private-Wiki eingesetzt werden kann.

Was mich und andere aber stört, das sind die langen URLs. Meist sind sie in der Form `http://www.example.com/twiki/bin/view/Web/WikiWord`. Und das ist definitiv [unschön](http://www.w3.org/QA/Tips/uri-choose). Viel schöner wäre etwas in der Form `http://www.example.com/Web/WikiWord`, nicht oder?

Es gibt zwar schon eine Menge [Hinweise](http://twiki.org/cgi-bin/view/TWiki/ShorterUrlCookbook) und [Ideen](http://twiki.org/cgi-bin/view/Codev/ShorterURLs), nur leider beziehen die sich meist auf die alte Version 3 (Cairo). Inzwischen gibt es aber eine neue Version (Dakar) und viele Dinge funktionieren anderes, einiges auch schöner.

Bei einer Installation, die ich gerade aufsetze habe ich mich als Basis die Konfiguration von [wiki.boum.org](http://wiki.boum.org/TechStdOut/BoumTWikiSetup) hergenommen und angepasst.

Folgende Anforderungen sind dabei berücksichtigt worden:

* URLs sollen möglichst kurz sein.
* Standard-URLs müssen auch funktionieren.
* Passwörter dürfen nicht im Klartext übertragen werden.

**Alle Konfigurationsdateien (bzw. -fragmente), die im folgenden erwähnt werden können auch [heruntergeladen](/media/2006/config.zip) werden.**

### Die Apache-Konfiguration
Die Anleitung beruht auf der [Version 4.0.2](http://twiki.org/cgi-bin/view/Codev/TWikiRelease04x00x02) (Dakar) von TWiki.

Die Pfadangaben müssen möglicherweise angepasst werden. Bei dem gezeigten Code ist TWiki in `/var/lib/twiki` installiert. Allerdings wurden einige kleine Änderungen vorgenommen:

* Das pub-Verzeichnis liegt in `/var/www/twiki/pub`
* Das bin-Verzeichnis liegt in `/usr/lib/cgi-bin/twiki`

Beachtet werden sollte außerdem, dass die Konfiguration den `TemplateLogin` verlangt. Bei anderen Login-Managern muss die Weiterleitung auf https anders und die Zugriffsregelung mittels `require valid user` geregelt werden.

Es gibt zwei Virtual Hosts für HTTP und HTTPS.

<% filter :code, :apache do %>
<VirtualHost _default_:80>
  ServerName www.example.com
  ServerAdmin admin@example.com

  DocumentRoot /var/www/twiki
  ScriptAlias /twiki/bin/ "/usr/lib/cgi-bin/twiki/"
  Alias /twiki/ "/var/www/twiki/"

  # Pub Dirs
  <Directory "/var/www/twiki/pub">
    Options FollowSymLinks +Includes -Indexes
    AllowOverride None
    Allow from all
  </Directory>

  # We set an environment variable called anonymous_spider
  # Setting a BrowserMatchNoCase to ^$ is important. It prevents
  # TWiki fromincluding its own topics as URLs and also prevents
  # other TWikis from doing the same. This is important to
  # prevent the most obvious Denial of Service attacks.
  # You can expand this by adding more BrowserMatchNoCase
  # statements to block evil browser agents trying the impossible
  # task of mirroring a twiki
  # Example:
  # BrowserMatchNoCase ^SiteSucker anonymous_spider
  BrowserMatchNoCase ^$ anonymous_spider

  <Directory "/usr/lib/cgi-bin/twiki">
    Options +ExecCGI FollowSymLinks
    SetHandler cgi-script
    Order Allow,Deny
    Allow from all
    Deny from env=anonymous_spider
  </Directory>

  # The other dirs should not be visible to the web at all,
  # but just to be safe: deny from all

  <Directory "/var/lib/twiki/data">
    deny from all
  </Directory>

  <Directory "/var/lib/twiki/templates">
    deny from all
  </Directory>

  <Directory "/var/lib/twiki/lib">
    deny from all
  </Directory>

  <Directory "/var/lib/twiki/tools">
    deny from all
  </Directory>

  <Directory "/var/lib/twiki/locale">
    deny from all
  </Directory>

  # This is the ShorterURL stuff as found in
  # http://wiki.boum.org/TechStdOut/BoumTWikiSetup
  <IfModule mod_rewrite.c>
    RewriteEngine On

    #/ displays homepage
    RewriteRule ^/$ /twiki/bin/view/Public/WebHome [PT]

    # Nicer, and to prevent anyone to bypass the
    # following redirect
    RewriteRule ^/twiki/bin/(.*) /$1 [R=permanent,L]

    # Scripts that need to be authentificated can
    # *only* be accessed via httpS
    RewriteRule ^/(viewauth|edit|preview|save|attach|upload|rename|rdiffauth|manage|installpasswd|logon|logout)(.*)    https://%{SERVER_NAME}/$1$2 [R,L]

    # !!! ATTENTION !!!
    # This rules assume, webs AND topics each starting with a caps

    # if (URL begins with a caps) then
    #   rewrite /twiki/bin/view/URL and stop
    # end if
    # if (URL begins with view) then
    #   redirect to Web/Topic without view and stop
    # end if
    # if (URL begins with a script) then
    #   rewrite /twiki/bin/URL
    # end if

    RewriteRule ^/([[:upper:]].*) /twiki/bin/view/$1 [PT]
    RewriteRule ^/([[:upper:]].*) /twiki/bin/view/$1 [PT]
    RewriteRule ^/view/(.*) /$1 [R=permanent,L]

    RewriteCond /usr/lib/cgi-bin/twiki/$1 -f
    RewriteRule ^/([a-z]+)(.*) /twiki/bin/$1$2 [PT]
  </IfModule>
</VirtualHost>
<% end %>

Und der HTTPS-VirtualHost:

<% filter :code, :apache do %>
<VirtualHost _default_:443>
  SSLEngine On
  SSLCertificateFile /etc/apache2/ssl/apache.pem

  ServerName www.example.com
  ServerAdmin admin@example.com

  DocumentRoot /var/www/twiki
  ScriptAlias /twiki/bin/ "/usr/lib/cgi-bin/twiki/"
  Alias /twiki/ "/var/www/twiki/"

  # We set an environment variable called anonymous_spider
  # Setting a BrowserMatchNoCase to ^$ is important. It prevents
  # TWiki fromincluding its own topics as URLs and also prevents
  # other TWikis from doing the same. This is important to
  # prevent the most obvious Denial of Service attacks.
  # You can expand this by adding more BrowserMatchNoCase
  # statements to block evil browser agents trying the impossible
  # task of mirroring a twiki
  # Example:
  # BrowserMatchNoCase ^SiteSucker anonymous_spider
  BrowserMatchNoCase ^$ anonymous_spider

  <Directory "/usr/lib/cgi-bin/twiki">
    Options +ExecCGI FollowSymLinks
    SetHandler cgi-script
    Order Allow,Deny
    Allow from all
    Deny from env=anonymous_spider
  </Directory>

  # This is the ShorterURL stuff as found in
  # http://wiki.boum.org/TechStdOut/BoumTWikiSetup
  <IfModule mod_rewrite.c>
    RewriteEngine On

    # / displays homepage
    RewriteRule ^/$ /twiki/bin/view/Main/WebHome [PT]

    # if (URL begins with a caps) then
    #   rewrite /twiki/bin/view/URL and stop
    # end if
    # if (URL begins with view) then
    #   redirect to Web/Topic without view and stop
    # end if
    # if (URL begins with a script) then
    #   rewrite /twiki/bin/URL
    # end if

    RewriteRule ^/([[:upper:]].*) /twiki/bin/view/$1 [PT]
    RewriteRule ^/view/(.*) /$1 [R=permanent,L]

    RewriteCond /usr/lib/cgi-bin/twiki/$1 -f
    RewriteRule ^/([a-z]+)(.*) /twiki/bin/$1$2 [PT]
  </IfModule>
</VirtualHost>
<% end %>

## TWiki-Konfiguration

Editiere die Datei `/var/lib/twiki/lib/LocalSite.cfg` und nimm darin die folgenden Einstellungen vor. Der Hostname ist dabei durch den DNS-Namen der Maschine zu ersetzen.

<% filter :code, :perl do %>
$cfg{ScriptUrlPath} = '';
$TWiki::cfg{ScriptUrlPaths}{view} = 'http://www.example.com';
$TWiki::cfg{ScriptUrlPaths}{login} = 'https://www.example.com/login';
$TWiki::cfg{ScriptUrlPaths}{logon} = 'https://www.example.com/logon';
$TWiki::cfg{ScriptUrlPaths}{logout} = 'https://www.example.com/logout';
$TWiki::cfg{ScriptUrlPaths}{viewauth} = 'https://www.example.com/viewauth';
$TWiki::cfg{ScriptUrlPaths}{edit} = 'https://www.example.com/edit';
$TWiki::cfg{ScriptUrlPaths}{preview} = 'https://www.example.com/preview';
$TWiki::cfg{ScriptUrlPaths}{save} = 'https://www.example.com/save';
$TWiki::cfg{ScriptUrlPaths}{attach} = 'https://www.example.com/attach';
$TWiki::cfg{ScriptUrlPaths}{upload} = 'https://www.example.com/upload';
$TWiki::cfg{ScriptUrlPaths}{rename} = 'https://www.example.com/rename';
$TWiki::cfg{ScriptUrlPaths}{rdiffauth} = 'https://www.example.com/rdiffauth';
$TWiki::cfg{ScriptUrlPaths}{manage} = 'https://www.example.com/manage';
$TWiki::cfg{ScriptUrlPaths}{installpasswd} = 'https://www.example.com/installpasswd';

$TWiki::cfg{LoginManager} = 'TWiki::Client::TemplateLogin';
<% end %>

## Die Patches

Leider verwendet der Pattern-Skin, der standardmäßig von TWiki verwendet wird einen fehlerhaften Mechanismus, um die URLs zu generieren. Darum müssen wir patchen.

<% filter :code, :bash do %>
cd /var/lib/twiki
find templates -name '*.tmpl' -exec perl -pi -e 's,%SCRIPTURL%/view%SCRIPTSUFFIX%,%SCRIPTURL{\"view\"%,g' {} \;
find templates -name '*.tmpl' -exec perl -pi -e 's,%SCRIPTURLPATH%/login%SCRIPTSUFFIX%,%SCRIPTURLPATH{\"login\"%,g' {} \;
find templates -name '*.tmpl' -exec perl -pi -e 's,%SCRIPTURLPATH%/edit%SCRIPTSUFFIX%,%SCRIPTURLPATH{\"edit\"%,g' {} \;
find templates -name '*.tmpl' -exec perl -pi -e 's,%SCRIPTURLPATH%/attach%SCRIPTSUFFIX%,%SCRIPTURLPATH{\"attach\"%,g' {} \;
<% end %>

## To Do

* Im https-Modus werden einige Daten über http geladen. Der Benutzer erhält dadurch möglicherweise eine Warnung vom Browser.
* Topics eines ausgewählten Webs sollten auch ohne Angabe des Webs ansprechbar sein.
* Möglicherweise sind noch Stellen im Pattern-Skin, an denen die URLs noch nicht korrekt gebildet werden.