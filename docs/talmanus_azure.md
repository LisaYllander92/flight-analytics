# Talmanus: Deploy till Azure (video)

Format: **Säg** = det du pratar om. **Visa** = vad som ska synas på skärmen. Tid: ca 8–10 min, trimma efter behov. Dölj alla lösenord/värden i videon (blurra eller visa bara namnen).

---

## 0. Intro (ca 30 s)

**Visa:** Repot i GitHub eller VS Code.

**Säg:** "Hej, jag visar hur vi deployar vårt projekt till Azure. Vi har två delar. Dagster, som kör dlt och dbt och orkestrerar pipelinen, körs som en Container App. Streamlit-dashboarden körs som en Web App. Båda är Docker-images som ligger i Azure Container Registry. Jag går igenom stegen i ordning: förbereda lokalt, pusha images, skapa resurserna i Azure och sätta miljövariabler."

---

## 1. Förberedelser lokalt (ca 1,5 min)

**Visa:** `docker-compose.yml` och `.env` (utan värden synliga).

**Säg:** "Vi har två Dockerfiles: `dockerfile.dwh` för Dagster och `dockerfile.dashboard` för Streamlit. I docker-compose bygger vi båda. Varje tjänst har en `image`-rad som börjar med `ACR_LOGIN_SERVER`, alltså adressen till vårt registry i Azure. Den variabeln ligger i `.env`, så att image-namnet blir rätt när vi pushar.

Notera `env_file: .env`. Det fungerar bara när vi kör lokalt med Docker. `.env` kopieras inte in i imagen, eftersom den innehåller hemligheter och ligger i `.dockerignore`. Det betyder att Azure inte kan se filen, och det är därför vi senare måste lägga in variablerna manuellt i portalen."

---

## 2. Bygg och testa lokalt (ca 1 min)

**Visa:** Docker Desktop öppet, terminalen.

**Säg:** "Först ser jag till att Docker Desktop är igång. Sedan bygger jag och startar containrarna."

```bash
docker compose build
docker compose up
```

**Visa:** Öppna localhost:3000 (Dagster) och localhost:8501 (Streamlit). Visa gärna en materialize.

**Säg:** "Allt fungerar lokalt, och det är exakt detta vi vill få att fungera i Azure."

---

## 3. Container Registry och push (ca 1,5 min)

**Visa:** Azure-portalen → Container registries → vårt registry → Access keys (Admin user på).

**Säg:** "I samma resource group har jag skapat ett Azure Container Registry. Jag har aktiverat Admin user, så att Container App och Web App kan logga in och hämta imagen."

**Visa:** Terminalen.

```bash
az login
az acr login --name <registrynamn>
docker compose push
```

**Säg:** "Jag loggar in mot Azure och registryt och pushar sedan båda images. Alternativt kan man pusha en och en med `docker push` och hela image-namnet."

**Visa:** Registry → Repositories: `dwh_pipeline` och `dashboard` med taggen `latest`.

---

## 4. Container App för Dagster (ca 2,5 min)

**Visa:** Container Apps → Create.

**Säg:** "Jag väljer samma resource group och ett namn, till exempel `dagster-container-app`, och region Sweden Central. På fliken Container avmarkerar jag quickstart-imagen och väljer Azure Container Registry. Här väljer jag vårt registry, imagen `dwh_pipeline` och taggen `latest`.

Jag ger containern lite mer resurser, 2 CPU och 4 GB minne. Dagster, dbt och dlt behöver en del minne, och för lite ger krasch.

Under Ingress aktiverar jag ingress, låter trafik komma från var som helst och sätter **target port till 3000**, eftersom det är Dagsters port."

**Visa:** Review + create. Gå sedan in i appen → Application → Containers → Edit and deploy → Environment variables.

**Säg:** "Nu kommer det viktigaste steget. Eftersom `.env` inte följer med imagen måste jag lägga in alla variabler här, med exakt samma namn som i `.env`. dbt letar till exempel efter `DESTINATION__SNOWFLAKE__CREDENTIALS__USERNAME`, och om den saknas kraschar Dagster vid start med felet *Env var required but not provided*. Därför lägger jag in användare, lösenord, host, databas, warehouse och roll, plus resten från `.env`, till exempel API-nyckeln till Swedavia.

Lösenord lägger jag som secret under Settings → Secrets, och i variabeln väljer jag *Reference a secret*. Observera att en secret i sig inte är en miljövariabel. Man måste skapa variabeln och peka på secreten.

Sedan sparar jag som ny revision. Ändringarna gäller först när den nya revisionen körs."

**Visa:** Revisions and replicas → Running. Öppna Application Url.

**Säg:** "Här ser vi Dagster UI, samma som lokalt. Jag kör en materialize för att verifiera att hela kedjan fungerar från Azure: dlt laddar till Snowflake och dbt transformerar."

---

## 5. Web App för Streamlit (ca 2 min)

**Visa:** App Services → Create → Web App.

**Säg:** "Samma resource group, ett eget namn, och Publish sätter jag till **Container**, operativsystem Linux, region Sweden Central. Ingen databas behövs. På fliken Container avmarkerar jag sidecar, väljer Azure Container Registry, imagen `dashboard` och taggen `latest`. Public access är på."

**Visa:** Web App → Settings → Environment variables.

**Säg:** "Här behövs tre saker utöver Snowflake-variablerna. `WEBSITES_PORT` sätts till 8501, eftersom Azure som standard förväntar sig en annan port. `STREAMLIT_SERVER_ADDRESS` sätts till 0.0.0.0 och `STREAMLIT_SERVER_PORT` till 8501, så att Streamlit lyssnar utåt på rätt port.

Sedan lägger jag in de variabler dashboarden använder för att ansluta till Snowflake: account, user, password, role, warehouse, database och schema. Även här gäller att Azure inte kan läsa `.env`."

**Visa:** Overview → Default domain → dashboarden.

**Säg:** "Det här är samma dashboard som lokalt, men nu hostad i Azure."

---

## 6. Felsökning och uppdateringar (ca 1 min)

**Visa:** Log stream i Container App och Web App.

**Säg:** "Om något går fel är Log stream första stället att titta. Vanligaste felen är felstavade eller saknade miljövariabler, fel port, eller för lite minne.

När jag ändrar kod bygger jag och pushar om imagen med `docker compose build` och `docker compose push`. Därefter skapar Container App en ny revision och Web App startas om."

---

## 7. Avslut (ca 15 s)

**Säg:** "Sammanfattningsvis: vi bygger och testar lokalt, pushar images till registryt, skapar en Container App för Dagster på port 3000 och en Web App för Streamlit på port 8501, och lägger in alla miljövariabler manuellt i Azure eftersom `.env` inte följer med. Tack för att ni tittade."

---

## Checklista före inspelning

- [ ] Docker Desktop igång
- [ ] Images pushade och synliga i registryt
- [ ] Container App och Web App skapade och körande
- [ ] Inga lösenord/API-nycklar synliga i bild (dölj värden)
- [ ] Dagster-materialize testad i Azure
- [ ] Dashboard öppen i webbläsaren och fungerar