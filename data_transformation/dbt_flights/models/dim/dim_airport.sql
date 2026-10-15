with src_airport as (select * from {{ ref('src_airport') }})

select
    {{ dbt_utils.generate_surrogate_key(['airport_iata']) }} as airport_id,
    airport_name,
    airport_iata,
    airport_icao,
    city
from src_airport