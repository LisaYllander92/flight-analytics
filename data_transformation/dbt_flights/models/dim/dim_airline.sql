with src_airline as (select * from {{ ref('src_airline') }})

select
    {{ dbt_utils.generate_surrogate_key(['airline_iata']) }} as airline_id,
    airline_iata,
    airline_icao,
    airline_name,
    country
from src_airline