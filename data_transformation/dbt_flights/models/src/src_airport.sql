with src_airports as (select * from {{ source('wikipedia', 'airports') }})
-- hämta hela rawtabellen
select
    nullif(trim(IATA_CODE), '') as airport_iata, -- ta bort mellanslag, gör om tom text till null och byt namn
    nullif(trim(AIRPORT), '') as airport_name,
    nullif(trim(LOCATION), '') as city
from src_airports
-- behåll bara flygplatser som har minst en kod
where nullif(trim(IATA_CODE), '') is not null
