CREATE TABLE customer (
   customer_id INT,
   customer_name VARCHAR(50),
   customer_email VARCHAR(50),
   customer_phone VARCHAR(15),
   load_date DATE,
	 customer_address VARCHAR(255)
);

INSERT INTO customer VALUES
   (1, 'John Doe', 'john.doe@example.com', '123-456-7890', '2022-01-01', '123 Main St'),
   (2, 'Jane Doe', 'jane.doe@example.com', '987-654-3210', '2022-01-01', '456 Elm St'),
   (3, 'Bob Smith', 'bob.smith@example.com', '555-555-5555', '2022-01-01', '789 Oak St');


select * from customer where customer_id=1;

 --for SCD1
 
update customer set customer_address='3465 Main St' where customer_id=1;

--for SCD1
ALTER TABLE customer ADD COLUMN cust_segment varchar(50);
ALTER TABLE customer ADD COLUMN start_date date;
ALTER TABLE customer ADD COLUMN end_date date;
ALTER TABLE customer ADD COLUMN version integer;

update customer  set cust_segment='GOLD', start_date='2020-09-14',end_date='2021-10-31', version=1 where customer_id=1;

INSERT INTO customer(customer_id, customer_name, customer_email, customer_phone, load_date, customer_address, cust_segment, start_date, end_date, version)
select customer_id, customer_name,customer_email,customer_phone,load_date, customer_address,'Platinum','2021-10-31','9999-12-31', version+1 from customer where customer_id=1;

--for SCD3
ALTER TABLE CUSTOMER ADD COLUMN prev_segment varchar(50);

INSERT INTO customer(customer_id, customer_name, customer_email, customer_phone, customer_address, customer_segment, start_date, end_date, version,
prev_segment)
select customer_id, customer_name,customer_email,customer_phone,load_date, customer_address,'Diamond','2022-11-01','9999-12-31', version+1, cust_segment from customer where customer_id=1;

UPDATE customer set prev_segment=cust_segment, cust_segment='Diamond' where customer_id=1 and version=2;


--for SCD6
INSERT INTO customer(customer_id, customer_name, customer_email, customer_phone,load_date, customer_address, cust_segment, start_date, end_date, version,
prev_segment)
select customer_id, customer_name,customer_email,customer_phone,load_date, customer_address,'Ruby','2022-11-01','9999-12-31', version+1, cust_segment from customer where customer_id=1;

select * from customer where customer_id=1;