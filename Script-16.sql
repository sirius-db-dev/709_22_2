create extension if not exists "uuid-ossp";

drop table if exists products, discounts, discount_to_prods, cascade;

create table products
(
	id uuid primary key default uuid_generate_v4(),
	prod_name text,
	category text
);

create table discounts
(
	id uuid primary key default uuid_generate_v4(),
	disc_name text,
	disc_size int,
	disc_start date,
	disc_end date
);

create table discount_to_prods
(
	prod_id uuid references products,
	disc_id uuid references discounts,
	primary key (prod_id, disc_id)
);

insert into products (prod_name, category)
values 	('Milk', 'Diary'),
		('Cheese', 'Diary'),
		('Frozen burger', 'Fastfood'),
		('Apples 1kg', 'Fruit'),
		('Potatoes 50kg', 'Vegetables');
	
insert into discounts (disc_name, disc_size, disc_start, disc_end)
values	('Diary week', 15, '2023.01.01', '2024.01.01'),
		('Healthy food', 7, '2024.02.13', '2024.07.14'),
		('Black friday', 99, '2024.02.13', '2024.02.14');
	
insert into discount_to_prods (prod_id, disc_id)
values	((select id from products where prod_name = 'Milk'),
		(select id from discounts where disc_name = 'Diary week')),
		((select id from products where prod_name = 'Cheese'),
		(select id from discounts where disc_name = 'Diary week')),
		((select id from products where prod_name = 'Apples 1kg'),
		(select id from discounts where disc_name = 'Healthy food')),
		((select id from products where prod_name = 'Potatoes 50kg'),
		(select id from discounts where disc_name = 'Healthy food')),
		((select id from products where prod_name = 'Apples 1kg'),
		(select id from discounts where disc_name = 'Black friday')),
		((select id from products where prod_name = 'Potatoes 50kg'),
		(select id from discounts where disc_name = 'Black friday')),
		((select id from products where prod_name = 'Milk'),
		(select id from discounts where disc_name = 'Black friday')),
		((select id from products where prod_name = 'Cheese'),
		(select id from discounts where disc_name = 'Black friday'));
		

select 
	p.id,
	p.prod_name,
	p.category,
	coalesce(jsonb_agg(jsonb_build_object(
		'id', d.id, 'disc_name', d.disc_name,
		'size', d.disc_size, 'start', d.disc_start, 'end', d.disc_end))
		filter (where d.id is not null), '[]') as discounts
from products p
left join discount_to_prods dp on p.id = dp.prod_id
left join discounts d on dp.disc_id = d.id
group by p.id;

select 
	d.id,
	d.disc_name,
	d.disc_size,
	d.disc_start,
	d.disc_end,
	coalesce(jsonb_agg(jsonb_build_object(
		'id', p.id, 'prod_name', p.prod_name, 'category', p.category))
		filter (where p.id is not null), '[]') as products
from discounts d
left join discount_to_prods dp on d.id = dp.disc_id
left join products p on dp.prod_id = p.id
group by d.id;




