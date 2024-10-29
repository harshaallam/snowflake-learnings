--not making use of cached results, just to have fair test of materialized view optimized data retrieval response
ALTER SESSION SET USE_CACHED_RESULT=FALSE;
ALTER WAREHOUSE COMPUTE_WH SUSPEND;
ALTER WAREHOUSE COMPUTER_WH RESUME;


create or replace transient database db_transient;

create or replace schema transient_schema;
create or replace table db_transient.transient_schema.emp_transient as
select * from DW_SNOWFLAKE_DE.PIPES.EMPLOYEE;

select * from emp_transient;

create or replace materialized view emp_mv as
select * from emp_transient;


show materialized views;
-- 'behind_by' column from the above command tells how much time the mv is behind after the origianl table emp_trasient got modified. If emp_transient gets modified, 'behind_by' is specified with some time.MV helps with pullling the modified data from mv itself without querying the source table.

update emp_transient set last_name='Allam' where id=1;

select * from emp_mv;

ALTER SESSION SET USE_CACHED_RESULT=TRUE;