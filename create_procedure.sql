create procedure doang_so_ban_hang_theo_thang_va_nam
as 
begin 
	SELECT 
		s.store_id,
		store_name , 
		SUM ( quantity * list_price *  ( 1 - discount )) total_sales , 
		YEAR( b.shipped_date) sales_year 
	FROM sales.stores s
		INNER JOIN  sales.orders b 
		ON b.store_id = s.store_id
		INNER JOIN sales.order_items c 
		ON c.order_id = b.order_id
	WHERE b.shipped_date is not null
	GROUP BY 
		s.store_id,
		store_name , 
		YEAR( b.shipped_date) 
	ORDER BY sales_year
 
end