create or replace table employee(
id INTEGER,
first_name varchar(50),
last_name varchar(50),
email varchar(255),
location varchar(255),
department varchar(255)
);

COPY INTO employee
from @DW_SNOWFLAKE_DE.TIME_TRAVEL.timetravel_stage
files=('employee_data_1.csv')
file_format=(TYPE=CSV SKIP_HEADER=1 FIELD_DELIMITER=',')

Select * from employee;

drop table employee;

undrop table employee;