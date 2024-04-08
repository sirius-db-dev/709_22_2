/* 1 */
select model from product_a7r
where category = 'часы'
	and sales_start = 2023
	and sales_end is null
	and score in (4, 5);


/* 2 */
with vendor_linux as (
	(select vendor_id from vendor_product_info_pp9 vpip
	join product_a7r as p on vpip.product_id = p.id
	where p.category = 'ноутбуки'
		and p.os = 'Linux')
	except
	(select vendor_id from vendor_product_info_pp9 vpip
	join product_a7r as p on vpip.product_id = p.id
	where p.category = 'ноутбуки'
		and p.os = 'Windows')
)
select name from vendor_gbi vg
join vendor_linux vl on vg.id = vl.vendor_id
group by vg.id;


/* 3 */
with vendor_clock_and_ebooks as (
	select distinct vendor_id from vendor_product_info_pp9 vpip
	join product_a7r as p on vpip.product_id = p.id
	where p.category in ('часы', 'электронные книги')
)
select name from vendor_gbi vg
join vendor_clock_and_ebooks vce on vg.id = vce.vendor_id
group by vg.id;


/* 4 */
select name from vendor_gbi
where id in (
	select vendor_id from product_a7r par
	join vendor_product_info_pp9 vpip on vpip.product_id = par.id
	where brand = 'Apple'
)
union
select name from vendor_gbi
where id in (
	select vendor_id from transport_86p t
	join vendor_transport_info_ijq vtii on vtii.transport_id = t.id 
	where lifting_capacity > 25
);


/* 5 */
select * from 
(
	select min(weight) min_price, max(weight) max_price from product_a7r par
	where category = 'ноутбуки'
		and brand = 'MSI'
) as a,
(
	select avg(price) avg_price, sum(price)*sum(quantity) sum_price from product_a7r par
	join vendor_product_info_pp9 vpip on vpip.product_id = par.id
	where category = 'ноутбуки'
		and brand = 'MSI'
) as b

/* 6 */
select model  from product_a7r par
where category = 'ноутбуки'
	and screen_size = (select max(screen_size) from product_a7r where category = 'ноутбуки')
	and weight = (select min(weight) from product_a7r where category = 'ноутбуки' and screen_size = (select max(screen_size) from product_a7r where category = 'ноутбуки'))


/* 7 */
with unicue_brands as (
	select distinct brand from product_a7r
)
select count(brand) from unicue_brands;

