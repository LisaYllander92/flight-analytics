USE ROLE USERADMIN;
CREATE ROLE IF NOT EXISTS flight_dbt_role;
CREATE ROLE IF NOT EXISTS flight_dlt_role;

CREATE USER IF NOT EXISTS filippa
    PASSWORD = 'Gräddhyllan123' 
    DEFAULT_WAREHOUSE = swedavia_wh;

CREATE USER IF NOT EXISTS rickard
    PASSWORD = 'Gräddhyllan123' 
    DEFAULT_WAREHOUSE = swedavia_wh;

CREATE USER IF NOT EXISTS lisa
    PASSWORD = 'Gräddhyllan123' 
    DEFAULT_WAREHOUSE = swedavia_wh;

CREATE USER IF NOT EXISTS miranda
    PASSWORD = 'Gräddhyllan123' 
    DEFAULT_WAREHOUSE = swedavia_wh;

CREATE USER IF NOT EXISTS alexandra
    PASSWORD = 'Gräddhyllan123' 
    DEFAULT_WAREHOUSE = swedavia_wh;

USE ROLE SECURITYADMIN;

GRANT ROLE flight_dbt_role TO USER lisa;
GRANT ROLE flight_dbt_role TO USER miranda;
GRANT ROLE flight_dbt_role TO USER alexandra;
GRANT ROLE flight_dbt_role TO USER rickard;

GRANT USAGE ON WAREHOUSE swedavia_wh TO ROLE flight_dbt_role;
GRANT USAGE ON DATABASE swedavia_db TO ROLE flight_dbt_role;
GRANT USAGE ON SCHEMA swedavia_db.staging TO ROLE flight_dbt_role;
GRANT CREATE TABLE ON SCHEMA swedavia_db.staging TO ROLE flight_dbt_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA swedavia_db.staging TO ROLE flight_dbt_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON FUTURE TABLES IN SCHEMA swedavia_db.staging TO ROLE flight_dbt_role;

GRANT ROLE flight_dbt_role TO ROLE flight_dlt_role;

SHOW ROLES;

SHOW USERS;