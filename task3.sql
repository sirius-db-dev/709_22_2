drop table clients
create table clients
(
	id			int primary key,
	first_name	text,
	second_name	text,
	phone		text
);

insert into clients(id, first_name, second_name, phone)
	values (1, 'Вася', 'Пупкин', '21391203'),
	       (2, 'Петя', 'Литвинов', '12312312'),
	       (3, 'Вова', 'Демьяненко', '2342342'),
	       (4, 'Дима', 'Алексей', '12312313');

create table orders
(
	id			int primary key,
	client_id	int references clients,
	date_order	date,
	amount		int
);

insert into orders (id, client_id, date_order, amount)
values 
	(1, 1, '2020-01-01', 98),
	(2, 3, '2021-08-23', 1000),
	(3, 1, '2023-02-15', 33),
	(4, 2, '2025-06-08', 12312),
	(5, 1, '2026-02-19', 3445);

select 
	cl.id,
	cl.first_name,
	cl.second_name,
	cl.phone,
	coalesce(jsonb_agg(jsonb_build_object(
	'id', rd.id, 'client_id', rd.client_id, 'date_order', rd.date_order, 'amount', rd.amount))
	filter (where rd.id is not null), '[]')
	as orders
from clients cl
	left join orders rd on cl.id = rd.client_id
group by cl.id;

