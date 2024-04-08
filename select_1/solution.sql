--1
--select model
--from product_sa2 ps
--where category = 'часы'
--and sales_start = 2023
--and score >= 4 and score <= 5;


--2
--select vb."name" 
--from vendor_5br vb 
--join vendor_product_info_osp vpio on vpio.vendor_id = vb.id 
--join product_sa2 ps on vpio.product_id = ps.id
--where category = 'ноутбуки' and os = 'Linux'
--except 
--select vb2."name" 
--from vendor_5br vb2 
--join vendor_product_info_osp vpio2 on vpio2.vendor_id = vb2.id
--join product_sa2 ps2 on vpio2.product_id = ps2.id
--where category = 'ноубуки' and os = 'Windows';


--3
--select vb."name" 
--from vendor_5br vb 
--join vendor_product_info_osp vpio on vpio.vendor_id = vb.id 
--join product_sa2 ps on vpio.product_id = ps.id 
--where category = 'электронные книги'
--intersect 
--select vb2."name"
--from vendor_5br vb2 
--join vendor_product_info_osp vpio2 on vpio2.vendor_id = vb2.id
--join product_sa2 ps2 on vpio2.product_id = ps2.id
--where category = 'часы';


--4
--select vb."name" 
--from vendor_5br vb 
--join vendor_product_info_osp vpio on vpio.vendor_id = vb.id 
--join product_sa2 ps on vpio.product_id = ps.id
--where brand = 'Apple'
--union
--select vb2."name"
--from vendor_5br vb2 
--join vendor_car_info_f7w vcifw on vcifw.vendor_id = vb2.id
--join car_jq8 cj on vcifw.car_id = cj.id
--where lifting_capacity >= 25;


--5
--select min(weight), max(weight), avg(price), sum(price * quantity)
--from product_sa2 ps
--join vendor_product_info_osp vpio on vpio.product_id = ps.id
--where category = 'ноутбуки' and brand = 'MSI';


--6
--with
--	max_screen_size as (
--		select max(screen_size)
--		from product_sa2
--		where category = 'ноутбуки'
--	),
-- 	min_weight_among_max_screen_size as (
--		select min(weight)
--		from product_sa2
--		where category = 'ноутбуки' and screen_size = (select * from max_screen_size)
--	)
--
--select model 
--from product_sa2
--where category = 'ноутбуки'
--and screen_size = (select * from max_screen_size)
--and weight = (select * from min_weight_among_max_screen_size);


--7
--with unique_brands as (
--	select distinct brand
--	from product_sa2
--)
--
--select count(brand)
--from unique_brands;
