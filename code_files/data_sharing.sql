--Create a different database and tables that would like to share to other accounts
-- In this tutorial will learn how to share the database and data in tables using reader account. In Snowflake, one can read the data of a database by using reader account even though not having an individual snowflake account

CREATE OR REPLACE DATABASE DB_SHARE;

CREATE OR REPLACE TABLE DB_SHARE.PUBLIC.EMPLOYEE_SHARE
CLONE DW_SNOWFLAKE_DE.PIPES.EMPLOYEE;

SELECT * FROM EMPLOYEE_SHARE;

--Create a share object
CREATE OR REPLACE SHARE SHARE_OBJ;

--Grant permissions to the database, schema, and tables
GRANT USAGE ON DATABASE DB_SHARE TO SHARE SHARE_OBJ;
GRANT USAGE ON SCHEMA DB_SHARE.PUBLIC TO SHARE SHARE_OBJ;
GRANT SELECT ON TABLE DB_SHARE.PUBLIC.EMPLOYEE_SHARE TO SHARE SHARE_OBJ;

--View the grants of the share object 'SHARE_OBJ'
SHOW GRANTS TO SHARE SHARE_OBJ;

--Add a reader account to the share obj to access the shared database

ALTER SHARE SHARE_OBJ ADD ACCOUNT=<reader-account_id>;

--Create a reader account

CREATE MANAGED ACCOUNT reader_account
ADMIN_NAME = ##
ADMIN_PASSWORD='##'
TYPE=READER;

--{"accountName":"READER_ACCOUNT","accountLocator":"AG00104","url":"https://uzjnmuv-reader_account.snowflakecomputing.com","accountLocatorUrl":"https://ag00104.us-east-2.aws.snowflakecomputing.com
--These credentials will be used to login to the reading account by using the above provided URL

SHOW MANAGED ACCOUNTS;

--Add account: AG00104 to the 'SHARE_OBJ'

ALTER SHARE SHARE_OBJ ADD ACCOUNT=AG00104;

--login in using acount'##' and password'##' in https://ag00104.us-east-2.aws.snowflakecomputing.com
--create a database using the 'SHARE_OBJ'
-- The below code is from the reader account 

'''
--make the 
show shares;
DESC SHARE UZJNMUV.NK75369.SHARE_OBJ;

--create da database using the share

CREATE DATABASE DB_SHARE_READER FROM SHARE UZJNMUV.NK75369.SHARE_OBJ;

SELECT * FROM DB_SHARE_READER.PUBLIC.EMPLOYEE_SHARE;

--Hence can access the shared database using the reader account
--Reader account cannot modify the data, can only view it
'''


