# ---------------------------------------------------------------
# Resources
# Registers the resources that the assets depend on. Dagster uses
# the key (e.g. "dlt") to match the parameter name in the asset
# functions and injects the right resource at run time.
# ---------------------------------------------------------------

# orchestration/src/orchestration/defs/resources.py
import dagster as dg
from dagster_dbt import DbtCliResource
# Reuse the resource instance we created in dlt_assets.py
from orchestration.defs.assets.dlt_assets import dlt_resource

# Reuse the dbt project object we created in dbt_assets.py
from orchestration.defs.assets.dbt_assets import dbt_project

# @dg.definitions tells Dagster's auto-discovery to pick up this function.
# Resources are NOT found automatically from module-level variables,
# so we register them explicitly here.


@dg.definitions
def resources() -> dg.Definitions:
    return dg.Definitions(
        # The key "dlt" must match the parameter name `dlt` in the
        # asset functions (dependency injection by name).
        resources={
            "dlt": dlt_resource,
            "dbt": DbtCliResource(project_dir=dbt_project),
        },
    )
