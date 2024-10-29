create or replace database demo_db;

create or replace table demo_db.public.emp_mask
clone dw_snowflake_de.pipes.employee;

select * from emp_mask limit 5;

--create a role

create or replace role ENGINEER_FULL;
create or replace role ENGINEER_MASKED;

--grant the below privileges to the roles 

GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE ENGINEER_FULL;
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE ENGINEER_MASKED;

GRANT USAGE ON DATABASE DEMO_DB TO ROLE ENGINEER_FULL;
GRANT USAGE ON DATABASE DEMO_DB TO ROLE ENGINEER_MASKED;

GRANT USAGE ON SCHEMA DEMO_DB.PUBLIC TO ROLE ENGINEER_FULL;
GRANT USAGE ON SCHEMA DEMO_DB.PUBLIC TO ROLE ENGINEER_MASKED;

GRANT SELECT ON TABLE DEMO_DB.PUBLIC.EMP_MASK TO ROLE ENGINEER_FULL;
GRANT SELECT ON TABLE DEMO_DB.PUBLIC.EMP_MASK TO ROLE ENGINEER_MASKED;

--grant the roles to access the user

GRANT ROLE ENGINEER_FULL TO USER SA9KG;
GRANT ROLE ENGINEER_MASKED TO USER SA9KG;

--crate a masking policy 
CREATE OR REPLACE MASKING POLICY mask_policy
    as (val varchar) returns varchar ->
        case
        when current_role() in ('ACCOUNTADMIN') THEN val
        ELSE '##-##-##'
        end;
      
--add the masking policy to a column or columns
ALTER TABLE DEMO_DB.PUBLIC.EMP_MASK MODIFY COLUMN EMAIL 
SET MASKING POLICY MASK_POLICY;

--change the role and try accessing the data, here ENGINEER_FULL does not have the access to view the original data, hence masked data only visible
-- Likewise apply masking policy to the required columns
USE ROLE ENGINEER_FULL;
SELECT * FROM EMP_MASK LIMIT 5;

CREATE OR REPLACE MASKING POLICY mask_last2
    as (val varchar) returns varchar ->
        case
        when current_role() in ('ACCOUNTADMIN') THEN val
        ELSE concat(left(val,2),'*******')
        end;

ALTER TABLE EMP_MASK MODIFY COLUMN LAST_NAME 
SET MASKING POLICY mask_last2;

USE ROLE ENGINEER_FULL;
SELECT * FROM EMP_MASK LIMIT 5;


--cannot undrop the masking policies directly as there as in run or assignment is in progress to the columns.
-- So unmask it and then undrop it

--unset masking policy will remove all kinds of masking polices affecting on that column
--Change it back to ACCOUNTADMIN, as ENGINEER_ROLE does not has the privelege or executing the below commands
USE ROLE ACCOUNTADMIN;
ALTER TABLE DEMO_DB.PUBLIC.EMP_MASK MODIFY COLUMN EMAIL 
UNSET MASKING POLICY;
ALTER TABLE EMP_MASK MODIFY COLUMN LAST_NAME
UNSET MASKING POLICY;

DROP MASKING POLICY MASK_POLICY;
DROP MASKING POLICY MASK_LAST2;