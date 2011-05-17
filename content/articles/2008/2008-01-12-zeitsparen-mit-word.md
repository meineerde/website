---
title: "Zeitsparen mit Word"
tags: [lang:de, Word]
created_at: 2008-01-12 14:17:12 CET
updated_at: 2009-07-03 00:25:39 CEST
author: Holger Just

kind: article
publish: true
---

Es sind die kleinen Dinge, die einem viel Zeit sparen können. Bei Word geht es (zumindest, wenn man Vorlagen einsetzt) häufig darum, alle *Felder* zu aktualisieren.

Leider wird das von Microsoft nicht direkt ermöglicht. Es kann natürlich auch sein, dass ich es nur nicht gefunden habe.

Solange man keine Felder in Kopf- und/oder Fußzeilen einsetzt reicht ja ein klassisches Strg+A gefolgt von F9, was sich aber nur auf den "normalen" Text auswirkt.

Möchte man hingegen wirklich **alle** Felder eines Dokuments aktualisieren, dann kann man das folgende einfache Makro hernehmen. Es ist getestet auf Word XP und 2003.


<% filter :code, :vbnet do %>
Sub AlleFelderAktualisieren()
    '  Felder aktualisieren
    Dim Part As Range
    For Each Part In ActiveDocument.StoryRanges
        Part.Fields.Update
        While Not (Part.NextStoryRange Is Nothing)
            Set Part = Part.NextStoryRange
            Part.Fields.Update
        Wend
    Next

    '  Inhaltsverzeichnis aktualisieren
    Dim TOC As TableOfContents
    For Each TOC In ActiveDocument.TablesOfContents
        TOC.Update
    Next
End Sub
<% end %>
