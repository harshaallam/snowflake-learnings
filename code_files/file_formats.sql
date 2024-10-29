CREATE OR REPLACE SCHEMA DW_SNOWFLAKE_DE.file_formats;

CREATE OR REPLACE FILE FORMAT DW_SNOWFLAKE_DE.file_formats.my_file_format;
--defautly creates my_file_format as csv 

DESC FILE FORMAT DW_SNOWFLAKE_DE.file_formats.my_file_format;

--updating skip_header value to 1 as by default created with 0
ALTER FILE FORMAT  DW_SNOWFLAKE_DE.file_formats.my_file_format set skip_header=1, field_optionally_enclosed_by='"';


CREATE OR REPLACE FILE FORMAT my_file_format1
TYPE=CSV
FIELD_DELIMITER=','
SKIP_HEADER=1
FIELD_OPTIONALLY_ENCLOSED_BY='"';

DESC FILE FORMAT DW_SNOWFLAKE_DE.PUBLIC.EXTERNAL_STAGE_AWS;


SELECT * FROM FILE_VIEW limit 5;


create or replace view  file_view AS(
select s.$1 as order_id, s.$2 as amount, s.$3 as profit,
CASE WHEN CAST(s.$3 as integer) < 0 THEN 'not profit' ELSE 'profit' END as category
from @DW_SNOWFLAKE_DE.PUBLIC.EXTERNAL_STAGE_AWS S
);
