create view VIEW_CUSTOMERS 
as 
select 
 customer_id,
 first_name + ' ' + last_name as full_name 
 ,phone , email
from sales.customers

--	create a sample user
CREATE login [SAMPLE] with password = N'Nguyenminhnhatzzsi4',	DEFAULT_DATABASE = BikeStores
GO 
Use BikeStores
GO 
CREATE USER [SAMPLE] FOR LOGIN [SAMPLE]
GO 
-- grant for access for sample user
grant select on dbo.VIEW_CUSTOMERS to [SAMPLE]




--create index 
create index sales_customers_first_name on sales.customers(first_name)

	select * from sales.customers 

	 select * from sales.customer1 


SET IDENTITY_INSERT sales.customers  off;














































