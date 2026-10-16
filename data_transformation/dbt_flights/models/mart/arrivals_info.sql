with 
    fct_arrivals as (select * from {{ ref('fct_arrivals') }}),
    dim_airline as (select * from {{ ref('dim_airline') }}),
    dim_airport as (select * from {{ ref('dim_airport') }}),
    dim_date as (select * from {{ ref('dim_date') }})
select
    d.date,
    fa.flight_status,
    fa.data_fetched_date,
    da.airline_name,
    da.country,
    fa.scheduled_arrival_utc,
    fa.actual_arrival_utc,
    fa.delay_minutes,
    fa.is_delayed
from fct_arrivals fa
left join dim_date d on fa.date_id = d.date_id
left join dim_airline da on fa.airline_id = da.airline_id
where d.date = '2026-10-15'


