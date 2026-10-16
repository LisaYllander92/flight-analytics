with 
    fct_departures as (select * from {{ ref('fct_departures') }}),
    dim_airline as (select * from {{ ref('dim_airline') }}),
    dim_airport as (select * from {{ ref('dim_airport') }}),
    dim_date as (select * from {{ ref('dim_date') }})
select
    al.airline_name,
    al.airline_country,
    ap.airport_name,
    d.date,
    fd.flight_status,
    fd.scheduled_departure_utc,
    fd.actual_departure_utc,
    datediff('minute', fd.scheduled_departure_utc, fd.actual_departure_utc) as delay_minutes,
    coalesce(delay_minutes >= 15, false) as is_delayed
from fct_departures fd
left join dim_date d on fd.date_id = d.date_id
left join dim_airline al on fd.airline_id = al.airline_id
left join dim_airport ap on fd.departure_airport_id = ap.airport_id
WHERE flight_status != 'Deleted'



