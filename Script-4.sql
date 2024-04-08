--1
select model
from product_f0k
where sales_start = 2023 and score >= 4 and score <= 5;

--2
select name
from product_f0k p join vendor_product_info_lj6 vpi on p.id = vpi.product_id
join vendor_vyn v on vpi.vendor_id = v.id
where os = 'Linux'
except 
select name
from product_f0k p join vendor_product_info_lj6 vpi on p.id = vpi.product_id
join vendor_vyn v on vpi.vendor_id = v.id
where os = 'Windows';

--3
select name
from product_f0k p join vendor_product_info_lj6 vpi on p.id = vpi.product_id
join vendor_vyn v on vpi.vendor_id = v.id
where category = 'электронные книги' or category = 'книги';

--4
select name
from product_f0k p join vendor_product_info_lj6 vpi on p.id = vpi.product_id
join vendor_vyn v on vpi.vendor_id = v.id
join vendor_vehicle_info_ykk vvi on vvi.vendor_id = v.id
join vehicle_t0x veh on vvi.vehicle_id = veh.id
where brand = 'Apple' or lifting_capacity > 25;

--5
select min(weight), max(weight), avg(price) , sum(price * quantity)
from product_f0k p join vendor_product_info_lj6 vpi on p.id = vpi.product_id
join vendor_vyn v on vpi.vendor_id = v.id
where category = 'ноутбуки' and brand = 'MSI';

--6
select model
from product_f0k pfk
where screen_size = 34
order by weight asc
limit 1;

--7
select distinct count(brand)
from product_f0k;




