-- 1. Skapa roller
USE ROLE USERADMIN;
CREATE ROLE IF NOT EXISTS flight_dlt_role;
CREATE ROLE IF NOT EXISTS flight_dbt_role;

-- 2. Hierarki och användare
USE ROLE SECURITYADMIN;
GRANT ROLE flight_dlt_role TO ROLE SYSADMIN;
GRANT ROLE flight_dbt_role TO ROLE SYSADMIN;
GRANT ROLE flight_dlt_role TO USER developer;
GRANT ROLE flight_dbt_role TO USER developer;

-- 3. Warehouse (båda behöver köra frågor)
GRANT USAGE ON WAREHOUSE swedavia_wh TO ROLE flight_dlt_role;
GRANT USAGE ON WAREHOUSE swedavia_wh TO ROLE flight_dbt_role;

-- 4. dlt: skriver rådata till staging
GRANT USAGE ON DATABASE swedavia_db TO ROLE flight_dlt_role;
GRANT CREATE SCHEMA ON DATABASE swedavia_db TO ROLE flight_dlt_role;
GRANT USAGE, CREATE TABLE ON SCHEMA swedavia_db.staging TO ROLE flight_dlt_role;

-- 5. dbt: läser staging, bygger egna scheman
GRANT USAGE ON DATABASE swedavia_db TO ROLE flight_dbt_role;
GRANT CREATE SCHEMA ON DATABASE swedavia_db TO ROLE flight_dbt_role;
GRANT USAGE ON SCHEMA swedavia_db.staging TO ROLE flight_dbt_role;
GRANT SELECT ON ALL TABLES IN SCHEMA swedavia_db.staging TO ROLE flight_dbt_role;
GRANT SELECT ON FUTURE TABLES IN SCHEMA swedavia_db.staging TO ROLE flight_dbt_role;

-- 6. Flytta ägarskap för redan skapade tabeller till dlt-rollen
--    (behövs bara om SHOW GRANTS visade en annan ägare)
GRANT OWNERSHIP ON ALL TABLES IN SCHEMA swedavia_db.staging
  TO ROLE flight_dlt_role COPY CURRENT GRANTS;



--- TEST 
USE ROLE flight_dlt_role;
SELECT * FROM swedavia_db.staging.departures;
SELECT FROM swedavia_db.staging._dlt_loads ORDER BY inserted_at DESC;

select * from swedavia_db.staging.departures 
where query_date ='2026-10-12'
limit 10; 