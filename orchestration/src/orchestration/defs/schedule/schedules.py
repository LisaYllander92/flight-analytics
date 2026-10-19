import dagster as dg

from orchestration.defs.jobs.jobs import job_dlt

daily_schedule_dlt = dg.ScheduleDefinition(
    job = job_dlt,
    cron_schedule = "0 6 * * *",
    execution_timezone = "Europe/Stockholm",
)