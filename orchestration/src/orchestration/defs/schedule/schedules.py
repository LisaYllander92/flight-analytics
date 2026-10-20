import dagster as dg

from orchestration.defs.jobs.jobs import job_dlt

# Daily schedule that runs 06.00 every day using the job_dlt
daily_schedule_dlt = dg.ScheduleDefinition(
    job=job_dlt,
    cron_schedule="0 6 * * *",
    execution_timezone="Europe/Stockholm",
    # to run it automatically
    default_status=dg.DefaultScheduleStatus.RUNNING
)
