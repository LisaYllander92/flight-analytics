with src_departures as (select * from {{ source('swedavia', 'departures') }})

select
FLIGHT_ID as flight_number,
LOCATION_AND_STATUS__FLIGHT_LEG_STATUS_ENGLISH as flight_status,
AIRLINE_OPERATOR__IATA as airline_iata,
AIRLINE_OPERATOR__NAME as airline_name,
FLIGHT_LEG_IDENTIFIER__DEPARTURE_AIRPORT_IATA as departure_airport_iata,
FLIGHT_LEG_IDENTIFIER__ARRIVAL_AIRPORT_IATA as arrival_airport_iata,
DEPARTURE_TIME__SCHEDULED_UTC as scheduled_departure_utc,
DEPARTURE_TIME__ESTIMATED_UTC as estimated_departure_utc,
DEPARTURE_TIME__ACTUAL_UTC as actual_departure_utc,
DATA_FETCHED_DATE as data_fetched_date,
FLIGHT_LEG_IDENTIFIER__FLIGHT_DEPARTURE_DATE_UTC as leg_departure_date_utc
from src_departures

