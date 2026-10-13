
#################
# PIPELINE#
#################

# This part will be replaced by only the dlt-source

# The pipeline will instead be running in the orchestration definitions - part

import dlt
import os
from pathlib import Path
from get_swedavia_data import flights_source, SWE_AIRPORTS, DATES


def run_pipeline():
    pipeline = dlt.pipeline(
        pipeline_name="swedavia_flights",
        destination="snowflake",
        dataset_name="staging",
    )

    load_info = pipeline.run(
        flights_source(aiports=SWE_AIRPORTS.keys(), dates=DATES)
    )

    print(load_info)


if __name__ == "__main__":
    working_directory = Path(__file__).parent.parent
    os.chdir(working_directory)

    run_pipeline()
