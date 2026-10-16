with date_spine as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2026-01-01' as date)",
        end_date="dateadd(year, 1, current_date)" 
    ) }}
)

select
    {{ dbt_utils.generate_surrogate_key(['cast(date_day as date)']) }} as date_id,
    cast(date_day as date) as date,
    year(date_day)         as year,
    month(date_day)        as month,
    day(date_day)          as day
from date_spine