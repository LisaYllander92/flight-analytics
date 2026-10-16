with src_arrivals as (select * from {{ ref('src_arrivals') }})

select
    {{ dbt_utils.generate_surrogate_key([
        'flight_number',
        'flight_departure_date_utc',
        'departure_airport_iata',
        'arrival_airport_iata'
    ]) }} as arrival_id,
    flight_number,
    {{ dbt_utils.generate_surrogate_key(['cast(scheduled_arrival_utc as date)']) }} as date_id,
    {{ dbt_utils.generate_surrogate_key(['airline_iata']) }} as airline_id,
    {{ dbt_utils.generate_surrogate_key(['arrival_airport_iata']) }} as arrival_airport_id,
    {{ dbt_utils.generate_surrogate_key(['departure_airport_iata']) }} as departure_airport_id,
    flight_status_code,
    flight_status,
    scheduled_arrival_utc,
    estimated_arrival_utc,
    actual_arrival_utc,
    data_fetched_date
from src_arrivals


