
drop table if exists chats, messages cascade;

create table chats
(
	id int primary key,
	title text,
	create_date date
);

create table messages
(
	id int primary key,
	chat_id int references chats not null,
	msg_text text,
	send_date date
);

insert into chats (id, title, create_date)
values (1, 'programming', '2017-01-01'),
		(2, 'homework', '2010-09-23'),
		(3, 'work', '2015-11-19');

insert into messages (id, chat_id, msg_text, send_date)
values (1, 1, 'i do not know', '2024-02-15'),
		(2, 1, 'i do not understand anything', '2024-02-15'),
		(3, 2, 'second excersize', '2024-02-15'),
		(4, 2, 'we need to learn that', '2024-02-15'),
		(5, 3, 'project', '2024-02-15');
	

select * from chats;
select * from messages;

select * from chats join messages on messages.chat_id = chats.id;








drop table if exists providers, vehicles cascade;

create table providers
(
	id int primary key,
	title text,
	number text
);

create table vehicles
(
	id int primary key,
	provider_id int references providers not null,
	mark text,
	model text,
	v_power int
);

insert into providers (id, title, number)
values (1, 'Aleks', '56820475205'),
		(2, 'Ian', '29305205720'),
		(3, 'Sam', '49104862946');

insert into vehicles (id, provider_id, mark, model, v_power)
values (1, 1, 'AAA', '15a', 100),
		(2, 2, 'IiI', '589nh', 75),
		(3, 1, 'AAA', '38dh', 90),
		(4, 3, 'SmS', 'vg4jb', 88),
		(5, 2, 'III', 'jv3fn3', 66);
	

select * from providers;
select * from vehicles;

select * from providers join vehicles on vehicles.provider_id = providers.id;






drop table if exists buyers, orders cascade;

create table buyers
(
	id int primary key,
	firts_name text,
	second_name text,
	number text
);

create table orders
(
	id int primary key,
	buyer_id int references buyers not null,
	buy_date date,
	price int
);

insert into buyers (id, firts_name, second_name, number)
values (1, 'Aleks', 'Lansen', '56820475205'),
		(2, 'Ian', 'Chen', '29305205720'),
		(3, 'Sam', 'Willson', '49104862946');

insert into orders (id, buyer_id, buy_date, price)
values (1, 1, '2010-08-03', 100),
		(2, 2, '2014-09-23', 75),
		(3, 1, '2000-10-20', 90),
		(4, 3, '2020-04-19', 88),
		(5, 2, '2016-12-29', 66);
	
select * from buyers;
select * from orders;

select * from buyers join orders on buyers.id = orders.buyer_id;


