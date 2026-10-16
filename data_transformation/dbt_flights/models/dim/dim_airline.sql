with src_airline as (select * from {{ ref('src_airline') }}

)
select
    {{ dbt_utils.generate_surrogate_key(['airline_iata']) }} as airline_id,
    COALESCE(airline_iata, 'Missing') as airline_iata,
    COALESCE(airline_icao, 'Missing') as airline_icao,
    trim (COALESCE(airline_name, 'Missing')) as airline_name,
    trim (COALESCE(country, 'Missing')) as country,
from src_airline
where airline_iata is not null
    or airline_icao is not null


