with src_airport as (select * from {{ ref('src_airport') }})

select
    {{ dbt_utils.generate_surrogate_key(['airport_iata']) }} as airport_id,
    upper(trim(airport_iata)) as airport_iata,
    trim(coalesce(airport_name, 'Missing')) as airport_name,
    trim(coalesce(city, 'Missing')) as city
from src_airport
where airport_iata is not null
