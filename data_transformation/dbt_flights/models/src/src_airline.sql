with src_airlines as (select * from {{ source('wikipedia', 'airlines') }})
-- hämta hela rawtatabellen
select
    nullif(trim(iata), '') as airline_iata, -- ta bort mellanslag, gör om tom text till null och byt namn
    nullif(trim(icao), '') as airline_icao,
    nullif(trim(airline), '') as airline_name,
    nullif(trim(country_region), '') as country
from src_airlines
-- behåll bara flygbolag som har minst en kod (extra filter för att ta bort onödigt små bolag)
where nullif(trim(iata), '') is not null
    or nullif(trim(icao), '') is not null
