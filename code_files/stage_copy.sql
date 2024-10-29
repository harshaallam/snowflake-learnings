--creation of a stage that helps in connecting to the AWS s3 bucket using key and secret key

CREATE OR REPLACE STAGE external_stage_aws
URL='s3://bucketsnowflakes3/OrderDetails'
FILE_FORMAT=(TYPE=CSV SKIP_HEADER=1 FIELD_OPTIONALLY_ENCLOSED_BY='"');

--public s3 bcukets don't need credentials, only private ones need
CREDENTIALS=(AWS_KEY_ID='##' AWS_SECRET_KEY='##');

list @external_stage_aws;


CREATE OR REPLACE TABLE orders(
order_id varchar(50),
amount integer,
profit integer,
quantity integer,
category varchar(50),
sub_category varchar(50)
);

--stage can assess the files in the location and helps in copying into the tables
COPY INTO orders
FROM @external_stage_aws/OrderDetails.csv 
FILE_FORMAT=(TYPE=CSV FIELD_DELIMITER=',' SKIP_HEADER=1 FIELD_OPTIONALLY_ENCLOSED_BY='"')


SELECT * FROM ORDER_category LIMIT 10;

CREATE OR REPLACE TABLE order_category(
order_id varchar(20),
amount integer,
profit integer,
quantity integer,
profit_category varchar(50)
);


copy into order_category
from (
select s.$1 as order_id,s.$2 as amount,s.$3 as profit,
case when CAST(s.$3 as int) < 0 then 'non profit' else 'profit' end as profit_category
from @external_stage_aws s);

ALTER TABLE order_category drop column quantity;

select s.$1 from @external_stage_aws s limit 5;