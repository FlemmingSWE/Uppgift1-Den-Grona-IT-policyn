# Uppgift-1-Den-Grona-IT-policyn
Att snabbt etablera agila rutiner och kombinera detta med scripting.

# 🌿 Grön IT-policy – PowerShell-modul för nätverksinventering

> **Projektmetodik och förändringsledning | Hyperdrive Scrum | Vecka 23**

---

## 📌 Product Vision
Vi vill skapa en PowerShell-baserad Grön IT-lösning som hjälper administratörer att identifiera inaktiva datorer i nätverket och schemalägga avstängning för att minska onödig energiförbrukning.

---

## 🎯 Vad gör modulen?

Modulen löser ett konkret problem: datorer lämnas påslagna i onödan — på natten, under helger, och när ingen använder dem. Det slösar energi och kostar pengar.

Vårt PowerShell-script:

1. **Inventerar nätverket** – Skannar det lokala nätverket med WMI/CIM och listar anslutna maskiner
2. **Identifierar inaktiva maskiner** – Kontrollerar senaste aktivitet och pingar maskiner för att avgöra om de används
3. **Schemalägger avstängning** – Skickar ett kontrollerat avstängnings- eller vilolägeskommando till inaktiva maskiner
4. **Loggar allt** – Varje händelse skrivs till en loggfil med tidsstämpel så att åtgärder kan spåras i efterhand

---

## 🛠️ Teknisk stack

| Teknik | Användning |
|--------|------------|
| PowerShell | Huvudspråk för all scripting |
| WMI / CIM | Hämta systeminformation från lokala och fjärranslutna maskiner |
| GitHub Projects | Scrum-tavla och uppgiftsspårning |
| Git / GitHub | Versionshantering och kodlagring |

---

## ⚙️ Krav för att köra modulen

- Windows med PowerShell 5.1 eller senare
- Administratörsbehörighet (krävs för nätverksskanning och avstängning)
- Åtkomst till ett lokalt nätverk (hemnätverk fungerar utmärkt för demo)

---

## 🚀 Kom igång

Viktigt att köra Powershell som "administratör"!

powershell
# 1. Klona repot
git clone https://github.com/FlemmingSWE/Uppgift1-Den-Grona-IT-policyn.git

# 2. Navigera till mappen som skapats.
cd Uppgift1-Den-Grona-IT-policyn

# 3. Kör basscriptet (Sprint 0)
.\basescript.ps1
```



---

## 📅 Sprint-översikt (Product Roadmap)

| Sprint | Dag | Mål | Inkrement |
|--------|-----|-----|-----------|
| Sprint 0 | Fredag | Sätta upp miljö + Scrum-struktur | Basscript som loggar systeminfo till fil |
| Sprint 1 | Måndag | Automatisera strömsparfunktion | Scriptet kan stänga av / försätta i viloläge |
| Sprint 2 | Tisdag | Nätverksskanning | Scriptet hittar alla datorer på nätverket |
| Sprint 3 | Onsdag | Identifiera inaktiva maskiner | Scriptet avgör vilka maskiner som är inaktiva |
| Redovisning | Torsdag | Demo av färdig produkt | Komplett, körbar PowerShell-modul |

---

## 📁 Projektstruktur


gron-it-policy/
│
├── README.md               ← Du läser den just nu
├── basescript.ps1          ← Sprint 0: Loggar systeminfo
├── shutdown-module.ps1     ← Sprint 1: Hanterar avstängning
├── network-scan.ps1        ← Sprint 2: Skannar nätverket
├── inactive-detection.ps1  ← Sprint 3: Hittar inaktiva maskiner
└── logs/
    └── system.log          ← Genereras automatiskt vid körning
```

---

## 🔄 Hur vi arbetar (Scrum i Hyperdrive)

Vi kör **1-dags-sprintar** med följande dagliga struktur:

- **08:00** – Daily Scrum (15 min): Vad gjorde vi igår? Vad gör vi idag? Finns det hinder?
- **08:15** – Sprintplanering: Vi drar User Stories till "In Progress" på GitHub-tavlan
- **09:15–15:30** – Sprintgenomförande: Kodning, testning, dokumentation
- **15:30** – Sprint Review: Vi demonstrerar körbar kod
- **15:45** – Sprint Retrospektiv: Vad fungerade? Vad förbättrar vi?

> Alla uppgifter spåras på vår [GitHub Project Board](https://github.com/FlemmingSWE/Uppgift1-Den-Grona-IT-policyn.git) i realtid.

---

## 👥 Team

| Namn | Roll |
|------|------|
| [William Minnert] | Scrum Master |
| [Flamur Mehmeti] | Product owner |
| [Oskar Wågman] | Utvecklare |
| [Anna Ljungkvist] | Utvecklare |

---

## 📝 Sprint-reflektioner

*(Fylls i löpande av Scrum Master efter varje Sprint Review och Retrospektiv)*

### Sprint 0 – Fredag
**Sprint Review:** *Vad levererade vi idag?*
> ...

**Sprint Retrospektiv:** *Vad fungerade bra? Vad förbättrar vi?*
> ...

### Sprint 1 – Måndag
**Sprint Review:** *Vad levererade vi idag?*
> ...

**Sprint Retrospektiv:** *Vad fungerade bra? Vad förbättrar vi?*
> ...

### Sprint 2 – Tisdag
**Sprint Review:** *Vad levererade vi idag?*
> ...

**Sprint Retrospektiv:** *Vad fungerade bra? Vad förbättrar vi?*
> ...

### Sprint 3 – Onsdag:
**Sprint Review:** *Vad levererade vi idag?*
> ...

**Sprint Retrospektiv** *Vad fungerade bra? Vad förbättrar vi?*
> ...

### Sprint 4 - Torsdag:
**Sprint Review:** *Vad levererade vi idag?*
> ...

**Sprint Retrospektiv** *Vad fungerade bra? Vad förbättrar vi?*
> ...

---
