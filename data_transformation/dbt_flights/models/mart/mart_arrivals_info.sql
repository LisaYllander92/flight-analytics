with 
    fct_arrivals as (select * from {{ ref('fct_arrivals') }}),
    dim_airline as (select * from {{ ref('dim_airline') }}),
    dim_airport as (select * from {{ ref('dim_airport') }}),
    dim_date as (select * from {{ ref('dim_date') }})
select
    al.airline_name,
    al.airline_country,
    ap.airport_name,
    d.date,
    fa.flight_status,
    fa.scheduled_arrival_utc,
    fa.actual_arrival_utc,
    datediff('minute', fa.scheduled_arrival_utc, fa.actual_arrival_utc) as delay_minutes,
    coalesce(delay_minutes >= 15, false) as is_delayed
from fct_arrivals fa
left join dim_date d on fa.date_id = d.date_id
left join dim_airline al on fa.airline_id = al.airline_id
left join dim_airport ap on fa.arrival_airport_id = ap.airport_id



