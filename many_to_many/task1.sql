create extension if not exists "uuid-ossp";

drop table if exists product, stock, stock_to_product cascade;


create table product(
	id uuid primary key default uuid_generate_v4(),
	name text,
	price int,
	category text
);

create table stock(
	id uuid primary key default uuid_generate_v4(),
	discount int,
	date_begin date,
	date_end date
);

create table stock_to_product(
	stock_id uuid references stock,
	product_id uuid references product,
	primary key (stock_id, product_id)
);


insert into product(name, price, category)
values
	('Молоко', 45, 'еда'),
	('Пшено', 12, 'еда'),
	('Чипсы', 130, 'еда'),
	('Игровой руль', 4500, 'техника');

insert into stock(discount, date_begin, date_end)
values
	(15, '1998-01-23', '1998-02-20'),
	(20, '2000-01-24', '2006-01-24');

insert into stock_to_product(stock_id, product_id)
values
	((select id from stock where stock.date_begin = '1998-01-23' and stock.date_end = '1998-02-20'), (select id from product where product.name = 'Молоко')),
	((select id from stock where stock.discount = 15), (select id from product where product.name = 'Пшено')),
	((select id from stock where stock.discount = 20), (select id from product where product.name = 'Игровой руль'));



select
	product.id,
	product.name,
	product.price,
	product.category,
	coalesce(json_agg(json_build_object(
		'discount', stock.discount, 'date_begin', stock.date_begin, 'date_end', stock.date_end))
		filter (where stock.id is not null), '[]') as stock
from product
left join stock_to_product on product.id = stock_to_product.product_id
left join stock on stock.id = stock_to_product.stock_id
group by product.id;


select
	stock.id,
	stock.discount,
	stock.date_begin,
	stock.date_end,
	coalesce(json_agg(json_build_object(
		'name', product.name, 'price', product.price, 'category', product.category))
		filter (where product.id is not null), '[]') as product
from stock
left join stock_to_product on stock.id = stock_to_product.stock_id
left join product on product.id = stock_to_product.product_id
group by stock.id;

