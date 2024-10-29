CREATE OR REPLACE SCHEMA DW_SNOWFLAKE_DE.PIPES;

CREATE OR REPLACE TABLE employee_pipe(
id INTEGER,
first_name varchar(50),
last_name varchar(50),
email varchar(255),
location varchar(255),
department varchar(255)
);

CREATE OR REPLACE FILE FORMAT pipe_fileformat
TYPE=CSV
SKIP_HEADER=1
FIELD_DELIMITER=','
FIELD_OPTIONALLY_ENCLOSED_BY='"'
NULL_IF=('NULL','null')

CREATE OR REPLACE STAGE pipe_stage
URL='s3://dw-snowflake-de/snowpipe/'
STORAGE_INTEGRATION=SNOWFLAKE_S3_INTEGRATION;

LIST @PIPE_STAGE;

COPY INTO EMPLOYEE_PIPE
FROM @DW_SNOWFLAKE_DE.PIPES.PIPE_STAGE
FILE_FORMAT=(FORMAT_NAME=pipe_fileformat)
FILES=('employee_data_1.csv');

select * from employee_pipe;

CREATE OR REPLACE PIPE pipe_s3
AUTO_INGEST=TRUE
AS
COPY INTO EMPLOYEE_PIPE
FROM @DW_SNOWFLAKE_DE.PIPES.PIPE_STAGE
FILE_FORMAT=(FORMAT_NAME=pipe_fileformat);



DESC PIPE pipe_s3;

-- take value of 'notification channel' from the desc command and give it in the 'event notifications' segment's 'SQS Queue Arn' in S3 bucket's properties.
-- the pipe loads the data into table when a file is available in the bucket location, according to the copy command written while the creation of the snow pipe.