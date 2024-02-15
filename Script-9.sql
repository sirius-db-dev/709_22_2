create extension if not exists "uuid-ossp";

drop table if exists suppliers, vehicles;

create table suppliers
(
	id		uuid primary key default uuid_generate_v4(),
	name	text,
	phone	int
);

create table vehicles
(
	id		uuid primary key default uuid_generate_v4(),
	sup_id	uuid references suppliers(id),
	brand	text,
	model	text,
	gruzo	int
);

insert into suppliers (name, phone)
values
	('Боб строитель', 123456789),
	('Иван Будько', 987654321),
	('Егор Роганов', 111222333);

insert into vehicles (sup_id, brand, model, gruzo)
values
	((select id from suppliers where name='Боб строитель'), 'Mercedes', 'A12', 770),
	((select id from suppliers where name='Боб строитель'), 'KAMAZ', '110', 1150),
	((select id from suppliers where name='Иван Будько'), 'BELAZ', 'PIPEC', 2000),
	((select id from suppliers where name='Иван Будько'), 'Zhiguli', '5', 140),
	((select id from suppliers where name='Егор Роганов'), 'Tuc-tuc', '07', 4000),
	((select id from suppliers where name='Егор Роганов'), 'Telega', '228', 15);

select 
	s.id,
	name,
	phone,
	coalesce(json_agg(jsonb_build_object(
		'id', v.id,
		'sup_id', v.sup_id,
		'brand', v.brand,
		'model', v.model,
		'gruzo', v.gruzo))
		filter (where v.id is not null), '[]') as vehicles
from suppliers s
left join vehicles v on s.id=v.sup_id
group by s.id;

