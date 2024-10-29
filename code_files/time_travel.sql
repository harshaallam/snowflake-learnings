CREATE OR REPLACE SCHEMA DW_SNOWFLAKE_DE.TIME_TRAVEL;

CREATE OR REPLACE TABLE employee_timetravel(
id INTEGER,
first_name varchar(50),
last_name varchar(50),
email varchar(255),
location varchar(255),
department varchar(255)
);


CREATE FILE FORMAT timetravel_fileformat
TYPE=CSV
SKIP_HEADER=1
FIELD_DELIMITER=','
FIELD_OPTIONALLY_ENCLOSED_BY='"'
NULL_IF=('NULL','null');

CREATE OR REPLACE STAGE timetravel_stage
URL='s3://dw-snowflake-de/snowpipe/'
STORAGE_INTEGRATION=snowflake_s3_integration
FILE_FORMAT=timetravel_fileformat;

COPY INTO employee_timetravel
FROM @timetravel_stage
files=('employee_data_1.csv')

select *from employee_timetravel;


update employee_timetravel set last_name='Allam';

select * from employee_timetravel at (offset=> -60*8);

create or replace table employee_timetravel1 as (
select * from employee_timetravel at (offset => -60*9)
)
select * from employee_timetravel1;

-- rather than loading into the original table after time tarvelling, better to use an temperoray table 'employee_timetravel1' to store and then load the data to original table. Because sometimes timestamp columns in the original table gets misloaded

truncate employee_timetravel;
insert into employee_timetravel
(select * from employee_timetravel1);

select * from employee_timetravel;