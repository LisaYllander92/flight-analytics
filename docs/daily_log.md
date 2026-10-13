## Här skriver vi vad som gjorts under dagen.

```md
## Datum - Rubrik

### Medverkande:

**Beskrivning:**
**Information:** - vilken fil du jobbat i - var finns ytterligare information - ex mapp/fil
```

---

## 08/10 "setup uv, python package och install dependencies"

### Medverkande: Lisa, Rickard, Miranda, Filippa

**Beskrivning:** skapade uv med "uv init --no-package --python 3.13"

- OBS: KÖR UV SYNC
  Information: se pyproject.toml

---

## 09/10 "hämta data och börja göra eda"

### Medverkande: Lisa, Rickard, Miranda

**Beskrivning:** Vi har hämtat datan för att göra eda. Fyll gärna på (undersök mera).
För eda (svedavia) så testade vi bara med arrivals, ej departures.

**Information:**

- Se i uppdatering-kanalen i discord för .env info
- Se eda-filer under eda-mappen

## 09/10 "Hämta datan med 3 dates & alla Svedavia-flygplatser"

### Medverkande: Miranda

**Beskrivning:**
I eda_svedavia.ipynb har funktioner lagst till för att :

- Läsa in IDAG, IGÅR & I FÖRRGÅR som datum (gick inte att läsa 3 dagar bakåt..)
- Läsa in alla Svedavias flygplatser
- Hämta dem med hjälp av URL:en & API nyckel
- Få en dataFrame med arrivals
- Få en dataframe med departures

**Information:**

- Datumen är från dagen man hämtar och två dagar bakåt (inga prefixa datum)
- I DataFrame gjorde även två kolumner: "Swedavia_airport_name" & "Date_fetched" för att se datum för hämtning och Swedavia fygplats-namn

---

## 11/10 "EDA flight status (arrivals)"

### Medverkande: Rickard

**Beskrivning:** Undersökte kolumnen `remarksEnglish` för arrivals (flight status). Varje flyg har 0, 1 eller 2 meddelanden: ett om flygets status och ett om bagage. Varje meddelande har en tag, NEUTRAL eller NEGATIVE. NEGATIVE är 11 inställda flyg + 9 flyg med ny tid (Arrives/Estimated), troligen försenade men inte verifierat. Inget "Delayed"-meddelande finns för arrivals.

**Information:**

- Fil: `eda/eda_svedavia.ipynb`, se avsnittet "Summary: flight status (arrivals)"
- Kvar att göra: jämföra de 9 flygen med planerad tid, och göra samma undersökning för departures

---

## 11/10 "Hur vi räknar försening"

### Medverkande: Alexandra

**Beskrivning:** Eftersom arrivals inte har något "Delayed"-meddelande räknar vi försening från tiderna i stället.

- Försening = faktisk tid (eller beräknad tid om flyget inte landat/startat än) minus planerad tid
- Försenat = 15 min sent eller mer (kan ändras i `DELAY_THRESHOLD_MIN`)
- Inställda och borttagna flyg får ingen försening, de har egna kolumner
- Funktionen `add_delay` lägger till kolumnerna: `delay_minutes`, `is_cancelled`, `is_deleted`, `has_time`, `is_delayed` och `flight_date`
- `flight_date` = planerad tid i svensk tid. Vi använder den i stället för `Date_fetched`, som bara är datumet vi frågade API:t om
- Dubbletter (samma flyg på två datum, runt midnatt) är borttagna
- Kollade mot Swedavias egna varningar (NEGATIVE): de stämmer med vår definition, men de hittar bara 12 av 141 försenade arrivals. Därför är tiderna bättre

**Information:**

- Fil: `eda/eda_swedavia.ipynb`, se avsnittet "Delay definition"
- Kvar att göra: gruppen behöver godkänna 15 min och `flight_date`. Sen ska samma regler in i dbt

## 13/10 - DM model

### Medverkande: Miranda, Lisa, Filippa, Rickard

**Beskrivning:**
Skapat dbml i db-diagram med fact och dim-tables.

**Information:**

- Mapp dm-model med png bild på modellen samt dbml-fil för koden.
