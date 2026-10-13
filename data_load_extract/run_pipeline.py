
#################
# PIPELINE#
#################

# This part will be replaced by only the dlt-source

# The pipeline will instead be running in the orchestration definitions - part

import dlt
import os
from pathlib import Path
from get_swedavia_data import flights_source, SWE_AIRPORTS, DATES
from get_wikipedia_data import airline_codes_resource, airport_codes_resource


def run_pipeline():
    pipeline = dlt.pipeline(
        pipeline_name="swedavia_flights",
        destination="snowflake",
        dataset_name="staging",
    )

    load_info = pipeline.run(
        [
            flights_source(airports=SWE_AIRPORTS.keys(), dates=DATES),
            airport_codes_resource(),
            airline_codes_resource()
        ]
    )

    print(load_info)


if __name__ == "__main__":
    working_directory = Path(__file__).parent.parent / "orchestration"
    os.chdir(working_directory)

    run_pipeline()
