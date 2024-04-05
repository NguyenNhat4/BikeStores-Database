
begin transaction
update sales.customers set first_name='test' where customer_id = 1
update sales.customers set first_name= 'test2' where customer_id = 2

select * from sales.customers
 