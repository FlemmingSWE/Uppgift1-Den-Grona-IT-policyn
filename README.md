# Uppgift-1-Den-Grona-IT-policyn
Att snabbt etablera agila rutiner och kombinera detta med scripting.

# 🌿 Grön IT-policy – PowerShell-modul för nätverksinventering

> **Projektmetodik och förändringsledning | Hyperdrive Scrum | Vecka 23**

---

## 🌱 Produktvision

Detta projekt är en **Grön IT-lösning för Windows-domänmiljöer**.  
Syftet är att minska onödig energiförbrukning genom att automatisera hanteringen av klientdatorer som står på utan att användas.

Lösningen använder **Group Policy** för att centralt distribuera ett **PowerShell-script** till utvalda datorer i nätverket. Scriptet körs lokalt på klienterna och kan:

- kontrollera om datorn är inaktiv
- logga när scriptet har körts
- Stänga av datorn enligt organisationens energipolicy

På så sätt kan IT-administratörer hantera energibesparande åtgärder centralt, utan att behöva konfigurera varje dator manuellt.

> Målet är att skapa en enkel, skalbar och administrerbar lösning som kombinerar **Grön IT**, **automatisering** och **central styrning** i en Windows Server-miljö.

---

## 🎯 Vad gör modulen?

Modulen löser ett konkret problem: datorer lämnas påslagna i onödan — på natten, under helger, och när ingen använder dem. Det slösar energi och kostar pengar.

Vårt PowerShell-script:

1. **Inventerar nätverket** – Skannar det lokala nätverket med WMI/CIM och listar anslutna maskiner
2. **Identifierar inaktiva maskiner** – Kontrollerar senaste aktivitet och pingar maskiner för att avgöra om de används
3. **Schemalägger avstängning** – Skickar ett kontrollerat avstängningskommando till inaktiva maskiner
4. **Loggar allt** – Varje händelse skrivs till en loggfil med tidsstämpel så att åtgärder kan spåras i efterhand

---

## 🛠️ Teknisk stack

| Teknik | Användning |
|--------|------------|
| PowerShell | Huvudspråk för all scripting |
| WMI / CIM | Hämta systeminformation från AD anslutna maskiner
| GitHub Projects | Scrum-tavla och uppgiftsspårning |
| Git / GitHub | Versionshantering och kodlagring |

---

## ⚙️ Krav för att köra modulen

- Windows med PowerShell 5.1 eller senare
- Administratörsbehörighet (krävs för nätverksskanning och avstängning)
- Åtkomst till ett lokalt nätverk (hemnätverk fungerar utmärkt för demo)

---


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
| [Mohamad Sallat] | Utvecklare |

---

## 📝 Sprint-reflektioner

*(Fylls i löpande av Scrum Master efter varje Sprint Review och Retrospektiv)*

### Sprint 0 – Fredag
**Sprint Review:** *Vad levererade vi idag?*
> Vi gjorde produktvision och diskuterade övergripande kring hur vi skulle börja måndagen, vi skapade en gemensam textfil där vi brainstormade ideer och tankar.

**Sprint Retrospektiv:** *Vad fungerade bra? Vad förbättrar vi?*
> Var lite klurigt att komma in i tankesättet kring User stories och det var svårt att förstå hur vi skulle prioritera då vi inte har någon erfarenhet av att skriva kod tillsammans med andra.

### Sprint 1 – Måndag
**Sprint Review:** *Vad levererade vi idag?*
> Vi levererade färdiga script som är redo att test mergas på tisdag.

**Sprint Retrospektiv:** *Vad fungerade bra? Vad förbättrar vi?*
> Vi fördelade arbetet och kom igång med att göra det vi skulle, vi blev klara med scripten som skulle skrivas men vi kanske kan bli bättre på att synka under tidens gång.

### Sprint 2 – Tisdag
**Sprint Review:** *Vad levererade vi idag?*
> Idag testade vi att merga våra script och göra ett test i en labbmiljö, detta fungerade med lyckat resultat, vi skruvade också lite på shutdown scriptet för att mitigera risken för dataförlust.

**Sprint Retrospektiv:** *Vad fungerade bra? Vad förbättrar vi?*
> Bättre möte idag, teamet kändes mer synkade och vi hade en gemensam bild kring vad som skulle göras för dagen.

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
