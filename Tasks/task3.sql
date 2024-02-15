drop table if exists provider, transport cascade;

create table provider
(
	id int primary key generated always as identity,
	name text,
	phone text
);

create table transport
(
	id int primary key generated always as identity,
	provider_id int references provider(id),
	brand text,
	model text,
	payload int check(payload>=0)
);

insert into provider(name, phone) values
	('поставщик хлеба','+79849511255'),
	('поставщик мяса','+79442158543');

insert into transport(provider_id, brand, model, payload) values
	(2,'мерседес', 'pro model', 1000),
	(1,'лада', 'крутая модель', 900);

select p.id, p.name, p.phone, 
	coalesce(jsonb_agg(json_build_object('id', t.id, 'brand', t.brand, 'model', t.model, 'payload', t.payload))
	filter(where t.provider_id is not null), '[]')
	from provider p
	left join transport t on p.id = t.provider_id
	group by p.id;