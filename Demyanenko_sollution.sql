-- 1
select model, sales_start, sales_end from product_k2q
where category = 'часы' and sales_start = 2023 and sales_end is null;


--2 
select name from product_k2q
join supplier_product_info_6ty on supplier_product_info_6ty.product_id = product_k2q.id
join supplier_7ym on supplier_7ym.id = supplier_product_info_6ty.supplier_id
where os = 'Linux'
except
select name from product_k2q
join supplier_product_info_6ty on supplier_product_info_6ty.product_id = product_k2q.id
join supplier_7ym on supplier_7ym.id = supplier_product_info_6ty.supplier_id
where os = 'Windows';

--3
select name from product_k2q
join supplier_product_info_6ty on supplier_product_info_6ty.product_id = product_k2q.id
join supplier_7ym on supplier_7ym.id = supplier_product_info_6ty.supplier_id
where category = 'часы'
intersect 
select name from product_k2q
join supplier_product_info_6ty on supplier_product_info_6ty.product_id = product_k2q.id
join supplier_7ym on supplier_7ym.id = supplier_product_info_6ty.supplier_id
where category = 'электронные книги';

--4
select name from product_k2q
join supplier_product_info_6ty on supplier_product_info_6ty.product_id = product_k2q.id
join supplier_7ym on supplier_7ym.id = supplier_product_info_6ty.supplier_id
where brand = 'Apple'
union
select name from car_sit
join supplier_car_info_7u0 on car_sit.id = supplier_car_info_7u0.car_id 
join supplier_7ym on supplier_7ym.id = supplier_car_info_7u0.supplier_id
where lifting_capacity > 25;

--5

select min(price), max(price), avg(price), sum(price*quantity) from product_k2q
join supplier_product_info_6ty on supplier_product_info_6ty.product_id = product_k2q.id
where brand = 'MSI';


--6

(select max(screen_size) from product_k2q where category = 'ноутбуки');
(select min(weight) from product_k2q where category = 'ноутбуки');

--P.S.: Я вручную проверил, таких ноутбуков нету в базе... :(
with max_screen_sized as (select * from product_k2q
where screen_size = (select max(screen_size) from product_k2q) and category = 'laptop')
select model from max_screen_sized
where weight = (select min(weight) from product_k2q);

--7

select count(distinct brand) from product_k2q; 
