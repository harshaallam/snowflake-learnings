show tables;


create or replace table employee_clone
clone employee;

select * from employee_clone;

update employee_clone set last_name='Allam';

select * from employee;

--employee_clone is exactly the same table as employee, cloned table uses the same resources and creates a new table,
--modifying data in clone table will not affect the original table

update employee set first_name='Harsha';

select * from employee_clone;
--modifying original talble also won't affect the clone table, so better to create a clone table and work on it rather than working on original table while experimenting with code

select * from employee at (offset => -60*5);

truncate employee;
insert into employee
select * from employee at (offset => -60*5);

select * from employee;

-- simillarly we can do the same with schemas and databases as well
create or replace schema pipes_clone
clone pipes;

create or replace database DW_SNOWFLAKE_DE_CLONE
CLONE DW_SNOWFLAKE_DE;

drop table employee_clone;
drop schema pipes_clone;
drop database DW_SNOWFLAKE_DE_CLONE;