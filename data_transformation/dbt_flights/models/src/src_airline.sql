with src_airlines as (select * from {{ source('wikipedia', 'airlines') }})

select
    IATA as airline_iata,
    ICAO as airline_icao,
    AIRLINE as airline_name,
    COUNTRY_REGION as country
from src_airlines

