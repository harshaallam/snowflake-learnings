CREATE OR REPLACE SCHEMA DW_SNOWFLAKE_DE.STORAGE_INTEGRATION;

--build connection between s3 and snowflake by providing IAM roles ARN value in STORAGE_AWS_ROLE_ARN

CREATE OR REPLACE STORAGE INTEGRATION snowflake_s3_integration
TYPE =EXTERNAL_STAGE
STORAGE_PROVIDER=S3
ENABLED=TRUE
STORAGE_AWS_ROLE_ARN='arn:aws:iam::##'
STORAGE_ALLOWED_LOCATIONS=('s3://dw-snowflake-de')
COMMENT='This is an external connection to AWS S3';


DESC STORAGE INTEGRATION snowflake_s3_integration;

-- provide 'STORAGE_AWS_EXTERNAL_ID' and STORAGE_AWS_IAM_USER_ARN values that gets from above desc command's output
--in AWS IAM roles Trust relationships section at 'sts:ExternalId' and 'AWS' places respectively

-- this builds the connection but need to create stage to establish the connection to the bucket


CREATE OR REPLACE FILE FORMAT storage_init_fileformat
TYPE=CSV
SKIP_HEADER=1
FIELD_DELIMITER=','
FIELD_OPTIONALLY_ENCLOSED_BY='"'
NULL_IF=('NULL','null')
EMPTY_FIELD_AS_NULL=TRUE;

CREATE OR REPLACE STAGE storage_init_stage
URL='s3://dw-snowflake-de'
STORAGE_INTEGRATION=snowflake_s3_integration
file_format=storage_init_fileformat;

LIST @storage_init_stage;

CREATE OR REPLACE TABLE orders(
order_id varchar(50),
amount integer,
profit integer,
quantity integer,
category varchar(50),
sub_category varchar(50)
);


COPY INTO ORDERS
FROM @storage_init_stage
files=('OrderDetails.csv');

SELECT * FroM ORDERS LIMIT 5;