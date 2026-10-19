import dagster as dg
from orchestration.defs.jobs.jobs import job_dlt, job_dbt


# ---------------------------------------------------------------
# Sensor: start the dbt job when the dlt job has finished
# ---------------------------------------------------------------

@dg.run_status_sensor(
    # Only react when the monitored job ends with SUCCESS.
    # If the dlt job fails, the sensor does nothing and dbt is not run.
    run_status=dg.DagsterRunStatus.SUCCESS,
    # The job to watch: the one the scheduale starts (all four dlt assets)
    monitored_jobs=[job_dlt],
    # The job to launch when the condition is met.
    request_job=job_dbt,
    # Sensor are OFF by default. This turns it on automatically
    default_status=dg.DefaultSensorStatus.RUNNING,
)

def dlt_success_sensor(context: dg.RunStatusSensorContext):
    # Log which run triggered us, which helps when debugging in the UI.
    context.log.info(f"dlt run {context.dagster_run.run_id} succeeded, starting dbt")
    # Yield starts the job givin in request_job above.
    yield dg.RunRequest()