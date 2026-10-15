with src_departures as (select * from {{ ref('src_departures') }})

select
    {{ dbt_utils.generate_surrogate_key([
        'flight_number',
        'flight_departure_date_utc',
        'departure_airport_iata',
        'arrival_airport_iata'
    ]) }} as departure_id,
    flight_number,
    {{ dbt_utils.generate_surrogate_key(['cast(scheduled_departure_utc as date)']) }} as date_id,
    {{ dbt_utils.generate_surrogate_key(['airline_iata']) }} as airline_id,
    {{ dbt_utils.generate_surrogate_key(['departure_airport_iata']) }} as departure_airport_id,
    {{ dbt_utils.generate_surrogate_key(['arrival_airport_iata']) }} as arrival_airport_id,
    flight_status_code,
    flight_status,
    scheduled_departure_utc,
    estimated_departure_utc,
    actual_departure_utc,
    datediff('minute', scheduled_departure_utc, actual_departure_utc) as delay_minutes,
    coalesce(datediff('minute', scheduled_departure_utc, actual_departure_utc) >= 15, false) as is_delayed,
    coalesce(lower(flight_status_code) like '%CAN%', false) as is_cancelled,
    data_fetched_date
from src_departures
