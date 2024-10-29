CREATE OR REPLACE STAGE json_handling_stage
URL='S3://dw-snowflake-de/json_data_handling/'
CREDENTIALS=(AWS_KEY_ID='##' AWS_SECRET_KEY='##');


list @json_handling_stage;

CREATE OR REPLACE FILE FORMAT file_format_json
TYPE =JSON;


DESC FILE FORMAT DW_SNOWFLAKE_DE.FILE_FORMATS.FILE_FORMAT_JSON;

CREATE OR REPLACE TABLE JSON_RAW(
raw_file variant
);

select * from json_raw;

COPY INTO JSON_RAW
FROM @json_handling_stage
FILE_FORMAT=(FORMAT_NAME=file_format_json)
files=('spotify_raw_2024-10-02 06-40-53.803178.json');

select raw_file:items[0].added_at::STRING from json_raw;
