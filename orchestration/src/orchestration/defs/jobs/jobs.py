import dagster as dg

# Job that extracts raw data from external sources and loads it to Snowflake staging
job_dlt = dg.define_asset_job(
    name="job_dlt",
    # Select the dlt assets to run: flight data from Swedavia and reference data from Wikipedia
    selection=dg.AssetSelection.keys(
        "dlt_flights_source_arrivals",
        "dlt_flights_source_departures",
        "dlt_wikipedia_source_raw_wikipedia_airlines",
        "dlt_wikipedia_source_raw_wikipedia_airports",
    ),
    description="Extracts flight data from Swedavia and reference data from Wikipedia, loads to Snowflake staging",
)

# Job that transforms the staged data by building all dbt models in Snowflake
job_dbt = dg.define_asset_job(
    name="job_dbt",
    # Select all assets in the "default" group (the dbt models)
    selection=dg.AssetSelection.groups("default"),
    description="Builds all dbt models in Snowflake",
)
