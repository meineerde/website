---
title: "Spam des Tages 5"
tags: [lang:German, Spam]
created_at: 2007-02-19 16:38:23 CET
updated_at: 2009-07-03 00:23:51 CEST
author: Holger Just

kind: article
publish: true
---

Ich bekomm sooooo einen Hals. Ein wenig Mühe könnten sich die Spammer schon noch geben. Ist es denn zu viel verlangt, wenigstens die variablen Felder der Spam-Mail zu ersetzen?

<% filter :code_simple, :text do %>
From: "%FROM_NAME" <%%FROM_EMAIL>
To: undisclosed-recipients:;
...
Received: from 192.168.0.%RND_DIGIT
  (203-219-%DIGSTAT2-%STATDIG.%RND_FROM_DOMAIN
  [203.219.%DIGSTAT2.%STATDIG]) by
  mail%SINGSTAT.%RND_FROM_DOMAIN (envelope-from
  %FROM_EMAIL) (8.13.6/8.13.6) with SMTP id
  %STATWORD for <%%TO_EMAIL>; %CURRENT_DATE_TIME
Message-Id: <%%RND_DIGIT[10].%STATWORD@mail%SINGSTAT.%RND_FROM_DOMAIN> 

%TO_CC_DEFAULT_HANDLER
Subject: %SUBJECT
Sender: "%FROM_NAME" <%%FROM_EMAIL>
Mime-Version: 1.0 
Content-Type: text/html
Date: %CURRENT_DATE_TIME

%MESSAGE_BODY
<% end %>

Jetzt muss ich hier über diese Stümper ranten, anstatt mich über *richtigen* Spam aufzuregen...