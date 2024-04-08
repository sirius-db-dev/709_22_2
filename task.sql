--1. Вывести модели часов, которые начали продаваться в 2023 году и не закончили продаваться, и оценкой от 4 до 5.
select model from product_ve4 p where category = 'часы' and sales_start >= 2023 and sales_end is null and score >= 4;
--2. Вывести названия компаний (НЕ брендов), поставляющих ноутбуки на операционной системе Linux, но не на Windows.
select s.name from product_ve4 p 
join supplier_product_info_jto sp on sp.product_id = p.id
left join supplier_0mv s on sp.supplier_id = s.id
where os = 'Linux' and category = 'ноутбуки'
intersect  
select s.name from product_ve4 p 
join supplier_product_info_jto sp on sp.product_id = p.id
left join supplier_0mv s on sp.supplier_id = s.id
where os != 'Window' and category = 'ноутбуки'
--3. Вывести названия компаний, поставляющие как электронные книги, так и часы.
select s.name from product_ve4 p 
join supplier_product_info_jto sp on sp.product_id = p.id
left join supplier_0mv s on sp.supplier_id = s.id
where category = 'электронные книги'
intersect 
select s.name from product_ve4 p 
join supplier_product_info_jto sp on sp.product_id = p.id
left join supplier_0mv s on sp.supplier_id = s.id
where category = 'часы'
--4. Вывести названия компаний, поставляющих продукцию бренда Apple либо имеющие транспортные средства с грузоподъемностью от 25.
select s.name from supplier_0mv s
left join supplier_product_info_jto sp on sp.supplier_id = s.id
left join product_ve4 p on sp.product_id = p.id
where brand = 'Apple'
union  
select s.name from supplier_0mv s
left join supplier_vehicle_info_2jv sv on sv.supplier_id = s.id
left join vehicle_ufy v on v.id = sv.vehicle_id
where v.lifting_capacity > 25;
--5. Вывести минимальный, максимальный вес, среднюю цену и суммарную стоимость (price * quantity) ноутбуков бренда MSI.
select max(width), min(width), avg(price), sum(price * quantity) from supplier_product_info_jto sp
left join product_ve4 p on p.id = sp.product_id
group by sp.price, p.brand, p.category
having p.brand = 'MSI' and p.category = 'ноутбуки'
--6. Вывести модели ноутбуков с наибольшим размером экрана и наименьшим весом среди ноутбуков с наибольшим размером экрана.
with min_width_max_screen_size as (select width, screen_size from product_ve4 p
where category = 'ноутбуки' group by model, width, screen_size
having width = min(width) and screen_size = max(screen_size))
select model from min_width_max_screen_size f left join product_ve4 p on p.width = f.width and p.screen_size = f.screen_size
--7. Вывести количество различных брендов в бд.
select sum(a.a) from (select 1 as a from product_ve4 p group by p.brand) as a group by a.a




