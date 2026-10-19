# DBT Assets


from pathlib import Path
from dagster_dbt import DbtCliResource, DbtProject, dbt_assets
import dagster as dg

# Path to the dbt project (the folder that contains dbt_project.yml)
dbt_project_directory = (
    Path(__file__).resolve().parents[5] / "data_transformation" / "dbt_flights"
)

# Folder that contains profiles.yml (Snowflake connection settings)
profiles_dir = Path.home() / ".dbt"

# Tell Dagster where the dbt project and the profile are
dbt_project = DbtProject(
    project_dir=dbt_project_directory,
    profiles_dir=profiles_dir,
)

# In dev, Dagster runs "dbt parse" automatically to create target/manifest.json
dbt_project.prepare_if_dev()


# Create dbt assets
# Turn the dbt models into dagster asset
# Path to the manifest.json file
@dbt_assets(manifest=dbt_project.manifest_path)
def dbt_models(context: dg.AssetExecutionContext, dbt: DbtCliResource):
    # dbt build
    yield from dbt.cli(["build"], context=context).stream()
