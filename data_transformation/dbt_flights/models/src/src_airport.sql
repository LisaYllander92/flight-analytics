with src_airports as (select * from {{ source('wikipedia', 'airports') }})
-- hämta hela rawtabellen
select
    nullif(trim(iata), '') as airport_iata, -- ta bort mellanslag, gör om tom text till null och byt namn
    nullif(trim(icao), '') as airport_icao,
    nullif(trim(airport_name), '') as airport_name,
    nullif(trim(city_served), '') as city
from src_airports
-- behåll bara flygplatser som har minst en kod
where nullif(trim(iata), '') is not null
    or nullif(trim(icao), '') is not null
