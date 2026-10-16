with src_airports as (select * from {{ source('wikipedia', 'airports') }})
-- hämta hela rawtabellen
select
    IATA_CODE as airport_iata, -- ta bort mellanslag, gör om tom text till null och byt namn
    AIRPORT as airport_name,
    LOCATION as city
from src_airports
