with src_arrivals as (select * from {{ source('swedavia', 'arrivals') }})


select 
    FLIGHT_ID as flight_number, {# use this to create an arrival_id #}
    LOCATION_AND_STATUS__FLIGHT_LEG_STATUS_ENGLISH as flight_status, 
    ARRIVAL_TIME__SCHEDULED_UTC as schedueled_arrival, 
    ARRIVAL_TIME__ACTUAL_UTC as actual_arrival
from src_arrivals

