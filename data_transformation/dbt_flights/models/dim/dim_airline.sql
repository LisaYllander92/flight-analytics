with src_airline as (select * from {{ ref('src_airline') }}

),
missing_airline as (
    select
        COALESCE(airline_iata, 'Missing') as airline_iata,
        COALESCE(airline_icao, 'Missing') as airline_icao,
        COALESCE(airline_name, 'Missing') as airline_name,
        COALESCE(country, 'Missing') as country,
    from src_airline

),
duplicated_airline as (
    select *
    from missing_airline
    qualify row_number() over(partition by airline_iata order by airline_name, airline_icao,country) = 1

)
    select
    {{ dbt_utils.generate_surrogate_key(['airline_iata']) }} as airline_id,
        airline_iata,
        airline_icao,
        airline_name,
        country
    from duplicated_airline


