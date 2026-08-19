# Sicherheit

## Was umgesetzt ist

**Anmeldung und Sitzungen**
- Passwörter mit Argon2id (19 MiB Speicher, 3 Durchgänge), reine WASM-Umsetzung ohne Compiler
- Sitzungstoken zufällig, 32 Byte; in der Datenbank liegt nur der SHA-256-Hash
- Cookie `HttpOnly`, `SameSite=Lax`, `Secure` in Produktion
- Automatische Abmeldung nach 12 Stunden
- Passwortwechsel beendet alle bestehenden Sitzungen
- Rate Limiting: höchstens 8 Anmeldeversuche pro E-Mail in 10 Minuten
- Anmeldung mit sechsstelligem Code: nur auf einem Gerät, das sich schon einmal mit Passwort angemeldet hat; der Code liegt ebenfalls als Argon2id-Hash in der Datenbank; nach 5 Fehlversuchen 15 Minuten gesperrt; Setzen und Ändern verlangt das Passwort

**Eingaben und Rechte**
- Jede Anfrage wird mit Zod geprüft, bevor sie die Datenbank erreicht
- Jede Abfrage filtert zusätzlich nach der eigenen Benutzer-ID – fremde Daten sind nicht erreichbar
- Rollen: Eigentümer (alles), Vertrauensperson (schreiben), Nur-Lese-Zugriff
- Löschen des Kontos und das Sicherheitsprotokoll bleiben dem Eigentümer vorbehalten

**Dateien**
- Dokumente liegen in der Datenbank und sind ausschliesslich über eine authentifizierte Route abrufbar – es gibt keine öffentliche Datei-URL, die man erraten könnte
- Der Dateityp wird an den ersten Bytes geprüft, nicht an der Endung
- Erlaubt: PDF, JPG, PNG, WEBP, HEIC, TXT bis 4 MB
- Dateinamen werden serverseitig neu vergeben; Pfadangaben aus dem Browser werden verworfen
- SHA-256-Prüfsumme pro Datei
- Ein Speicherbudget bremst, bevor der Gratis-Tarif der Datenbank an seine Grenze läuft

**Transport und Browser**
- HTTPS-Pflicht, `Strict-Transport-Security` mit zwei Jahren
- Content Security Policy ohne `unsafe-eval`, `object-src 'none'`, `frame-ancestors 'none'`
- `X-Content-Type-Options`, `X-Frame-Options`, `Referrer-Policy`, `Permissions-Policy`
- Der Service Worker speichert **keine** API-Antworten und **keine** Dokumente zwischen

**Protokollierung**
- Audit-Log für Anmeldung, Fehlversuche, Löschungen, Uploads, Exporte, Passwortwechsel
- Bewusst ohne Passwörter, Sitzungsschlüssel und Dateiinhalte
- Einsehbar unter Verwaltung

**Geheimnisse**
- Alle Zugangsdaten stehen in Umgebungsvariablen (bei Vercel unter Settings → Environment Variables), nie im Code, nie im Frontend
- Der tägliche Cronjob unter `/api/cron` ist öffentlich erreichbar, tut aber ohne das Geheimnis `CRON_SECRET` nichts
- `.env.example` enthält ausschliesslich Platzhalter
- `.env` und `.vercel/` stehen in `.gitignore` und landen nie im Repository

## Was bewusst fehlt

**Der Zahlencode ist bequemer, nicht sicherer.** Sechs Ziffern sind schwächer als ein langes
Passwort. Zwei Dinge halten ihn trotzdem zusammen: Er funktioniert nur auf einem Gerät, das
sich schon einmal regulär angemeldet hat, und nach fünf Fehlversuchen ist Schluss – Raten
scheitert also am Zeitfenster, nicht an der Länge. Wer dein entsperrtes Telefon in der Hand
hält, hat es damit aber leichter als vorher. Wem das zu locker ist, lässt den Code aus.

**Zwei-Faktor-Authentifizierung** ist nicht aktiviert. Für eine private Installation mit
einem einzigen Konto, langem Passwort und Rate Limiting ist der Nutzen gering, der
Aufwand bei Geräteverlust aber hoch. Das Datenmodell ist vorbereitet; wenn du es
willst, lässt es sich nachrüsten.

**Kein Virenscanner.** Ein echter Scan bräuchte ClamAV auf dem Server. Stattdessen:
strenge Positivliste erlaubter Typen und Prüfung des tatsächlichen Dateiinhalts.
Das verhindert ausführbare Dateien zuverlässig, ersetzt aber keinen Scanner.

**Keine zusätzliche Verschlüsselung der Dokumente.** Sie liegen im Klartext in der Datenbank,
geschützt durch die Zugriffskontrolle der App und die Verschlüsselung des Anbieters im Ruhezustand.
Eine eigene Verschlüsselung würde einen Schlüssel verlangen, der beim Verlust alle Dokumente
unlesbar macht.

## Was du selbst tun solltest

- Ein langes, einmaliges Passwort verwenden und im Passwortmanager ablegen
- Das Datenbankpasswort nicht anderweitig benutzen
- Das Repository auf GitHub **privat** halten
- Prüfen, dass in `Settings → Environment Variables` keine Werte versehentlich als "Public" markiert sind
- Regelmässig ein Backup ziehen, siehe [BACKUP.md](BACKUP.md)
- Node.js-Version aktuell halten und Abhängigkeiten gelegentlich erneuern

## Im Verdachtsfall

1. Passwort ändern – das beendet alle Sitzungen sofort
2. Unter Verwaltung die aktiven Sitzungen und das Protokoll prüfen
3. Datenbankpasswort beim Anbieter erneuern (Neon: Projekt → **Roles** → Passwort zurücksetzen) und in den Umgebungsvariablen eintragen
4. Neu veröffentlichen (Vercel: **Deployments** → oberster Eintrag → **Redeploy**)
