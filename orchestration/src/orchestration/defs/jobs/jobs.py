import dagster as dg

job_dlt = dg.define_asset_job(
    name="job_dlt", 
    selection=dg.AssetSelection.keys(
        "dlt_flights_source_arrivals", 
        "dlt_flights_source_departures", 
        "dlt_wikipedia_source_raw_wikipedia_airlines",
        "dlt_wikipedia_source_raw_wikipedia_airports"
), description="Extracts flight data from Swedavia and reference data from Wikipedia, loads to Snowflake staging",
)

job_dbt = dg.define_asset_job(
    name="job_dbt",
    selection=dg.AssetSelection.groups("default"
),
    description="Builds all dbt models in Snowflake",
)