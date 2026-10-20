-- 1. Create roles 
USE ROLE USERADMIN;
CREATE ROLE IF NOT EXISTS flight_dlt_role;
CREATE ROLE IF NOT EXISTS flight_dbt_role;

-- 2. Grants to role and users 
USE ROLE SECURITYADMIN;
GRANT ROLE flight_dlt_role TO ROLE SYSADMIN;
GRANT ROLE flight_dbt_role TO ROLE SYSADMIN;
GRANT ROLE flight_dlt_role TO USER developer;
GRANT ROLE flight_dbt_role TO USER developer;

-- 3. Warehouse grants 
GRANT USAGE ON WAREHOUSE swedavia_wh TO ROLE flight_dlt_role;
GRANT USAGE ON WAREHOUSE swedavia_wh TO ROLE flight_dbt_role;

-- 4. dlt: grants
GRANT USAGE ON DATABASE swedavia_db TO ROLE flight_dlt_role;
GRANT CREATE SCHEMA ON DATABASE swedavia_db TO ROLE flight_dlt_role;
GRANT USAGE, CREATE TABLE ON SCHEMA swedavia_db.staging TO ROLE flight_dlt_role;

-- 5. dbt: grants 
GRANT USAGE ON DATABASE swedavia_db TO ROLE flight_dbt_role;
GRANT CREATE SCHEMA ON DATABASE swedavia_db TO ROLE flight_dbt_role;
GRANT USAGE ON SCHEMA swedavia_db.staging TO ROLE flight_dbt_role;
GRANT SELECT ON ALL TABLES IN SCHEMA swedavia_db.staging TO ROLE flight_dbt_role;
GRANT SELECT ON FUTURE TABLES IN SCHEMA swedavia_db.staging TO ROLE flight_dbt_role;

--- 6. Tests 
USE ROLE flight_dlt_role;
SELECT * FROM swedavia_db.staging.departures;
SELECT FROM swedavia_db.staging._dlt_loads ORDER BY inserted_at DESC;

select * from swedavia_db.staging.departures 
where query_date ='2026-10-12'
limit 10; 