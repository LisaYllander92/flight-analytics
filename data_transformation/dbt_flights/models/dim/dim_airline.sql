with src_airline as (select * from {{ ref('src_airline') }}

)
select
    {{ dbt_utils.generate_surrogate_key(['airline_iata']) }} as airline_id,
    airline_iata,
    max(COALESCE(airline_icao, 'Missing')) as airline_icao,
    max(trim (COALESCE(airline_name, 'Missing'))) as airline_name,
    max(trim (COALESCE(airline_country, 'Missing'))) as airline_country,
from src_airline
where airline_iata is not null
    or airline_icao is not null
group by airline_iata


