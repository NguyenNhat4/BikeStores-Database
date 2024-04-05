--  kiểm tra số lượng bảng và số row (dữ liệu ) trong mỗi bảng trong database bikeStores
SELECT COUNT(*) AS table_count
FROM information_schema.tables
WHERE table_schema IN ('sales', 'production');

-- tạo và view database diagram cho database bikeStores 

-- 18. Danh sách khách hàng có số điện thoại
SELECT * 
FROM sales.customers
WHERE phone IS NOT NULL;

-- 19. Danh sách khách hàng có tên bắt đầu bằng chữ cái A
SELECT * 
FROM sales.customers
WHERE first_name LIKE 'A%';

-- 20. Thống kê doanh số bán hàng theo từng sản phẩm
SELECT 
    a.product_name,
    SUM(b.quantity * b.list_price * (1 - b.discount)) AS total_sales_per_product 
FROM 
    production.products AS a
LEFT JOIN  
    sales.order_items AS b ON a.product_id = b.product_id
GROUP BY 
    a.product_name;

-- 21. Thống kê số lượng đơn hàng của từng cửa hàng
SELECT 
    a.store_id,
    a.store_name,
    SUM(b.quantity) AS total_orders
FROM 
    sales.stores AS a
LEFT JOIN 
    production.stocks AS b ON a.store_id = b.store_id
LEFT JOIN 
    sales.order_items AS c ON b.product_id = c.product_id
GROUP BY 
    a.store_id, a.store_name;

-- 22. Thống kê doanh số bán hàng của từng cửa hàng
SELECT 
    a.store_id,
    a.store_name, 
    SUM(c.quantity * c.list_price * (1 - c.discount)) AS total_sales
FROM 
    sales.stores AS a
LEFT JOIN 
    production.stocks AS b ON a.store_id = b.store_id
LEFT JOIN 
    sales.order_items AS c ON b.product_id = c.product_id
GROUP BY 
    a.store_id, a.store_name;

-- 23. Thống kê doanh số bán hàng theo từng nhân viên
SELECT
    a.staff_id,
    CONCAT(a.first_name, ' ', a.last_name) AS "Staff name",
    SUM(c.quantity * c.list_price * (1 - c.discount)) AS total_sales
FROM
    sales.staffs AS a
LEFT JOIN
    sales.orders AS b ON a.staff_id = b.staff_id 
LEFT JOIN
    sales.order_items AS c ON b.order_id = c.order_id
GROUP BY 
    a.staff_id, a.first_name, a.last_name;

-- 24. Thống kê lượng tồn kho theo từng sản phẩm
SELECT 
    a.product_id,
    b.product_name,
    SUM(a.quantity) AS products_in_stock
FROM 
    production.stocks AS a
LEFT JOIN 
    production.products AS b 
	ON a.product_id = b.product_id 
GROUP BY 
    a.product_id, b.product_name
ORDER BY 
    products_in_stock;

--25. Thống kê doanh số bán hàng theo từng thương hiệu sản phẩm 
SELECT
    b.brand_id,
    b.brand_name,
    SUM(s.quantity * s.list_price * (1 - s.discount)) AS total_brand_sales
FROM
    production.brands b
	INNER JOIN production.products p 
	ON p.brand_id = b.brand_id
	INNER JOIN sales.order_items s 
	ON p.product_id = s.product_id
GROUP BY
    b.brand_id,
    b.brand_name;
--26. liệt kê sản phẩm chưa bán được cái nào 
SELECT product_id, product_name
FROM production.products p
WHERE NOT EXISTS (
    SELECT 1
    FROM sales.order_items oi
    WHERE oi.product_id = p.product_id
);
--27. liệt kê khách hàng chưa mua hàng lần nào 
SELECT 
	a.customer_id,
	CONCAT(a.first_name,' ' ,a.last_name) customer_Full_Name
FROM 
	sales.customers a
WHERE NOT EXISTS (
	SELECT 1
	FROM	 
	sales.orders b
	WHERE
	b.customer_id =a.customer_id
	);
		

--28.liệt kê khách hàng mua từ 10 đơn hàng trở lên 
SELECT 
 a.*
FROM 
	sales.customers a
WHERE a.customer_id IN (
	SELECT customer_id
	FROM sales.orders 
	GROUP BY customer_id
	HAVING 
    COUNT(DISTINCT order_id) >= 10
)

--29.liệt kê khách hàng ở thành phố newyork , bang NY
SELECT *
FROM 
	sales.customers a
WHERE [state] = 'NY' AND city = 'New York'

--30.thống kê doang số bán hàng của từng của hàng theo năm 
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
 

--31. Thống kê sản phẩm có tồn kho lớn hơn 100 tại mỗi kho 
SELECT a.*,b.quantity
FROM production.products a
	JOIN production.stocks b 
	ON a.product_id = b.product_id 
WHERE b.quantity > 100;


--32.Thống kê số khách hàng đã từng mua hàng tại cửa hàng Santa Cruz Bikes

SELECT COUNT(*) AS number_of_customers
FROM (
    SELECT DISTINCT o.customer_id
    FROM sales.stores s
INNER JOIN sales.orders o ON s.store_id = o.store_id
    WHERE s.store_name = 'Santa Cruz Bikes' and (o.shipped_date is not null)
) AS customer_purchases;


--33. Thống kê số khách hàng đã từng mua hàng tại cửa hàng Santa Cruz Bikes và địa chỉ ở thành phố Santa Cruz
SELECT COUNT(*) Number_Of_Customers
FROM (
   SELECT DISTINCT b.customer_id
	FROM sales.stores a 
	INNER JOIN  sales.orders b 
	ON a.store_id = b.store_id
	WHERE a.store_name = 'Santa Cruz Bikes'
	AND a.city = 'Santa Cruz'  
	AND b.shipped_date is not null
) as customers


--34.Liệt kê sản phẩm có giá từ 500$ đến 1000$ 
SELECT product_id, product_name, list_price
FROM production.products
WHERE list_price BETWEEN 500 AND 1000

--36.liệu kê danh sách khách hàng có first_name kết thúc bằng chữ cái u
SElECT 
	customer_id,
	first_name,
	last_name
FROM sales.customers
WHERE first_name LIKE '%u'

--37.liệu kê danh sách khách hàng có email của gmail 
SElECT 
	*
FROM sales.customers
WHERE email LIKE '%gmail.com'
SElECT 
	*
FROM sales.customers

--38. Trích xuất dữ liệu email domain khác nhau từ dữ liệu khách hàng 
--( gợi ý: sử dụng các hàng string ,charindex và len)
SELECT 
	DISTINCT RIGHT(email, LEN(email)-CHARINDEX('@',email)) AS email_domain 
FROM sales.customers

--39. Trích xuất đầu số điện thoại khác nhau từ dữ liệu khách hàng 

SELECT 
DISTINCT LEFT(phone,CHARINDEX(')',phone)) phone_head
FROM sales.customers
WHERE phone is not null


--40. Liệt kê danh sách thông tin nhân viên kèm thông tin người quản lý 

