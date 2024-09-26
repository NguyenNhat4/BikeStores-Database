
--Store procedure - function

-- Viết hàm tính tổng 2 số a,b 
alter function tonga_b
(
	@a int ,
	@b int 
)
returns int 
as 
begin 
	declare @tong int
	set @tong = @a+@b
	return @tong
end

select dbo.tonga_b(8,10) tong2so


-- Viết hàm tính tổng từ 1 đến n 
ALTER FUNCTION dbo.tong1_n
(
    @n INT
)
RETURNS INT
AS
BEGIN
    DECLARE @sum INT;
    SET @sum = ((1 + @n) * @n) / 2;
    RETURN @sum;
END;
GO

SELECT dbo.tong1_n(200) AS tong1denN;


--53. viết hàm tính tiền của một order items 
		--Name:fcn_order_item_payment  
		--Input: order_id, item_id 
		--Output: item price 

ALter FUNCTION fcn_order_item_payment
(
@order_id int, 
@item_id int
)
RETURNS FLOAT																		  
AS																					 
BEGIN 
DECLARE @item_price FLOAT
SET @item_price =
(select quantity * list_price *  ( 1 - discount )
from
sales.order_items 
where order_id = @order_id AND	item_id = @item_id
)
return @item_price 
END;

select dbo.fcn_order_item_payment(6,1) as item_price

--54.Viết hàm tính tiền của một orders
		--Name: fcn_order_item_payment2
		--Input: order_id
		--Output: order price  
		

alter function fcn_order_item_payment2
(
@order_id int 
)
returns float
as 
begin 
declare @total float
select @total = SUM(quantity * list_price *  ( 1 - discount ))
from sales.order_items
where order_id = @order_id
return @total

end
 select  dbo.fcn_order_item_payment2(8)  total_orders
--55. Viết hàm trả về thứ của ngày 
		--Name: fcn_DOW
		-- input:date 
		-- output: thứ 2->2... chủ nhật -> 1
 alter function fcn_DOW
 (
@date DATE
)
returns int 
as 
begin 
 DECLARE @dayOfWeek NVARCHAR(50);
    
    SET @dayOfWeek = DATEPART(dw, @date);
    
    RETURN @dayOfWeek;
end													   
		  		   select dbo.fcn_DOW('2004-11-18')  datenum