

CREATE OR REPLACE TABLE employee1(
id INTEGER,
first_name varchar(50),
last_name varchar(50),
email varchar(255),
location varchar(255),
department varchar(255)
);

show tables;

alter table employee1 set DATA_RETENTION_TIME_IN_DAYS=10;

drop table DW_SNOWFLAKE_DE.pipes.employee1;

undrop table DW_SNOWFLAKE_DE.pipes.employee1;

--rentention time of a permanent table is made to be 0 and somehow dropped the table and retrieval(undrop) cannot be possible

alter table DW_SNOWFLAKE_DE.pipes.employee1 set DATA_RETENTION_TIME_IN_DAYS=0;

drop table DW_SNOWFLAKE_DE.pipes.employee1;

undrop table DW_SNOWFLAKE_DE.pipes.employee1;

CREATE OR REPLACE TRANSIENT TABLE emp_trans(
id int);

--rentention time cannot be modified in transient tables, as it's default value is 1, whereas for permanent tables is 90 days
alter table emp_trans set DATA_RETENTION_TIME_IN_DAYS=2;



CREATE OR REPLACE TRANSIENT SCHEMA TRANSIENT_SCHEMA;

CREATE OR REPLACE TABLE DW_SNOWFLAKE_DE.TRANSIENT_SCHEMA.employee_permanent(
id integer);

--rentention time cannot be changed for a permanent table created under transient schema, its default value is 1 day

alter table employee_permanent set DATA_RETENTION_TIME_IN_DAYS=2;

show tables;


